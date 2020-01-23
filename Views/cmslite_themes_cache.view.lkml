view: theme_cache {
  derived_table: {
    sql: SELECT subtheme_id, subtheme, theme_id, theme, topic_id, topic FROM cmslite.themes ;;
    sql_trigger_value: SELECT MAX(endtime) FROM cmslite.microservice_log  ;;
    distribution_style: all
  }
  dimension: theme_id {}
  dimension: theme {}
  dimension: subtheme_id {}
  dimension: subtheme {}
  dimension: topic_id {}
  dimension: topic {}
}
