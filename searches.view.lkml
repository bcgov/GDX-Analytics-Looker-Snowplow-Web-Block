view: searches {
  sql_table_name: derived.searches ;;

  dimension: search_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.search_id ;;
  }

  dimension: app_id {
    type: string
    sql: ${TABLE}.app_id ;;
  }

  dimension: br_family {
    type: string
    sql: ${TABLE}.br_family ;;
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

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
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

  dimension: dcs_id {
    type: string
    sql: ${TABLE}.dcs_id ;;
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

  dimension: doc_height {
    type: number
    sql: ${TABLE}.doc_height ;;
  }

  dimension: doc_width {
    type: number
    sql: ${TABLE}.doc_width ;;
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

  dimension: dvce_type {
    type: string
    sql: ${TABLE}.dvce_type ;;
  }

  dimension: filters {
    type: string
    sql: ${TABLE}.filters ;;
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

  dimension: network_userid {
    type: string
    sql: ${TABLE}.network_userid ;;
  }

  dimension: node_id {
    type: string
    sql: ${TABLE}.node_id ;;
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

  dimension: page_results {
    type: number
    sql: ${TABLE}.page_results ;;
  }

  dimension: page_title {
    type: string
    sql: ${TABLE}.page_title ;;
  }

  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url ;;
  }

  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }

  dimension: page_urlpath {
    type: string
    sql: ${TABLE}.page_urlpath ;;
  }

  dimension: page_urlquery {
    type: string
    sql: ${TABLE}.page_urlquery ;;
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

  dimension: refr_urlhost {
    type: string
    sql: ${TABLE}.refr_urlhost ;;
  }

  dimension: refr_urlpath {
    type: string
    sql: ${TABLE}.refr_urlpath ;;
  }

  dimension: refr_urlquery {
    type: string
    sql: ${TABLE}.refr_urlquery ;;
  }

  dimension: refr_urlscheme {
    type: string
    sql: ${TABLE}.refr_urlscheme ;;
  }

  dimension: search_date {
    type: string
    sql: ${TABLE}.search_date ;;
  }

  dimension: search_in_session_index {
    type: number
    sql: ${TABLE}.search_in_session_index ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: session_index {
    type: number
    sql: ${TABLE}.session_index ;;
  }

  dimension: terms {
    type: string
    sql: ${TABLE}.terms ;;
  }

  dimension: total_results {
    type: number
    sql: ${TABLE}.total_results ;;
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

  measure: count {
    type: count
    drill_fields: [search_id, os_name, br_name, geo_region_name]
  }
}
