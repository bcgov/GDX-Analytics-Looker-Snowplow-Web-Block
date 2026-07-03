include: "/Includes/date_comparisons_common.view"

view: bcparks_action {
  derived_table: {
    sql: SELECT wp.id AS page_view_id, page_urlhost, domain_sessionid AS session_id,
          action,
          result_count,
          city_name,
          park_name,
          label,
          "filters.activities" AS activities,
          "filters.area" AS area,
          "filters.camping" AS camping,
          "filters.facilities" AS facilities,
          "filters.popular" AS popular,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', bcpa.root_tstamp) AS timestamp,
          CASE WHEN "park_name" IS NOT NULL THEN 1 ELSE 0 END AS park_name_count,
          CASE WHEN "city_name" IS NOT NULL THEN 1 ELSE 0 END AS city_name_count,
          CASE WHEN "filters.activities" IS NOT NULL THEN 1 ELSE 0 END AS activities_count,
          CASE WHEN "filters.area" IS NOT NULL THEN 1 ELSE 0 END AS area_count,
          CASE WHEN "filters.camping" IS NOT NULL  THEN 1 ELSE 0 END AS camping_count,
          CASE WHEN "filters.facilities" IS NOT NULL THEN 1 ELSE 0 END AS facilities_count,
          CASE WHEN "filters.popular" IS NOT NULL  THEN 1 ELSE 0 END AS popular_count,
          --
          CASE WHEN action = 'accordion_open' THEN 1 ELSE 0 END AS accordion_open_count,
          CASE WHEN action = 'accordion_close' THEN 1 ELSE 0 END AS accordion_close_count,
          CASE WHEN action = 'clear_filters' THEN 1 ELSE 0 END AS clear_filters_count,
          CASE WHEN action = 'link_click' THEN 1 ELSE 0 END AS link_click_count,
          CASE WHEN action = 'update_search' THEN 1 ELSE 0 END AS update_search_count,
          CASE WHEN action = 'search' THEN 1 ELSE 0 END AS search_count

        FROM atomic.ca_bc_gov_bcparks_action_1 AS bcpa
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON bcpa.root_id = wp.root_id AND bcpa.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON bcpa.root_id = events.event_id AND bcpa.root_tstamp = events.collector_tstamp
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %}
          ;;
    distribution_style: all
    datagroup_trigger: datagroup_25_55
    increment_key: "event_hour"
    increment_offset: 3
  }

  extends: [date_comparisons_common]
  dimension_group: filter_start {
    sql:  ${TABLE}.timestamp ;;
  }

  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }

  dimension: page_urlhost {}

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }
  dimension: label {}

  dimension_group: event {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }


  # FILTER DIMENSIONS

  dimension: activities {}
  dimension: area {}
  dimension: city_name {}
  dimension: park_name {}
  dimension: camping {}
  dimension: facilities {}
  dimension: popular {}


  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

  # FILTER CATEGORY COUNTS
  measure: activities_count {
    group_label: "Filter Category Counts"
    type: sum
    sql: ${TABLE}.activities_count ;;
  }
  measure: park_name_count {
    group_label: "Filter Category Counts"
    type: sum
    sql: ${TABLE}.park_name_count ;;
  }
  measure: city_name_count {
    group_label: "Filter Category Counts"
    type: sum
    sql: ${TABLE}.city_name_count ;;
  }
  measure: area_count {
    group_label: "Filter Category Counts"
    type: sum
    sql: ${TABLE}.area_count ;;
  }
  measure: camping_count {
    group_label: "Filter Category Counts"
    type: sum
    sql: ${TABLE}.camping_count ;;
  }
  measure: facilities_count {
    group_label: "Filter Category Counts"
    type: sum
    sql: ${TABLE}.facilities_count ;;
  }
  measure: popular_count {
    group_label: "Filter Category Counts"
    type: sum
    sql: ${TABLE}.popular_count ;;
  }

  measure: row_count {
    type: count
  }
  # ACTION COUNTS
  measure: accordion_open_count {
    group_label: "Action Counts"
    type: sum
    sql: ${TABLE}.accordion_open_count ;;
  }
  measure: accordion_close_count {
    group_label: "Action Counts"
    type: sum
    sql: ${TABLE}.accordion_close_count ;;
  }
  measure: clear_filters_count {
    group_label: "Action Counts"
    type: sum
    sql: ${TABLE}.clear_filters_count ;;
  }
  measure: link_click_count {
    group_label: "Action Counts"
    type: sum
    sql: ${TABLE}.link_click_count ;;
  }
  measure: update_search_count {
    group_label: "Action Counts"
    type: sum
    sql: ${TABLE}.update_search_count ;;
  }
  measure: search_count {
    group_label: "Action Counts"
    type: sum
    sql: ${TABLE}.search_count ;;
  }


}
