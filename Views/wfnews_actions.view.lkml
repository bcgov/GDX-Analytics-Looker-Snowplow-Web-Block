view: wfnews_actions {
  label: "Wildfire News Actions"
  derived_table: {
    sql: SELECT
          wfa.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          action,
          area,
          wfa.id,
          text,
          -- action counts
          CASE WHEN action = 'feature_layer_navigation' THEN 1 ELSE 0 END AS feature_layer_navigation_count,
          CASE WHEN action = 'location_search' THEN 1 ELSE 0 END AS location_search_count,
          CASE WHEN action = 'incident_tab_change' THEN 1 ELSE 0 END AS incident_tab_change_count,
          CASE WHEN action = 'find_my_location' THEN 1 ELSE 0 END AS find_my_location_count,
          CASE WHEN action = 'wildfire_list_click' THEN 1 ELSE 0 END AS wildfire_list_click_count,
          CASE WHEN action = 'incident_list_options' THEN 1 ELSE 0 END AS incident_list_options_count,
          CASE WHEN action = 'order_list_click' THEN 1 ELSE 0 END AS order_list_click_count,
          CASE WHEN action = 'alert_list_click' THEN 1 ELSE 0 END AS alert_list_click_count,
          CASE WHEN action = 'area_restriction_map_click' THEN 1 ELSE 0 END AS area_restriction_map_click_count,
          CASE WHEN action = 'area_restriction_outbound_click' THEN 1 ELSE 0 END AS area_restriction_outbound_click_count,
          CASE WHEN action = 'orders_outbound_click' THEN 1 ELSE 0 END AS orders_outbound_click_count,
          -- action session counts
          CASE WHEN action = 'feature_layer_navigation' THEN domain_sessionid ELSE NULL END AS feature_layer_navigation_session_count,
          CASE WHEN action = 'location_search' THEN domain_sessionid ELSE NULL END AS location_search_session_count,
          CASE WHEN action = 'incident_tab_change' THEN domain_sessionid ELSE NULL END AS incident_tab_change_session_count,
          CASE WHEN action = 'find_my_location' THEN domain_sessionid ELSE NULL END AS find_my_location_session_count,
          CASE WHEN action = 'wildfire_list_click' THEN domain_sessionid ELSE NULL END AS wildfire_list_click_session_count,
          CASE WHEN action = 'incident_list_options' THEN domain_sessionid ELSE NULL END AS incident_list_options_session_count,
          CASE WHEN action = 'order_list_click' THEN domain_sessionid ELSE NULL END AS order_list_click_session_count,
          CASE WHEN action = 'alert_list_click' THEN domain_sessionid ELSE NULL END AS alert_list_click_session_count,
          CASE WHEN action = 'area_restriction_map_click' THEN domain_sessionid ELSE NULL END AS area_restriction_map_click_session_count,
          CASE WHEN action = 'area_restriction_outbound_click' THEN domain_sessionid ELSE NULL END AS area_restriction_outbound_click_session_count,
          CASE WHEN action = 'orders_outbound_click' THEN domain_sessionid ELSE NULL END AS orders_outbound_click_session_count,

           CONVERT_TIMEZONE('UTC', 'America/Vancouver', wfa.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_wfnews_action_1 AS wfa
          LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON wfa.root_id = wp.root_id AND wfa.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON wfa.root_id = events.event_id AND wfa.root_tstamp = events.collector_tstamp
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


  dimension: action {
    drill_fields: [area,id]
  }
  dimension: area {
    drill_fields: [action,id]
  }
  dimension: id {}
  dimension: text {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
  }
  measure: feature_layer_navigation_count {
    type: sum
  }
  measure: location_search_count {
    type: sum
  }
  measure: incident_tab_change_count {
    type: sum
  }
  measure: find_my_location_count {
    type: sum
  }
  measure: wildfire_list_click_count {
    type: sum
  }
  measure: incident_list_options_count {
    type: sum
  }
  measure: order_list_click_count {
    type: sum
  }
  measure: alert_list_click_count {
    type: sum
  }
  measure: area_restriction_map_click_count {
    type: sum
  }
  measure: area_restriction_outbound_click_count {
    type: sum
  }
  measure: orders_outbound_click_count {
    type: sum
  }

  measure: feature_layer_navigation_session_count {
    type: sum_distinct
    sql: ${TABLE}.feature_layer_navigation_session_count;;
    sql_distinct_key: ${TABLE}.feature_layer_navigation_session_count;;
  }
  measure: location_search_session_count {
    type: sum_distinct
    sql: ${TABLE}.location_search_session_count;;
    sql_distinct_key: ${TABLE}.location_search_session_count;;
  }
  measure: incident_tab_change_session_count {
    type: sum_distinct
    sql: ${TABLE}.incident_tab_change_session_count;;
    sql_distinct_key: ${TABLE}.incident_tab_change_session_count;;
  }
  measure: find_my_location_session_count {
    type: sum_distinct
    sql: ${TABLE}.find_my_location_session_count;;
    sql_distinct_key: ${TABLE}.find_my_location_session_count;;
  }
  measure: wildfire_list_click_session_count {
    type: sum_distinct
    sql: ${TABLE}.wildfire_list_click_session_count;;
    sql_distinct_key: ${TABLE}.wildfire_list_click_session_count;;
  }
  measure: incident_list_options_session_count {
    type: sum_distinct
    sql: ${TABLE}.incident_list_options_session_count;;
    sql_distinct_key: ${TABLE}.incident_list_options_session_count;;
  }
  measure: order_list_click_session_count {
    type: sum_distinct
    sql: ${TABLE}.order_list_click_session_count;;
    sql_distinct_key: ${TABLE}.order_list_click_session_count;;
  }
  measure: alert_list_click_session_count {
    type: sum_distinct
    sql: ${TABLE}.alert_list_click_session_count;;
    sql_distinct_key: ${TABLE}.alert_list_click_session_count;;
  }
  measure: area_restriction_map_click_session_count {
    type: sum_distinct
    sql: ${TABLE}.area_restriction_map_click_session_count;;
    sql_distinct_key: ${TABLE}.area_restriction_map_click_session_count;;
  }
  measure: area_restriction_outbound_click_session_count {
    type: sum_distinct
    sql: ${TABLE}.area_restriction_outbound_click_session_count;;
    sql_distinct_key: ${TABLE}.area_restriction_outbound_click_session_count;;
  }
  measure: orders_outbound_click_session_count {
    type: sum_distinct
    sql: ${TABLE}.orders_outbound_click_session_count;;
    sql_distinct_key: ${TABLE}.orders_outbound_click_session_count;;
  }


  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

}
