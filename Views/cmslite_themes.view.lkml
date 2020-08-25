# ================================================================================
# NOTE: Changes here should be replicated in https://analytics.gov.bc.ca/projects/google_api/files/cmslite_themes.view.lkml
# ================================================================================

include: "//cmslite_metadata/Views/themes.view"

view: cmslite_themes {
  extends: [themes]

  # Hide unneeded dimensions from base view
  dimension: parent_node_id {hidden: yes}
  dimension: parent_title {hidden:yes}
  dimension: title {hidden: yes}
  dimension: hr_url {hidden: yes}

  # theme
  # the CMSL theme
  dimension: theme {
    description: "The CMS Lite theme."
    type: string
    drill_fields: [subtheme, topic]
    sql: COALESCE(${TABLE}.theme, '(no theme)') ;;
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
    description: "The alphanumeric CMS Lite theme identifer."
    type: string
    sql: COALESCE(${TABLE}.theme_id,'') ;;
  }

  # subtheme
  # the CMSL subtheme
  dimension: subtheme {
    description: "The CMS Lite subtheme."
    type: string
    drill_fields: [topic]
    sql: COALESCE(${TABLE}.subtheme, '(no subtheme)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.subtheme
  }

  # subtheme ID
  # the CMSL subtheme ID
  dimension: subtheme_id {
    description: "The alphanumeric CMS Lite subtheme identifier."
    type: string
    sql: COALESCE(${TABLE}.subtheme_id,'') ;;
  }

  # topic
  # the CMSL topic
  dimension: topic {
    description: "The CMS Lite topic."
    type: string
    sql: COALESCE(${TABLE}.topic, '(no topic)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.topic
  }

  # topic ID
  # the CMSL topic ID
  dimension: topic_id {
    description: "The alphanumeric CMS Lite topic identifier."
    type: string
    sql: COALESCE(${TABLE}.topic_id,'') ;;
  }

  # subtopic
  # the CMSL subtopic
  dimension: subtopic {
    description: "The CMS Lite subtopic."
    type: string
    sql: COALESCE(${TABLE}.subtopic, '(no subtopic)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.subtopic
  }

  # subtopic ID
  # the CMSL subtopic ID
  dimension: subtopic_id {
    description: "The alphanumeric CMS Lite subtopic identifier."
    type: string
    sql: COALESCE(${TABLE}.subtopic_id,'') ;;
  }

  # subsubtopic
  # the CMSL subsubtopic
  dimension: subsubtopic {
    description: "The CMS Lite subsubtopic."
    type: string
    sql: COALESCE(${TABLE}.subsubtopic, '(no subsubtopic)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.subsubtopic
  }

  # subsubtopic ID
  # the CMSL subsubtopic ID
  dimension: subsubtopic_id {
    description: "The alphanumeric CMS Lite subsubtopic identifier."
    type: string
    sql: COALESCE(${TABLE}.subsubtopic_id,'') ;;
  }

}
