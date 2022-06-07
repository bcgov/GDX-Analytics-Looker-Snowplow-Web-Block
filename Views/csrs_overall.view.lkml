# Version: 1.0.0
include: "/Includes/date_comparisons_common.view"

view: csrs_overall {
  label: "CSRS Overall"
  derived_table: {
    sql: WITH base AS (
        SELECT
            cs.root_id AS root_id,
            wp.id AS page_view_id,
            domain_sessionid AS session_id,
            COALESCE(events.page_urlhost,'') AS page_urlhost,
            events.page_url,
            direction,
            question,
            step,
            response,
            CONVERT_TIMEZONE('UTC', 'America/Vancouver', cs.root_tstamp) AS timestamp,
            ROW_NUMBER() OVER (PARTITION BY session_id, step ORDER BY collector_tstamp DESC) AS step_index
      FROM atomic.ca_bc_gov_csrs_questionnaire_step_1 AS cs
        LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
        ON cs.root_id = wp.root_id AND cs.root_tstamp = wp.root_tstamp
        LEFT JOIN atomic.events ON cs.root_id = events.event_id AND cs.root_tstamp = events.collector_tstamp
        WHERE page_urlhost = 'childsupportrecalc.gov.bc.ca'
        --WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      ),
      latest_steps AS (
        SELECT session_id, question, step, response
        FROM base
        WHERE step_index = 1 -- this will select the values they enterred the last time they enterred a value at this step

      ),
      session_stats AS (
        SELECT session_id,
          MAX(step) AS max_step, MIN(timestamp) AS min_timestamp, MAX(timestamp) AS max_timestamp
        FROM base
        GROUP BY session_id
      )
      SELECT session_stats.*,
        CASE WHEN (step1.response = 'Yes'
              AND step2.response = 'Yes'
              AND step3.response = 'No'
              AND step4.response = 'No'
              AND step5.response = 'No'
              AND step6.response = 'Yes'
              AND step7.response = 'No'
              AND step8.response = 'No' )
            THEN 'Eligible'
            WHEN (step1.response IN ('Yes','I don''t know')
              AND step2.response IN ('Yes','I don''t know')
              AND step3.response IN ('No','I don''t know')
              AND step4.response IN ('No','I don''t know')
              AND step5.response IN ('No','I don''t know')
              AND step6.response IN ('Yes','I don''t know')
              AND step7.response IN ('No','I don''t know')
              AND step8.response IN ('No','I don''t know'))
            THEN 'Maybe Eligible'
            WHEN (step1.response IS NOT NULL
              AND step2.response IS NOT NULL
              AND step3.response IS NOT NULL
              AND step4.response IS NOT NULL
              AND step5.response IS NOT NULL
              AND step6.response IS NOT NULL
              AND step7.response IS NOT NULL
              AND step8.response IS NOT NULL)
            THEN 'Ineligible'
            ELSE 'Incomplete'
        END AS outcome,
        step1.response AS step_1_response,
        step2.response AS step_2_response,
        step3.response AS step_3_response,
        step4.response AS step_4_response,
        step5.response AS step_5_response,
        step6.response AS step_6_response,
        step7.response AS step_7_response,
        step8.response AS step_8_response
      FROM session_stats
      LEFT JOIN latest_steps AS step1 ON step1.session_id = session_stats.session_id AND step1.step = 1
      LEFT JOIN latest_steps AS step2 ON step2.session_id = session_stats.session_id AND step2.step = 2
      LEFT JOIN latest_steps AS step3 ON step3.session_id = session_stats.session_id AND step3.step = 3
      LEFT JOIN latest_steps AS step4 ON step4.session_id = session_stats.session_id AND step4.step = 4
      LEFT JOIN latest_steps AS step5 ON step5.session_id = session_stats.session_id AND step5.step = 5
      LEFT JOIN latest_steps AS step6 ON step6.session_id = session_stats.session_id AND step6.step = 6
      LEFT JOIN latest_steps AS step7 ON step7.session_id = session_stats.session_id AND step7.step = 7
      LEFT JOIN latest_steps AS step8 ON step8.session_id = session_stats.session_id AND step8.step = 8
      ;;
    distribution_style: all
    #datagroup_trigger: datagroup_10_40
    #increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    #increment_offset: 3
    persist_for: "1 hour"
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.min_timestamp ;;
  }

  dimension: direction {}
  dimension: response {}
  dimension: question {
    order_by_field: step
  }
  dimension: step { }
  dimension: max_step {}

  dimension_group: min_timestamp {
    sql: ${TABLE}.min_timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension_group: max_timestamp {
    sql: ${TABLE}.max_timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension_group: duration {
    type: duration
    intervals: [day,hour,minute,second]
    sql_start: ${min_timestamp_raw};;
    sql_end: ${max_timestamp_raw};;
  }

  dimension: outcome { }

  dimension: step_1_response {}
  dimension: step_2_response {}
  dimension: step_3_response {}
  dimension: step_4_response {}
  dimension: step_5_response {}
  dimension: step_6_response {}
  dimension: step_7_response {}
  dimension: step_8_response {}

  dimension_group: event {
    sql: ${TABLE}.min_timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension: session_id {}

  measure: count {
    type: count
    label: "Count"
  }
  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }
  measure: page_view_count {
    description: "Count of the outcome over distinct Page View IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: ${TABLE}.page_view_id  ;;
  }


}
