include: "/Includes/date_comparisons_common.view"

view: pims_searches {
  label: "PIMS Searches"
  derived_table: {
    sql: SELECT
          ps.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          address,
          agency,
          classification,
          erp_properties,
          fiscal_year,
          land_only,
          location,
          lot_max,
          lot_min,
          net_usable,
          pid_pin,
          predominate_use,
          project_name_number,
          property_name,
          results_count,
          spl_properties,
          statuses,
          view,
          -- view counts
          CASE WHEN view = 'map' THEN 1 ELSE 0 END AS map_count,
          CASE WHEN view = 'property_inventory' THEN 1 ELSE 0 END AS property_inventory_count,
          CASE WHEN view = 'agency_projects' THEN 1 ELSE 0 END AS agency_projects_count,
          CASE WHEN view = 'spl_projects' THEN 1 ELSE 0 END AS spl_projects_count,
          CASE WHEN view = 'surplus_properties' THEN 1 ELSE 0 END AS surplus_properties_count,
          -- view session counts
          CASE WHEN view = 'map' THEN domain_sessionid ELSE NULL END AS map_session_count,
          CASE WHEN view = 'property_inventory' THEN domain_sessionid ELSE NULL END AS property_inventory_session_count,
          CASE WHEN view = 'agency_projects' THEN domain_sessionid ELSE NULL END AS agency_projects_session_count,
          CASE WHEN view = 'spl_projects' THEN domain_sessionid ELSE NULL END AS spl_projects_session_count,
          CASE WHEN view = 'surplus_properties' THEN domain_sessionid ELSE NULL END AS surplus_properties_session_count,


          CONVERT_TIMEZONE('UTC', 'America/Vancouver', ps.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_pims_search_1 AS ps
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
          ON ps.root_id = wp.root_id AND ps.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON ps.root_id = events.event_id AND ps.root_tstamp = events.collector_tstamp
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


  dimension: address {}
  dimension: agency {}
  dimension: classification {}
  dimension: erp_properties {}
  dimension: fiscal_year {}
  dimension: land_only {}
  dimension: location {}
  dimension: lot_max {}
  dimension: lot_min {}
  dimension: net_usable {}
  dimension: pid_pin {
    label: "PID/PIN"
  }
  dimension: predominate_use {}
  dimension: project_name_number {}
  dimension: property_name {}
  dimension: results_count {}
  dimension: spl_properties {}
  dimension: statuses {}
  dimension: view {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
    label: "Search Count"
  }
  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

  measure: map_search_count {
    type: sum
  }
  measure: property_inventory_search_count {
    type: sum
  }
  measure: agency_projects_inventory_search_count {
    type: sum
  }
  measure: spl_projects_search_count {
    type: sum
  }
  measure: surplus_properties_search_count {
    type: sum
  }

  measure: map_search_session_count {
    type: count_distinct
    sql: ${TABLE}.map_session_count;;
    sql_distinct_key: ${TABLE}.map_session_count;;
  }
  measure: property_inventory_search_session_count {
    type: count_distinct
    sql: ${TABLE}.property_inventory_session_count;;
    sql_distinct_key: ${TABLE}.property_inventory_session_count;;
  }
  measure: agency_projects_search_session_count {
    type: count_distinct
    sql: ${TABLE}.agency_projects_session_count;;
    sql_distinct_key: ${TABLE}.agency_projects_session_count;;
  }
  measure: spl_projects_search_session_count {
    type: count_distinct
    sql: ${TABLE}.spl_projects_session_count;;
    sql_distinct_key: ${TABLE}.spl_projects_session_count;;
  }
  measure: surplus_properties_search_session_count {
    type: count_distinct
    sql: ${TABLE}.surplus_properties_session_count;;
    sql_distinct_key: ${TABLE}.surplus_properties_session_count;;
  }
}
