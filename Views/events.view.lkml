# Refer to the Snowplow wiki Canonical Event Model for details:
# https://github.com/snowplow/snowplow/wiki/canonical-event-model

view: events {
  sql_table_name: atomic.events ;;

  # Common fields (platform and event independent)
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#common

  ## Application fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#application

  dimension: app_id {
    description: "The application identifier from which the event originated."
    type: string
    sql: ${TABLE}.app_id ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
    description: "The platform from which the event originated."
  }

  ## Date / Time fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#date-time

  dimension_group: collector_tstamp {
    group_label: "Date/Time Fields"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.collector_tstamp ;;
    description: "The timestamp for the event that was recorded by the collector."
  }

  dimension_group: dvce_created_tstamp {
    group_label: "Date/Time Fields"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.dvce_created_tstamp ;;
    description: "The timestamp for the event that was recorded on the client device."
  }

  dimension_group: dvce_sent_tstamp {
    group_label: "Date/Time Fields"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.dvce_sent_tstamp ;;
    description: "The timestamp for when the event was sent by the client device."
  }

  dimension_group: etl_tstamp {
    group_label: "Date/Time Fields"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.etl_tstamp ;;
    description: "The timestamp for when the event began Extract-Transform-Load."
  }

  dimension: os_timezone {
    group_label: "Date/Time Fields"
    type: string
    sql: ${TABLE}.os_timezone ;;
    description: "The client operating system timezone."
  }

  dimension_group: derived_tstamp {
    group_label: "Date/Time Fields"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.derived_tstamp ;;
    description: "The timestamp, making an allowance for innaccurate device clock"
  }

  dimension_group: true_tstamp {
    group_label: "Date/Time Fields"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.true_tstamp ;;
    description: "The user-set \"true timestamp\" for the event"
  }

  ## Event / transaction fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#eventtransaction

  dimension: event {
    group_label: "Transaction fields"
    type: string
    sql: ${TABLE}.event ;;
    description: "The type of event recorded."
  }

  dimension: event_id {
    group_label: "Transaction fields"
    primary_key: yes
    type: string
    sql: ${TABLE}.event_id ;;
    description: "A universally unqiue identifier for each event"
  }

  dimension: txn_id {
    group_label: "Transaction fields"
    type: number
    sql: ${TABLE}.txn_id ;;
    description: "The transaction identiifier set client-side, used to de-dupe records."
  }

  dimension: event_fingerprint {
    group_label: "Transaction fields"
    type: string
    sql: ${TABLE}.event_fingerprint ;;
    description: "A hash of the client-set event fields."
  }

  ## Snowplow version fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#version

  dimension: v_tracker {
    group_label: "Snowplow version fields"
    type: string
    sql: ${TABLE}.v_tracker ;;
    description: "The tracker version."
  }

  dimension: v_collector {
    group_label: "Snowplow version fields"
    type: string
    sql: ${TABLE}.v_collector ;;
    description: "The collector version."
  }

  dimension: v_etl {
    group_label: "Snowplow version fields"
    type: string
    sql: ${TABLE}.v_etl ;;
    description: "The Extract-Transform-Load version."
  }

  dimension: name_tracker {
    group_label: "Snowplow version fields"
    type: string
    sql: ${TABLE}.name_tracker ;;
    description: "The tracker namespace."
  }

  dimension: etl_tags {
    group_label: "Snowplow version fields"
    type: string
    sql: ${TABLE}.etl_tags ;;
    description: "The tags for this ETL run, described in JSON."
  }

  ## User-related fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#user

  dimension: user_id {
    group_label: "User-related fields"
    type: string
    sql: ${TABLE}.user_id ;;
    description: "A unique identifier set by the business."
  }

  dimension: domain_userid {
    group_label: "User-related fields"
    type: string
    sql: ${TABLE}.domain_userid ;;
    description: "The user identifier set by Snowplow using a first party cookie."
  }

  dimension: network_userid {
    group_label: "User-related fields"
    type: string
    sql: ${TABLE}.network_userid ;;
    description: "The user identifier set by Snowplow using a third party cookie."
  }

  dimension: user_ipaddress {
    group_label: "User-related fields"
    type: string
    sql: ${TABLE}.user_ipaddress ;;
    description: "The user's IP address."
  }

  dimension: domain_sessionidx {
    group_label: "User-related fields"
    type: number
    sql: ${TABLE}.domain_sessionidx ;;
    description: "A session index."
  }

  dimension: domain_sessionid {
    group_label: "User-related fields"
    type: string
    sql: ${TABLE}.domain_sessionid ;;
    description: "A session identifier."
  }

  ## Device and operating system fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#device

  dimension: useragent {
    description: "The useragent string of the current session."
    group_label: "Device and OS fields"
    type: string
    sql: ${TABLE}.useragent ;;
  }

  dimension: dvce_type {
    group_label: "Device and OS fields"
    type: string
    sql: ${TABLE}.dvce_type ;;
    description: "The type of device."
  }

  dimension: dvce_ismobile {
    group_label: "Device and OS fields"
    type: yesno
    sql: ${TABLE}.dvce_ismobile ;;
    description: "Whether the device is mobile."
  }

  dimension: dvce_screenheight {
    group_label: "Device and OS fields"
    type: number
    sql: ${TABLE}.dvce_screenheight ;;
    description: "The screen height in pixels."
  }

  dimension: dvce_screenwidth {
    group_label: "Device and OS fields"
    type: number
    sql: ${TABLE}.dvce_screenwidth ;;
    description: "The screen width in pixels."
  }

  dimension: os_name {
    group_label: "Device and OS fields"
    type: string
    sql: ${TABLE}.os_name ;;
    description: "The name of the operating system."
  }

  dimension: os_family {
    group_label: "Device and OS fields"
    type: string
    sql: ${TABLE}.os_family ;;
    description: "The operating system family."
  }

  dimension: os_manufacturer {
    group_label: "Device and OS fields"
    type: string
    sql: ${TABLE}.os_manufacturer ;;
    description: "The organization responsible for the operating system."
  }

  ## Location fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#location

  dimension: geo_country {
    group_label: "Location fields"
    type: string
    sql: ${TABLE}.geo_country ;;
    description: "The visitor's country code (In ISO 3166-1 format)."
  }

  dimension: geo_region {
    group_label: "Location fields"
    type: string
    sql: ${TABLE}.geo_region ;;
    description: "The visitor's country region code (In ISO 3166-2 format)."
  }

  dimension: geo_city {
    group_label: "Location fields"
    type: string
    sql: ${TABLE}.geo_city ;;
    description: "The visitor's city."
  }

  dimension: geo_zipcode {
    group_label: "Location fields"
    type: string
    sql: ${TABLE}.geo_zipcode ;;
    description: "The visitor's postal code."
  }

  dimension: geo_latitude {
    group_label: "Location fields"
    type: number
    sql: ${TABLE}.geo_latitude ;;
    description: "The visitor's location latitude."
  }

  dimension: geo_longitude {
    group_label: "Location fields"
    type: number
    sql: ${TABLE}.geo_longitude ;;
    description: "The visitor's location longitude."
  }

  dimension: geo_region_name {
    group_label: "Location fields"
    type: string
    sql: ${TABLE}.geo_region_name ;;
    description: "The visitior's region name."
  }

  dimension: geo_timezone {
    group_label: "Location fields"
    type: string
    sql: ${TABLE}.geo_timezone ;;
    description: "The visitor's timezone name."
  }

  ## IP address-based fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#ip

  dimension: ip_isp {
    group_label: "IP address-based fields"
    type: string
    sql: ${TABLE}.ip_isp ;;
    description: "The visitor's Internet Service Provider (ISP) name."
  }

  dimension: ip_organization {
    group_label: "IP address-based fields"
    type: string
    sql: ${TABLE}.ip_organization ;;
    description: "The name of the organization associated with the visitor's IP address (defaults to the ISP name if no associated organization is found)."
  }

  dimension: ip_domain {
    group_label: "IP address-based fields"
    type: string
    sql: ${TABLE}.ip_domain ;;
    description: "The second level domain name associated with the visitor's IP address."
  }

  dimension: ip_netspeed {
    group_label: "IP address-based fields"
    type: string
    sql: ${TABLE}.ip_netspeed ;;
    description: "The visitor's connection type."
  }

  ## Metadata fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#metadata

  dimension: event_vendor {
    group_label: "Event metadata fields"
    type: string
    sql: ${TABLE}.event_vendor ;;
    description: "The name of who defined the event."
  }

  dimension: event_name {
    group_label: "Event metadata fields"
    type: string
    sql: ${TABLE}.event_name ;;
    description: "The name of the event type."
  }

  dimension: event_format {
    group_label: "Event metadata fields"
    type: string
    sql: ${TABLE}.event_format ;;
    description: "The format of the event."
  }

  dimension: event_version {
    group_label: "Event metadata fields"
    type: string
    sql: ${TABLE}.event_version ;;
    description: "The version of the event's schema."
  }

  # Platform-specific fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#platform

  ## Web-specific fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#web

  dimension: page_url {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.page_url ;;
    description: "The web page URL."
  }

  dimension: page_urlscheme {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.page_urlscheme ;;
    description: "The web page protocol or schema."
  }

  dimension: page_urlhost {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.page_urlhost ;;
    description: "The web page domain or host."
  }

  dimension: page_urlport {
    group_label: "Web-specific fields"
    type: number
    sql: ${TABLE}.page_urlport ;;
    description: "The web page port (defaults to 80 if unspecified)."
  }

  dimension: page_urlpath {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.page_urlpath ;;
    description: "The path of the page, after the domain."
  }

  dimension: page_urlquery {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.page_urlquery ;;
    description: "The querystring of the URL."
  }

  dimension: page_urlfragment {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.page_urlfragment ;;
    description: "The anchor (or \"fragment\") of the URL"
  }

  dimension: page_referrer {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.page_referrer ;;
    description: "The URL of the referring web page."
  }

  dimension: page_title {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.page_title ;;
    description: "The web page title."
  }

  dimension: refr_urlscheme {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_urlscheme ;;
    description: "The referrer web page protocol or schema."
  }

  dimension: refr_urlhost {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_urlhost ;;
    description: "The web page domain or host."
  }

  dimension: refr_urlport {
    group_label: "Web-specific fields"
    type: number
    sql: ${TABLE}.refr_urlport ;;
    description: "The referrer web page port (defaults to 80 if unspecified)."
  }

  dimension: refr_urlpath {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_urlpath ;;
    description: "The path of the referrer page, after its domain."
  }

  dimension: refr_urlquery {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_urlquery ;;
    description: "The querystring of the referring page's URL."
  }

  dimension: refr_urlfragment {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_urlfragment ;;
    description: "The anchor (or \"fragment\") of the referring page's URL."
  }

  dimension: refr_medium {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_medium ;;
    description: "The type of referrer."
  }

  dimension: refr_source {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_source ;;
    description: "The name of referrer, if recognised."
  }

  dimension: refr_term {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_term ;;
    description: "The referring keywords, if the referrer source is a search engine."
  }

  dimension: refr_domain_userid {
    group_label: "Web-specific fields"
    type: string
    sql: ${TABLE}.refr_domain_userid ;;
    description: "The Snowplow domain_userid of the referring website."
  }

  dimension_group: refr_dvce_tstamp {
    group_label: "Web-specific fields"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.refr_dvce_tstamp ;;
    description: "The timestamp when the domain_userid was attached to the inbound link."
  }

  ### Document fields

  dimension: doc_charset {
    group_label: "Document fields"
    type: string
    sql: ${TABLE}.doc_charset ;;
    description: "The page’s character encoding."
  }

  dimension: doc_width {
    group_label: "Document fields"
    type: number
    sql: ${TABLE}.doc_width ;;
    description: "The page's width in pixels."
  }

  dimension: doc_height {
    group_label: "Document fields"
    type: number
    sql: ${TABLE}.doc_height ;;
    description: "The page's height in pixels."
  }

  ### Marketing / traffic source fields

  dimension: mkt_medium {
    group_label: "Traffic source fields"
    type: string
    sql: ${TABLE}.mkt_medium ;;
    description: "The type of traffic source."
  }

  dimension: mkt_source {
    group_label: "Traffic source fields"
    type: string
    sql: ${TABLE}.mkt_source ;;
    description: "The company or website where this visit came from."
  }

  dimension: mkt_term {
    group_label: "Traffic source fields"
    type: string
    sql: ${TABLE}.mkt_term ;;
    description: "Any keywords that are associated with the referrer."
  }

  dimension: mkt_content {
    group_label: "Traffic source fields"
    type: string
    sql: ${TABLE}.mkt_content ;;
    description: "The advertising identifier."
  }

  dimension: mkt_campaign {
    group_label: "Traffic source fields"
    type: string
    sql: ${TABLE}.mkt_campaign ;;
    description: "The campaign identifier."
  }

  dimension: mkt_clickid {
    group_label: "Traffic source fields"
    type: string
    sql: ${TABLE}.mkt_clickid ;;
    description: "The click identifier."
  }

  dimension: mkt_network {
    group_label: "Traffic source fields"
    type: string
    sql: ${TABLE}.mkt_network ;;
    description: "The advertising network to which the click ID belongs."
  }

  ### Browser fields

  dimension: user_fingerprint {
    group_label: "Browser fields"
    type: string
    sql: ${TABLE}.user_fingerprint ;;
    description: "A user fingerprint generated by looking at the individual browser features."
  }

  dimension: br_name {
    group_label: "Browser fields"
    type: string
    sql: ${TABLE}.br_name ;;
    description: "The browser name."
  }

  dimension: br_version {
    group_label: "Browser fields"
    type: string
    sql: ${TABLE}.br_version ;;
    description: "The browser version."
  }

  dimension: br_family {
    group_label: "Browser fields"
    type: string
    sql: ${TABLE}.br_family ;;
    description: "The browser family."
  }

  dimension: br_type {
    group_label: "Browser fields"
    type: string
    sql: ${TABLE}.br_type ;;
    description: "The browser type."
  }

  dimension: br_renderengine {
    group_label: "Browser fields"
    type: string
    sql: ${TABLE}.br_renderengine ;;
    description: "The browser rendering engine."
  }

  dimension: br_lang {
    group_label: "Browser fields"
    type: string
    sql: ${TABLE}.br_lang ;;
    description: "The language the browser is set to."
  }

  dimension: br_features_pdf {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_pdf ;;
    description: "Whether the browser recognizes PDFs."
  }

  dimension: br_features_flash {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_flash ;;
    description: "Whether Flash is installed."
  }

  dimension: br_features_java {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_java ;;
    description: "Whether Java is installed."
  }

  dimension: br_features_director {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_director ;;
    description: "Whether Adobe Shockwave is installed."
  }

  dimension: br_features_quicktime {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_quicktime ;;
    description: "Whether QuickTime is installed."
  }

  dimension: br_features_realplayer {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_realplayer ;;
    description: "Whether RealPlayer is installed."
  }

  dimension: br_features_windowsmedia {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_windowsmedia ;;
    description: "Whether mplayer2 is installed."
  }

  dimension: br_features_gears {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_gears ;;
    description: "Whether Google Gears is installed."
  }

  dimension: br_features_silverlight {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_features_silverlight ;;
    description: "Whether Microsoft Silverlight is installed."
  }

  dimension: br_cookies {
    group_label: "Browser fields"
    type: yesno
    sql: ${TABLE}.br_cookies ;;
    description: "Whether cookies are enabled."
  }

  dimension: br_colordepth {
    group_label: "Browser fields"
    type: string
    sql: ${TABLE}.br_colordepth ;;
    description: "The bit depth of the browser color palette."
  }

  dimension: br_viewheight {
    group_label: "Browser fields"
    type: number
    sql: ${TABLE}.br_viewheight ;;
    description: "The browser viewport height."
  }

  dimension: br_viewwidth {
    group_label: "Browser fields"
    type: number
    sql: ${TABLE}.br_viewwidth ;;
    description: "The browser viewport width."
  }


  # Event-specific fields
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#event

  ## Page views
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#231-page-views
  # All the fields that are required are part of the standard fields available for any web-based event e.g. page_urlscheme, page_title.

  ## Page pings
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#232-page-pings

  dimension: pp_xoffset_min {
    group_label: "Activity tracking fields"
    type: number
    sql: ${TABLE}.pp_xoffset_min ;;
    description: "The minimum page X-axis offset seen in the last activity tracked page ping period."
  }

  dimension: pp_xoffset_max {
    group_label: "Activity tracking fields"
    type: number
    sql: ${TABLE}.pp_xoffset_max ;;
    description: "The maximum page X-axis offset seen in the last activity tracked page ping period."
  }

  dimension: pp_yoffset_min {
    group_label: "Activity tracking fields"
    type: number
    sql: ${TABLE}.pp_yoffset_min ;;
    description: "The minimum page Y-axis offset seen in the last activity tracked page ping period."
  }

  dimension: pp_yoffset_max {
    group_label: "Activity tracking fields"
    type: number
    sql: ${TABLE}.pp_yoffset_max ;;
    description: "The maximum page Y-axis offset seen in the last activity tracked page ping period."
  }

  ## Ecommerce transactions
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#233-ecommerce-transactions

  dimension: tr_orderid {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.tr_orderid ;;
    description: "The order identifier of an Ecommerce event."
  }

  dimension: tr_affiliation {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.tr_affiliation ;;
    description: "The transaction affiliation (such as the online retailer name) of an Ecommerce related"
  }

  dimension: tr_total {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.tr_total ;;
    description: "The total transaction value of an Ecommerce event."
  }

  dimension: tr_tax {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.tr_tax ;;
    description: "The total tax included in the transaction value of an Ecommerce event."
  }

  dimension: tr_shipping {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.tr_shipping ;;
    description: "The delivery cost charged on an Ecommerce event."
  }

  dimension: tr_tax_base {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.tr_tax_base ;;
    description: "The total tax, in the base currency, of an Ecommerce event."
  }

  dimension: tr_total_base {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.tr_total_base ;;
    description: "The total, in the base currency, of an Ecommerce event."
  }

  dimension: tr_shipping_base {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.tr_shipping_base ;;
    description: "The delivery cost charged, in the base currency, in an Ecommerce event."
  }

  dimension: tr_city {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.tr_city ;;
    description: "The city in the delivery address, for an Ecommerce event."
  }

  dimension: tr_state {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.tr_state ;;
    description: "The state/province in the delivery address, for an Ecommerce event."
  }

  dimension: tr_country {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.tr_country ;;
    description: "The country in the delivery address, for an Ecommerce event."
  }

  dimension: tr_currency {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.tr_currency ;;
    description: "An Ecommerce event's currency."
  }

  dimension: ti_orderid {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.ti_orderid ;;
    description: "An Ecommerce event's order identifier."
  }

  dimension: ti_sku {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.ti_sku ;;
    description: "An Ecommerce event's product SKU."
  }

  dimension: ti_name {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.ti_name ;;
    description: "The product name for an Ecommerce event."
  }

  dimension: ti_category {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.ti_category ;;
    description: "The product category for an Ecommerce event."
  }

  dimension: ti_price {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.ti_price ;;
    description: "The product unit price of an Ecommerce event."
  }

  dimension: ti_price_base {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.ti_price_base ;;
    description: "The price, in the base currency, of an Ecommerce event."
  }

  dimension: ti_quantity {
    group_label: "Ecommerce fields"
    type: number
    sql: ${TABLE}.ti_quantity ;;
    description: "The number of product in an Ecommerce event."
  }

  dimension: ti_currency {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.ti_currency ;;
    description: "The currency of an Ecommerce event."
  }

  dimension: base_currency {
    group_label: "Ecommerce fields"
    type: string
    sql: ${TABLE}.base_currency ;;
    description: "The reporting currency of an Ecommerce event."
  }

  ## Error tracking
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#234-error-tracking

  ## Custom structured events
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#235-custom-structured-events

  dimension: se_category {
    group_label: "Custom event fields"
    type: string
    sql: ${TABLE}.se_category ;;
    description: "The category of a custom structured event."
  }

  dimension: se_action {
    group_label: "Custom event fields"
    type: string
    sql: ${TABLE}.se_action ;;
    description: "The action performed or event name for a custom structured event."
  }

  dimension: se_label {
    group_label: "Custom event fields"
    type: string
    sql: ${TABLE}.se_label ;;
    description: "An identifier of the object which is the action, as tracked by a custom structured event."
  }

  dimension: se_property {
    group_label: "Custom event fields"
    type: string
    sql: ${TABLE}.se_property ;;
    description: "A property associated with the object of the action, as tracked by a custom structured event."
  }

  dimension: se_value {
    group_label: "Custom event fields"
    type: number
    sql: ${TABLE}.se_value ;;
    description: "A value associated with the event or action, as tracked by a custom structured event."
  }

  ## Custom unstructured events
  # https://github.com/snowplow/snowplow/wiki/canonical-event-model#236-custom-unstructured-events

  ###
  # Looker contributed fields

  measure: count {
    type: count
    drill_fields: [detail*]
    description: "A count of the queried table, with drill fields on Event ID, Geo Region Name, Product Name, Browser Name, Operating System Name, and the Event Name."
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      event_id,
      geo_region_name,
      ti_name,
      br_name,
      os_name,
      event_name
    ]
  }
}
