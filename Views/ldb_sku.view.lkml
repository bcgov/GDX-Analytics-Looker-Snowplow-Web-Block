view: ldb_sku {
  label: "LDB SKU Lookup Table"
  sql_table_name: microservice.ldb_sku ;;

  dimension: alcohol {
    type: number
    sql: ${TABLE}.alcohol ;;
  }

  dimension: all_upcs {
    type: string
    sql: ${TABLE}.all_upcs ;;
  }

  dimension: availability_override {
    type: yesno
    sql: ${TABLE}.availability_override ;;
  }

  dimension: bcl_select {
    type: yesno
    sql: ${TABLE}.bcl_select ;;
  }

  dimension: blacklist {
    type: yesno
    sql: ${TABLE}.blacklist ;;
  }

  dimension: body {
    type: string
    sql: ${TABLE}.body ;;
  }

  dimension: bottles_per_pack {
    type: number
    sql: ${TABLE}.bottles_per_pack ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    drill_fields: [sub_category]
  }

  dimension: sub_category {
    type: string
    sql: ${TABLE}.sub_category ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    drill_fields: [region,sub_region]
    sql: ${TABLE}.country ;;
  }
  dimension: region {
    type: string
    drill_fields: [sub_region]
    sql: ${TABLE}.region ;;
  }
  dimension: sub_region {
    type: string
    sql: ${TABLE}.sub_region ;;
  }
  dimension: craft_beer {
    type: yesno
    sql: ${TABLE}.craft_beer ;;
  }

  dimension_group: date_added {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_added ;;
  }

  dimension_group: date_removed {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_removed ;;
  }

  dimension: grape_variety {
    type: string
    sql: ${TABLE}.grape_variety ;;
  }

  dimension: image {
    type: string
    sql: ${TABLE}.image ;;
  }

  dimension: inventory {
    type: number
    sql: ${TABLE}.inventory ;;
  }

  dimension: inventory_code {
    type: number
    sql: ${TABLE}.inventory_code ;;
  }

  dimension: kosher {
    type: yesno
    sql: ${TABLE}.kosher ;;
  }

  dimension_group: lto_end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lto_end ;;
  }

  dimension: lto_price {
    type: number
    sql: ${TABLE}.lto_price ;;
  }

  dimension_group: lto_start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lto_start ;;
  }

  dimension: new_flag {
    type: yesno
    sql: ${TABLE}.new_flag ;;
  }

  dimension: organic {
    type: yesno
    sql: ${TABLE}.organic ;;
  }

  dimension: price_override {
    type: yesno
    sql: ${TABLE}.price_override ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}.product_type ;;
  }

  dimension: rating {
    type: number
    sql: ${TABLE}.rating ;;
  }

  dimension: regular_price {
    type: number
    sql: ${TABLE}.regular_price ;;
  }

  dimension: restriction_code {
    type: string
    sql: ${TABLE}.restriction_code ;;
  }

  dimension: sku {
    type: number
    sql: ${TABLE}.sku ;;
  }

  dimension: status_code {
    type: number
    sql: ${TABLE}.status_code ;;
  }

  dimension: store_count {
    type: number
    sql: ${TABLE}.store_count ;;
  }

  dimension: sweetness {
    type: string
    sql: ${TABLE}.sweetness ;;
  }

  dimension: upc {
    type: string
    sql: ${TABLE}.upc ;;
  }

  dimension: volume {
    type: number
    sql: ${TABLE}.volume ;;
  }

  dimension: votes {
    type: number
    sql: ${TABLE}.votes ;;
  }

  dimension: vqa {
    type: yesno
    sql: ${TABLE}.vqa ;;
  }

  dimension: whitelist {
    type: yesno
    sql: ${TABLE}.whitelist ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name]
  }
}
