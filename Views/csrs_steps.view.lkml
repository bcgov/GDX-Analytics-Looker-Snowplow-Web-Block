# Version: 1.0.0
include: "/Includes/date_comparisons_common.view"

view: csrs_steps {
  label: "CSRS Steps"
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
      )
      SELECT session_id, base.timestamp, question, step, direction, response,
          CASE WHEN response = 'Yes' THEN 1 ELSE NULL END AS yes_count,
          CASE WHEN response = 'No' THEN 1 ELSE NULL END AS no_count,
          CASE WHEN response = 'I don''t know' THEN 1 ELSE NULL END AS dont_count,
          CASE WHEN response IS NULL THEN 1 ELSE NULL END AS blank_count,
          CASE WHEN (step = 1 AND response = 'Yes' )
              OR (step = 2 AND response = 'Yes')
              OR (step = 3 AND response = 'No')
              OR (step = 4 AND response = 'No')
              OR (step = 5 AND response = 'No')
              OR (step = 6 AND response = 'Yes')
              OR (step = 7 AND response = 'No')
              OR (step = 8 AND response = 'No' )
            THEN 'Eligible'
            WHEN response = 'I don''t know' THEN 'Maybe Eligible'
            WHEN response IS NOT NULL THEN 'Ineligible'
          END AS outcome,
          CASE WHEN outcome = 'Eligible' THEN 1 ELSE 0 END AS eligible_count,
          CASE WHEN outcome = 'Maybe Eligible' THEN 1 ELSE 0 END AS maybe_count,
          CASE WHEN outcome = 'Ineligible' THEN 1 ELSE 0 END AS ineligible_count
        FROM base
        WHERE step_index = 1
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
    sql: ${TABLE}.timestamp ;;
  }
  dimension: direction {}
  dimension: response {}
  dimension: question {
    order_by_field: step
  }
  dimension: step { }
  dimension: max_step {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
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

  measure: yes_count {
    type: sum
    sql: ${TABLE}.yes_count ;;
    group_label: "Answer Counts"
  }
  measure: no_count {
    type: sum
    sql: ${TABLE}.no_count ;;
    group_label: "Answer Counts"
  }
  measure: dont_count {
    label: "I don't know count"
    type: sum
    sql: ${TABLE}.dont_count ;;
    group_label: "Answer Counts"
  }
  measure: blank_count {
    type: sum
    sql: ${TABLE}.blank_count ;;
    group_label: "Answer Counts"
    }
  measure: eligible_count {
    type: sum
    sql: ${TABLE}.eligible_count ;;
    group_label: "Outcome Counts"
    }
  measure: ineligible_count {
    type: sum
    sql: ${TABLE}.ineligible_count ;;
    group_label: "Outcome Counts"
  }
  measure: maybe_count {
    label: "Maybe Eligible Count"
    type: sum
    sql: ${TABLE}.maybe_count ;;
    group_label: "Outcome Counts"
  }

}
