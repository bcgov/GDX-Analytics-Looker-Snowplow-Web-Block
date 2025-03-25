# Version: 1.0.0
include: "/Includes/date_comparisons_common.view"

view: tenancy_dispute_clicks  {
  derived_table: {
    sql: SELECT
          rc.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          source_url,
          target_url,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', rc.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_rtb_click_1  AS rc
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
          ON rc.root_id = wp.root_id AND rc.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON rc.root_id = events.event_id AND rc.root_tstamp = events.collector_tstamp
      WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        ;;
    distribution: "page_view_id"
    sortkeys: ["page_view_id","timestamp"]
    datagroup_trigger: datagroup_healthgateway_updated
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
                # to reprocess up to 3 hours of results
    increment_offset: 3
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

  dimension: source_url {
    drill_fields: [target_url]
  }
  dimension: target_url {
    drill_fields: [source_url]
    link: {
      label: "Visit Page"
      url: "{{ value }}"
    }
  }


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
