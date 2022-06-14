# Version 1.0.0
include: "/Includes/date_comparisons_common.view"

view: mobile_application_errors {

  derived_table: {
    sql: SELECT ae.message, ae.exception_name, ae.is_fatal, ae.line_number, ev.app_id, name_tracker, ev.v_tracker AS tracker_version,
       CONVERT_TIMEZONE('UTC', 'America/Vancouver', ae.root_tstamp) AS timestamp,
      --screen_view_id,
      event_id,
      user_id,
      network_userid,
      platform
      --ev.*
      FROM atomic.com_snowplowanalytics_snowplow_application_error_1 AS ae
      JOIN atomic.events AS ev ON ae.root_id = ev.event_id AND ae.root_tstamp = ev.collector_tstamp AND event_name = 'application_error'
      WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      ;;
    distribution_style: all
    datagroup_trigger: datagroup_25_55
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


  dimension: app_id {
    description: "The application identifier from which the event originated."
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

  dimension: build {
    group_label: "Application"
  }
  dimension: version {
    group_label: "Application"
  }
  dimension: name_tracker { #missing column in table
    group_label: "Application"
    sql: NULL ;;
  }
  dimension: tracker_version { #missing column in table
    description: "The tracker version."
    type: string
    sql: NULL ;;
    group_label: "Application"
  }

  dimension: screen_view_id {}
  dimension: event_id {}
  dimension: user_id {}
  dimension: device_user_id {}
  dimension: network_userid {}
  dimension: session_id {}
  dimension: session_index {}
  dimension: platform {}

  dimension: message {}
  dimension: exception_name {}
  dimension: is_fatal {}


  # A "faked" device type until the real data is populated
  dimension: os {
    sql: CASE WHEN ${useragent} LIKE '%android%' THEN 'Android'
            WHEN ${useragent} LIKE '%Darwin%' THEN 'iOS'
            END;;
    group_label: "Device and OS"
  }
  dimension: dvce_screenwidth {
    group_label: "Device and OS"
  }
  dimension: dvce_screenheight {
    group_label: "Device and OS"
  }
  dimension: device_manufacturer {
    group_label: "Device and OS"
  }
  dimension: device_model {
    group_label: "Device and OS"
  }
  dimension: os_type {
    group_label: "Device and OS"
  }
  dimension: os_version {
    group_label: "Device and OS"
  }
  dimension: android_idfa {
    group_label: "IDFA"
  }
  dimension: apple_idfa {
    group_label: "IDFA"
  }
  dimension: apple_idfv {
    group_label: "IDFA"
  }
  dimension: open_idfa {
    group_label: "IDFA"
  }
  dimension: device_latitude {
    group_label: "Device Geo Information"
  }
  dimension: device_longitude {
    group_label: "Device Geo Information"
  }
  dimension: device_latitude_longitude_accuracy {
    group_label: "Device Geo Information"
  }
  dimension: device_altitude {
    group_label: "Device Geo Information"
  }
  dimension: device_altitude_accuracy {
    group_label: "Device Geo Information"
  }
  dimension: device_bearing {
    group_label: "Device Geo Information"
  }
  dimension: device_speed {
    group_label: "Device Geo Information"
  }

  dimension: geo_country {
    type: string
    sql: ${TABLE}.geo_country ;;
    group_label: "Location"
    suggest_explore: geo_cache
    suggest_dimension: geo_cache.geo_country
  }

  dimension: geo_region {
    type: string
    sql: ${TABLE}.geo_region ;;
    group_label: "Location"
  }
  dimension: geo_region_or_country {
    type: string
    description: "The Geo Region or Country when the Region is blank."
    sql: COALESCE(${TABLE}.geo_region_name,${TABLE}.geo_country)  ;;
    group_label: "Location"
  }

  dimension: geo_region_name {
    type: string
    sql: ${TABLE}.geo_region_name ;;
    group_label: "Location"
    suggest_explore: geo_cache
    suggest_dimension: geo_cache.geo_region_name
  }

  dimension: geo_city {
    type: string
    sql: ${TABLE}.geo_city ;;
    group_label: "Location"
    suggest_explore: geo_cache
    suggest_dimension: geo_cache.geo_city
  }

  dimension: geo_zipcode {
    type: zipcode
    sql: ${TABLE}.geo_zipcode ;;
    group_label: "Location"
  }

  dimension: geo_latitude {
    type: number
    sql: ${TABLE}.geo_latitude ;;
    group_label: "Location"
    # use geo_location instead
    hidden: yes
  }

  dimension: geo_longitude {
    type: number
    sql: ${TABLE}.geo_longitude ;;
    group_label: "Location"
    # use geo_location instead
    hidden: yes
  }

  dimension: geo_timezone {
    type: string
    sql: ${TABLE}.geo_timezone ;;
    group_label: "Location"
    # use os_timezone instead
    hidden: yes
  }

  dimension: geo_location {
    type: location
    sql_latitude: ${geo_latitude} ;;
    sql_longitude: ${geo_longitude} ;;
    group_label: "Location"
  }

  dimension: geo_bc {
    type: string
    sql: CASE WHEN ${TABLE}.geo_region = 'BC' THEN 'BC' ELSE 'Outside BC' END;;
    group_label: "Location"
  }


  dimension: user_ipaddress {
    group_label: "Network Info"
  }
  dimension: useragent {
    group_label: "Network Info"
  }
  dimension: carrier {
    group_label: "Network Info"
  }
  dimension: network_technology {
    group_label: "Network Info"
  }
  dimension: network_type {
    group_label: "Network Info"
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
  measure: user_count {
    type: count_distinct
    sql: ${device_user_id} ;; # or is it network_userid?
    group_label: "Counts"
  }
}
