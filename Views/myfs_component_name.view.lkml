view: myfs_component_name {
  derived_table: {
    sql:
     WITH big_list AS ( SELECT
          ROW_NUMBER () OVER (PARTITION BY wp.id) AS index,
          wp.id, cn.*, pv.session_id
        FROM atomic.ca_bc_gov_myfs_component_name_1  AS cn
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON cn.root_id = wp.root_id AND cn.root_tstamp = wp.root_tstamp
        JOIN derived.page_views AS pv ON pv.page_view_id = wp.id
        WHERE component_name <> 'Undefined'
        ORDER BY cn.root_tstamp ASC
      ),
      list AS ( SELECT
          big_list.*,
          ROW_NUMBER () OVER (PARTITION BY session_id) AS index_in_session
        FROM big_list
        WHERE index = 1
        ORDER BY root_tstamp ASC
      ),
      session_info AS ( SELECT
          session_id,
          MAX(index_in_session) AS max_index,
          MIN(index_in_session) AS min_index
        FROM list
        GROUP BY session_id
      )
      SELECT
        list.index_in_session, list.id, list.root_tstamp, list.component_name, list.session_id,
        session_info.max_index, session_info.min_index,
        CASE WHEN list.index_in_session = min_index THEN TRUE ELSE FALSE END AS first_component,
        CASE WHEN list.index_in_session = max_index THEN TRUE ELSE FALSE END AS last_component
      FROM list
      JOIN session_info ON session_info.session_id = list.session_id;;
    distribution_style: all
    persist_for: "2 hours"
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: component_name {
    type: string
    sql: ${TABLE}.component_name ;;
  }
  dimension: first_component {
    type: yesno
    sql: ${TABLE}.first_component ;;
    group_label: "Component Order"
  }
  dimension: last_component {
    type: yesno
    sql: ${TABLE}.last_component ;;
    group_label: "Component Order"
    }
  dimension: component_order {
    type: string
    sql: CASE WHEN ${TABLE}.first_component THEN 'First'
              WHEN ${TABLE}.last_component THEN 'Last'
              ELSE 'Middle' END ;;
    group_label: "Component Order"
  }
measure: first_component_count {
  type: sum
  sql: CASE WHEN ${TABLE}.first_component THEN 1 ELSE 0 END;;
}
measure: last_component_count {
  type: sum
  sql: CASE WHEN ${TABLE}.last_component THEN 1 ELSE 0 END;;
}
}
