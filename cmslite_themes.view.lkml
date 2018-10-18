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

  dimension: node_id {
    type: string
    sql: ${TABLE}.node_id ;;
  }

  dimension: theme {
    type: string
    sql: ${TABLE}.theme ;;
  }
  dimension: theme_id {
    type: string
    sql: COALESCE(${TABLE}.theme_id,'') ;; #ensure that this field is not NULL, so that user attribute filters work
  }

  dimension: subtheme {
    type: string
    sql: ${TABLE}.subtheme ;;
  }
  dimension: subtheme_id {
    type: string
    sql: ${TABLE}.subtheme_id ;;
  }

}
