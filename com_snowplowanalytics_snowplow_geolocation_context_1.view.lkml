view: com_snowplowanalytics_snowplow_geolocation_context_1 {
  sql_table_name: atomic.com_snowplowanalytics_snowplow_geolocation_context_1 ;;

  dimension: altitude {
    type: number
    sql: ${TABLE}.altitude ;;
  }

  dimension: altitude_accuracy {
    type: number
    sql: ${TABLE}.altitude_accuracy ;;
  }

  dimension: bearing {
    type: number
    sql: ${TABLE}.bearing ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: latitude_longitude_accuracy {
    type: number
    sql: ${TABLE}.latitude_longitude_accuracy ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
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

  dimension: speed {
    type: number
    sql: ${TABLE}.speed ;;
  }

  measure: count {
    type: count
    drill_fields: [schema_name]
  }
}
