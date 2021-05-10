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
          CASE WHEN "filters.annual_salary" <> 'All' THEN 1 ELSE 0 END AS annual_salary_count,
          CASE WHEN "filters.education" <> 'All' THEN 1 ELSE 0 END AS education_count,
          CASE WHEN "filters.industry" NOT IN ('All','A') THEN 1 ELSE 0 END AS industry_count,
          CASE WHEN "filters.job_type" <> 'All' THEN 1 ELSE 0 END AS job_type_count,
          CASE WHEN "filters.keyword" <> '' THEN 1 ELSE 0 END AS keyword_count,
          CASE WHEN "filters.occupational_category" <> 'All' THEN 1 ELSE 0 END AS category_count,
          CASE WHEN "filters.occupational_interest" <> 'All' THEN 1 ELSE 0 END AS interest_count,
          CASE WHEN "filters.region" <> 'All' THEN 1 ELSE 0 END AS region_count,
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

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension_group: event {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
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


  measure: annual_salary_count {
    type: sum
    sql: ${TABLE}.annual_salary_count ;;
  }
  measure: education_count {
    type: sum
    sql: ${TABLE}.education_count ;;
  }
  measure: industry_count {
    type: sum
    sql: ${TABLE}.industry_count ;;
  }
  measure: job_type_count {
    type: sum
    sql: ${TABLE}.job_type_count ;;
  }
  measure: keyword_count {
    type: sum
    sql: ${TABLE}.keyword_count ;;
  }
  measure: category_count {
    type: sum
    sql: ${TABLE}.category_count ;;
  }
  measure: interest_count {
    type: sum
    sql: ${TABLE}.interest_count ;;
  }
  measure: region_count {
    type: sum
    sql: ${TABLE}.region_count ;;
  }

}
