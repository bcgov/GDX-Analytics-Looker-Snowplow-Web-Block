view: searches {
  sql_table_name: derived.searches ;;

  dimension: p_key {
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${search_id} ;;
  }

  # DIMENSIONS

  # Application

  dimension: app_id {
    description: "The application identifier from which the event originated."
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

  # this is only available for WebTrends data
  dimension: dcs_id {
    description: "The Webtrends profile identifier."
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

  # Page
  # duplicates throughout this section

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
  # duplicates throughout this section

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
  # duplicates throughout this section

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
  # duplicates throughout this section

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
  # duplicates throughout this section

  dimension: is_government {
    description: "Yes if the IP address maps to a known BC Government network."
    # the filter is put in this view because the IP is defined here in this view
    type: yesno
    # the filter is checking to see if the IP is in the gov network
    sql: ${ip_address} LIKE '142.22.%' OR ${ip_address} LIKE '142.23.%' OR ${ip_address} LIKE '142.23.255%' OR ${ip_address} LIKE '142.24.%' OR ${ip_address} LIKE '142.31.%' OR ${ip_address} LIKE '142.31.255%' OR ${ip_address} LIKE '142.25.%' OR ${ip_address} LIKE '142.26.%' OR ${ip_address} LIKE '142.27.%' OR ${ip_address} LIKE '142.28.%' OR ${ip_address} LIKE '142.29.%' OR ${ip_address} LIKE '142.30.%' OR ${ip_address} LIKE '142.32.%' OR ${ip_address} LIKE '142.33.%' OR ${ip_address} LIKE '142.34.%' OR ${ip_address} LIKE '142.35.%' OR ${ip_address} LIKE '142.36.%' ;;
  }

  dimension: ip_address {
    description: "The user's IP address, with the final octet replaced with \"1\" to remove personally identifiable information."
    type: string
    sql: ${TABLE}.user_ipaddress ;;
    group_label: "IP"
  }

  # Browser
  # This section contains fields that are duplicated across over view files in this project

  dimension: useragent {
    description: "The useragent string for this session."
    hidden: yes
    type: string
    sql: ${TABLE}.useragent ;;
    group_label: "Browser"
  }

  dimension: browser_name {
    description: "The browser name."
    type: string
    sql: ${TABLE}.br_name ;;
    group_label: "Browser"
  }

  dimension: browser_family {
    description: "The browser family."
    type: string
    sql: ${TABLE}.br_family ;;
    group_label: "Browser"
  }

  dimension: browser_version {
    description: "The browser version."
    type: string
    sql: ${TABLE}.br_version ;;
    group_label: "Browser"
  }

  dimension: browser_type {
    description: "The browser type."
    type: string
    sql: ${TABLE}.br_type ;;
    group_label: "Browser"
  }

  dimension: browser_engine {
    description: "The browser rendering engine."
    type: string
    sql: ${TABLE}.br_renderengine ;;
    group_label: "Browser"
  }

  dimension: browser_view_width {
    description: "The browser viewport width."
    type: number
    sql: ${TABLE}.br_viewwidth ;;
    group_label: "Browser"
  }

  dimension: browser_view_height {
    description: "The browser viewport height."
    type: number
    sql: ${TABLE}.br_viewheight ;;
    group_label: "Browser"
  }

  dimension: browser_language {
    description: "The language the browser is set to."
    type: string
    sql: ${TABLE}.br_lang ;;
    group_label: "Browser"
  }

  # OS
  # duplicates throughout this section

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

  # Device
  # duplicates throughout this section

  dimension: device_type {
    description: "A label that describes the viewing device type as Mobile or Computer."
    type: string
    sql: ${TABLE}.dvce_type ;;
    group_label: "Device"
  }

  dimension: device_is_mobile {
    description: "True if the viewing device is mobile; False otherwise."
    type: yesno
    sql: ${TABLE}.dvce_ismobile ;;
    group_label: "Device"
  }

  # Search

  # duplicate from atomic.events (events.view.lkml)
  dimension_group: search_time {
    type: time
    timeframes: [hour,date,week,month,quarter,year,raw]
    sql:  ${TABLE}.collector_tstamp ;;
    group_label: "Search"
  }

  # search_id: string
  # Table reference - VARCHAR(255) ENCODE ZSTD NOT NULL
  # Unique ID for each click (equal to event_id in atomic.events)
  dimension: search_id {
    type: string
    sql: ${TABLE}.search_id ;;
    group_label: "Search"
  }

  # search_in_session_index: number
  # Table reference - INT8 ENCODE ZSTD
  #
  # This dimension is used in calculated fields that are more meaningful for Explores (max_search_index);
  #  on it's own, search_in_session_index it is difficult to describe succinctly, and may be more confusing
  #  than helpful to Looker users developing Explores, so it has been hidden.
  dimension: search_in_session_index {
    description: "The search index within a single session."
    type: number
    # index within each session
    sql: ${TABLE}.search_in_session_index ;;
    group_label: "Search"
    hidden: yes
  }

  # TODO: flag for removal; this is a URI query component that is better represented to users by readable_terms.
  dimension: search_field {
    type: string
    # sql: decode(split_part(${page_url},'/search/',2),'%20', ' ');;
    sql: REPLACE(split_part(${page_url},'/search/',2), '%20', ' ')
      ;;
    hidden: yes
  }

  # Search results

  # terms: string
  #
  # Table reference - VARCHAR(2048) ENCODE RAW
  # terms returns a string array of search terms
  # The array can have a size greater than 1 in multi-dimension searches
  # TODO: GDXDSD-1326
  dimension: raw_search_terms {
    type: string
    sql: ${TABLE}.terms ;;
    group_label: "Results"
    hidden: yes
  }

  # readable_terms: string
  #
  # removes wrapping [" "] from the terms dimension, array and
  # replaces + signs with ' ', rendering a readable string in
  # the case of the term string array containing a single element
  # TODO: GDXDSD-1326 handle multiple-term searches past the first index, and empty searches.
  dimension: search_terms {
    description: "The search term(s) that were queried."
    type:  string
    sql:  replace(substring(${raw_search_terms}, 3, length(${raw_search_terms})-4),'+',' ') ;;
    group_label: "Results"
  }

  # filters: string
  # Table reference - VARCHAR(2048) ENCODE RAW
  # e.g.: '{'category': 'books', 'sub-category': 'non-fiction'}'
  dimension: filters {
    description: "The search filters selected."
    type: string
    sql: ${TABLE}.filters ;;
    group_label: "Results"
  }

  # total_results: number
  # Table reference - INT ENCODE RAW
  dimension: total_results {
    description: "The number of search results found."
    type: number
    sql: ${TABLE}.total_results ;;
    group_label: "Results"
  }

  # page_results: number
  # Table reference - INT ENCODE RUNLENGTH
  dimension: page_results {
    description: "The number of results displayed on the first page"
    type: number
    sql: ${TABLE}.page_results ;;
    group_label: "Results"
  }

  # MEASURES
  # duplicates throughout this section

  measure: row_count {
    type: count
    group_label: "Counts"
  }

  # search_count
  # a distinct count of the unique searches returned
  # Unique ID for each click (equal to event_id in atomic.events)
  measure: search_count {
    description: "A distinct count of the unique searches returned in this Explore."
    type: count_distinct
    sql: ${search_id} ;;
    group_label: "Counts"
  }

  # max_search_index: number
  # Table reference - INT8 ENCODE ZSTD
  # returns the max value of search session indexes
  measure: max_search_index {
    description: "the highest number of searches that occurred over the sessions in the result set."
    type: max
    sql: ${search_in_session_index} ;;
  }

  # average_searches_per_visit: number
  # Table reference - INT8 ENCODE ZSTD
  # finds the average value of search session indexes
  measure: average_searches_per_visit {
    description: "the average number of searches that occurred over the sessions in the result set."
    type: average
    sql: ${search_in_session_index} ;;
    group_label: "Engagement"
  }

  # duplicate
  measure: session_count {
    type: count_distinct
    sql: ${session_id} ;;
    group_label: "Counts"
  }

  # duplicate
  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
  }
}
