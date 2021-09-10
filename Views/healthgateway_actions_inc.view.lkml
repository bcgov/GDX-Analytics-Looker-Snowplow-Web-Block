view: healthgateway_actions_inc {
  label: "Health Gateway Actions"
  derived_table: {
    sql: SELECT
          ga.root_id AS root_id,
          wp.id AS page_view_id,domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          action,
          message,
          text,
          CASE WHEN action = 'download_report' THEN 1 ELSE 0 end AS download_report_count,
          CASE WHEN action = 'download_card' THEN 1 ELSE 0 end AS download_card_count,
          CASE WHEN action = 'view_card' THEN 1 ELSE 0 end AS view_card_count,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', ga.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_gateway_action_1 AS ga
          LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON ga.root_id = wp.root_id AND ga.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON ga.root_id = events.event_id AND ga.root_tstamp = events.collector_tstamp
        WHERE {% incrementcondition %} ga.root_tstamp {% endincrementcondition %}

          ;;
    distribution_style: all
    datagroup_trigger: datagroup_healthgateway_updated_2
    increment_key: "event_minute10"
    increment_offset: 9
  }


  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }
  dimension: page_url {}


  dimension: action {}

  dimension: action_name {
    type: string
    sql: CASE WHEN ${action} = 'save_qr' THEN 'Save Vax (quick)'
              WHEN ${action} = 'view_qr' THEN 'View Vax (quick)'
              WHEN ${action} = 'view_card' THEN 'View Vax (full)'
              WHEN ${action} = 'download_card' THEN 'Save Vax (full)'
          ELSE ${action} END ;;
  }
  dimension: message {}
  dimension: text {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, minute30, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
  }

  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

  measure: download_report_count {
    type: sum
    sql: ${TABLE}.download_report_count;;
  }
  measure: download_card_count {
    type: sum
    sql: ${TABLE}.download_card_count;;
  }
  measure: view_card_count {
    type: sum
    sql: ${TABLE}.view_card_count;;
  }
}
