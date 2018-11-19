view: cmslite_themes {
  derived_table: {
    sql: WITH ids AS (
      SELECT cm.node_id,
          CASE
            WHEN cm.parent_node_id = 'CA4CBBBB070F043ACF7FB35FE3FD1081' and cm.page_type = 'BC Gov Theme' THEN cm.node_id -- On Gov.bc.ca, a page with this as root IS a theme. Will change node_id to title when available
            WHEN cm.ancestor_nodes = '||' THEN cm.parent_node_id
            ELSE TRIM(SPLIT_PART(cm.ancestor_nodes, '|', 2)) -- take the second entry. The first is always blank as the string has '|' on each end
          END AS theme_id,
          CASE
            WHEN cm.parent_node_id = 'CA4CBBBB070F043ACF7FB35FE3FD1081' THEN NULL -- this page IS a theme, not a sub-theme
            WHEN cm.ancestor_nodes = '||' AND cm.page_type = 'BC Gov Theme' THEN cm.node_id -- this page is a sub-theme
            WHEN TRIM(SPLIT_PART(cm.ancestor_nodes, '|', 3)) = '' AND cm_parent.page_type = 'BC Gov Theme' THEN cm.parent_node_id -- the page's parent is a sub-theme
            WHEN TRIM(SPLIT_PART(cm.ancestor_nodes, '|', 3)) <> '' THEN TRIM(SPLIT_PART(cm.ancestor_nodes, '|', 3)) -- take the third entry. The first is always blank as the string has '|' on each end and the second is the theme
            ELSE NULL
          END AS subtheme_id
          FROM cmslite.metadata AS cm
          LEFT JOIN cmslite.metadata AS cm_parent ON cm_parent.page_type = 'BC Gov Theme' AND cm_parent.node_id = cm.parent_node_id
      )
      SELECT
      ids.*,
      cm_theme.title AS theme,
      cm_sub_theme.title AS subtheme
      FROM ids
      LEFT JOIN cmslite.metadata AS cm_theme ON cm_theme.node_id = theme_id
      LEFT JOIN cmslite.metadata AS cm_sub_theme ON cm_sub_theme.node_id = subtheme_id
      ;;
    persist_for: "24 hours"
    distribution_style: all
  }

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
