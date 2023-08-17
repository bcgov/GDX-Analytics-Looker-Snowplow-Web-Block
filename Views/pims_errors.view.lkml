view: pims_errors {
  label: "PIMS Errors"
  derived_table: {
    sql: SELECT
          pe.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          error_message,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', pe.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_pims_error_1 AS pe
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
          ON pe.root_id = wp.root_id AND pe.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON pe.root_id = events.event_id AND pe.root_tstamp = events.collector_tstamp
      ;;
    distribution: "page_view_id"
    sortkeys: ["page_view_id","timestamp"]
    persist_for: "2 hours"
    #datagroup_trigger: datagroup_healthgateway_updated
    #increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    #increment_offset: 3
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


  dimension: error_message {}


  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
    label: "Error Count"
  }
  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

}
