include: "/Includes/date_comparisons_common.view"

view: user_feedback{
  derived_table: {
    sql: SELECT
          fa.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          page_urlscheme || '://' || page_urlhost || regexp_replace(page_urlpath, 'index.(html|htm|aspx|php|cgi|shtml|shtm)$','') AS page_display_url,
          action,
          fa.id,
          list,
          text,
          CASE WHEN action = 'Load' THEN 1 ELSE 0 END AS load_count,
          CASE WHEN action = 'Back' THEN 1 ELSE 0 END AS back_count,
          CASE WHEN action = 'Close' THEN 1 ELSE 0 END AS close_count,
          CASE WHEN action = 'Thumbs Up' THEN 1 ELSE 0 END AS thumbs_up_count,
          CASE WHEN action = 'Thumbs Down' THEN 1 ELSE 0 END AS thumbs_down_count,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', fa.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_feedback_feedback_action_1 AS fa
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
      ON fa.root_id = wp.root_id AND fa.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON fa.root_id = events.event_id AND fa.root_tstamp = events.collector_tstamp
      ;;
    distribution: "page_view_id"
    sortkeys: ["page_view_id","timestamp"]
    persist_for: "2 hours"
    #datagroup_trigger: datagroup_healthgateway_updated
    #increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    #increment_offset: 3
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
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
  dimension: id {}
  dimension: list {}
  dimension: text {}
  dimension: session_id {}
  dimension: page_display_url {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
    label: "Count"
  }

  measure: thumbs_up_count {
    type: sum
    sql: ${TABLE}.thumbs_up_count ;;
  }

  measure: thumbs_down_count {
    type: sum
    sql: ${TABLE}.thumbs_down_count ;;
  }

  measure: load_count {
    type: sum
    sql: ${TABLE}.load_count ;;
  }

  measure: close_count {
    type: sum
    sql: ${TABLE}.close_count ;;
  }
  measure: back_count {
    type: sum
    sql: ${TABLE}.back_count ;;
  }


  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

}
