# Version: 1.0.0
include: "/Includes/date_comparisons_common.view"

view: csrs_clicks {
  label: "CSRS Clicks"
  derived_table: {
    sql: SELECT
          cc.root_id AS root_id,
          wp.id AS page_view_id,domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          label,
          question,
          step,
          CASE WHEN url LIKE '/%' THEN 'https://childsupportrecalc.gov.bc.ca' || url ELSE url END AS url,
      CONVERT_TIMEZONE('UTC', 'America/Vancouver', cc.root_tstamp) AS timestamp

      FROM atomic.ca_bc_gov_csrs_questionnaire_click_1 AS cc
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
      ON cc.root_id = wp.root_id AND cc.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON cc.root_id = events.event_id AND cc.root_tstamp = events.collector_tstamp
      WHERE page_urlhost = 'childsupportrecalc.gov.bc.ca'
      --WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
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

  dimension: label {
    link: {
      label: "Visit {{url}}"
      url: "{{url}}"
      #icon_url : "https://wellbeing.gov.bc.ca/themes/custom/bootstrap4_wellbeing/favicon.ico"
    }
  }
  dimension: question {
    order_by_field: step
  }
  dimension: step { }

  dimension: url {
    label: "Outbound URL"
    link: {
      label: "Visit {{label}}"
      url: "{{url}}"
      #icon_url : "https://wellbeing.gov.bc.ca/themes/custom/bootstrap4_wellbeing/favicon.ico"
    }
  }

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
    label: "Click Count"
  }

  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }


}
