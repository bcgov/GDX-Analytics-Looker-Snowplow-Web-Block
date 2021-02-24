view: form_error {
  derived_table: {
    sql: SELECT wp.id AS page_view_id,
        fe.root_id AS form_event_id,
        CONVERT_TIMEZONE('UTC', 'America/Vancouver', fe.root_tstamp) AS timestamp,
        events.page_urlhost,
        events.page_url,
        formid,
        formstage,
        error,
        error_index,
        error_trigger,
        field_type,
        fieldname
        FROM atomic.ca_bc_gov_form_error_1 AS fe
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON fe.root_id = wp.root_id AND fe.root_tstamp = wp.root_tstamp
        JOIN atomic.events ON fe.root_id = events.event_id AND fe.root_tstamp = events.collector_tstamp
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
  dimension: error {}
  dimension: error_index {}
  dimension: error_trigger {}
  dimension: field_type {}
  dimension: fieldname {}


  dimension: formid {
    label: "Form ID"
    link: {
      label: "Visit Form"
      url: "https://forms2.gov.bc.ca/forms/content?id={{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }
  dimension: formstage {}


  measure: row_count {
    type: count
  }
  measure: error_group_count {
    type: sum
    sql: CASE WHEN error_index = 1 THEN 1 ELSE 0 END ;;
  }
}
