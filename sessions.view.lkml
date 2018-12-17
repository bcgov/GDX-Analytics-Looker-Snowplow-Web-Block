include: "shared_fields_common.view.lkml"

view: sessions {
  sql_table_name: derived.sessions ;;

  extends: [shared_fields_common]

  # Modifying extended fields
  dimension: browser_view_height { hidden: yes }
  dimension: browser_view_width { hidden: yes }
  dimension: os_version { hidden: yes }
  dimension: node_id { hidden: yes }
  dimension: p_key { hidden: yes }
  dimension: page_height { hidden: yes }
  dimension: page_title { hidden: yes }
  dimension: page_url { hidden: yes }
  dimension: page_urlhost { hidden: yes }
  dimension: page_urlpath { hidden: yes }
  dimension: page_urlquery { hidden: yes }
  dimension: page_width { hidden: yes }
  dimension: search_field { hidden: yes }

  # DIMENSIONS

  # Session Time

  # session_start: time
  # Table reference: TIMESTAMP
  #
  # session_start corresponds to the first value of page_view_start_time within that session.
  # Explores can reference any timeframe except raw;
  # LookML can reference raw without any formatting or timezone conversions, and all other timeframes can be referenced with conversion.
  #
  # References:
  # * https://github.com/snowplow-proservices/ca.bc.gov-snowplow-pipeline/blob/master/jobs/webmodel/README.md
  dimension_group: session_start {
    description: "The start time of the first page view of a given session."
    type: time
    timeframes: [raw, time, minute10, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.session_start ;;
    #X# group_label:"Session Time"
  }

  # session_end: time
  # Table reference: TIMESTAMP
  #
  # session_end corresponds to the last page_view_end_time within that session.
  # Explores can reference any timeframe except raw;
  # LookML can reference raw without any formatting or timezone conversions, and all other timeframes can be referenced with conversion.
  #
  # References:
  # * https://github.com/snowplow-proservices/ca.bc.gov-snowplow-pipeline/blob/master/jobs/webmodel/README.md
  dimension_group: session_end {
    description: "The end time of the last page view of a given session."
    type: time
    timeframes: [raw, time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.session_end ;;
    #X# group_label:"Session Time"
    # hidden: yes
  }

  # flexible_filter_date_range: date
  #
  # flexible_filter_date_range provides the necessary filter for Explores of current_period and last_period
  # and to filter is_in_current_period_or_last_period.
  filter: flexible_filter_date_range {
    type: date
    description: "This provides a date range used by dimensions in the Flexible Filters group. NOTE: On its own it does not do anything."
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
    hidden: yes
  }

  # is_in_current_period_or_last_period determines which sessions occur on an after the start of the last_period
  # and before end of the current_period, as selected on the flexible_filter_date_range filter in an Explore.
  filter: is_in_current_period_or_last_period {
    type: yesno
    sql:  DATEDIFF(SECOND,${TABLE}.session_start, {% date_start flexible_filter_date_range %}) / 86400.0 <= ${period_difference}
      AND ${TABLE}.session_start < {% date_end flexible_filter_date_range %} ;;
  }


  # current period identifies sessions falling between the start and end of the date range selected
  dimension: current_period {
    group_label: "Flexible Filter"
    type: yesno
    sql: ${TABLE}.session_start >= {% date_start flexible_filter_date_range %}
      AND ${TABLE}.session_start < {% date_end flexible_filter_date_range %} ;;
    hidden: yes
  }

  # last_period selects the the sessions that occurred immediately prior to the current_session and
  # over the same number of days as the current_session.
  # For instance, it would provide a suitable comparison of data from one week to the next.
  dimension: last_period {
    group_label: "Flexible Filter"
    type: yesno
    sql: ${TABLE}.session_start >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
      AND ${TABLE}.session_start < {% date_start flexible_filter_date_range %} ;;
    hidden: yes
  }

  # dimension: date_window provides the pivot label for constructing tables and charts
  # that compare current_period and last_period
  dimension: date_window {
    group_label: "Flexible Filter"
    case: {
      when: {
        sql: ${TABLE}.session_start >= {% date_start flexible_filter_date_range %}
             AND ${TABLE}.session_start < {% date_end flexible_filter_date_range %} ;;
        label: "current_period"
      }
      when: {
        sql: ${TABLE}.session_start >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
             AND ${TABLE}.session_start < {% date_start flexible_filter_date_range %} ;;
        label: "last_period"
      }
      else: "unknown"
    }
    description: "Pivot on Date Window to compare measures between the current and last periods, use with Comparison Date"
  }

  # comparison_date returns dates in the current_period providing a positive offset of
  # the last_period date range. Exploring comparison_date with any measure and a pivot
  # on date_window results in a pointwise comparison of current and last periods
  #
  # Note that we need to put this back into UTC as otherwise, Looker will double convert the timezone later
  dimension: comparison_date {
    group_label: "Flexible Filter"
    required_fields: [date_window]
    description: "Comparison Date offsets measures from the last period to appear in the range of the current period,
    allowing a pairwise comparison between these periods when used with Date Window."
    type: date
    sql:
       CASE
         WHEN ${TABLE}.session_start >= {% date_start flexible_filter_date_range %}
             AND ${TABLE}.session_start < {% date_end flexible_filter_date_range %}
            THEN CONVERT_TIMEZONE('America/Los_Angeles','UTC', ${session_start_date})
         WHEN ${TABLE}.session_start >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
             AND ${TABLE}.session_start < {% date_start flexible_filter_date_range %}
            THEN DATEADD(DAY,${period_difference},(CONVERT_TIMEZONE('America/Los_Angeles','UTC', ${session_start_date})))
         ELSE
           NULL
       END ;;
  }

  # Session Time (User Timezone)

  # dimension_group: session_start_local {
  # type: time
  # timeframes: [time, time_of_day, hour_of_day, day_of_week]
  # sql: ${TABLE}.session_start_local ;;
  #X# group_label:"Session Time (User Timezone)"
  # convert_tz: no
  # }

  # dimension_group: session_end_local {
  # type: time
  # timeframes: [time, time_of_day, hour_of_day, day_of_week]
  # sql: ${TABLE}.session_end_local ;;
  #X# group_label:"Session Time (User Timezone)"
  # convert_tz: no
  # hidden: yes
  # }

  # Engagement

  parameter: date_granularity {
    type: string
    allowed_value: { value: "Day" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
  }

  dimension: date {
    label_from_parameter: date_granularity
    sql:
       CASE
         WHEN {% parameter date_granularity %} = 'Day' THEN
           ${session_start_date}::VARCHAR
         WHEN {% parameter date_granularity %} = 'Month' THEN
           ${session_start_month}::VARCHAR
         WHEN {% parameter date_granularity %} = 'Quarter' THEN
           ${session_start_quarter}::VARCHAR
         WHEN {% parameter date_granularity %} = 'Year' THEN
           ${session_start_year}::VARCHAR
         ELSE
           NULL
       END ;;
  }

  # Engagement

  dimension: page_views {
    type: number
    sql: ${TABLE}.page_views ;;
    group_label: "Engagement"
  }

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
    group_label: "Engagement"
  }

  dimension: searches {
    type: number
    sql: ${TABLE}.searches ;;
    group_label: "Engagement"
  }

  dimension: time_engaged {
    type: number
    sql: ${TABLE}.time_engaged_in_s ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: time_engaged_tier {
    type: tier
    tiers: [0, 10, 30, 60, 120, 240]
    style: integer
    sql: ${time_engaged} ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: user_bounced {
    type: yesno
    sql: ${page_views} = 1 AND ${time_engaged} = 0 ;;
    group_label: "Engagement"
  }

  dimension: user_engaged {
    type: yesno
    sql: ${page_views} > 2 AND ${time_engaged} > 59 ;;
    group_label: "Engagement"
  }

  # First Page

  dimension: first_page_url {
    description: "The URL of the page where a session began."
    type: string
    sql: ${TABLE}.first_pageurl ;;
    group_label: "First Page"
  }

  dimension: first_page_node_id {
    description: "The identifier of the page where a session began."
    type: string
    sql: ${TABLE}.node_id ;;
    group_label: "First Page"
  }

  # dimension: first_page_urlscheme {
  # type: string
  # sql: ${TABLE}.first_page_urlscheme ;;
  # group_label: "First Page"
  # hidden: yes
  # }

  dimension: first_page_urlhost {
    description: "The host name of the page where a session began."
    type: string
    sql: ${TABLE}.first_page_urlhost ;;
    group_label: "First Page"
  }

  # dimension: first_page_urlport {
  # type: number
  # sql: ${TABLE}.first_page_urlport ;;
  # group_label: "First Page"
  # hidden: yes
  # }

  dimension: first_page_urlpath {
    description: "The URL path of the page where a session began."
    type: string
    sql: ${TABLE}.first_page_urlpath ;;
    group_label: "First Page"
  }

  dimension: first_page_urlquery {
    description: "The URL query of the page where a session began."
    type: string
    sql: ${TABLE}.first_page_urlquery ;;
    group_label: "First Page"
  }

  # dimension: first_page_urlfragment {
  # type: string
  # sql: ${TABLE}.first_page_urlfragment ;;
  # group_label: "First Page"
  # }

  dimension: first_page_title {
    description: "The Title for the page where a session began."
    type: string
    sql: ${TABLE}.first_page_title ;;
    group_label: "First Page"
  }

  dimension: session_length {
    type: number
    sql: DATEDIFF(SECONDS, ${session_start_raw}, ${session_end_raw}) ;;
  }

  # MEASURES

  measure: average_session_length {
    type: average
    sql: ${session_length} / 86400.0;;
    value_format: "h:mm:ss"
#     to_char(${session_length}::interval, 'HH24:MI:SS') ;;
  }
#   to_char(${session_length})

  measure: row_count {
    type: count
    group_label: "Counts"
  }

  measure: page_view_count {
    type: sum
    sql: ${page_views} ;;
    group_label: "Counts"
  }

  measure: click_count {
    type: sum
    sql: ${clicks} ;;
    group_label: "Counts"
  }

  measure: session_count {
    type: count_distinct
    sql: ${session_id};;
    group_label: "Counts"
    drill_fields: [session_count]
  }
  set: session_count{
    fields: [session_id, session_start_date, first_page_url, referer_medium, page_view_count, total_time_engaged]
  }

  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
    drill_fields: [user_count]
  }
  set: user_count{
    fields: [domain_userid, users.first_page_url, session_count, average_time_engaged, total_time_engaged]
  }

  measure: new_user_count {
    type: count_distinct
    sql: ${domain_userid} ;;

    filters: {
      field: session_index
      value: "1"
    }

    group_label: "Counts"
    drill_fields: [new_user_count]
  }
  set: new_user_count{
    fields: [domain_userid, users.first_page_url, session_count, average_time_engaged, total_time_engaged]
  }

  measure: bounced_user_count {
    type: count_distinct
    sql: ${domain_userid} ;;

    filters: {
      field: user_bounced
      value: "yes"
    }

    group_label: "Counts"
  }

  measure: engaged_user_count {
    type: count_distinct
    sql: ${domain_userid} ;;

    filters: {
      field: user_engaged
      value: "yes"
    }

    group_label: "Counts"
  }

  # Engagement

  measure: total_time_engaged {
    type: sum
    sql: ${time_engaged} ;;
    value_format: "#,##0\"s\""
    group_label: "Engagement"
  }

  measure: average_time_engaged {
    type: average
    sql: ${time_engaged} ;;
    value_format: "0.00\"s\""
    group_label: "Engagement"
  }
}
