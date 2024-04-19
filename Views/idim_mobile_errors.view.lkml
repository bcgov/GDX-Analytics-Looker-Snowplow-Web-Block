# Version 1.0.0
include: "/Includes/date_comparisons_common.view"

view: idim_mobile_errors {
  label: "IDIM Mobile Errors"
  derived_table: {
    sql: SELECT me.error_code, me.body, ev.app_id, name_tracker, ev.v_tracker AS tracker_version,
         CONVERT_TIMEZONE('UTC', 'America/Vancouver', me.root_tstamp) AS timestamp,
        event_id,
        ev.user_id,
        network_userid,
        session_id,
        mcv.id AS screen_view_id,
        platform,
        version,
        build,
        mc.os_version
      FROM atomic.ca_bc_gov_idim_mobile_error_1 AS me
      JOIN atomic.events AS ev ON me.root_id = ev.event_id AND me.root_tstamp = ev.collector_tstamp AND event_name = 'mobile_error'
      JOIN atomic.com_snowplowanalytics_mobile_screen_1 AS mcv ON mcv.root_id = me.root_id AND mcv.root_tstamp = me.root_tstamp
      JOIN atomic.com_snowplowanalytics_snowplow_client_session_1 AS mcs ON mcs.root_id = me.root_id AND mcs.root_tstamp = me.root_tstamp
      LEFT JOIN atomic.com_snowplowanalytics_mobile_application_1 AS ma ON ma.root_id = me.root_id AND ma.root_tstamp = me.root_tstamp
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_mobile_context_1 AS mc ON mc.root_id = me.root_id AND mc.root_tstamp = me.root_tstamp
      WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      ;;
    distribution_style: all
    datagroup_trigger: datagroup_05_35
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
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

  dimension: os_version {
    group_label: "Application"
  }
  dimension: os {
    group_label: "Device and OS"
    sql: CASE WHEN ${name_tracker}='android' THEN 'Android' ELSE ${name_tracker} END ;;
  }
  dimension: app_id {
    description: "The application identifier from which the event originated."
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

  dimension: screen_view_id {}
  dimension: event_id {}
  dimension: user_id {}
  dimension: network_userid {}

  dimension: session_id {
    link: {
      label: "Drill into session"
      url: "/explore/snowplow_web_block/mobile_screen_views?fields=mobile_screen_views.session_id,mobile_screen_views.screenview_start_time,mobile_screen_views.screen_view_in_session_index,mobile_screen_views.screen_view_id,mobile_screen_views.screen_view_name,mobile_screen_views.app_id,mobile_screen_views.build,mobile_screen_views.version,mobile_screen_views.device_manufacturer,mobile_screen_views.device_model,mobile_screen_views.dvce_screenheight,mobile_screen_views.dvce_screenwidth,mobile_screen_views.os,mobile_screen_views.os_type,mobile_screen_views.os_version&f[mobile_screen_views.session_id]=&sorts=mobile_screen_views.screenview_start_time&limit=500&f[mobile_screen_views.session_id]={{ value }}"
    }
  }
  dimension: platform {}

  dimension: error_code {}
  dimension: body {}

  dimension: build {
    group_label: "Application"
  }
  dimension: version {
    group_label: "Application"
  }
  dimension: name_tracker {
    group_label: "Application"
  }
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
