view: workbc_careereducation_find_test_incremental {
  derived_table: {
    sql: SELECT wp.id AS page_view_id, action,
          count AS results_count,
          "filters.audiences" AS audiences,
          "filters.competencies" AS competencies,
          "filters.focus_area" AS focus_area,
          "filters.lifecycle_stage" AS lifecycle_stage,
          "filters.show_category" AS show_category,
          "filters.keyword" AS keyword,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', fr.root_tstamp) AS timestamp,
          CASE WHEN "filters.audiences" <> 'All' THEN 1 ELSE 0 END AS audiences_count,
          CASE WHEN "filters.competencies" <> 'All' THEN 1 ELSE 0 END AS competencies_count,
          CASE WHEN "filters.focus_area" <> 'All' THEN 1 ELSE 0 END AS focus_area_count,
          CASE WHEN "filters.lifecycle_stage" <> 'All' THEN 1 ELSE 0 END AS lifecycle_stage_count,
          CASE WHEN "filters.show_category" <> 'All Lesson Plans & Resources' THEN 1 ELSE 0 END AS show_category_count,
          CASE WHEN "filters.keyword" <> '' AND keyword IS NOT NULL THEN 1 ELSE 0 END AS keyword_count,
          CASE WHEN action = 'update' THEN 1 ELSE 0 END AS update_count,
          CASE WHEN action = 'load' THEN 1 ELSE 0 END AS load_count
        FROM atomic.ca_bc_gov_workbc_find_resources_1 AS fr
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON fr.root_id = wp.root_id AND fr.root_tstamp = wp.root_tstamp
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %}
          ;;
    distribution_style: all
    datagroup_trigger: datagroup_20_50
    increment_key: "event_hour"
    increment_offset: 3
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


  dimension: audiences {}
  dimension: competencies {}
  dimension: focus_area {}
  dimension: lifecycle_stage {}
  dimension: show_category {}
  dimension: keyword {}


  measure: update_count {
    type: sum
    sql: ${TABLE}.update_count ;;
  }
  measure: load_count {
    type: sum
    sql: ${TABLE}.load_count ;;
  }

  measure: audiences_count {
    type: sum
    sql: ${TABLE}.audiences_count;;
  }
  measure: competencies_count {
    type: sum
    sql: ${TABLE}.competencies_count;;
  }
  measure: focus_area_count {
    type: sum
    sql: ${TABLE}.focus_area_count;;
  }
  measure: lifecycle_stage_count {
    type: sum
    sql: ${TABLE}.lifecycle_stage_count;;
  }
  measure: show_category_count {
    type: sum
    sql: ${TABLE}.show_category_count;;
  }
  measure: keyword_count {
    type: sum
    sql: ${TABLE}.keyword_count;;
  }


}
