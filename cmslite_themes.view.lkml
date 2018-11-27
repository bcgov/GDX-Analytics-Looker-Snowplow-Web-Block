view: cmslite_themes {
  sql_table_name: cmslite.themes ;;

  # node_id
  # the CMSL node ID
  dimension: node_id {
    description: "The alphanumeric CMSL node identifier."
    type: string
    sql: ${TABLE}.node_id ;;
  }

  # theme
  # the CMSL theme
  dimension: theme {
    description: "The CMSL theme."
    type: string
    sql: ${TABLE}.theme ;;
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
    description: "The alphanumeric CMSL theme identifer."
    type: string
    sql: COALESCE(${TABLE}.theme_id,'') ;;
  }

  # subtheme
  # the CMSL subtheme
  dimension: subtheme {
    description: "The CMSL subtheme."
    type: string
    sql: ${TABLE}.subtheme ;;
  }

  # subtheme ID
  # the CMSL subtheme ID
  dimension: subtheme_id {
    description: "The alphanumeric CMSL subtheme identifier."
    type: string
    sql: ${TABLE}.subtheme_id ;;
  }

}
