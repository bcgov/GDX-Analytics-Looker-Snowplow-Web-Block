include: "/Includes/date_comparisons_common.view"

view: user_feedback{
  derived_table: {
    sql:
      WITH fa AS
          (SELECT action, list, text, id, NULL AS trigger, CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp, root_tstamp, root_id
          FROM atomic.ca_bc_gov_feedback_feedback_action_1
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
            AND timestamp >= '2024-02-01'
        UNION
          SELECT action, list, text, id, trigger, CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp, root_tstamp, root_id
          FROM atomic.ca_bc_gov_feedback_feedback_action_2
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
            AND timestamp >= '2024-02-01'
          )

    SELECT
          fa.root_id AS root_id,
          wp.id AS page_view_id,
          domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          page_urlscheme || '://' || page_urlhost || regexp_replace(page_urlpath, 'index.(html|htm|aspx|php|cgi|shtml|shtm)$','') AS page_display_url,
          action,
          fa.id,
          trigger,
          list,
          text,
          CASE WHEN action = 'Load' THEN 1 ELSE 0 END AS load_count,
          CASE WHEN action = 'Back' THEN 1 ELSE 0 END AS back_count,
          CASE WHEN action = 'Close' THEN 1 ELSE 0 END AS close_count,
          CASE WHEN action = 'Triggered' THEN 1 ELSE 0 END AS triggered_count,
          CASE WHEN action = 'Thumbs Up' THEN 1 ELSE 0 END AS thumbs_up_count,
          CASE WHEN action = 'Thumbs Down' THEN 1 ELSE 0 END AS thumbs_down_count,
          CASE WHEN action = 'Rating 1' THEN 1 ELSE 0 END AS rating_1_count,
          CASE WHEN action = 'Rating 2' THEN 1 ELSE 0 END AS rating_2_count,
          CASE WHEN action = 'Rating 3' THEN 1 ELSE 0 END AS rating_3_count,
          CASE WHEN action = 'Rating 4' THEN 1 ELSE 0 END AS rating_4_count,
          CASE WHEN action = 'Rating 5' THEN 1 ELSE 0 END AS rating_5_count,
          CASE WHEN action = 'Rating 1' THEN 1
                WHEN action = 'Rating 2' THEN 2
                WHEN action = 'Rating 3' THEN 3
                WHEN action = 'Rating 4' THEN 4
                WHEN action = 'Rating 5' THEN 5
                ELSE NULL END as rating,
          CASE WHEN action IN ('Thumbs Up', 'Thumbs Down', 'Rating 1', 'Rating 2', 'Rating 3', 'Rating 4', 'Rating 5') THEN 1 ELSE 0 END AS rating_count,
          fa."timestamp",
          geo_latitude,
          geo_longitude
      FROM fa
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
      ON fa.root_id = wp.root_id AND fa.root_tstamp = wp.root_tstamp
      LEFT JOIN atomic.events ON fa.root_id = events.event_id AND fa.root_tstamp = events.collector_tstamp
      ;;
    distribution: "page_view_id"
    sortkeys: ["page_view_id","timestamp"]
    datagroup_trigger: datagroup_20_50
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
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


  dimension: action {}
  dimension: rating {
    type: number
  }
  dimension: id {}
  dimension: list {}
  dimension: text {}
  dimension: trigger {}
  dimension: session_id {}
  dimension: page_display_url {}

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
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

  dimension: geo_location {
    type: location
    sql_latitude: ${geo_latitude} ;;
    sql_longitude: ${geo_longitude} ;;
    group_label: "Location"
  }

  measure: count {
    type: count
    label: "Count"
  }

  measure: thumbs_up_count {
    type: sum
    sql: ${TABLE}.thumbs_up_count ;;
  }
   measure: rating_count {
    type: sum
    sql: ${TABLE}.rating_count ;;
  }
  measure: rating_1_count {
    type: sum
    sql: ${TABLE}.rating_1_count ;;
  }
  measure: rating_2_count {
    type: sum
    sql: ${TABLE}.rating_2_count ;;
  }
  measure: rating_3_count {
    type: sum
    sql: ${TABLE}.rating_3_count ;;
  }
  measure: rating_4_count {
    type: sum
    sql: ${TABLE}.rating_4_count ;;
  }
  measure: rating_5_count {
    type: sum
    sql: ${TABLE}.rating_5_count ;;
  }

  measure: thumbs_down_count {
    type: sum
    sql: ${TABLE}.thumbs_down_count ;;
  }

  measure: load_count {
    type: sum
    sql: ${TABLE}.load_count ;;
  }

  measure: close_count {
    type: sum
    sql: ${TABLE}.close_count ;;
  }
  measure: back_count {
    type: sum
    sql: ${TABLE}.back_count ;;
  }
  measure: triggered_count {
    type: sum
    sql: ${TABLE}.triggered_count ;;
  }

  measure: average_rating {
    type: average
    sql: ${TABLE}.rating/1.0;;
    value_format: "0.0#"
  }


  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

}
