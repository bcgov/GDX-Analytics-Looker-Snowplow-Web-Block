view: workbc_careersearch_find {
  derived_table: {
    sql: SELECT wp.id AS page_view_id, action,
          count AS results_count,
          "filters.annual_salary" AS annual_salary,
          "filters.education" AS education,
          "filters.industry" AS industry,
          "filters.job_type" AS job_type,
          "filters.keyword" AS keyword,
          "filters.occupational_category" AS category,
          "filters.occupational_interest" AS interest,
          "filters.region" AS region,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', fc.root_tstamp) AS timestamp,
          CASE WHEN action = 'apply' THEN 1 ELSE 0 END AS apply_count,
          CASE WHEN action = 'reset' THEN 1 ELSE 0 END AS reset_count,
          CASE WHEN action = 'load' THEN 1 ELSE 0 END AS load_count
        FROM atomic.ca_bc_gov_workbc_find_career_1 AS fc
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON fc.root_id = wp.root_id AND fc.root_tstamp = wp.root_tstamp
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


  dimension: results_count {}
  dimension: annual_salary {}
  dimension: education {}
  dimension: industry {}
  dimension: job_type {}
  dimension: keyword {}
  dimension: category {}
  dimension: interest {}
  dimension: region {}

  measure: apply_count {
    type: sum
    sql: ${TABLE}.apply_count ;;
  }
  measure: load_count {
    type: sum
    sql: ${TABLE}.load_count ;;
  }
  measure: reset_count {
    type: sum
    sql: ${TABLE}.load_count ;;
  }

}
