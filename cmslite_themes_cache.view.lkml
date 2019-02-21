view: theme_cache {
  derived_table: {
    sql: SELECT DISTINCT subtheme_id, subtheme, theme_id, theme FROM cmslite.themes ORDER BY 1 ;;
    sql_trigger_value: SELECT endtime FROM cmslite.microservice_log ORDER BY endtime DESC LIMIT 1 ;;
    distribution_style: all
  }
  dimension: theme_id {}
  dimension: theme {}
  dimension: subtheme_id {}
  dimension: subtheme {}
}
