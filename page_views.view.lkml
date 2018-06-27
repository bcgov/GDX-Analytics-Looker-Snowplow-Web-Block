view: page_views {
  sql_table_name: derived.page_views ;;

  dimension: p_key {
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${page_view_id} ;;
  }

  # DIMENSIONS

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

  # Page View

  dimension: page_view_id {
    type: string
    sql: ${TABLE}.page_view_id ;;
    group_label: "Page View"
  }

  dimension: page_view_index {
     type: number
     index across all sessions
     sql: ${TABLE}.page_view_index ;;
     group_label: "Page View"
  }

  dimension: page_view_in_session_index {
    type: number
    # index within each session
    sql: ${TABLE}.page_view_in_session_index ;;
    group_label: "Page View"
  }

  # Page View Time

  dimension_group: page_view_start {
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.page_view_start_time ;;
    #X# group_label:"Page View Time"
  }

  dimension_group: page_view_end {
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.page_view_end_time ;;
    #X# group_label:"Page View Time"
    hidden: yes
  }

  # Page View Time (Device created)

  dimension_group: page_view_min_dvce_created_tstamp {
    type: time
    timeframes: [time, time_of_day, hour_of_day, day_of_week]
    sql: ${TABLE}.page_view_min_dvce_created_tstamp ;;
    convert_tz: no
  }

  dimension_group: page_view_max_dvce_created_tstamp {
    type: time
    timeframes: [time, time_of_day, hour_of_day, day_of_week]
    sql: ${TABLE}.page_view_max_dvce_created_tstamp ;;
    convert_tz: no
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

  dimension: entrance {
    type: yesno
    sql: ${TABLE}.entrance = 1 ;;
    group_label: "Engagement"
  }

  dimension: exit {
    type: yesno
    sql: ${TABLE}.exit = 1 ;;
    group_label: "Engagement"
  }

  dimension: new_user {
    type: yesno
    sql: ${TABLE}.new_user = 1 ;;
    group_label: "Engagement"
  }

  dimension: user_engaged {
    type: yesno
    sql: ${time_engaged} >= 30 ;;
    group_label: "Engagement"
  }

  # Page

  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url ;;
    group_label: "Page"
  }

  # dimension: page_url_scheme {
    # type: string
    # sql: ${TABLE}.page_url_scheme ;;
    # group_label: "Page"
    # hidden: yes
  # }

  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
    group_label: "Page"
  }

  # dimension: page_url_port {
    # type: number
    # sql: ${TABLE}.page_url_port ;;
    # group_label: "Page"
    # hidden: yes
  # }

  dimension: page_urlpath {
    type: string
    sql: ${TABLE}.page_urlpath ;;
    group_label: "Page"
  }

  dimension: page_urlquery {
    type: string
    sql: ${TABLE}.page_urlquery ;;
    group_label: "Page"
  }

  # dimension: page_url_fragment {
    # type: string
    # sql: ${TABLE}.page_url_fragment ;;
    # group_label: "Page"
  # }

  dimension: page_title {
    type: string
    sql: ${TABLE}.page_title ;;
    group_label: "Page"
  }

  dimension: first_page_title_test {
    label: "FIRST PAGE TITLE"
    type: string
    sql: CASE WHEN ${page_view_in_session_index} = 1 THEN ${page_title} ELSE NULL END ;;
  }

  # dimension: last_page_title {
    # type: string
    # sql: CASE WHEN ${page_view_in_session_index} = ${sessions_rollup.max_page_view_index} THEN ${page_title} ELSE NULL END ;;
  # }

  dimension: search_field {
    type: string
    # sql: decode(split_part(${page_url},'/search/',2),'%20', ' ');;
    sql: REPLACE(split_part(${page_url},'/search/',2), '%20', ' ');;
  }

  dimension: page_width {
    type: number
    sql: ${TABLE}.page_width ;;
    group_label: "Page"
  }

  dimension: page_height {
    type: number
    sql: ${TABLE}.page_height ;;
    group_label: "Page"
  }

  # Referer

  dimension: page_referer {
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

  # dimension: referer_url_port {
    # type: number
    # sql: ${TABLE}.referer_url_port ;;
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

  # dimension: referer_url_fragment {
    # type: string
    # sql: ${TABLE}.referer_url_fragment ;;
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

  dimension: marketing_channel  {
    type:  string
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

  dimension: is_government {
    # the filter is put in this view because the IP is defined here in this view
    type: yesno
    # the filter is checking to see if the IP is in the gov network
    sql: ${ip_address} LIKE '142.22.%' OR ${ip_address} LIKE '142.23.%' OR ${ip_address} LIKE '142.23.255%' OR ${ip_address} LIKE '142.24.%' OR ${ip_address} LIKE '142.31.%' OR ${ip_address} LIKE '142.31.255%' OR ${ip_address} LIKE '142.25.%' OR ${ip_address} LIKE '142.26.%' OR ${ip_address} LIKE '142.27.%' OR ${ip_address} LIKE '142.28.%' OR ${ip_address} LIKE '142.29.%' OR ${ip_address} LIKE '142.30.%' OR ${ip_address} LIKE '142.32.%' OR ${ip_address} LIKE '142.33.%' OR ${ip_address} LIKE '142.34.%' OR ${ip_address} LIKE '142.35.%' OR ${ip_address} LIKE '142.36.%' ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.user_ipaddress ;;
    group_label: "IP"
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

  # Application

  dimension: app_id {
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

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

  dimension: browser_viewwidth {
    type: number
    sql: ${TABLE}.br_viewwidth ;;
    group_label: "Browser"
  }

  dimension: browser_viewheight {
    type: number
    sql: ${TABLE}.br_viewheight ;;
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

  dimension: os_version {
    type: string
    sql: ${TABLE}.os_version ;;
    group_label: "OS"
  }

  # dimension: os_type {
    # type: string
    # sql: ${TABLE}.os_type ;;
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

  # dimension: device {
    # type: string
    # sql: ${TABLE}.device ;;
    # group_label: "Device"
  # }

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

  # Page performance

  # dimension: redirect_time {
    # type: number
    # sql: ${TABLE}.redirect_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: unload_time {
    # type: number
    # sql: ${TABLE}.unload_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: app_cache_time {
    # type: number
    # sql: ${TABLE}.app_cache_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: dns_time {
    # type: number
    # sql: ${TABLE}.dns_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: tcp_time {
    # type: number
    # sql: ${TABLE}.tcp_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: request_time {
    # type: number
    # sql: ${TABLE}.request_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: response_time {
    # type: number
    # sql: ${TABLE}.response_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: processing_time {
    # type: number
    # sql: ${TABLE}.processing_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: dom_loading_to_interactive_time {
    # type: number
    # sql: ${TABLE}.dom_loading_to_interactive_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: dom_interactive_to_complete_time {
    # type: number
    # sql: ${TABLE}.dom_interactive_to_complete_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: onload_time {
    # type: number
    # sql: ${TABLE}.onload_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  # dimension: total_time {
    # type: number
    # sql: ${TABLE}.total_time_in_ms ;;
    # value_format: "0\"ms\""
    # group_label: "Page Performance"
  # }

  dimension: exit_page_flag {
    type: yesno
    sql: ${page_view_index} = ${max_page_view_rollup.max_page_view_index} ;;
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
      field: page_view_index
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
    sql: COALESCE(${session_id},0) ;;
    group_label: "Counts"
  }

  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
  }

  # Engagement

  # measure: page_2_count {
    # type: count_distinct
    # sql: ${page_views_2.page_title} ;;
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

  # measure: average_percentage_scrolled {
    # type: average
    # sql: ${y_percentage_scrolled} ;;
    # value_format: "0.00\%"
    # group_label: "Engagement"
  # }

  # Page performance

  # measure: average_request_time {
    # type: average
    # sql: ${request_time} ;;
    # value_format: "#,##0\"ms\""
    # group_label: "Page Performance"
  # }

  # measure: average_response_time {
    # type: average
    # sql: ${response_time} ;;
    # value_format: "#,##0\"ms\""
    # group_label: "Page Performance"
  # }

  # measure: average_time_to_dom_interactive {
    # type: average
    # sql: ${dom_loading_to_interactive_time} ;;
    # value_format: "#,##0\"ms\""
    # group_label: "Page Performance"
  # }

  # measure: average_time_to_dom_complete {
    # type: average
    # sql: ${dom_interactive_to_complete_time} ;;
    # value_format: "#,##0\"ms\""
    # group_label: "Page Performance"
  # }

  # measure: average_onload_time {
    # type: average
    # sql: ${onload_time} ;;
    # value_format: "#,##0\"ms\""
    # group_label: "Page Performance"
  # }

  # measure: average_total_time {
    # type: average
    # sql: ${total_time} ;;
    # value_format: "#,##0\"ms\""
    # group_label: "Page Performance"
  # }
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
