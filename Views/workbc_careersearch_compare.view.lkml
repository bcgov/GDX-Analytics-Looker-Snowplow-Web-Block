view: workbc_careersearch_compare {
  derived_table: {
    sql: SELECT wp.id AS page_view_id, action,
          noc_1, noc1.description AS description_1,
          noc_2, noc2.description AS description_2,
          noc_3, noc3.description AS description_3,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', cc.root_tstamp) AS timestamp,
          CASE WHEN action = 'compare' THEN 1 ELSE 0 END AS compare_count,
          CASE WHEN action = 'clear' THEN 1 ELSE 0 END AS clear_count
        FROM atomic.ca_bc_gov_workbc_compare_careers_1 AS cc
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON cc.root_id = wp.root_id AND cc.root_tstamp = wp.root_tstamp
          LEFT JOIN microservice.careertoolkit_workbc AS noc1 -- the "00" trick is temporarily needed until the lookup table gets fixed
              ON noc1.noc = cc.noc_1 OR cc.noc_1 = '0' || noc1.noc OR cc.noc_1 = '00' || noc1.noc OR cc.noc_1 = '00' || noc1.noc
          LEFT JOIN microservice.careertoolkit_workbc AS noc2 -- the "00" trick is temporarily needed until the lookup table gets fixed
              ON noc2.noc = cc.noc_2 OR cc.noc_2 = '0' || noc2.noc OR cc.noc_2 = '00' || noc2.noc OR cc.noc_2 = '00' || noc2.noc
          LEFT JOIN microservice.careertoolkit_workbc AS noc3 -- the "00" trick is temporarily needed until the lookup table gets fixed
              ON noc3.noc = cc.noc_3 OR cc.noc_3 = '0' || noc3.noc OR cc.noc_3 = '00' || noc3.noc OR cc.noc_3 = '00' || noc3.noc

                    ;;
    distribution_style: all
    persist_for: "2 hours"
  }

  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }

  dimension: root_id {
    description: "Unique ID of the event"
    primary_key: yes
    type: string
    sql: ${TABLE}.root_id ;;
  }

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }
  dimension: noc_1 {}
  dimension: description_1 {}
  dimension: noc_2 {}
  dimension: description_2 {}
  dimension: noc_3 {}
  dimension: description_3 {}

  measure: compare_count {
    type: sum
    sql: ${TABLE}.compare_count ;;
  }
  measure: clear_count {
    type: sum
    sql: ${TABLE}.clear_count ;;
  }
}
