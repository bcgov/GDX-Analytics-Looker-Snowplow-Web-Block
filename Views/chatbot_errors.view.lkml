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
          session_id,
          status

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


}
