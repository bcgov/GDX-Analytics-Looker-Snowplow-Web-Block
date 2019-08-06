include: "shared_fields_common.view"
include: "date_comparisons_common.view"

view: page_views {
  sql_table_name: derived.page_views ;;

  extends: [shared_fields_common,date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.page_view_start_time ;;
  }

  # Modifying extended fields
  dimension: os_version { hidden: yes }

  dimension: p_key {
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${page_view_id} ;;
  }


  # Addititonal Drills
  dimension: browser_language {
    drill_fields: [page_display_url]
  }

  dimension: referrer_medium {
    drill_fields: [referrer_medium, referrer_source, referrer_urlhost, page_display_url]
  }


  # DIMENSIONS

  # Page View

  dimension: page_view_id {
    type: string
    sql: ${TABLE}.page_view_id ;;
    group_label: "Page View"
  }

#   dimension: page_view_index {
#     type: number
#     # index across all sessions
#     sql: ${TABLE}.page_view_index ;;
#     group_label: "Page View"
#   }

  dimension: page_view_in_session_index {
    type: number
    # index within each session
    sql: ${TABLE}.page_view_in_session_index ;;
    group_label: "Page View"
  }

  # Page View Time

  dimension_group: page_view_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_start_time ;;
    #X# group_label:"Page View Time"
  }

  dimension_group: page_view_start_marketing_drill {
    description: "The start time of the first page view of a given session."
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_start_time ;;
    drill_fields: [page_display_url, marketing_drills*]
    label: "Page View Start"
    group_label: "Page View Date (Markerting Drill)"
  }


  dimension_group: page_view_end {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_end_time ;;
    #X# group_label:"Page View Time"
    hidden: yes
  }

  # Page View Time (User Timezone)

  dimension_group: page_view_start_device_created {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_min_dvce_created_tstamp ;;
    #X# group_label:"Page View Time (User Timezone)"
  }

  dimension_group: page_view_end_device_created {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_max_dvce_created_tstamp ;;
    #X# group_label:"Page View Time (User Timezone)"
    hidden: yes
  }

  # Engagement

  dimension: time_engaged {
    type: number
    sql: ${TABLE}.time_engaged_in_s ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: time_engaged_tier {
    type: tier
    tiers: [0, 10, 30, 60, 120]
    style: integer
    sql: ${time_engaged} ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: x_pixels_scrolled {
    type: number
    sql: ${TABLE}.horizontal_pixels_scrolled ;;
    group_label: "Engagement"
    value_format: "0\"px\""
  }

  dimension: y_pixels_scrolled {
    type: number
    sql: ${TABLE}.vertical_pixels_scrolled ;;
    group_label: "Engagement"
    value_format: "0\"px\""
  }

  dimension: x_percentage_scrolled {
    type: number
    sql: ${TABLE}.horizontal_percentage_scrolled ;;
    group_label: "Engagement"
    value_format: "0\%"
  }

  dimension: y_percentage_scrolled {
    type: number
    sql: ${TABLE}.vertical_percentage_scrolled ;;
    group_label: "Engagement"
    value_format: "0\%"
  }

  dimension: y_percentage_scrolled_tier {
    type: tier
    tiers: [0, 25, 50, 75, 101]
    style: integer
    sql: ${y_percentage_scrolled} ;;
    group_label: "Engagement"
    value_format: "0\%"
  }

  dimension: user_bounced {
    type: yesno
    sql: ${time_engaged} = 0 ;;
    group_label: "Engagement"
  }

  dimension: user_engaged {
    type: yesno
    sql: ${time_engaged} >= 30 AND ${y_percentage_scrolled} >= 25 ;;
    group_label: "Engagement"
  }

  dimension: bounce {
    type: number
    sql: ${TABLE}.bounce ;;
    group_label: "Engagement"
  }

  dimension: entrance {
    type: number
    sql: ${TABLE}.entrance ;;
    group_label: "Engagement"
  }

  dimension: exit {
    type: number
    sql: ${TABLE}.exit ;;
    group_label: "Engagement"
  }

  dimension: new_user {
    type: number
    sql: ${TABLE}.new_user ;;
    group_label: "Engagement"
  }

  #page

  dimension: first_page_title {
    description: "The title of the first page visited in the session."
    type: string
    sql: CASE WHEN ${page_view_in_session_index} = 1 THEN ${page_title} ELSE NULL END ;;
  }

  dimension: last_page_title {
    description: "The title of the last page visited in the session."
    type: string
    sql: CASE WHEN ${page_view_in_session_index} = ${sessions_rollup.max_page_view_index} THEN ${page_title} ELSE NULL END ;;
  }

  # Page performance
    # these fields have been removed from the new web model

  # MEASURES

  measure: row_count {
    type: count
    group_label: "Counts"
  }

  measure: page_view_count {
    type: count_distinct
    sql: ${page_view_id} ;;
    group_label: "Counts"
  }

  measure: bounced_page_view_count {
    type: count_distinct
    sql: ${page_view_id} ;;
    filters: {
      field: user_bounced
      value: "yes"
    }
    group_label: "Counts"
  }

  measure: max_page_view_index {
    type: max
    sql: ${page_view_in_session_index} ;;
  }

  measure: engaged_page_view_count {
    type: count_distinct
    sql: ${page_view_id} ;;
    filters: {
      field: user_engaged
      value: "yes"
    }
    group_label: "Counts"
  }

  measure: landing_page_count {
    type: count_distinct
    sql: ${page_view_id} ;;
    filters: {
      field: page_view_in_session_index
      value: "1"
    }
  }

  measure: exit_page_count {
    type: sum
    sql: ${TABLE}.exit ;;
  }

  measure: session_count {
    type: count_distinct
    sql: ${session_id} ;;
    group_label: "Counts"
  }

  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
  }

  # Engagement

  # measure: page_2_count {
  #   type: count_distinct
  #   sql: ${page_views_2.page_title} ;;
  # }

  measure: total_time_engaged {
    type: sum
    sql: ${time_engaged} ;;
    value_format: "#,##0\"s\""
    group_label: "Engagement"
  }

  measure: average_page_views_per_visit {
    type: average
    sql: ${page_view_in_session_index} ;;
    group_label: "Engagement"
  }

  measure: average_time_engaged {
    type: average
    sql: ${time_engaged} ;;
    value_format: "0.00\"s\""
    group_label: "Engagement"
  }

  measure: average_percentage_scrolled {
    type: average
    sql: ${y_percentage_scrolled} ;;
    value_format: "0.00\%"
    group_label: "Engagement"
  }
}

# If necessary, uncomment the line below to include explore_source.
# include: "snowplow_web_block.model.lkml"
explore: max_page_view_rollup {}
view: max_page_view_rollup {
  derived_table: {
    explore_source: page_views {
      column: page_view_id {}
      column: page_title {}
      column: max_page_view_index {}
      derived_column: p_key {
        sql: ROW_NUMBER() OVER (order by true) ;;
      }
    }
  }
  dimension: p_key {primary_key:yes}
  dimension: page_view_id {}
  dimension: page_title {}
  dimension: max_page_view_index {
    type: number
  }
}
