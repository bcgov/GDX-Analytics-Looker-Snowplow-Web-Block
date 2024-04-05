# Version 1.0.0
include: "/Includes/date_comparisons_common.view"

view: idim_actions {
  label: "IDIM Actions"
  derived_table: {
    sql: SELECT name_tracker, ev.app_id, ev.v_tracker AS tracker_version,
         CONVERT_TIMEZONE('UTC', 'America/Vancouver', ia.root_tstamp) AS timestamp,
        action,
        message,
        text,
        mcv.id AS screen_view_id,
        platform
      FROM atomic.ca_bc_gov_idim_action_1 AS ia
      JOIN atomic.events AS ev ON ia.root_id = ev.event_id AND ia.root_tstamp = ev.collector_tstamp AND event_name = 'action' AND event_vendor = 'ca.bc.gov.idim'
      LEFT JOIN atomic.com_snowplowanalytics_mobile_screen_1 AS mcv ON mcv.root_id = ia.root_id AND mcv.root_tstamp = ia.root_tstamp
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_client_session_1 AS mcs ON mcs.root_id = ia.root_id AND mcs.root_tstamp = ia.root_tstamp
    --WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      ;;
    distribution_style: all
    #datagroup_trigger: datagroup_05_35
    #increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    #increment_offset: 3
    persist_for: "2 hours"
  }

  extends: [date_comparisons_common]
  dimension_group: filter_start {
    sql:  ${TABLE}.timestamp ;;
  }

  dimension_group: event {
    sql:  ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension: action {}
  dimension: message {}
  dimension: text {}


  dimension: app_id {
    description: "The application identifier from which the event originated."
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

  dimension: screen_view_id {}
  #dimension: event_id {}
  dimension: user_id {}
  #dimension: network_userid {}

  dimension: session_id {
    link: {
      label: "Drill into session"
      url: "/explore/snowplow_web_block/mobile_screen_views?fields=mobile_screen_views.session_id,mobile_screen_views.screenview_start_time,mobile_screen_views.screen_view_in_session_index,mobile_screen_views.screen_view_id,mobile_screen_views.screen_view_name,mobile_screen_views.app_id,mobile_screen_views.build,mobile_screen_views.version,mobile_screen_views.device_manufacturer,mobile_screen_views.device_model,mobile_screen_views.dvce_screenheight,mobile_screen_views.dvce_screenwidth,mobile_screen_views.os,mobile_screen_views.os_type,mobile_screen_views.os_version&f[mobile_screen_views.session_id]=&sorts=mobile_screen_views.screenview_start_time&limit=500&f[mobile_screen_views.session_id]={{ value }}"
    }
  }
  dimension: platform {}

  measure: row_count {
    type: count
    group_label: "Counts"
  }

  measure: session_count {
    type: count_distinct
    sql: ${session_id} ;;
    group_label: "Counts"
  }
  measure: screen_view_count {
    type: count_distinct
    sql: ${screen_view_id} ;;
    group_label: "Counts"
  }

}
