view: searches {
  sql_table_name: derived.searches ;;


  dimension: p_key {
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${search_id} ;;
  }

  # DIMENSIONS

  # Application

  dimension: app_id {
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

  # this is only available for WebTrends data
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

  # Search

  dimension_group: search_time {
    type: time
    timeframes: [hour,date,week,month,quarter,year,raw]
    sql:  ${TABLE}.collector_tstamp ;;
    group_label: "Search"
  }

  dimension: search_id {
    type: string
    sql: ${TABLE}.search_id ;;
    group_label: "Search"
  }

  dimension: search_in_session_index {
    type: number
    # index within each session
    sql: ${TABLE}.search_in_session_index ;;
    group_label: "Search"
  }


  # Page

  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url ;;
    group_label: "Page"
  }

  dimension: node_id {
    type: string
    sql: ${TABLE}.node_id;;
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

  dimension: search_field {
    type: string
    # sql: decode(split_part(${page_url},'/search/',2),'%20', ' ');;
    sql: REPLACE(split_part(${page_url},'/search/',2), '%20', ' ')
      ;;
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

  # Search results

  # terms returns a string array of search terms
  # which can have a size > 1
  dimension: terms {
    type: string
    sql: ${TABLE}.terms ;;
    group_label: "Results"
  }

  # readable_terms removes wrapping [" "] from the terms dimension,
  # array and replaces + signs with ' ', rendering a readable string
  # in the case of the term string array containing a single element
  dimension: readable_terms {
    type:  string
    sql:  replace(substring(${terms}, 3, length(${terms})-4),'+',' ') ;;
    group_label: "Results"
  }

  dimension: filters {
    type: string
    sql: ${TABLE}.filters ;;
    group_label: "Results"
  }

  dimension: total_results {
    type: number
    sql: ${TABLE}.total_results ;;
    group_label: "Results"
  }

  dimension: page_results {
    type: number
    sql: ${TABLE}.page_results ;;
    group_label: "Results"
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

  # MEASURES

  measure: row_count {
    type: count
    group_label: "Counts"
  }

  measure: search_count {
    type: count_distinct
    sql: ${search_id} ;;
    group_label: "Counts"
  }

  measure: max_search_index {
    type: max
    sql: ${search_in_session_index} ;;
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

  measure: average_searches_per_visit {
    type: average
    sql: ${search_in_session_index} ;;
    group_label: "Engagement"
  }
}
