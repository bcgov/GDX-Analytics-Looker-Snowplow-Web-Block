view: snplow_monitor_detail {
  sql_table_name: atomic.snplow_monitor_detail ;;

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension_group: etl_tstamp {
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
    sql: ${TABLE}.etl_tstamp ;;
  }

  dimension_group: max {
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
    sql: ${TABLE}.max ;;
  }

  dimension_group: min {
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
    sql: ${TABLE}.min ;;
  }


}
