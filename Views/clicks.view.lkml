# Details on the derived.clicks table is in the Snowplow Web Model documentation:
# https://github.com/snowplow-proservices/ca.bc.gov-snowplow-pipeline/blob/master/jobs/webmodel/README.md#4-clicks

include: "/Includes/shared_fields_common.view"
include: "/Includes/shared_fields_no_session.view"
include: "/Includes/date_comparisons_common.view"

view: clicks {
  sql_table_name: derived.clicks ;;

  extends: [shared_fields_common,shared_fields_no_session,date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.collector_tstamp ;;
  }



  dimension: p_key {
    description: "The primary key, which is one of: User ID, Domain User ID, Session ID, or Click ID."
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${click_id} ;;
  }

  # Modifying extended fields
  dimension: geo_country { drill_fields: [page_display_url] }

  # DIMENSIONS

  # Click

  # click_time: time
  # Table reference - TIMESTAMP ENCODE ZSTD
  # returns the timestamp at any of the dimensions identified in the timeframes list
  dimension_group: click_time {
    description: "The timestamp for the page view as recorded by the collector."
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
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
    suggestions: ["download","link_click"]
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

  # slider_clicks
  #
  # Compares the element class to 'pull-left', which is the element class attribute on links in the slider.
  dimension: slider_clicks {
    description: "Yes if the click came from the main Government slider."
    type: yesno
    sql: ${TABLE}.element_classes LIKE '%pull-left%' ;;
    group_label: "Click"
  }


  # Targets
  # This section contains fields that are duplicated across over view files in this project

  dimension: target_url {
    type: string
    sql: ${TABLE}.target_url ;;
    group_label: "Target"
    link: {
      label: "Visit Link"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: target_url_fragment {
    type: string
    sql: SPLIT_PART(${TABLE}.target_url,'#',2) ;;
    group_label: "Target"
  }

  dimension: target_url_case_insensitive {
    type: string
    sql: LOWER(${TABLE}.target_url) ;;
    group_label: "Target"
    link: {
      label: "Visit Link"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: target_url_nopar {
    type: string
    #This removes the parameters from the url, anything including the ?
    sql: regexp_replace(${TABLE}.target_url, '\\?.*$') ;;
    group_label: "Target"
    link: {
      label: "Visit Link"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: target_url_nopar_case_insensitive {
    type: string
    sql: LOWER(regexp_replace(${TABLE}.target_url, '\\?.*$')) ;;
    group_label: "Target"
    link: {
      label: "Visit Link"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: truncated_target_url_nopar_case_insensitive {
    type: string
    #when editing, also see shared_fields_common.page_display_url
    sql: regexp_replace(regexp_replace(regexp_replace(${target_url_nopar_case_insensitive},'/((index|default)\\.(htm|html|cgi|shtml|shtm))|(default\\.(asp|aspx))/{0,}$','/'),'//$','/'),'%20',' ') ;;
    group_label: "Target"
    link: {
      label: "Visit Link"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  #substring select the host only
  dimension: target_urlhost {
    type: string
    # A range of non / chars, followed by a '.' (subdomain.domain.tdl), followed by range of non / or : characters (strips port)
    # https://stackoverflow.com/questions/17310972/how-to-parse-host-out-of-a-string-in-redshift
    sql:  ${TABLE}.target_urlhost ;;
    group_label: "Target"
    link: {
      label: "Visit Link"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: target_display_url {
    label: "Target Display URL"
    # when editing also see clicks.truncated_target_url_nopar_case_insensitive
    description: "Cleaned URL of the page without query string or standard file names like index.html"
    sql: ${TABLE}.target_display_url;;
    group_label: "Target"
    drill_fields: [page_display_url]
    link: {
      label: "Visit Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }


  dimension: tibc_target_display_url {
    label: "TIBC Target Display URL"
    # when editing also see clicks.truncated_target_url_nopar_case_insensitive
    description: "Cleaned URL of the page without query string or standard file names like index.html"
    sql: ${TABLE}.target_display_url;;
    group_label: "TIBC"
    link: {
      label: "Visit Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }


  dimension: target_urlscheme {
    type:  string
    sql: ${TABLE}.target_urlscheme ;;
    label: "Target"
    hidden: yes
  }

  dimension: target_urlpath {
    type: string
    sql: ${TABLE}.target_urlpath ;;
    group_label: "Target"
  }

  dimension: target_urlquery {
    type: string
    sql: ${TABLE}.target_urlquery ;;
    group_label: "Target"
  }

  #substring select the filename with extension
  dimension: target_file {
    type: string
    sql: REGEXP_SUBSTR(REGEXP_REPLACE(SPLIT_PART(SPLIT_PART(SPLIT_PART(${target_url}, ${target_urlhost} , 2),'?', 1),'#', 1),'(.aspx)$'),'([^\/]+\.[A-Za-z0-9]+)$') ;;
    group_label: "Target"
  }

  #substring select the extension only
  dimension: target_extension {
    type: string
    sql:CASE
        WHEN SPLIT_PART(REGEXP_REPLACE(SPLIT_PART(SPLIT_PART(${TABLE}.target_url, '?', 1), '#', 1), '(.aspx)$'), ${target_urlhost}, 2) LIKE '%.%'
        THEN REGEXP_SUBSTR(SPLIT_PART(REGEXP_REPLACE(SPLIT_PART(SPLIT_PART(${TABLE}.target_url, '?', 1), '#', 1), '(.aspx)$'), ${target_urlhost}, 2), '([^\.]+$)')
        ELSE NULL
      END ;;
    group_label: "Target"
  }

  ### Click Target Marketing

  set: marketing_drills {
    fields: [marketing_source, marketing_campaign, marketing_ministry,marketing_team,marketing_campaign_id,marketing_sequence,marketing_cta,marketing_platform,marketing_sender_placement,marketing_lang,marketing_audience,marketing_sub_audience,marketing_ad_type]
  }

  dimension: click_mkt_campaign {
    type: string
    sql:
      CASE
        WHEN POSITION('utm_campaign' in ${target_urlquery}) > 0 THEN SPLIT_PART(SPLIT_PART(SPLIT_PART(${target_urlquery}, 'utm_campaign=', 2), '&', 1), '#', 1)
        ELSE NULL END ;;
    group_label: "Target Marketing"
  }

  dimension: marketing_date {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',1) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_ministry {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',2) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_team {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',3) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_campaign_id {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',4) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]

  }

  dimension: marketing_sequence {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',5) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_cta {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',6) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_platform {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',7) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_sender_placement {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',8) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_lang {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',9) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_audience {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',10) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_sub_audience {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',11) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }

  dimension: marketing_ad_type {
    type: string
    sql: SPLIT_PART(${click_mkt_campaign},'_',12) ;;
    group_label: "Target Marketing"
    drill_fields: [marketing_drills*]
  }


  #was the click to a different domain name (url host)
  dimension: offsite_click {
    type:  yesno
    sql: ${TABLE}.offsite_click ;;
    group_label: "Target"
  }

#was the click to a different domain name (url host)
  dimension: offsite_click_binary {
    type:  string
    sql: ${TABLE}.offsite_click ;;
    description: "A binary representation of offsite_click for use with Aggregate Aware Tables."
    group_label: "Target"
  }

# Custom dimension for TIBC reporting
  dimension: tibc_click_conversion{
    type: string
    sql: CASE WHEN ${target_urlscheme} = 'mailto' THEN 'Email Link'
              WHEN ${TABLE}.target_urlhost NOT IN ('www.british-columbia.cn', 'www.britishcolumbia.ca', 'www.britishcolumbia.jp', 'www.britishcolumbia.kr', 'app.britishcolumbia.ca') THEN 'External Link'
              WHEN ${target_extension} = 'pdf' THEN 'PDF Downloads'
              WHEN ${target_extension} = 'jpg' THEN 'JPG Downloads'
              WHEN ${target_extension} = 'png' THEN 'PNG Downloads'
        ELSE NULL END ;;
    description: "Custom dimension to report on TIBC click conversions."
    group_label: "TIBC"
  }

  dimension: element_classes {
    type:  string
    sql: ${TABLE}.element_classes ;;
    group_label: "Element"
  }
  dimension: element_id {
    type:  string
    sql: ${TABLE}.element_id ;;
    group_label: "Element"
  }
  dimension: element_target {
    type:  string
    sql: ${TABLE}.element_target ;;
    group_label: "Element"
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
