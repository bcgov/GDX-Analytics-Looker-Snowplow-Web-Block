view: forms {
  derived_table: {
    sql:
     SELECT wp.id, fs.formid AS form_id, fs.message AS form_message, CONVERT_TIMEZONE('UTC', 'America/Vancouver', fs.root_tstamp)  AS form_submission_timestamp
        FROM atomic.ca_bc_gov_form_submit_1  AS fs
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON fs.root_id = wp.root_id AND fs.root_tstamp = wp.root_tstamp
      ORDER BY fs.root_tstamp ASC;;
    distribution_style: all
    persist_for: "2 hours"
  }

  dimension: page_view_id {
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: form_id {
    type: string
    sql: ${TABLE}.form_id ;;
  }
  dimension: form_message {
    type: string
    sql: ${TABLE}.form_message ;;
  }
  dimension_group: form_submission {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.form_submission_timestamp ;;
  }

  measure: count {
    type: count
  }
}
