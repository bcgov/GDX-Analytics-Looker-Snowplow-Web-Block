view: welcomebc_actions {
  derived_table: {
    sql: SELECT wp.id AS page_view_id,
          action,
          message,
          text,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          COALESCE(events.page_url,'') AS page_url,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', wc.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_welcomebc_action_1 AS wc
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
          ON wc.root_id = wp.root_id AND wc.root_tstamp = wp.root_tstamp
        LEFT JOIN atomic.events ON wc.root_id = events.event_id AND wc.root_tstamp = events.collector_tstamp

      ;;
    distribution_style: all
    persist_for: "2 hours"
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

  dimension: page_url {}
  dimension: page_display_url {
    sql:  SPLIT_PART(SPLIT_PART(${page_url},'#',1), '?', 1) ;;
  }
  dimension: page_urlhost {}

  dimension: action {}
  dimension: text {}
  dimension: message {}
  dimension: session_id {}




  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
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

}
