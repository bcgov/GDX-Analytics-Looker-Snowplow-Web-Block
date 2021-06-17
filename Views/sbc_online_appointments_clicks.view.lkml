view: sbc_online_appointments_clicks {
  label: "SBC Online Appointments Clicks"
  derived_table: {
    sql: SELECT ac.root_id, wp.id AS page_view_id,
          pv.session_id,
          label,
          logged_in,
          appointment_step,
          location,
          service,
          url,
          CASE WHEN label = 'Login: BCeID' THEN 1 ELSE 0 END AS bceid_login_count,
          CASE WHEN label = 'Create: BCeID' THEN 1 ELSE 0 END AS bceid_create_count,
          CASE WHEN label = 'Register' THEN 1 ELSE 0 END AS register_count,
          CASE WHEN label = 'Info: Privacy Statement' THEN 1 ELSE 0 END AS privacy_count,
          CASE WHEN label = 'Help' THEN 1 ELSE 0 END AS help_count,
          CASE WHEN label = 'Online Option' THEN 1 ELSE 0 END AS online_option_count,
          CASE WHEN label = 'Login' THEN 1 ELSE 0 END AS login_count,
          CASE WHEN label = 'View Location Services' THEN 1 ELSE 0 END AS location_services_count,
          CASE WHEN label = 'Login: BC Services Card' THEN 1 ELSE 0 END AS bcsc_login_count,
          CASE WHEN label = 'Info: About the BCeID' THEN 1 ELSE 0 END AS bceid_info_count,
          CASE WHEN label NOT IN ('Login: BCeID', 'Create: BCeID', 'Register', 'Info: Privacy Statement', 'Help', 'Online Option', 'Login', 'View Location Services', 'Login: BC Services Card', 'Info: About the BCeID') THEN 1 ELSE 0 END AS other_count,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', ac.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_cfmspoc_appointment_click_1 AS ac
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON ac.root_id = wp.root_id AND ac.root_tstamp = wp.root_tstamp
          JOIN derived.page_views AS pv ON pv.page_view_id = wp.id
        WHERE timestamp < DATE_TRUNC('day',GETDATE())
          ;;
    distribution_style: all
    datagroup_trigger: datagroup_sbc_online_appointments
  }

  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }

  dimension: root_id {
    description: "Unique ID of the event"
    primary_key: yes
    type: string
    sql: ${TABLE}.root_id ;;
  }

  dimension_group: click {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: session_id {}
  dimension: label {}
  dimension: logged_in {}
  dimension: appointment_step {}
  dimension: location {}
  dimension: service {}
  dimension: url {}
  dimension: bceid_login_count {}
  dimension: bceid_create_count {}
  dimension: register_count {}
  dimension: privacy_count {}
  dimension: help_count {}
  dimension: online_option_count {}
  dimension: login_count {}
  dimension: location_services_count {}
  dimension: bcsc_login_count {}
  dimension: bceid_info_count {}
  dimension: other_count {}
  dimension: timestamp {}

  measure: row_count {
    type: count
  }
  measure: session_count {
    type: count_distinct
    sql: ${session_id}
    ;;
  }

}
