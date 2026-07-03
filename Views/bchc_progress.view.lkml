 # Version: 1.0.0
include: "/Includes/date_comparisons_common.view"

view: bchc_progress  {
  label: "BC Health Careers Progress"
  derived_table: {
    sql:
      WITH raw_list AS (
         SELECT
          events.domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          action,
          CASE WHEN action = 'start' THEN 1
            WHEN action = 'submit' THEN 2
            WHEN action = 'submit_success' THEN 3
          ELSE NULL END AS action_order,
        CONVERT_TIMEZONE('UTC', 'America/Vancouver', bchca.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_bchc_action_1  AS bchca
        LEFT JOIN atomic.events ON bchca.root_id = events.event_id AND bchca.root_tstamp = events.collector_tstamp
        WHERE action IN ('start','submit','submit_success')
          AND {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      )
      SELECT
      page_urlhost,
      rl.session_id,
      CASE WHEN action IN ('start','submit', 'submit_success') THEN rl.session_id ELSE NULL END AS start_sessions,
      CASE WHEN action IN ('submit', 'submit_success') THEN rl.session_id ELSE NULL END AS submit_sessions,
      CASE WHEN action IN ('submit_success') THEN rl.session_id ELSE NULL END AS success_sessions,
      MIN(timestamp) AS min_timestamp, MAX(timestamp) AS max_timestamp,
      MAX(action_order) AS action_order
      FROM raw_list AS rl
      --JOIN final_step AS fs ON fs.session_id = rl.session_id AND fs.session_id_ranked = 1
      GROUP BY 1,2,3,4,5


      ;;
    distribution: "session_id"
    sortkeys: ["session_id","min_timestamp"]
    datagroup_trigger: datagroup_healthgateway_updated
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.min_timestamp ;;
  }

  dimension_group: event {
    sql: ${TABLE}.min_timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension: session_id {}
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }

  dimension: latest_action {
    sql: CASE WHEN ${TABLE}.action_order = 1 THEN 'start'
      WHEN ${TABLE}.action_order = 2 THEN 'submit'
      WHEN ${TABLE}.action_order = 3 THEN 'submit_success'
      ELSE NULL END;;
    type:  string

  }
  dimension: action_order {
    type: number

  }
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

  measure: count {
    type: count
    label: "Count"
  }


  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

  measure: start_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.start_sessions;;
    sql: ${TABLE}.start_sessions  ;;
  }
  measure: submit_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.submit_sessions;;
    sql: ${TABLE}.submit_sessions  ;;
  }
  measure: success_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.success_sessions;;
    sql: ${TABLE}.success_sessions  ;;
  }

}
