# Details on the derived.clicks table is in the Snowplow Web Model documentation:
# https://github.com/snowplow-proservices/ca.bc.gov-snowplow-pipeline/blob/master/jobs/webmodel/README.md#4-clicks

include: "shared_fields_common.view.lkml"

view: clicks {
  sql_table_name: derived.clicks ;;

  extends: [shared_fields_common]

  dimension: p_key {
    description: "The primary key, which is one of: User ID, Domain User ID, Session ID, or Click ID."
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${click_id} ;;
  }

  # DIMENSIONS

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
