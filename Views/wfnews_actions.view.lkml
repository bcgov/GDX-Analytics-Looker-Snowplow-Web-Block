view: wfnews_actions {
  label: "Wildfire News Actions"
  derived_table: {
    sql: SELECT
          wf.root_id AS root_id,
          wp.id AS page_view_id,domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          action,
          wf.id,
          text,
          area,
          CASE WHEN action = 'wildfire_list_click' THEN 1 ELSE 0 end AS wildfire_list_click_count,
          CASE WHEN action = 'order_list_click' THEN 1 ELSE 0 end AS order_list_click_count,
          CASE WHEN action = 'feature_layer_navigation' THEN 1 ELSE 0 end AS feature_layer_navigation_count,
          CASE WHEN action = 'incident_tab_change' THEN 1 ELSE 0 end AS incident_tab_change_count,
          CASE WHEN action = 'location_search' THEN 1 ELSE 0 end AS location_search_count,
          CASE WHEN action = 'incident_list_options' THEN 1 ELSE 0 end AS incident_list_options_count,
          CASE WHEN action = 'area_restriction_outbound_click' THEN 1 ELSE 0 end AS area_restriction_outbound_click_count,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', wf.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_wfnews_action_1 AS wf
          LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON wf.root_id = wp.root_id AND wf.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON wf.root_id = events.event_id AND wf.root_tstamp = events.collector_tstamp
        -- WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        ;;
    distribution_style: all
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


  dimension: action {}
  dimension: area {}

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

  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

  measure: wildfire_list_click_count {
    type: sum
    sql: ${TABLE}.wildfire_list_click_count;;
  }
  measure: order_list_click_count {
    type: sum
    sql: ${TABLE}.order_list_click_count;;
  }
  measure: feature_layer_navigation_count {
    type: sum
    sql: ${TABLE}.feature_layer_navigation_count;;
  }
  measure: incident_tab_change_count {
    type: sum
    sql: ${TABLE}.incident_tab_change_count;;
  }
  measure: location_search_count {
    type: sum
    sql: ${TABLE}.location_search_count;;
  }
  measure: incident_list_options_count {
    type: sum
    sql: ${TABLE}.incident_list_options_count;;
  }
  measure: area_restriction_outbound_click_count {
    type: sum
    sql: ${TABLE}.area_restriction_outbound_click_count;;
  }

}
