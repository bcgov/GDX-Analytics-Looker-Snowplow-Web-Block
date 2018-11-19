# Details on the derived.clicks table is in the Snowplow Web Model documentation:
# https://github.com/snowplow-proservices/ca.bc.gov-snowplow-pipeline/blob/master/jobs/webmodel/README.md#4-clicks

view: clicks {
  sql_table_name: derived.clicks ;;

  # duplicate
  dimension: p_key {
    description: "The primary key, which is one of: User ID, Domain User ID, Session ID, or Click ID."
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${click_id} ;;
  }

  # DIMENSIONS

  # Application
  # This section contains fields that are duplicated across over view files in this project

  dimension: app_id {
    description: "The application identifier from which the event originated."
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

  # dcs_id
  # The DCS identifieir is the webtrends profile identifier
  # this is only available for WebTrends data
  dimension: dcs_id {
    description: "The Webtrends profile identifier."
    type: string
    sql: ${TABLE}.dcs_id ;;
    group_label: "Application"
    hidden: yes
  }

  # User
  # This section contains fields that are duplicated across over view files in this project

  dimension: user_id {
    description: "A unique identifier set by the business."
    type: string
    sql: ${TABLE}.user_id ;;
    group_label: "User"
  }

  dimension: domain_userid {
    description: "The user identifier set by Snowplow using a first party cookie."
    type: string
    sql: ${TABLE}.domain_userid ;;
    group_label: "User"
  }

  dimension: network_userid {
    description: "The user identifier set by Snowplow using a third party cookie."
    type: string
    sql: ${TABLE}.network_userid ;;
    group_label: "User"
    hidden: yes
  }

  # Session
  # This section contains fields that are duplicated across over view files in this project

  dimension: session_id {
    description: "A visit or session identifier."
    type: string
    sql: ${TABLE}.session_id ;;
    group_label: "Session"
  }

  dimension: session_index {
    description: "A visit or session index, starting at 1 on the first page visited. Can be used in path analysis."
    type: number
    sql: ${TABLE}.session_index ;;
    group_label: "Session"
    hidden: yes
  }

  # Click

  # click_time: time
  # Table reference - TIMESTAMP ENCODE ZSTD
  # returns the timestamp at any of the dimensions identified in the timeframes list
  dimension_group: click_time {
    description: "The timestamp for the page view as recorded by the collector."
    type: time
    timeframes: [hour,date,week,month,quarter,year,raw]
    sql:  ${TABLE}.collector_tstamp ;;
    group_label: "Click"
  }

  # click_id: string
  # Table reference - VARCHAR(255) ENCODE ZSTD NOT NULL
  # an alphanumeric identifier that matches to event_id in atomic.events
  dimension: click_id {
    description: "A unique identifier for each click."
    type: string
    sql: ${TABLE}.click_id ;;
    group_label: "Click"
  }

  # click_type: string
  # Table reference - VARCHAR(36) ENCODE ZSTD NOT NULL
  # Click type labels are currently either "link click" or "download"
  dimension: click_type {
    description: "A label that is either \"link_click\" or \"download\"."
    type: string
    sql: ${TABLE}.click_type ;;
    group_label: "Click"
  }

  # click_in_session_index: number
  # Table reference - INT8 ENCODE ZSTD
  # the order of clicks over a session's duration are indexed; that value
  #  is stored in this click_in_session_index. This dimension is used in
  #  measures: max_click_link and average_clicks_per_visit.
  dimension: click_in_session_index {
    description: "The index of this click number in a single session."
    type: number
    # index within each session
    sql: ${TABLE}.click_in_session_index ;;
    group_label: "Click"
    hidden: yes
  }


  # Page
  # This section contains fields that are duplicated across over view files in this project

  dimension: page_url {
    description: "The web page URL."
    type: string
    sql: ${TABLE}.page_url ;;
    group_label: "Page"
  }

  dimension: node_id {
    description: "The CMS Lite node identifier for Gov pages."
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
    description: "The web page domain or host."
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
    description: "The path of the page, after the domain."
    type: string
    sql: ${TABLE}.page_urlpath ;;
    group_label: "Page"
  }

  dimension: page_urlquery {
    description: "The querystring of the URL."
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
    description: "The web page title."
    type: string
    sql: ${TABLE}.page_title ;;
    group_label: "Page"
  }


  dimension: search_field {
    description: "The raw search query parameters"
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
  # This section contains fields that are duplicated across over view files in this project

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
  # This section contains fields that are duplicated across over view files in this project

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
  # This section contains fields that are duplicated across over view files in this project

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
    descrption: "The useragent string for this session."
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
  # This section contains fields that are duplicated across over view files in this project

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

  # Targets
  # This section contains fields that are duplicated across over view files in this project

  dimension: target_url {
    type: string
    sql: ${TABLE}.target_url ;;
    group_label: "Target"
  }

  dimension: target_url_nopar {
    type: string
    #This removes the parameters from the url, anything including the ?
    sql: regexp_replace(${TABLE}.target_url, '\\?.*$') ;;
    group_label: "Target"
  }

  #substring select the host only
  dimension: target_host {
    type: string
    # A range of non / chars, followed by a '.' (subdomain.domain.tdl), followed by range of non / or : characters (strips port)
    # https://stackoverflow.com/questions/17310972/how-to-parse-host-out-of-a-string-in-redshift
    sql:  REGEXP_SUBSTR(${TABLE}.target_url, '[^/]+\\.[^/:]+') ;;
    group_label: "Target"
  }

  #substring select the filename with extension
  dimension: target_file {
    type: string
    sql: REGEXP_SUBSTR(${TABLE}.target_url, '[^/]+$') ;;
    group_label: "Target"
  }

  #substring select the extension only
  dimension: target_extension {
    type: string
    sql:REGEXP_SUBSTR(${TABLE}.target_url, '[^\.]+$') ;;
    group_label: "Target"
  }

  # Device
  # This section contains fields that are duplicated across over view files in this project

  dimension: device_type \{
    description: "A label that describes the viewing device type as Mobile or Computer."
    type: string
    sql: ${TABLE}.dvce_type ;;
    group_label: "Device"
  }


  dimension: device_is_mobile \{
    description: "True if the viewing device is mobile; False otherwise."
    type: yesno
    sql: ${TABLE}.dvce_ismobile ;;
    group_label: "Device"
  }

  # MEASURES

  # duplicate
  measure: row_count {
    description: "A count of all rows in this Explore."
    type: count
    group_label: "Counts"
  }

  # click_count
  # A count of all clicks, regardless of type
  measure: click_count {
    description: "A count of all the clicks in this Explore (link clicks and downloads)."
    type: count_distinct
    sql: ${click_id} ;;
    group_label: "Counts"
  }

  # link_click_count
  # A count of link clicks
  measure: link_click_count {
    description: "A count of only the link clicks in this Explore."
    type: count_distinct
    sql: ${click_id} ;;
    filters: {
      field: click_type
      value: "link_click"
    }
    group_label: "Counts"
  }

  # download_click_count
  # A count of download clicks
  measure: download_click_count {
    description: "A count of only the download clicks in this Explore."
    type: count_distinct
    sql: ${click_id} ;;
    filters: {
      field: click_type
      value: "download"
    }
    group_label: "Counts"
  }

  # max_click_index
  # Table reference - INT8 ENCODE ZSTD
  # a measure returning the max value of click_in_session_index
  measure: max_click_index {
    description: "The highest number of clicks over all sessions in this Explore."
    type: max
    sql: ${click_in_session_index} ;;
  }

  # average_clicks_per_visit
  # Table reference - INT8 ENCODE ZSTD
  # a measure returning the average value of click_in_session_index
  measure: average_clicks_per_visit {
    description: "The average number of clicks over all sessions in this Explore."
    type: average
    sql: ${click_in_session_index} ;;
    group_label: "Engagement"
  }

  # duplicated in other views
  measure: session_count {
    type: count_distinct
    sql: ${session_id} ;;
    group_label: "Counts"
  }

  # duplicated in other views
  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
  }
}
