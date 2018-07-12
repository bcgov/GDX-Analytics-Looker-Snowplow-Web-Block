view: com_snowplowanalytics_snowplow_ua_parser_context_1 {
  sql_table_name: atomic.com_snowplowanalytics_snowplow_ua_parser_context_1 ;;

  dimension: device_family {
    type: string
    sql: ${TABLE}.device_family ;;
  }

  dimension: os_family {
    type: string
    sql: ${TABLE}.os_family ;;
  }

  dimension: os_major {
    type: string
    sql: ${TABLE}.os_major ;;
  }

  dimension: os_minor {
    type: string
    sql: ${TABLE}.os_minor ;;
  }

  dimension: os_patch {
    type: string
    sql: ${TABLE}.os_patch ;;
  }

  dimension: os_patch_minor {
    type: string
    sql: ${TABLE}.os_patch_minor ;;
  }

  dimension: os_version {
    type: string
    sql: ${TABLE}.os_version ;;
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

  dimension: useragent_family {
    type: string
    sql: ${TABLE}.useragent_family ;;
  }

  dimension: useragent_major {
    type: string
    sql: ${TABLE}.useragent_major ;;
  }

  dimension: useragent_minor {
    type: string
    sql: ${TABLE}.useragent_minor ;;
  }

  dimension: useragent_patch {
    type: string
    sql: ${TABLE}.useragent_patch ;;
  }

  dimension: useragent_version {
    type: string
    sql: ${TABLE}.useragent_version ;;
  }

  measure: count {
    type: count
    drill_fields: [schema_name]
  }
}
