view: events {
  sql_table_name: atomic.events ;;

  dimension: event_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: app_id {
    type: string
    sql: ${TABLE}.app_id ;;
  }

  dimension: base_currency {
    type: string
    sql: ${TABLE}.base_currency ;;
  }

  dimension: br_colordepth {
    type: string
    sql: ${TABLE}.br_colordepth ;;
  }

  dimension: br_cookies {
    type: yesno
    sql: ${TABLE}.br_cookies ;;
  }

  dimension: br_family {
    type: string
    sql: ${TABLE}.br_family ;;
  }

  dimension: br_features_director {
    type: yesno
    sql: ${TABLE}.br_features_director ;;
  }

  dimension: br_features_flash {
    type: yesno
    sql: ${TABLE}.br_features_flash ;;
  }

  dimension: br_features_gears {
    type: yesno
    sql: ${TABLE}.br_features_gears ;;
  }

  dimension: br_features_java {
    type: yesno
    sql: ${TABLE}.br_features_java ;;
  }

  dimension: br_features_pdf {
    type: yesno
    sql: ${TABLE}.br_features_pdf ;;
  }

  dimension: br_features_quicktime {
    type: yesno
    sql: ${TABLE}.br_features_quicktime ;;
  }

  dimension: br_features_realplayer {
    type: yesno
    sql: ${TABLE}.br_features_realplayer ;;
  }

  dimension: br_features_silverlight {
    type: yesno
    sql: ${TABLE}.br_features_silverlight ;;
  }

  dimension: br_features_windowsmedia {
    type: yesno
    sql: ${TABLE}.br_features_windowsmedia ;;
  }

  dimension: br_lang {
    type: string
    sql: ${TABLE}.br_lang ;;
  }

  dimension: br_name {
    type: string
    sql: ${TABLE}.br_name ;;
  }

  dimension: br_renderengine {
    type: string
    sql: ${TABLE}.br_renderengine ;;
  }

  dimension: br_type {
    type: string
    sql: ${TABLE}.br_type ;;
  }

  dimension: br_version {
    type: string
    sql: ${TABLE}.br_version ;;
  }

  dimension: br_viewheight {
    type: number
    sql: ${TABLE}.br_viewheight ;;
  }

  dimension: br_viewwidth {
    type: number
    sql: ${TABLE}.br_viewwidth ;;
  }

  dimension_group: collector_tstamp {
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
  }

  dimension_group: derived_tstamp {
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
  }

  dimension: doc_charset {
    type: string
    sql: ${TABLE}.doc_charset ;;
  }

  dimension: doc_height {
    type: number
    sql: ${TABLE}.doc_height ;;
  }

  dimension: doc_width {
    type: number
    sql: ${TABLE}.doc_width ;;
  }

  dimension: domain_sessionid {
    type: string
    sql: ${TABLE}.domain_sessionid ;;
  }

  dimension: domain_sessionidx {
    type: number
    sql: ${TABLE}.domain_sessionidx ;;
  }

  dimension: domain_userid {
    type: string
    sql: ${TABLE}.domain_userid ;;
  }

  dimension_group: dvce_created_tstamp {
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
  }

  dimension: dvce_ismobile {
    type: yesno
    sql: ${TABLE}.dvce_ismobile ;;
  }

  dimension: dvce_screenheight {
    type: number
    sql: ${TABLE}.dvce_screenheight ;;
  }

  dimension: dvce_screenwidth {
    type: number
    sql: ${TABLE}.dvce_screenwidth ;;
  }

  dimension_group: dvce_sent_tstamp {
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
  }

  dimension: dvce_type {
    type: string
    sql: ${TABLE}.dvce_type ;;
  }

  dimension: etl_tags {
    type: string
    sql: ${TABLE}.etl_tags ;;
  }

  dimension_group: etl_tstamp {
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
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: event_fingerprint {
    type: string
    sql: ${TABLE}.event_fingerprint ;;
  }

  dimension: event_format {
    type: string
    sql: ${TABLE}.event_format ;;
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: event_vendor {
    type: string
    sql: ${TABLE}.event_vendor ;;
  }

  dimension: event_version {
    type: string
    sql: ${TABLE}.event_version ;;
  }

  dimension: geo_city {
    type: string
    sql: ${TABLE}.geo_city ;;
  }

  dimension: geo_country {
    type: string
    sql: ${TABLE}.geo_country ;;
  }

  dimension: geo_latitude {
    type: number
    sql: ${TABLE}.geo_latitude ;;
  }

  dimension: geo_longitude {
    type: number
    sql: ${TABLE}.geo_longitude ;;
  }

  dimension: geo_region {
    type: string
    sql: ${TABLE}.geo_region ;;
  }

  dimension: geo_region_name {
    type: string
    sql: ${TABLE}.geo_region_name ;;
  }

  dimension: geo_timezone {
    type: string
    sql: ${TABLE}.geo_timezone ;;
  }

  dimension: geo_zipcode {
    type: string
    sql: ${TABLE}.geo_zipcode ;;
  }

  dimension: ip_domain {
    type: string
    sql: ${TABLE}.ip_domain ;;
  }

  dimension: ip_isp {
    type: string
    sql: ${TABLE}.ip_isp ;;
  }

  dimension: ip_netspeed {
    type: string
    sql: ${TABLE}.ip_netspeed ;;
  }

  dimension: ip_organization {
    type: string
    sql: ${TABLE}.ip_organization ;;
  }

  dimension: mkt_campaign {
    type: string
    sql: ${TABLE}.mkt_campaign ;;
  }

  dimension: mkt_clickid {
    type: string
    sql: ${TABLE}.mkt_clickid ;;
  }

  dimension: mkt_content {
    type: string
    sql: ${TABLE}.mkt_content ;;
  }

  dimension: mkt_medium {
    type: string
    sql: ${TABLE}.mkt_medium ;;
  }

  dimension: mkt_network {
    type: string
    sql: ${TABLE}.mkt_network ;;
  }

  dimension: mkt_source {
    type: string
    sql: ${TABLE}.mkt_source ;;
  }

  dimension: mkt_term {
    type: string
    sql: ${TABLE}.mkt_term ;;
  }

  dimension: name_tracker {
    type: string
    sql: ${TABLE}.name_tracker ;;
  }

  dimension: network_userid {
    type: string
    sql: ${TABLE}.network_userid ;;
  }

  dimension: os_family {
    type: string
    sql: ${TABLE}.os_family ;;
  }

  dimension: os_manufacturer {
    type: string
    sql: ${TABLE}.os_manufacturer ;;
  }

  dimension: os_name {
    type: string
    sql: ${TABLE}.os_name ;;
  }

  dimension: os_timezone {
    type: string
    sql: ${TABLE}.os_timezone ;;
  }

  dimension: page_referrer {
    type: string
    sql: ${TABLE}.page_referrer ;;
  }

  dimension: page_title {
    type: string
    sql: ${TABLE}.page_title ;;
  }

  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url ;;
  }

  dimension: page_urlfragment {
    type: string
    sql: ${TABLE}.page_urlfragment ;;
  }

  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }

  dimension: page_urlpath {
    type: string
    sql: ${TABLE}.page_urlpath ;;
  }

  dimension: page_urlport {
    type: number
    sql: ${TABLE}.page_urlport ;;
  }

  dimension: page_urlquery {
    type: string
    sql: ${TABLE}.page_urlquery ;;
  }

  dimension: page_urlscheme {
    type: string
    sql: ${TABLE}.page_urlscheme ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: pp_xoffset_max {
    type: number
    sql: ${TABLE}.pp_xoffset_max ;;
  }

  dimension: pp_xoffset_min {
    type: number
    sql: ${TABLE}.pp_xoffset_min ;;
  }

  dimension: pp_yoffset_max {
    type: number
    sql: ${TABLE}.pp_yoffset_max ;;
  }

  dimension: pp_yoffset_min {
    type: number
    sql: ${TABLE}.pp_yoffset_min ;;
  }

  dimension: refr_domain_userid {
    type: string
    sql: ${TABLE}.refr_domain_userid ;;
  }

  dimension_group: refr_dvce_tstamp {
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
  }

  dimension: refr_medium {
    type: string
    sql: ${TABLE}.refr_medium ;;
  }

  dimension: refr_source {
    type: string
    sql: ${TABLE}.refr_source ;;
  }

  dimension: refr_term {
    type: string
    sql: ${TABLE}.refr_term ;;
  }

  dimension: refr_urlfragment {
    type: string
    sql: ${TABLE}.refr_urlfragment ;;
  }

  dimension: refr_urlhost {
    type: string
    sql: ${TABLE}.refr_urlhost ;;
  }

  dimension: refr_urlpath {
    type: string
    sql: ${TABLE}.refr_urlpath ;;
  }

  dimension: refr_urlport {
    type: number
    sql: ${TABLE}.refr_urlport ;;
  }

  dimension: refr_urlquery {
    type: string
    sql: ${TABLE}.refr_urlquery ;;
  }

  dimension: refr_urlscheme {
    type: string
    sql: ${TABLE}.refr_urlscheme ;;
  }

  dimension: se_action {
    type: string
    sql: ${TABLE}.se_action ;;
  }

  dimension: se_category {
    type: string
    sql: ${TABLE}.se_category ;;
  }

  dimension: se_label {
    type: string
    sql: ${TABLE}.se_label ;;
  }

  dimension: se_property {
    type: string
    sql: ${TABLE}.se_property ;;
  }

  dimension: se_value {
    type: number
    sql: ${TABLE}.se_value ;;
  }

  dimension: ti_category {
    type: string
    sql: ${TABLE}.ti_category ;;
  }

  dimension: ti_currency {
    type: string
    sql: ${TABLE}.ti_currency ;;
  }

  dimension: ti_name {
    type: string
    sql: ${TABLE}.ti_name ;;
  }

  dimension: ti_orderid {
    type: string
    sql: ${TABLE}.ti_orderid ;;
  }

  dimension: ti_price {
    type: number
    sql: ${TABLE}.ti_price ;;
  }

  dimension: ti_price_base {
    type: number
    sql: ${TABLE}.ti_price_base ;;
  }

  dimension: ti_quantity {
    type: number
    sql: ${TABLE}.ti_quantity ;;
  }

  dimension: ti_sku {
    type: string
    sql: ${TABLE}.ti_sku ;;
  }

  dimension: tr_affiliation {
    type: string
    sql: ${TABLE}.tr_affiliation ;;
  }

  dimension: tr_city {
    type: string
    sql: ${TABLE}.tr_city ;;
  }

  dimension: tr_country {
    type: string
    sql: ${TABLE}.tr_country ;;
  }

  dimension: tr_currency {
    type: string
    sql: ${TABLE}.tr_currency ;;
  }

  dimension: tr_orderid {
    type: string
    sql: ${TABLE}.tr_orderid ;;
  }

  dimension: tr_shipping {
    type: number
    sql: ${TABLE}.tr_shipping ;;
  }

  dimension: tr_shipping_base {
    type: number
    sql: ${TABLE}.tr_shipping_base ;;
  }

  dimension: tr_state {
    type: string
    sql: ${TABLE}.tr_state ;;
  }

  dimension: tr_tax {
    type: number
    sql: ${TABLE}.tr_tax ;;
  }

  dimension: tr_tax_base {
    type: number
    sql: ${TABLE}.tr_tax_base ;;
  }

  dimension: tr_total {
    type: number
    sql: ${TABLE}.tr_total ;;
  }

  dimension: tr_total_base {
    type: number
    sql: ${TABLE}.tr_total_base ;;
  }

  dimension_group: true_tstamp {
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
  }

  dimension: txn_id {
    type: number
    sql: ${TABLE}.txn_id ;;
  }

  dimension: user_fingerprint {
    type: string
    sql: ${TABLE}.user_fingerprint ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_ipaddress {
    type: string
    sql: ${TABLE}.user_ipaddress ;;
  }

  dimension: useragent {
    type: string
    sql: ${TABLE}.useragent ;;
  }

  dimension: v_collector {
    type: string
    sql: ${TABLE}.v_collector ;;
  }

  dimension: v_etl {
    type: string
    sql: ${TABLE}.v_etl ;;
  }

  dimension: v_tracker {
    type: string
    sql: ${TABLE}.v_tracker ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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
