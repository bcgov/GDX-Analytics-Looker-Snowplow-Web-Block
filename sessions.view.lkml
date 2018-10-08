view: sessions {
  sql_table_name: derived.sessions ;;

  # DIMENSIONS

  # Application

  dimension: app_id {
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

  dimension: dcs_id {
    type: string
    sql: ${TABLE}.dcs_id ;;
    group_label: "Application"
  }


  # User

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
    group_label: "User"
  }

  dimension: domain_userid {
    type: string
    sql: ${TABLE}.domain_userid ;;
    group_label: "User"
  }

  dimension: network_userid {
    type: string
    sql: ${TABLE}.network_userid ;;
    group_label: "User"
    hidden: yes
  }

  # Session

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
    group_label: "Session"
  }

  dimension: session_index {
    type: number
    sql: ${TABLE}.session_index ;;
    group_label: "Session"
  }

  dimension: first_or_returning_session {
    type: string

    case: {
      when: {
        sql: ${session_index} = 1 ;;
        label: "First session"
      }

      when: {
        sql: ${session_index} > 1 ;;
        label: "Returning session"
      }

      else: "Error"
    }

    group_label: "Session"
    hidden: yes
  }

  # Session Time

  dimension_group: session_start {
    type: time
    timeframes: [raw, time, minute10, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.session_start ;;
    #X# group_label:"Session Time"
  }

  dimension_group: session_end {
    type: time
    timeframes: [raw, time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.session_end ;;
    #X# group_label:"Session Time"
#     hidden: yes
  }

  # date_range provides the necessary filter for Explores of current_session and last_period
  # where current_session captures the sessions from within the date range selected
  # and compares to last_period, which is the same duration as current_session, but
  # is offset such that it's end date exactly precedes current_session's start date
  filter: date_range {
    type: date
  }



  # TODO:
  # Dimensions current_period, is_in_range, and last_period need to be updated.
  # There is a problem where the dates to be compared are rolled
  # to tomorrow's date in the local time zone of the query, resulting
  # in incorrect reporting on the data.
  #
  # ${session_start_raw} must first be cast as a date that accounts for
  # the timezone from UTC to PST prior to the date_start/date_end
  # comparisons in the sql liquid variables.
  #
  # JIRA ticket GDXDSD-1189 contains discussion relating to this problem
  # A TODO in cfms_block/cfms_poc.view.lkml parallels this problem
  # The TODO goal of each is to unify on a generalized solution.
  #
  # Documentation references:
  # Looker Liquid Variables:
  #   https://docs.looker.com/reference/liquid-variables
  # Using date_start and date_end with date filters:
  #   https://discourse.looker.com/t/using-date-start-and-date-end-with-date-filters/2880
  #
  # current_period must include an upper limit to avoid including future dates when
  # a date-range is selected as the filter.

  # current_period filters sessions that are within the start and end range
  # of the date_range filter, as selected in an Explore.
  # the date_range filter is required for current_period
  # the last_period dimension is required to compare against current_period


  # period_difference calculates the number of days between the start and end dates
  # selected on the date_range filter, as selected in an Explore.
  # This is used by last_period to calculate its duration.
  dimension: period_difference {
    group_label: "Flexible Filter"
    type: number
    sql:  DATEDIFF(DAY, ${date_start}, ${date_end})  ;;
  }

  # is_in_range determines which sessions occur between the start of the last_period
  # and the end of the current_period, as selected on the date_range filter in an Explore.
  filter: is_in_range {
    type: yesno
    sql:  ${session_start_raw} >= DATEADD(DAY, -${period_difference}, ${date_start})
      AND ${session_start_raw} < ${date_end}    ;;
  }

  # last_period selects the the sessions that occurred immediately prior to the current_session and
  # over the same duration the current_session. Used in an explore, the date_range filter provides
  # the necessary is how input for date ranges to compare in this way.
  # the date_range filter is required for last_period
  # the current_period dimension is required to compare against last_period


  dimension: last_period {
    group_label: "Flexible Filter"
    type: yesno
    sql:  ${session_start_date} < ${date_start}
      AND ${session_start_date} >= DATEADD(DAY, -${period_difference}, ${date_start}) ;;
    required_fields: [is_in_range]
  }

  # current period is taking the first date of the selected date range ensuring all the sessions start on and after the date start
  # and less than the upper bound of the date selected cast into PDT

  dimension: current_period {
    group_label: "Flexible Filter"
    type: yesno
    sql: ${session_start_date} >= ${date_start}
      AND ${session_start_date} <= ${date_end};;
    # sql:  ${session_start_raw} >= {% date_start date_range %}
    #         AND
    #       ${session_start_raw} <= {% date_end date_range %} ;;
    # sql:  ${session_start_raw} >= {% date_start date_range %} ;;
  }

  dimension: date_start {
    type: date
    sql: {% date_start date_range %} ;;
  }

  dimension: date_end {
    type: date
    sql: {% date_end date_range %} ;;
  }

  dimension: session_start_window {
    required_fields: [is_in_range]
    case: {
      when: {
        sql: ${current_period} ;;
        label: "current_period"
      }

      when: {
        sql: ${last_period} ;;
        label: "previous_period"
      }

      else: "unknown"
    }

    # hidden: yes
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
    type: string
    sql: ${TABLE}.first_pageurl ;;
    group_label: "First Page"
  }

  dimension: first_page_node_id {
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
    type: string
    sql: ${TABLE}.first_page_urlpath ;;
    group_label: "First Page"
  }

  dimension: first_page_urlquery {
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
    type: string
    sql: ${TABLE}.first_page_title ;;
    group_label: "First Page"
  }

  # Referer

  dimension: referer_url {
    type: string
    sql: ${TABLE}.page_referrer ;;
    group_label: "Referer"
  }

  dimension: referer_urlscheme {
    type: string
    sql: ${TABLE}.refr_urlscheme ;;
    group_label: "Referer"
    hidden: yes
  }

  dimension: referer_urlhost {
    type: string
    sql: ${TABLE}.refr_urlhost ;;
    group_label: "Referer"
  }

  # dimension: referer_urlport {
  # type: number
  # sql: ${TABLE}.refr_urlport ;;
  # group_label: "Referer"
  # hidden: yes
  # }

  dimension: referer_urlpath {
    type: string
    sql: ${TABLE}.refr_urlpath ;;
    group_label: "Referer"
  }

  dimension: referer_urlquery {
    type: string
    sql: ${TABLE}.refr_urlquery ;;
    group_label: "Referer"
  }

  # dimension: referer_urlfragment {
  # type: string
  # sql: ${TABLE}.refr_urlfragment ;;
  # group_label: "Referer"
  # }

  dimension: referer_medium {
    type: string
    sql: ${TABLE}.refr_medium ;;
    group_label: "Referer"
  }

  dimension: referer_source {
    type: string
    sql: ${TABLE}.refr_source ;;
    group_label: "Referer"
  }

  dimension: referer_term {
    type: string
    sql: ${TABLE}.refr_term ;;
    group_label: "Referer"
  }

  # Marketing

  dimension: marketing_medium {
    type: string
    sql: ${TABLE}.mkt_medium ;;
    group_label: "Marketing"
  }

  dimension: marketing_source {
    type: string
    sql: ${TABLE}.mkt_source ;;
    group_label: "Marketing"
  }

  dimension: marketing_term {
    type: string
    sql: ${TABLE}.mkt_term ;;
    group_label: "Marketing"
  }

  dimension: marketing_content {
    type: string
    sql: ${TABLE}.mkt_content ;;
    group_label: "Marketing"
  }

  dimension: marketing_campaign {
    type: string
    sql: ${TABLE}.mkt_campaign ;;
    group_label: "Marketing"
  }

  dimension: marketing_clickid {
    type: string
    sql: ${TABLE}.mkt_clickid ;;
    group_label: "Marketing"
  }

  dimension: marketing_network {
    type: string
    sql: ${TABLE}.mkt_network ;;
    group_label: "Marketing"
  }

  dimension: marketing_channel {
    type: string
    sql: ${TABLE}.channel ;;
    group_label: "Marketing"
  }

  # Location

  dimension: geo_country {
    type: string
    sql: ${TABLE}.geo_country ;;
    group_label: "Location"
  }

  dimension: geo_region {
    type: string
    sql: ${TABLE}.geo_region ;;
    group_label: "Location"
  }

  dimension: geo_region_name {
    type: string
    sql: ${TABLE}.geo_region_name ;;
    group_label: "Location"
  }

  dimension: geo_city {
    type: string
    sql: ${TABLE}.geo_city ;;
    group_label: "Location"
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

  # IP

  dimension: ip_address {
    type: string
    sql: ${TABLE}.user_ipaddress ;;
    group_label: "IP"
  }

  dimension: is_government {
    # the filter is put in this view because the IP is defined here in this view
    # ATTENTION: This is_government filter is replicated by both page_views.view.lkml and sessions.view.lkml. ANY update to this code block must also be reflected in the corresponding code block of the other lkml file
    type: yesno
    # the filter is checking to see if the IP is in the gov network
    sql: ${ip_address} LIKE '142.22.%' OR ${ip_address} LIKE '142.23.%' OR ${ip_address} LIKE '142.24.%' OR ${ip_address} LIKE '142.25.%' OR ${ip_address} LIKE '142.26.%' OR ${ip_address} LIKE '142.27.%' OR ${ip_address} LIKE '142.28.%' OR ${ip_address} LIKE '142.29.%' OR ${ip_address} LIKE '142.30.%' OR ${ip_address} LIKE '142.31.%' OR  ${ip_address} LIKE '142.32.%' OR ${ip_address} LIKE '142.33.%' OR ${ip_address} LIKE '142.34.%' OR ${ip_address} LIKE '142.35.%' OR ${ip_address} LIKE '142.36.%' ;;
  }

  # dimension: ip_isp {
  # type: string
  # sql: ${TABLE}.ip_isp ;;
  # group_label: "IP"
  # }

  # dimension: ip_organization {
  # type: string
  # sql: ${TABLE}.ip_organization ;;
  # group_label: "IP"
  # }

  # dimension: ip_domain {
  # type: string
  # sql: ${TABLE}.ip_domain ;;
  # group_label: "IP"
  # }

  # dimension: ip_net_speed {
  # type: string
  # sql: ${TABLE}.ip_net_speed ;;
  # group_label: "IP"
  # }

  # Browser

  dimension: useragent {
    type: string
    sql: ${TABLE}.useragent ;;
    group_label: "Browser"
  }

  dimension: browser_name {
    type: string
    sql: ${TABLE}.br_name ;;
    group_label: "Browser"
  }

  dimension: browser_family {
    type: string
    sql: ${TABLE}.br_family ;;
    group_label: "Browser"
  }

  dimension: browser_version {
    type: string
    sql: ${TABLE}.br_version ;;
    group_label: "Browser"
  }

  dimension: browser_type {
    type: string
    sql: ${TABLE}.br_type ;;
    group_label: "Browser"
  }

  dimension: browser_engine {
    type: string
    sql: ${TABLE}.br_renderengine ;;
    group_label: "Browser"
  }

  dimension: browser_language {
    type: string
    sql: ${TABLE}.br_lang ;;
    group_label: "Browser"
  }

  # OS

  # dimension: os {
  # type: string
  # sql: ${TABLE}.os ;;
  # group_label: "OS"
  # }

  dimension: os_name {
    type: string
    sql: ${TABLE}.os_name ;;
    group_label: "OS"
  }

  dimension: os_family {
    type: string
    sql: ${TABLE}.os_family ;;
    group_label: "OS"
  }

  # dimension: os_minor_version {
  # type: string
  # sql: ${TABLE}.os_minor_version ;;
  # group_label: "OS"
  # }

  # dimension: os_build_version {
  # type: string
  # sql: ${TABLE}.os_build_version ;;
  # group_label: "OS"
  # }

  dimension: os_manufacturer {
    type: string
    sql: ${TABLE}.os_manufacturer ;;
    group_label: "OS"
  }

  dimension: os_timezone {
    type: string
    sql: ${TABLE}.os_timezone ;;
    group_label: "OS"
  }

  # Device

  dimension: device_type {
    type: string
    sql: ${TABLE}.dvce_type ;;
    group_label: "Device"
  }

  dimension: device_ismobile {
    type: yesno
    sql: ${TABLE}.dvce_ismobile ;;
    group_label: "Device"
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
