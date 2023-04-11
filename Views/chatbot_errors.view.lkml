include: "/Includes/date_comparisons_common.view"

view: chatbot_errors {
  derived_table: {
    sql:
        SELECT wp.id,
          ce.root_id AS chat_event_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          agent,
          code,
          frontend_id,
          ce.session_id AS chat_session_id,
          domain_sessionid AS session_id,
          status,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', ce.root_tstamp) AS timestamp,
          message,
          CASE
            WHEN message LIKE 'NotFoundException: Agent metadata not found for agentId%' THEN 'Agent metadata not found'
            WHEN message LIKE 'RpcException: project:ggl-chatbot-megaagent-prod has billing disabled%' THEN 'project:ggl-chatbot-megaagent-prod has billing disabled'
            WHEN message LIKE 'RpcException: Request throttled at the client by AdaptiveThrottler%' THEN 'Request throttled at the client by AdaptiveThrottler'
            WHEN message LIKE 'RpcException: Quota exceeded for quota metric ''Dialogflow Essentials Edition text query operations'' and limit ''Dialogflow Essentials Edition text query operations per minute'' %' THEN 'Quota exceeded for quota metric ''Dialogflow Essentials Edition text query operations'' and limit ''Dialogflow Essentials Edition text query operations per minute'''
            WHEN message LIKE 'RpcException: IAM permission ''dialogflow.sessions.detectIntent'' on ''projects/ggl-moh-dhs-healthlink-dev/agent'' denied%' THEN 'IAM permission ''dialogflow.sessions.detectIntent'' on ''projects/ggl-moh-dhs-healthlink-dev/agent'' denied'
            WHEN message LIKE 'RpcException: Intent with%not found among intents in environment%' THEN 'Intent not found among intents in environment'
            WHEN message LIKE 'Bot has stopped%' THEN 'Bot has stopped'
            ELSE message
          END AS message_catagory


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
  dimension: chat_event_id {
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
  dimension: message_catagory{
    type:  string
    sql: ${TABLE}.message_catagory;;
    drill_fields: [message]
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
