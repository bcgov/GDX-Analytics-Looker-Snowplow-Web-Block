include: "/Includes/date_comparisons_common.view"

view: chatbot_errors {
  derived_table: {
    sql:
        SELECT wp.id,
          ce.root_id AS chat_error_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          agent,
          code,
          frontend_id,
          message,
          ce.session_id AS chat_session_id,
          domain_sessionid AS session_id,
          status,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', ce.root_tstamp) AS timestamp

      FROM atomic.ca_bc_gov_chatbot_error_2 AS ce
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON ce.root_id = wp.root_id AND ce.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON ce.root_id = events.event_id AND ce.root_tstamp = events.collector_tstamp
      ;;

    distribution_style: all
    persist_for: "2 hours"
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
  }
  dimension: id {
    type: string
    label: "Page View ID"
    sql: ${TABLE}.id ;;
  }
  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }
  dimension: chat_error_id {
    type: string
    sql: ${TABLE}.chat_event_id ;;
  }
  dimension: code {
    type: string
    sql: ${TABLE}.code ;;
  }
  dimension: agent {
    type: string
    sql: ${TABLE}.agent ;;
  }
  dimension: frontend_id {
    type: string
    sql: ${TABLE}.frontend_id ;;
  }
  dimension: message {
    type: string
    sql: ${TABLE}.message ;;
  }
  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  measure: count {
    type: count
  }
  measure: session_count {
    description: "Count of the outcome over distinct Browser Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }
  measure: chat_session_count {
    description: "Count of the outcome over distinct Chat Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.chat_session_id ;;
    sql: ${TABLE}.chat_session_id  ;;
  }
}
