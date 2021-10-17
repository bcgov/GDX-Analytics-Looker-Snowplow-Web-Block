view: workbc_careereducation_click {
  derived_table: {
    sql: SELECT wp.id AS page_view_id,
          click_type,
          category,
          resource_id,
          text,
          CASE WHEN click_type = 'download_file' THEN 1 ELSE 0 END AS download_file_count,
          CASE WHEN click_type = 'download_worksheets' THEN 1 ELSE 0 END AS download_worksheets_count,
          CASE WHEN click_type = 'external_link' THEN 1 ELSE 0 END AS external_link_count,

          CASE WHEN click_type = 'related_resource' THEN 1 ELSE 0 END AS related_resource_count,
          CASE WHEN click_type = 'social' THEN 1 ELSE 0 END AS social_count,

          CASE WHEN click_type LIKE 'nav_%' THEN 1 ELSE 0 END AS nav_count,
          CASE WHEN click_type LIKE 'nav_Activities_%' THEN 1 ELSE 0 END AS nav_activities_count,
          CASE WHEN click_type LIKE 'nav_Curriculum_%' THEN 1 ELSE 0 END AS nav_curriculum_count,
          CASE WHEN click_type LIKE 'nav_Lesson_Plan_%' THEN 1 ELSE 0 END AS nav_lesson_plan_count,

          CONVERT_TIMEZONE('UTC', 'America/Vancouver', rc.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_workbc_resource_click_1  AS rc
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON rc.root_id = wp.root_id AND rc.root_tstamp = wp.root_tstamp;;
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

  dimension: click_type {}
  dimension: category {}
  dimension: resource_id {}
  dimension: text {}

  dimension: download_url {
    type: string
    sql: CASE WHEN click_type = 'download_file' THEN ${text} ELSE NULL END ;;
    link: {
      url: "{{ value }}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
  }

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
  }

  measure: download_file_count {
    type: sum
    sql: ${TABLE}.download_file_count;;
    drill_fields: [download_url]
  }
  measure: download_worksheets_count {
    type: sum
    sql: ${TABLE}.download_worksheets_count;;
  }
  measure: external_link_count {
    type: sum
    sql: ${TABLE}.external_link_count;;
  }

  measure: related_resource_count {
    type: sum
    sql: ${TABLE}.related_resource_count;;
  }
  measure: social_count {
    type: sum
    sql: ${TABLE}.social_count;;
  }

  measure: nav_count {
    type: sum
    sql: ${TABLE}.nav_count;;
  }
  measure: nav_Activities_count {
    type: sum
    sql: ${TABLE}.nav_Activities_count;;
  }
  measure: nav_Curriculum_count {
    type: sum
    sql: ${TABLE}.nav_Curriculum_count;;
  }
  measure: nav_Lesson_Plan_count {
    type: sum
    sql: ${TABLE}.nav_Lesson_Plan_count;;
  }
}
