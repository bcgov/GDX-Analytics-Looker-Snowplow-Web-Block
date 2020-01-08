include: "//cmslite_metadata/views/metadata.view"

view: theme_cache {
  derived_table: {
    sql: SELECT subtheme_id, subtheme, theme_id, theme, topic_id, topic FROM ${themes.SQL_TABLE_NAME} ;;
    sql_trigger_value: SELECT MAX(endtime) FROM ${microservice_log.SQL_TABLE_NAME}  ;;
    distribution_style: all
  }
  dimension: theme_id {}
  dimension: theme {}
  dimension: subtheme_id {}
  dimension: subtheme {}
  dimension: topic_id {}
  dimension: topic {}
}
