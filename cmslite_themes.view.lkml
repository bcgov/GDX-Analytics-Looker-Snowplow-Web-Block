view: theme_cache {
  derived_table: {
    sql: SELECT DISTINCT theme FROM cmslite.themes ORDER BY 1 ;;
    sql_trigger_value: SELECT endtime FROM cmslite.microservice_log ORDER BY endtime DESC LIMIT 1 ;;
    distribution_style: all
  }
  dimension: theme {}
}

view: subtheme_cache {
  derived_table: {
    sql: SELECT DISTINCT subtheme FROM cmslite.themes ORDER BY 1 ;;
    sql_trigger_value: SELECT endtime FROM cmslite.microservice_log ORDER BY endtime DESC LIMIT 1 ;;
    distribution_style: all
  }
  dimension: subtheme {}
}

# hidden explores for suggest_explore and suggest_dimensions to reference
explore: theme_cache {
  hidden: yes
}

explore: subtheme_cache {
  hidden: yes
}

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
    sql: ${TABLE}.theme ;;
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
    sql: ${TABLE}.subtheme ;;
    suggest_explore: subtheme_cache
    suggest_dimension: subtheme_cache.subtheme
  }

  # subtheme ID
  # the CMSL subtheme ID
  dimension: subtheme_id {
    description: "The alphanumeric CMS Lite subtheme identifier."
    type: string
    sql: ${TABLE}.subtheme_id ;;
  }

}
