# Version: 1.0.0
include: "/Includes/date_comparisons_common.view"

view: bchep_action  {
  label: "BCHEP Action"
  derived_table: {
    sql: SELECT
          vba.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.geo_city,
          events.page_url,
          action,
          message,
          section,
          dvce_ismobile AS is_mobile,
          CASE WHEN section = 'landing' THEN 1
            WHEN section = 'login' THEN 2
            WHEN section = 'pin-request' THEN 3
            WHEN section = 'returning-user-flow' THEN 4
            WHEN section = 'energuide-upload' THEN 5
            WHEN section = 'rating-estimate' THEN 6
            WHEN section = 'questionnaire-energy-report' THEN 7
            WHEN section = 'energy-report' THEN 8
            WHEN section = 'questionnaire-energy-plan' THEN 9
            WHEN section = 'energy-plan' THEN 10
            WHEN section = 'support' THEN 11
          ELSE NULL END AS section_order,
          step,
          "text",
          uid,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', vba.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_vhers_bchep_action_1  AS vba
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
          ON vba.root_id = wp.root_id AND vba.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON vba.root_id = events.event_id AND vba.root_tstamp = events.collector_tstamp
      WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        ;;
    distribution: "page_view_id"
    sortkeys: ["page_view_id","timestamp"]
    datagroup_trigger: datagroup_healthgateway_updated
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
  }
  dimension: session_id {}

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
  dimension: root_id {}
  dimension: action{}
  dimension: message{}
  dimension: section {}
  dimension: step {}
  dimension: text {}
  dimension: uid {}
  dimension: is_mobile {
    type: yesno
  }
  dimension: section_order {
    type: number
  }

  dimension: geo_city {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

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

  measure: uid_count {
    description: "Count of the outcome over distinct UIDs"
    label: "UID Count"
    type: count_distinct
    sql_distinct_key: ${TABLE}.uid ;;
    sql: ${TABLE}.uid  ;;
  }


}
