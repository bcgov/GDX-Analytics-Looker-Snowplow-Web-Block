include: "/Includes/date_comparisons_common.view"

view: pims_listing_clicks{
  label: "PIMS Listing Clicks"
  derived_table: {
    sql: SELECT
          plc.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          agency,
          classification,
          pid,
          pin,
          project_name,
          project_number,
          property_name,
          statuses,
          view,
          -- view counts
          CASE WHEN view = 'map' THEN 1 ELSE 0 END AS map_count,
          CASE WHEN view = 'property_inventory' THEN 1 ELSE 0 END AS property_inventory_count,
          -- view session counts
          CASE WHEN view = 'map' THEN domain_sessionid ELSE NULL END AS map_session_count,
          CASE WHEN view = 'property_inventory' THEN domain_sessionid ELSE NULL END AS property_inventory_session_count,


          CONVERT_TIMEZONE('UTC', 'America/Vancouver', plc.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_pims_listing_click_1 AS plc
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
          ON plc.root_id = wp.root_id AND plc.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON plc.root_id = events.event_id AND plc.root_tstamp = events.collector_tstamp
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


  dimension: agency {
    drill_fields: [classification,pid,pin,project_name,project_number,project_number,statuses]
  }
  dimension: classification {
    drill_fields: [agency,pid,pin,project_name,project_number,project_number,statuses]

  }
  dimension: pid {
    label: "PID"
  }
  dimension: pin {
    label: "PIN"
  }
  dimension: project_name {}
  dimension: project_number {}
  dimension: property_name {}
  dimension: statuses {}
  dimension: view {}


  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
    label: "Click Count"
  }
  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

  measure: map_click_count {
    label: "Map Click Count"
    type: sum
  }
  measure: property_inventory_click_count {
    label: "Property Inventory Click Count"
    type: sum
  }

  measure: map_session_count {
    label: "Map Click Session Count"
    type: count_distinct
    sql: ${TABLE}.map_session_count;;
    sql_distinct_key: ${TABLE}.map_session_count;;
  }

  measure: property_inventory_session_count {
    label: "Property Inventory Click Count"
    type: count_distinct
    sql: ${TABLE}.property_inventory_session_count;;
    sql_distinct_key: ${TABLE}.property_inventory_session_count;;
  }


}
