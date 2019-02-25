view: date_comparisons_common {

  # filter_start is a placeholder dimension for the date_comparisons_common view.

  # In order to extend this view, this dimension must be modified in the extending view.
  # For example, in the sessions view, this fiels is extended to query session_start in the database.
  #
  # dimension_group: filter_start {
  #   sql: ${TABLE}.session_start ;;
  # }
  dimension_group: filter_start {
    type: time
    # sql: ${MODIFY THIS IN EXTENDS} ;;
    timeframes: [raw, date, week, month, quarter, year]
    hidden: yes
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
  # Here's an explanation of why we use DATEDIFF(SECOND and not DAY
  #    https://www.sqlteam.com/articles/datediff-function-demystified
  filter: is_in_current_period_or_last_period {
    type: yesno
    sql:  ${filter_start_raw} >= DATEADD('day', -${period_difference}, {% date_start flexible_filter_date_range %})
      AND ${filter_start_raw} < {% date_end flexible_filter_date_range %} ;;
  }


  # current period identifies sessions falling between the start and end of the date range selected
  dimension: current_period {
    group_label: "Flexible Filter"
    type: yesno
    sql: ${filter_start_raw} >= {% date_start flexible_filter_date_range %}
      AND ${filter_start_raw} < {% date_end flexible_filter_date_range %} ;;
    hidden: yes
  }

  # last_period selects the the sessions that occurred immediately prior to the current_session and
  # over the same number of days as the current_session.
  # For instance, it would provide a suitable comparison of data from one week to the next.
  dimension: last_period {
    group_label: "Flexible Filter"
    type: yesno
    sql: ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
      AND ${filter_start_raw} < {% date_start flexible_filter_date_range %} ;;
    hidden: yes
  }

  # dimension: date_window provides the pivot label for constructing tables and charts
  # that compare current_period and last_period
  dimension: date_window {
    group_label: "Flexible Filter"
    case: {
      when: {
        sql: ${filter_start_raw} >= {% date_start flexible_filter_date_range %}
          AND ${filter_start_raw} < {% date_end flexible_filter_date_range %} ;;
        label: "Current Period"
      }
      when: {
        sql: ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
          AND ${filter_start_raw} < {% date_start flexible_filter_date_range %} ;;
        label: "Last Period"
      }
      else: "unknown"
    }
    description: "Pivot on Date Window to compare measures between the current and last periods, use with Comparison Date"
  }

  # comparison_date returns dates in the current_period providing a positive offset of
  # the last_period date range. Exploring comparison_date with any measure and a pivot
  # on date_window results in a pointwise comparison of current and last periods
  #
  dimension: comparison_date {
    group_label: "Flexible Filter"
    required_fields: [date_window]
    description: "Comparison Date offsets measures from the last period to appear in the range of the current period,
    allowing a pairwise comparison between these periods when used with Date Window."
    type: date
    sql:
       CASE
         WHEN ${filter_start_raw} >= {% date_start flexible_filter_date_range %}
             AND ${filter_start_raw} < {% date_end flexible_filter_date_range %}
            THEN ${filter_start_date}
         WHEN ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, {% date_start flexible_filter_date_range %})
             AND ${filter_start_raw} < {% date_start flexible_filter_date_range %}
            THEN DATEADD(DAY,${period_difference},(${filter_start_date}))
         ELSE
           NULL
       END ;;
  }

  parameter: summary_granularity {
    type: string
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    # allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
  }

  dimension: summary_start {
    type: date
    sql:  {% date_start flexible_filter_date_range %}::date;;
    hidden: yes
  }

  dimension: summary_end {
    type: date
    sql:  CASE WHEN {% date_start flexible_filter_date_range %}::date = {% date_end flexible_filter_date_range %}::date
                  THEN DATE_ADD('day',1, {% date_start flexible_filter_date_range %}::date)
                ELSE {% date_end flexible_filter_date_range %}::date
            END ;;
    hidden: yes
  }

  dimension: in_summary_period {
    group_label: "Summary"
    type: yesno
    sql: ${filter_start_raw} >= date_trunc({% parameter summary_granularity %}, ${summary_start} )
          AND ${filter_start_raw} < date_trunc({% parameter summary_granularity %}, ${summary_end} - interval '1 day') + interval '1 '{% parameter summary_granularity %}
        ;;
  }

  dimension: summary_date {
    label_from_parameter: summary_granularity
    sql:
       CASE
         WHEN {% parameter summary_granularity %} = 'Day' THEN
           ${filter_start_date}::VARCHAR
         WHEN {% parameter summary_granularity %} = 'Week' THEN
           ${filter_start_week}::VARCHAR
         WHEN {% parameter summary_granularity %} = 'Month' THEN
           ${filter_start_month}::VARCHAR
         WHEN {% parameter summary_granularity %} = 'Quarter' THEN
           ${filter_start_quarter}::VARCHAR
         WHEN {% parameter summary_granularity %} = 'Year' THEN
         ${filter_start_year}::VARCHAR
         ELSE
           NULL
       END
      ;;
  }

}
