view: health_app_views {
  label: "Health App Screen Views"
  derived_table: {
    sql: SELECT
          ev.app_id,
          ev.name_tracker,
          ev.app_id || ' - ' || ev.name_tracker AS app_type,
          msv.root_id,
          msv.id AS screen_view_id,
          ev.dvce_created_tstamp AS timestamp,
          ev.collector_tstamp,
          ev.dvce_created_tstamp,
          ev.dvce_sent_tstamp,
          ev.derived_tstamp,
          msv.name,
          msv.previous_id,
          msv.previous_name,
          scs.session_id,
          scs.previous_session_id,
          scs.session_index,
          scs.user_id,
          smc.os_type,
          smc.os_version,
          smc.device_manufacturer,
          smc.device_model,
          ev.user_ipaddress

          FROM atomic.com_snowplowanalytics_mobile_screen_view_1 AS msv
            LEFT JOIN atomic.com_snowplowanalytics_snowplow_client_session_1 AS scs
              ON msv.root_id = scs.root_id AND msv.root_tstamp = scs.root_tstamp
            LEFT JOIN atomic.com_snowplowanalytics_snowplow_mobile_context_1 AS smc
              ON msv.root_id = smc.root_id AND msv.root_tstamp = smc.root_tstamp
            LEFT JOIN atomic.events AS ev ON ev.collector_tstamp > '2021-10-14' AND msv.root_tstamp = ev.collector_tstamp AND msv.root_id = ev.event_id
        WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        ;;
    distribution_style: all
    datagroup_trigger: datagroup_healthgateway_updated
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
  }

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension_group: collector_tstamp {
    sql: ${TABLE}.collector_tstamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension_group: dvce_created_tstamp{
    sql: ${TABLE}.dvce_created_tstamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension_group: dvce_sent_tstamp {
    sql: ${TABLE}.dvce_sent_tstamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension_group: derived_tstamp {
    sql: ${TABLE}.derived_tstamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: app_type {}
  dimension: app_id {}
  dimension: name_tracker {}
  dimension: root_id {}
  dimension: screen_view_id {}
  dimension: name {}
  dimension: previous_id {}
  dimension: previous_name {}
  dimension: session_id {}
  dimension: previous_session_id {}
  dimension: session_index {}
  dimension: user_id {}
  dimension: os_type {}
  dimension: os_version {}
  dimension: device_manufacturer {}
  dimension: device_model {}
  dimension: user_ipaddress {}
  }
