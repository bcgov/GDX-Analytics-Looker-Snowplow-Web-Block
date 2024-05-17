include: "/Includes/date_comparisons_common.view"

view: openschool_actions {
  label: "OpenSchool Actions"
  derived_table: {
    sql: WITH action_list AS (
        SELECT
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          action,
          CASE WHEN action = 'get_role' AND text = 'Not a Contractor or Service Provider' THEN TRUE ELSE FALSE END AS role_not_contractor,
          CASE WHEN action = 'get_role' AND text = 'Contractor or Service Provider' THEN TRUE ELSE FALSE END AS role_contractor,
          CASE WHEN action = 'get_certificate' THEN TRUE ELSE FALSE END AS get_certificate,
          course,
          message,
          text,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', osa.root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_openschool_action_1  AS osa
        LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
            ON osa.root_id = wp.root_id AND osa.root_tstamp = wp.root_tstamp
        LEFT JOIN atomic.events ON osa.root_id = events.event_id AND osa.root_tstamp = events.collector_tstamp
        WHERE page_urlhost = 'mytrainingbc.ca'
      ),
      step_list AS (
        SELECT
        session_id,
        page_view_start_time,
        CASE WHEN page_display_url = 'https://mytrainingbc.ca/FOIPPA/' THEN 0
          WHEN page_display_url = 'https://mytrainingbc.ca/FOIPPA/module1.html' OR page_display_url = 'https://mytrainingbc.ca/FOIPPA/storyline/mod1/story_html5.html'  THEN 1
          WHEN page_display_url = 'https://mytrainingbc.ca/FOIPPA/module2.html' OR page_display_url = 'https://mytrainingbc.ca/FOIPPA/storyline/mod2/story_html5.html' THEN 2
          WHEN page_display_url = 'https://mytrainingbc.ca/FOIPPA/module3.html'OR page_display_url = 'https://mytrainingbc.ca/FOIPPA/storyline/mod3/story_html5.html'  THEN 3
          WHEN page_display_url = 'https://mytrainingbc.ca/FOIPPA/exam.html'OR page_display_url = 'https://mytrainingbc.ca/FOIPPA/storyline/exam_test/story.html' THEN 4
        ELSE NULL END AS this_step
      FROM derived.page_views
      WHERE page_view_start_date >= '2023-03-23' AND page_display_url LIKE 'https://mytrainingbc.ca/FOIPPA%' -- this is the date when custom tracking started
      )
      SELECT
        MIN(page_view_start_time) AS start_time,
        GREATEST(MAX(page_view_start_time), MAX(timestamp)) AS end_time,
        step_list.session_id,
        course,
        CASE WHEN BOOL_OR(get_certificate) THEN 5 ELSE MAX(this_step) END AS last_step,
        CASE WHEN BOOL_OR(get_certificate) THEN 'Certificate'
             WHEN MAX(this_step) = 0 THEN 'Start'
             WHEN MAX(this_step) = 4 THEN 'Exam'
             ELSE CONCAT('Module ', MAX(this_step))
        END AS progress,
        CASE WHEN BOOL_OR(role_not_contractor) THEN 'Not Contractor'
          WHEN BOOL_OR(role_contractor) THEN 'Contractor'
          ELSE NULL END AS role,
        BOOL_OR(role_not_contractor) AS role_not_contractor,
        BOOL_OR(role_contractor) AS role_contractor,
        BOOL_OR(get_certificate) AS get_certificate
        FROM step_list
        LEFT JOIN action_list ON action_list.session_id = step_list.session_id
        GROUP BY step_list.session_id, course
        HAVING last_step IS NOT NULL ;;
    distribution: "session_id"
    sortkeys: ["session_id","start_time"]
    persist_for: "2 hours"
    #datagroup_trigger: datagroup_healthgateway_updated
    #increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    #increment_offset: 3
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.start_time ;;
  }

  dimension: course { }
  dimension: last_step {}
  dimension: progress {
    order_by_field: last_step
  }
  dimension: role {}
  dimension: session_id {}
  dimension: role_not_contractor {
    type: yesno
  }
  dimension: role_contractor {
    type: yesno
  }
  dimension: get_certificate {
    type: yesno
  }

  dimension_group: start_time {
    sql: ${TABLE}.start_time ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension_group: end_time {
    sql: ${TABLE}.end_time ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
    label: "Count"
  }

  measure: role_not_contractor_count {
    type: sum
    sql: CASE WHEN ${role_not_contractor} = TRUE THEN 1 ELSE 0 END ;;
  }
  measure: role_contractor_count {
    type: sum
    sql: CASE WHEN ${role_contractor} = TRUE THEN 1 ELSE 0 END ;;
  }
  measure: get_certificate_count {
    type: sum
    sql: CASE WHEN ${get_certificate}= TRUE THEN 1 ELSE 0 END ;;
  }


  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

}
