view: healthgateway_actions {
  label: "Health Gateway Actions"
  derived_table: {
    sql:
        WITH ga AS
          (SELECT action, text, message, NULL AS actor, NULL AS dataset, NULL AS destination, NULL AS format, NULL AS origin, NULL AS rating, NULL AS "type", NULL AS url, CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp, root_tstamp, root_id
          FROM atomic.ca_bc_gov_gateway_action_1
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
            AND timestamp >= '2022-02-01'
        UNION
          SELECT action, text, NULL AS message, actor, dataset, destination, format, origin, rating, "type", url, CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp, root_tstamp, root_id
          FROM atomic.ca_bc_gov_gateway_action_2
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
            AND timestamp >= '2022-02-01'
        UNION
          SELECT action, text, NULL AS message, actor, dataset, destination, format, origin, rating, "type", url, CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp, root_tstamp, root_id
          FROM atomic.ca_bc_gov_gateway_action_3
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
            AND timestamp >= '2022-02-01'
          )
        SELECT
          ga.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          CASE WHEN name_tracker = 'rt' THEN domain_userid  -- this matches the column used in the page_views model for web
                ELSE network_userid -- to pull the other for mobile apps
            END AS user_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          action,
          text,
          message,
          actor,
          dataset,
          destination,
          format,
          origin,
          rating,
          "type", url,
          CASE WHEN action = 'download_report' THEN 1 ELSE 0 end AS download_report_count,
          CASE WHEN action = 'download_card' THEN 1 ELSE 0 end AS download_card_count,
          CASE WHEN action = 'view_card' THEN 1 ELSE 0 end AS view_card_count,
          ga.timestamp,
          CASE WHEN name_tracker = 'rt' THEN dvce_type ELSE name_tracker END AS device_type
        FROM ga
          LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON ga.root_id = wp.root_id AND ga.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON ga.root_id = events.event_id AND ga.root_tstamp = events.collector_tstamp
        ---WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        ;;
    distribution: "page_view_id"
    sortkeys: ["page_view_id","timestamp"]
    datagroup_trigger: datagroup_healthgateway_updated
    publish_as_db_view: yes
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
                # to reprocess up to 3 hours of results
    increment_offset: 3
  }


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
  dimension: device_type {}
  dimension: action {}

  dimension: action_name {
    type: string
    sql: CASE WHEN ${action} = 'save_qr' THEN 'Save Vax (quick)'
              WHEN ${action} = 'view_qr' THEN 'View Vax (quick)'
              WHEN ${action} = 'view_card' THEN 'View Vax (full)'
              WHEN ${action} = 'download_card' THEN 'Save Vax (full)'
          ELSE ${action} END ;;
  }
  dimension: message {}
  dimension: text {}
  dimension: actor {}
  dimension: dataset {}
  dimension: destination {}
  dimension: format {}
  dimension: origin {}
  dimension: rating {}
  dimension: type {}
  dimension: url {}



  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
  }

  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

  measure: user_count {
    description: "Count of the outcome over distinct User IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.user_id ;;
    sql: ${TABLE}.user_id  ;;
  }
  measure: download_report_count {
    type: sum
    sql: ${TABLE}.download_report_count;;
  }
  measure: download_card_count {
    type: sum
    sql: ${TABLE}.download_card_count;;
  }
  measure: view_card_count {
    type: sum
    sql: ${TABLE}.view_card_count;;
  }
}
