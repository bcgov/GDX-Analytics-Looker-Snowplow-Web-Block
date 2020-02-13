view: myfs_component_name {
  derived_table: {
    sql: SELECT wp.id, cn.*
          FROM atomic.ca_bc_gov_myfs_component_name_1  AS cn
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON cn.root_id = wp.root_id AND cn.root_tstamp = wp.root_tstamp
          ;;

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
  }
