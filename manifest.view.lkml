view: manifest {
  sql_table_name: atomic.manifest ;;

  dimension_group: commit_tstamp {
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
    sql: ${TABLE}.commit_tstamp ;;
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

  dimension: event_count {
    type: number
    sql: ${TABLE}.event_count ;;
  }

  dimension: shredded_cardinality {
    type: number
    sql: ${TABLE}.shredded_cardinality ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
