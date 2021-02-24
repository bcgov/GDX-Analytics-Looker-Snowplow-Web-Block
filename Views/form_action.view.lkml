view: form_action {
  derived_table: {
    sql: SELECT wp.id AS page_view_id,
        fa.root_id AS form_event_id,
        events.page_urlhost,
        events.page_url,
        action,
        formid,
        formstage,
        CASE WHEN message = '' THEN NULL ELSE message END AS message,
        CONVERT_TIMEZONE('UTC', 'America/Vancouver', fa.root_tstamp) AS timestamp,
        CASE WHEN action = 'submit' AND (message = 'submit' OR message IS NULL OR message = '') THEN 'submit success'
              WHEN action = 'submit' AND message = 'validation-error' THEN 'submit validation error'
              WHEN action = 'submit' AND message = 'form-error' THEN 'submit form error'
              WHEN action = 'submission-error' THEN 'submit form error'
              ELSE NULL
        END AS result,
        CASE WHEN action = 'submit' THEN 1 ELSE 0 END AS submit_count,
        CASE WHEN action = 'submit' AND (message = 'submit' OR message IS NULL OR message = '') THEN 1 ELSE 0 END AS submit_success_count,
        CASE WHEN action = 'submit' AND message = 'validation-error' THEN 1 ELSE 0 END AS submit_validation_error_count,
        CASE WHEN action = 'submit' AND message = 'form-error' THEN 1 ELSE 0 END AS submit_form_error_count,
        CASE WHEN action = 'submission-error' THEN 1 ELSE 0 END AS submission_error_count,
        CASE WHEN action = 'clear' THEN 1 ELSE 0 END AS clear_count,
        CASE WHEN action = 'pdf' THEN 1 ELSE 0 END AS pdf_count,
        CASE WHEN action = 'loaded' THEN 1 ELSE 0 END AS loaded_count,
        CASE WHEN action = 'emailed' THEN 1 ELSE 0 END AS emailed_count
        FROM atomic.ca_bc_gov_form_action_1 AS fa
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON fa.root_id = wp.root_id AND fa.root_tstamp = wp.root_tstamp
        JOIN atomic.events ON fa.root_id = events.event_id AND fa.root_tstamp = events.collector_tstamp
        ;;
    distribution_style: all
    persist_for: "1 hours"
  }

  dimension_group: event {
    type: time
    sql: ${TABLE}.timestamp ;;
  }
  dimension: page_view_id {
    type: string
    label: "Page View ID"
    sql: ${TABLE}.page_view_id ;;
  }
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }
  dimension: form_event_id {
    label: "Form Event ID"
  }
  dimension: action {}
  dimension: result {}
  dimension: message {}

  dimension: formid {
    label: "Form ID"
    link: {
      label: "Visit Form"
      url: "https://forms2.gov.bc.ca/forms/content?id={{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }
  dimension: formstage {}

  measure: unique_submit_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN ${TABLE}.action = 'submit' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }

  measure: unique_submit_success_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN ${TABLE}.result = 'submit success' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }

  measure: unique_submit_validation_error_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN ${TABLE}.result = 'submit validation error' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }

  measure: unique_loaded_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN  ${TABLE}.action = 'loaded' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }

  measure: submit_count {
    type: sum
    sql: ${TABLE}.submit_count ;;
    group_label: "Counts"
  }
  measure: submit_success_count {
    type: sum
    sql: ${TABLE}.submit_success_count ;;
    group_label: "Counts"
  }
  measure: submit_validation_error_count {
    type: sum
    sql: ${TABLE}.submit_validation_error_count ;;
    group_label: "Counts"
  }
  measure: submission_error_count {
    type: sum
    sql: ${TABLE}.submission_error_count ;;
    group_label: "Counts"
  }
  measure: clear_count {
    type: sum
    sql: ${TABLE}.clear_count ;;
    group_label: "Counts"
  }
  measure: pdf_count {
    type: sum
    sql: ${TABLE}.pdf_count ;;
    group_label: "Counts"
  }
  measure: loaded_count {
    type: sum
    sql: ${TABLE}.loaded_count ;;
    group_label: "Counts"
  }
  measure: emailed_count {
    type: sum
    sql: ${TABLE}.emailed_count ;;
    group_label: "Counts"
  }
  measure: row_count {
    type: count
  }
}
