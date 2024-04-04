include: "/Includes/date_comparisons_common.view"

view: bc_wallet_raw {
  label: "Digital Trust BC Wallet Showcase Raw Data"
  derived_table: {
    sql:
      SELECT
          da.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          action,
          path,
          step,
          CASE WHEN path = 'shared' AND step = 'Let''s get started' THEN 'common_1'
                WHEN path = 'student' AND step = 'Meet Alice' THEN 'student_1'
                WHEN path = 'student' AND step = 'Let''s get started!' THEN 'student_2'
                WHEN path = 'student' AND step = 'Install BC Wallet' THEN 'student_3'
                WHEN path = 'student' AND step = 'Connect with BestBC College' THEN 'student_4'
                WHEN path = 'student' AND step = 'Accept your student card' THEN 'student_5'
                WHEN path = 'student' AND step = 'You''re all set!' THEN 'student_6'
                WHEN path = 'student' AND step = 'Confirm the information to send' THEN 'student_7'

      WHEN path = 'Student' AND step = 'dashboard' THEN 'Student_8'
      ---
      WHEN path = 'student_clothesOnline' AND step = 'usecase_start' THEN 'student_clothesOnline_1'
      WHEN path = 'student_clothesOnline' AND step = 'Getting a student discount' THEN 'student_clothesOnline_2'
      WHEN path = 'student_clothesOnline' AND step = 'Start proving you''re a student' THEN 'student_clothesOnline_3'
      WHEN path = 'student_clothesOnline' AND step = 'Confirm the information to send' THEN 'student_clothesOnline_4'
      WHEN path = 'student_clothesOnline' AND step = 'You''re done!' THEN 'student_clothesOnline_5'


      WHEN path = 'student_study' AND step = 'usecase_start' THEN 'student_study_1'
      WHEN path = 'student_study' AND step = 'Book a study room' THEN 'student_study_2'
      WHEN path = 'student_study' AND step = 'Start booking the room' THEN 'student_study_3'
      WHEN path = 'student_study' AND step = 'Confirm the information to send' THEN 'student_study_4'
      WHEN path = 'student_study' AND step = 'You''re done!' THEN 'student_study_5'


      WHEN path = 'lawyer' AND step = 'Meet Joyce' THEN 'lawyer_1'
      WHEN path = 'lawyer' AND step = 'Let''s get started!' THEN 'lawyer_2'
      WHEN path = 'lawyer' AND step = 'Going Digital' THEN 'lawyer_3'
      WHEN path = 'lawyer' AND step = 'Accessing court materials' THEN 'lawyer_4'
      WHEN path = 'lawyer' AND step = 'Get your lawyer credential' THEN 'lawyer_5'
      WHEN path = 'lawyer' AND step = 'Accept your lawyer credential' THEN 'lawyer_6'
      WHEN path = 'lawyer' AND step = 'Get Person credential' THEN 'lawyer_7'
      WHEN path = 'lawyer' AND step = 'Accept your Person credential' THEN 'lawyer_8'
      WHEN path = 'lawyer' AND step = 'Meet Joyce' THEN 'lawyer_9'
      WHEN path = 'lawyer' AND step = 'Let''s get started!' THEN 'lawyer_10'
      WHEN path = 'lawyer' AND step = 'Going Digital' THEN 'lawyer_11'
      WHEN path = 'lawyer' AND step = 'Accessing court materials' THEN 'lawyer_12'
      WHEN path = 'lawyer' AND step = 'Confirm the information to send' THEN 'lawyer_13'
      WHEN path = 'lawyer' AND step = 'You''re all set!' THEN 'lawyer_14'



      WHEN path = 'Lawyer' AND step = 'dashboard' THEN 'Lawyer_15'


      WHEN path = 'lawyer_courtServices' AND step = 'usecase_start' THEN 'lawyer_courtServices_1'
      WHEN path = 'lawyer_courtServices' AND step = 'Gain access to court materials online' THEN 'lawyer_courtServices_2'
      WHEN path = 'lawyer_courtServices' AND step = 'Start proving you’re a lawyer' THEN 'lawyer_courtServices_3'
      WHEN path = 'lawyer_courtServices' AND step = 'Confirm the information to send' THEN 'lawyer_courtServices_4'
      WHEN path = 'lawyer_courtServices' AND step = 'You''re done!' THEN 'lawyer_courtServices_5'
      --401
      --54
      -- 29
      ELSE NULL END AS progress,
      -- view counts
      --CASE WHEN view = 'map' THEN 1 ELSE 0 END AS map_count,
      CONVERT_TIMEZONE('UTC', 'America/Vancouver', da.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_digital_action_1  AS da
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
      ON da.root_id = wp.root_id AND da.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON da.root_id = events.event_id AND da.root_tstamp = events.collector_tstamp
      ;;
    distribution: "page_view_id"
    sortkeys: ["page_view_id","timestamp"]
    persist_for: "2 hours"
    #datagroup_trigger: datagroup_healthgateway_updated
    #increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    #increment_offset: 3
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
  }

  dimension: progress {}

  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }
  dimension: page_url {}


  dimension: action {}
  dimension: session_id {}
  dimension: path {}
  dimension: step {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
  }
  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }
}
