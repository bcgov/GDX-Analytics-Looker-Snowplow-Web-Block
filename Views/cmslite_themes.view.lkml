# ================================================================================
# NOTE: Changes here should be replicated in https://analytics.gov.bc.ca/projects/google_api/files/cmslite_themes.view.lkml
# ================================================================================

include: "//cmslite_metadata/views/themes.view"

view: cmslite_themes {
  #sql_table_name: cmslite.themes ;;
  extends: [themes]

  # theme
  # the CMSL theme
  dimension: theme {
    drill_fields: [subtheme, topic]
    sql: COALESCE(${themes.node_id}, '(no theme)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.theme
  }

  # node_id
  # the CMSL theme ID
  #
  # the COALESCSE expression ensures that a blank value is returned in the
  # case where the ${TABLE}.theme_id value is missing or null; ensurinig that
  # user attribute filters will continue to work.
  #
  # reference - https://docs.aws.amazon.com/redshift/latest/dg/r_NVL_function.html
  dimension: theme_id {
    sql: COALESCE(${themes.theme_id},'') ;;
  }

  # subtheme
  # the CMSL subtheme
  dimension: subtheme {
    drill_fields: [topic]
    sql: COALESCE(${themes.subtheme}, '(no subtheme)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.subtheme
  }

  # subtheme ID
  # the CMSL subtheme ID
  dimension: subtheme_id {
    sql: COALESCE(${themes.subtheme_id},'') ;;
  }

  # topic
  # the CMSL topic
  dimension: topic {
    sql: COALESCE(${themes.topic}, '(no topic)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.topic
  }

  # topic ID
  # the CMSL topic ID
  dimension: topic_id {
    sql: COALESCE(${themes.topic_id},'') ;;
  }

}
