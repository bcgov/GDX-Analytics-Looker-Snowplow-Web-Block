view: snplow_monitor {
  sql_table_name: atomic.snplow_monitor ;;

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

  measure: count {
    type: count
    drill_fields: []
  }
}
