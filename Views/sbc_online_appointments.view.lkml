# Version: 1.1.0
view: sbc_online_appointments {
  label: "SBC Online Appointments"
  derived_table: {
    sql:
      WITH raw_list AS (
        SELECT ap.root_id, wp.id AS page_view_id,
          logged_in, status, appointment_id, appointment_step, client_id, location, service,
          pv.session_id,
          CASE WHEN appointment_step = 'Location Selection' THEN 1
            WHEN appointment_step = 'Select Service' THEN 2
            WHEN appointment_step = 'Select Date' THEN 3
            WHEN appointment_step = 'Login to Confirm Appointment' THEN 4
            WHEN appointment_step = 'Appointment Summary' THEN 5
            WHEN appointment_step = 'Appointment Confirmed' THEN 6
            ELSE NULL END AS step_order,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', ap.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_cfmspoc_appointment_step_1 AS ap
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON ap.root_id = wp.root_id AND ap.root_tstamp = wp.root_tstamp
          JOIN derived.page_views AS pv ON pv.page_view_id = wp.id
        WHERE status = 'new' -- for now, report only on new appointments, not updates
          AND timestamp < DATE_TRUNC('day',GETDATE())

      ),
      final_selections AS ( -- this is to assign the location and service as the latest selection
        SELECT session_id, location, service, appointment_step, appointment_id, client_id, ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY step_order DESC, timestamp DESC) AS session_id_ranked
        FROM raw_list
      )
      SELECT rl.session_id, fs.location, fs.service, fs.appointment_step, fs.appointment_id, fs.client_id, MIN(timestamp) AS min_timestamp, MAX(timestamp) AS max_timestamp,
        MAX(step_order) AS latest_step
      FROM raw_list AS rl
      JOIN final_selections AS fs ON fs.session_id = rl.session_id AND fs.session_id_ranked = 1
      GROUP BY 1,2,3,4,5,6
          ;;
    distribution_style: all
    datagroup_trigger: datagroup_sbc_online_appointments
    publish_as_db_view: yes
  }

  dimension: root_id {
    description: "Unique ID of the event"
    primary_key: yes
    type: string
    sql: ${TABLE}.root_id ;;
  }


  dimension_group: visit {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.min_timestamp ;;
  }

  dimension: appointment_step {}
  dimension: appointment_id {}
  dimension: client_id {}
  dimension: latest_step {}
  dimension: session_id {}
  dimension: location {}
  dimension: service {}

  dimension_group: max_time {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.max_timestamp ;;
  }
  dimension_group: min_time {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.min_timestamp ;;
  }
  dimension: max_timestamp {}
  dimension: min_timestamp {}
  dimension: duration{
    sql: DATEDIFF('seconds', ${min_timestamp},${max_timestamp}) ;;
  }

  measure: row_count {
    type: count
  }
  measure: session_count {
    type: count_distinct
    sql: ${session_id}
      ;;
  }
  measure: average_duration {
    type: average
    sql: ${duration} ;;
  }
}
