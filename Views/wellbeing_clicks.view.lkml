#Version: 1.1.0
include: "/Includes/date_comparisons_common.view"

view: wellbeing_clicks {
  label: "wellbeing.gov.bc.ca Clicks"
  derived_table: {
    sql: WITH base_table AS (
      (
        SELECT root_id, root_tstamp, id, click_type, name, url, CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_wellbeing_wellbeing_click_1
        WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      )
        UNION
      (
        SELECT root_id, root_tstamp, id, click_type, name, url, CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp
        FROM atomic.ca_bc_gov_wellbeing_wellbeing_click_2
        WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      )
    )

      SELECT
          wc.root_id AS root_id,
          wp.id AS page_view_id,domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          click_type,
          wc.id,
          name,
          url,
          CASE WHEN click_type LIKE '%listing_learn_more%' THEN 1 ELSE 0 END AS listing_learn_more_count,
          CASE WHEN click_type LIKE '%map_learn_more%' THEN 1 ELSE 0 END AS map_learn_more_count,
          CASE WHEN click_type LIKE '%card_learn_more%' THEN 1 ELSE 0 END AS card_learn_more_count,
          CASE WHEN click_type LIKE '%website%' THEN 1 ELSE 0 END AS website_count,
          CASE WHEN click_type LIKE '%general_url%' THEN 1 ELSE 0 END AS general_url_count,
          CASE WHEN click_type LIKE '%email%' THEN 1 ELSE 0 END AS email_count,
          CASE WHEN click_type LIKE '%phone%' THEN 1 ELSE 0 END AS phone_count,
          CASE WHEN click_type LIKE '%switch_to_list_view%' THEN 1 ELSE 0 END AS switch_to_list_view_count,
          CASE WHEN click_type LIKE '%switch_to_map_view%' THEN 1 ELSE 0 END AS switch_to_map_view_count,
          CASE WHEN click_type LIKE '%use_my_location%' THEN 1 ELSE 0 END AS use_my_location_count,
          CASE WHEN click_type LIKE '%map_group_popup%' THEN 1 ELSE 0 END AS map_group_popup_count,
          timestamp

        FROM base_table AS wc
          LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON wc.root_id = wp.root_id AND wc.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON wc.root_id = events.event_id AND wc.root_tstamp = events.collector_tstamp
        ;;
    distribution_style: all
    datagroup_trigger: datagroup_10_40
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

  dimension: click_type {}
  dimension:id {}
  dimension: name {
    link: {
      label: "Visit Resource Link"
      url: "{{url}}"
      icon_url : "https://wellbeing.gov.bc.ca/themes/custom/bootstrap4_wellbeing/favicon.ico"
    }
  }
  dimension: url {
    label: "Resource URL"
    link: {
      label: "Visit Resource Link"
      url: "{{url}}"
      icon_url : "https://wellbeing.gov.bc.ca/themes/custom/bootstrap4_wellbeing/favicon.ico"
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
  measure: listing_learn_more_count {
    type: sum
    label: "listing_learn_more count"
    group_label: "Click Type Counts"
  }
  measure: map_learn_more_count {
    type: sum
    label: "map_learn_more count"
    group_label: "Click Type Counts"
  }
  measure: card_learn_more_count {
    type: sum
    label: "card_learn_more count"
    group_label: "Click Type Counts"
  }
  measure: website_count {
    type: sum
    label: "website count"
    group_label: "Click Type Counts"
  }
  measure: general_url_count {
    type: sum
    label: "general_url count"
    group_label: "Click Type Counts"
  }
  measure: email_count {
    type: sum
    label: "email count"
    group_label: "Click Type Counts"
  }
  measure: phone_count {
    type: sum
    label: "phone count"
    group_label: "Click Type Counts"
  }
  measure: switch_to_list_view_count {
    type: sum
    label: "switch to list view count"
    group_label: "Click Type Counts"
  }
  measure: switch_to_map_view_count {
    type: sum
    label: "switch to map view count"
    group_label: "Click Type Counts"
  }
  measure: map_group_popup_count {
    type: sum
    label: "map group popup view count"
    group_label: "Click Type Counts"
  }
  measure: use_my_location_count {
    type: sum
    label: "use my location count"
    group_label: "Click Type Counts"
  }
}
