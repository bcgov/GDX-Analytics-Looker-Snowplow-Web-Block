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


  dimension: asset_folder {
    description: "Dev version of asset folders for FOI work"
    type: string
    sql: CASE
       WHEN ${parent_node_id} = '5CAE76ADAE994DC8B60212BA6DF22ED0' THEN 'Open Government'
       WHEN ${parent_node_id} = '7C24ACD5C5E54395877764D1D6278D12' THEN 'Open Information'
       WHEN ${parent_node_id} = '0AC4388189F44A4C962D526F80940BE3' THEN 'Alternative Service Delivery Contracts'
       WHEN ${parent_node_id} = '298AD3F178704B8F84020CE3F44217E8' THEN 'Archive'
       WHEN ${parent_node_id} = '455436B6ED734A9FA3987A12492E0AA2' THEN 'Calendars'
       WHEN ${parent_node_id} = '1AA5208799524175BB2248D63154F74C' THEN 'Directly_Awarded_Contracts'
       WHEN ${parent_node_id} = 'E005949023DE4ED28729F906352F9593' THEN 'Jan_2018_calendars'
       WHEN ${parent_node_id} = 'CA5A6D0BE40C4E0DBD28B9F852FD8C1D' THEN 'pattern library'
       ELSE NULL
       END ;;
  }

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
