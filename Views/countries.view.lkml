view: countries {
  sql_table_name: static.countries ;;

  dimension: country_name {
    type: string
    sql:  ${TABLE}.full_name ;;
  }
  dimension: country_code {
    type: string
    sql:  ${TABLE}.two_letter ;;
  }
}
