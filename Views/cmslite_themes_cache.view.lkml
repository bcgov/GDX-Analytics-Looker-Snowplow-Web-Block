view: theme_cache {
  derived_table: {
    sql: SELECT subtheme_id, subtheme, theme_id, theme, topic_id, topic, subtopic_id, subtopic, subsubtopic_id, subsubtopic FROM cmslite.themes ;;
    sql_trigger_value: SELECT MAX(endtime) FROM cmslite.microservice_log  ;;
    distribution_style: all
  }
  dimension: theme_id {}
  dimension: theme {}
  dimension: subtheme_id {}
  dimension: subtheme {}
  dimension: topic_id {}
  dimension: topic {}
  dimension: subtopic_id {}
  dimension: subtopic {}
  dimension: subsubtopic_id {}
  dimension: subsubtopic {}
}
