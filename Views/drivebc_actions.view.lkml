include: "/Includes/date_comparisons_common.view"

view: drivebc_actions {
  label: "DriveBC Actions"
  derived_table: {
    sql: SELECT
          dba.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          action,
          category,
          section,
          label,
          sub_label,
          -- CASE WHEN action IN ('area_restriction_outbound_click','orders_outbound_click') THEN text ELSE NULL END AS url,
          -- action counts
          -- CASE WHEN action = 'feature_layer_navigation' THEN 1 ELSE 0 END AS feature_layer_navigation_count,
          -- action session counts
          -- CASE WHEN action = 'feature_layer_navigation' THEN domain_sessionid ELSE NULL END AS feature_layer_navigation_session_count,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', dba.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_drivebc_action_1  AS dba
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
          ON dba.root_id = wp.root_id AND dba.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON dba.root_id = events.event_id AND dba.root_tstamp = events.collector_tstamp
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
  dimension: root_id {}

  dimension: action {}
  dimension: category {
    drill_fields: [label, section]
  }
  dimension: section {}
  dimension: label {
    drill_fields: [sub_label, section]
  }
  dimension: sub_label {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
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

}
