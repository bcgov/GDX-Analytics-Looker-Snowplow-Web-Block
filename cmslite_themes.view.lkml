# ================================================================================
# NOTE: Changes here should be replicated in https://analytics.gov.bc.ca/projects/google_api/files/cmslite_themes.view.lkml
# ================================================================================

view: cmslite_themes {
  sql_table_name: cmslite.themes ;;

  # node_id
  # the CMSL node ID
  dimension: node_id {
    description: "The alphanumeric CMS Lite node identifier."
    type: string
    sql: ${TABLE}.node_id ;;
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


  ### Custom dimensions for specific users
  # Pages in the Employment Standards Branch
  dimension: esb {
    description: "Pages to include in Employment Standards Branch Dashboards"
    type: string
    sql:  CASE WHEN ${topic_id} = '1B655EB4076248C893E7E7EC20EDE50B' OR ${node_id} IN ('820A75B4A1AF426C9450E4ADF0D1D783', 'B3752C36297F2A17229B69D2A8DF5C92', 'AC26F750350F4E259D8C1FEDDC3D8520', '534F924CA519AD88CF3501C0083F18BD', '04739694EBFE48FD9CC997E21356A2B5', 'F76CF34CF9294EC7AE3372AAE1772C2A', 'CD225564F2E045F78715845A479DD83E', '69A831C7AD3D243EE4E0F740B8D4990C')  THEN 1
            ELSE '' END ;;
  }

}
