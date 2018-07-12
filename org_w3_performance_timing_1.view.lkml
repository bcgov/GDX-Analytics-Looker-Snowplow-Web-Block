view: org_w3_performance_timing_1 {
  sql_table_name: atomic.org_w3_performance_timing_1 ;;

  dimension: chrome_first_paint {
    type: number
    sql: ${TABLE}.chrome_first_paint ;;
  }

  dimension: connect_end {
    type: number
    sql: ${TABLE}.connect_end ;;
  }

  dimension: connect_start {
    type: number
    sql: ${TABLE}.connect_start ;;
  }

  dimension: dom_complete {
    type: number
    sql: ${TABLE}.dom_complete ;;
  }

  dimension: dom_content_loaded_event_end {
    type: number
    sql: ${TABLE}.dom_content_loaded_event_end ;;
  }

  dimension: dom_content_loaded_event_start {
    type: number
    sql: ${TABLE}.dom_content_loaded_event_start ;;
  }

  dimension: dom_interactive {
    type: number
    sql: ${TABLE}.dom_interactive ;;
  }

  dimension: dom_loading {
    type: number
    sql: ${TABLE}.dom_loading ;;
  }

  dimension: domain_lookup_end {
    type: number
    sql: ${TABLE}.domain_lookup_end ;;
  }

  dimension: domain_lookup_start {
    type: number
    sql: ${TABLE}.domain_lookup_start ;;
  }

  dimension: fetch_start {
    type: number
    sql: ${TABLE}.fetch_start ;;
  }

  dimension: load_event_end {
    type: number
    sql: ${TABLE}.load_event_end ;;
  }

  dimension: load_event_start {
    type: number
    sql: ${TABLE}.load_event_start ;;
  }

  dimension: ms_first_paint {
    type: number
    sql: ${TABLE}.ms_first_paint ;;
  }

  dimension: navigation_start {
    type: number
    sql: ${TABLE}.navigation_start ;;
  }

  dimension: redirect_end {
    type: number
    sql: ${TABLE}.redirect_end ;;
  }

  dimension: redirect_start {
    type: number
    sql: ${TABLE}.redirect_start ;;
  }

  dimension: ref_parent {
    type: string
    sql: ${TABLE}.ref_parent ;;
  }

  dimension: ref_root {
    type: string
    sql: ${TABLE}.ref_root ;;
  }

  dimension: ref_tree {
    type: string
    sql: ${TABLE}.ref_tree ;;
  }

  dimension: request_start {
    type: number
    sql: ${TABLE}.request_start ;;
  }

  dimension: response_end {
    type: number
    sql: ${TABLE}.response_end ;;
  }

  dimension: response_start {
    type: number
    sql: ${TABLE}.response_start ;;
  }

  dimension: root_id {
    type: string
    sql: ${TABLE}.root_id ;;
  }

  dimension_group: root_tstamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.root_tstamp ;;
  }

  dimension: schema_format {
    type: string
    sql: ${TABLE}.schema_format ;;
  }

  dimension: schema_name {
    type: string
    sql: ${TABLE}.schema_name ;;
  }

  dimension: schema_vendor {
    type: string
    sql: ${TABLE}.schema_vendor ;;
  }

  dimension: schema_version {
    type: string
    sql: ${TABLE}.schema_version ;;
  }

  dimension: secure_connection_start {
    type: number
    sql: ${TABLE}.secure_connection_start ;;
  }

  dimension: unload_event_end {
    type: number
    sql: ${TABLE}.unload_event_end ;;
  }

  dimension: unload_event_start {
    type: number
    sql: ${TABLE}.unload_event_start ;;
  }

  measure: count {
    type: count
    drill_fields: [schema_name]
  }
}
