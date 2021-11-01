view: ldb_clicks {
  label: "LDB Clicks"
  derived_table: {
    sql: SELECT
          lc.root_id AS root_id,
          wp.id AS page_view_id,domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          click_type,
          lc.sku,
          CASE WHEN click_type = 'add_to_cellar' THEN 1 ELSE 0 end AS add_to_cellar_count,
          CASE WHEN click_type = 'where_to_buy' THEN 1 ELSE 0 end AS where_to_buy_count,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', lc.root_tstamp) AS timestamp

        FROM atomic.ca_bc_gov_ldb_click_1 AS lc
          LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON lc.root_id = wp.root_id AND lc.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON lc.root_id = events.event_id AND lc.root_tstamp = events.collector_tstamp
          LEFT JOIN microservice.ldb_sku ON ldb_sku.sku = lc.sku
        WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        ;;
    distribution_style: all
    datagroup_trigger:datagroup_25_55
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
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


  dimension: click_type {}
  dimension: sku {}

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

  measure: add_to_cellar_count {
    type: sum
    sql: ${TABLE}.add_to_cellar_count;;
  }
  measure: where_to_buy_count {
    type: sum
    sql: ${TABLE}.where_to_buy_count;;
  }
}
