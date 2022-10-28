# Version: 2.0.0
include: "/Includes/date_comparisons_common.view"

view: cit_userstory {
  label: "Community Information Tool User Story"
  derived_table: {
    sql: SELECT
          cit.root_id AS root_id,
          wp.id AS page_view_id,domain_sessionid AS session_id,
          --COALESCE(events.page_urlhost,'') AS page_urlhost,
          --vents.page_url,
          i_am,
          outcome,
          source,
          interest,
          kind_of_area,
          location,
      CONVERT_TIMEZONE('UTC', 'America/Vancouver', cit.root_tstamp) AS timestamp

      FROM atomic.ca_bc_gov_cit_userstory_1 AS cit
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
      ON cit.root_id = wp.root_id AND cit.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON cit.root_id = events.event_id AND cit.root_tstamp = events.collector_tstamp
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

  dimension: i_am {}
  dimension: outcome {}
  dimension: source {}
  dimension: interest {}
  dimension: kind_of_area {}
  dimension: location {}
}
