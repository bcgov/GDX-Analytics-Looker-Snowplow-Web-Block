include: "shared_fields_common.view.lkml"

view: page_views {
  sql_table_name: derived.page_views ;;

  extends: [shared_fields_common]

  # Modifying extended fields
  dimension: os_version { hidden: yes }

  dimension: p_key {
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${page_view_id} ;;
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
    timeframes: [time, minute10, hour, date, week, month, quarter, year, time_of_day, hour_of_day, day_of_week]
    sql: ${TABLE}.page_view_start_time ;;
    #X# group_label:"Page View Time"
  }

  dimension_group: page_view_end {
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year, time_of_day, hour_of_day, day_of_week]
    sql: ${TABLE}.page_view_end_time ;;
    #X# group_label:"Page View Time"
    hidden: yes
  }

  # Page View Time (User Timezone)

  dimension_group: page_view_start_device_created {
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year, time_of_day, hour_of_day, day_of_week]
    sql: ${TABLE}.page_view_min_dvce_created_tstamp ;;
    #X# group_label:"Page View Time (User Timezone)"
  }

  dimension_group: page_view_end_device_created {
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year, time_of_day, hour_of_day, day_of_week]
    sql: ${TABLE}.page_view_max_dvce_created_tstamp ;;
    #X# group_label:"Page View Time (User Timezone)"
    hidden: yes
  }

  # flexible_filter_date_range provides the necessary filter for Explores of current_period and last_period
  # and to filter is_in_current_period_or_last_period.
  filter: flexible_filter_date_range {
    description: "This provides a date range used by dimensions in the Flexible Filters group. NOTE: On its own it does not do anything."
    type: date
  }

  # date_start and date_end provide date range timezone corrections for
  # use in the dimensions current_period, is_in_current_period_or_last_period, and last_period
  #
  # Using liquid variables: https://docs.looker.com/reference/liquid-variables
  # Using date_start and date_end with date filters:
  #   https://discourse.looker.com/t/using-date-start-and-date-end-with-date-filters/2880
  dimension: date_start {
    type: date
    sql: {% date_start flexible_filter_date_range %} ;;
    hidden: yes
  }

  dimension: date_end {
    type: date
    sql: {% date_end flexible_filter_date_range %} ;;
    hidden: yes
  }

  # period_difference calculates the number of days between the start and end dates
  # selected on the flexible_filter_date_range filter, as selected in an Explore.
  dimension: period_difference {
    group_label: "Flexible Filter"
    type: number
    sql:  DATEDIFF(DAY, {% date_start flexible_filter_date_range %}, {% date_end flexible_filter_date_range %})  ;;
  }

  # is_in_current_period_or_last_period determines which sessions occur between the start of the last_period
  # and the end of the current_period, as selected on the flexible_filter_date_range filter in an Explore.
  filter: is_in_current_period_or_last_period {
    group_label: "Flexible Filter"
    type: yesno
    sql: DATEDIFF(SECOND,${TABLE}.page_view_min_dvce_created_tstamp, {% date_start flexible_filter_date_range %}) / 86400.0 <= ${period_difference}
    AND ${TABLE}.page_view_min_dvce_created_tstamp < {% date_end flexible_filter_date_range %} ;;
  }

  # current period identifies sessions falling between the start and end of the date range selected
  dimension: current_period {
    group_label: "Flexible Filter"
    type: yesno
    sql: ${TABLE}.page_view_min_dvce_created_tstamp >= {% date_start flexible_filter_date_range %}
      AND ${TABLE}.page_view_min_dvce_created_tstamp < {% date_end flexible_filter_date_range %} ;;
  }

  # last_period selects the the sessions that occurred immediately prior to the current_session and
  # over the same number of days as the current_session.
  # For instance, it would provide a suitable comparison of data from one week to the next.
  dimension: last_period {
    group_label: "Flexible Filter"
    type: yesno
    sql: ${TABLE}.page_view_min_dvce_created_tstamp >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
      AND ${TABLE}.page_view_min_dvce_created_tstamp < {% date_start flexible_filter_date_range %} ;;
  }


  dimension: date_window {
    group_label: "Flexible Filter"
    case: {
      when: {
        sql: ${TABLE}.page_view_min_dvce_created_tstamp >= {% date_start flexible_filter_date_range %}
          AND ${TABLE}.page_view_min_dvce_created_tstamp < {% date_end flexible_filter_date_range %} ;;
        label: "current_period"
      }
      when: {
        sql: ${TABLE}.page_view_min_dvce_created_tstamp >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
          AND ${TABLE}.page_view_min_dvce_created_tstamp < {% date_start flexible_filter_date_range %} ;;
        label: "last_period"
      }
      else: "unknown"
    }

    # hidden: yes
  }

  # comparison_date returns dates in the current_period providing a positive offset of
  # the last_period date range by. Exploring comparison_date with any Measure and a pivot
  # on date_window results in a pointwise comparison of current and last periods
  dimension: comparison_date {
    group_label: "Flexible Filter"
    required_fields: [date_window]
    type: date
    sql:
        CASE
         WHEN ${TABLE}.page_view_min_dvce_created_tstamp >= {% date_start flexible_filter_date_range %}
             AND ${TABLE}.page_view_min_dvce_created_tstamp < {% date_end flexible_filter_date_range %}
            THEN CONVERT_TIMEZONE('America/Los_Angeles','UTC', ${page_view_start_device_created_date})
         WHEN ${TABLE}.page_view_min_dvce_created_tstamp >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
             AND ${TABLE}.page_view_min_dvce_created_tstamp < {% date_start flexible_filter_date_range %}
            THEN DATEADD(DAY,${period_difference},(CONVERT_TIMEZONE('America/Los_Angeles','UTC', ${page_view_start_device_created_date})))
         ELSE
           NULL
       END ;;
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


  dimension: exit_page_flag {
    type: yesno
    sql: ${page_view_in_session_index} = ${max_page_view_rollup.max_page_view_index} ;;
  }

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
    type: count_distinct
    sql: ${page_view_id} ;;
    filters: {
      field: exit_page_flag
      value: "Yes"
    }
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
