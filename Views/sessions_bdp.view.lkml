include: "/Includes/shared_fields_common.view"
include: "/Includes/date_comparisons_common.view"

view: sessions_bdp {
  sql_table_name: derived.sessions_v1 ;;

  extends: [shared_fields_common,date_comparisons_common]

  dimension: device_is_mobile {
    description: "True if the viewing device is mobile; False otherwise."
    type: yesno
    sql: ${TABLE}.operating_system_class = 'Mobile' ;;
    group_label: "Device"
  }

  dimension: device_type {
    description: "A label that describes the viewing device type as Mobile or Computer."
    type: string
    sql: ${TABLE}.operating_system_class ;;
    drill_fields: [browser_family]
    group_label: "Device"
  }

  # NECESSARY for date_comparisons_common
  dimension_group: filter_start {
    sql: ${TABLE}.start_tstamp ;;
  }

  # NECESSARY for access filters
  dimension: node_id { hidden: yes }

  # Modifying extended fields
  dimension: geo_country {
    drill_fields: [first_page_display_url]
  }

  dimension: session_id {
    sql: ${TABLE}.domain_sessionid ;;
  }


  # DIMENSIONS

  # Session Time

  # session_start: time
  # Table reference: TIMESTAMP
  #
  # session_start corresponds to the first value of session_start_time within that session.
  # Explores can reference any timeframe except raw;
  # LookML can reference raw without any formatting or timezone conversions, and all other timeframes can be referenced with conversion.
  #
  # References:
  # * https://github.com/snowplow-proservices/ca.bc.gov-snowplow-pipeline/blob/master/jobs/webmodel/README.md
  dimension_group: session_start {
    description: "The start time of the first page view of a given session."
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.start_tstamp ;;
    #X# group_label:"Session Time"
  }

  dimension_group: session_start_marketing_drill {
    description: "The start time of the first page view of a given session."
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.start_tstamp ;;
    drill_fields: [first_page_display_url, marketing_drills*]
    label: "Session Start"
    group_label: "Session Start Date (Markerting Drill)"
  }

  # session_end: time
  # Table reference: TIMESTAMP
  #
  # session_end corresponds to the last page_view_end_time within that session.
  # Explores can reference any timeframe except raw;
  # LookML can reference raw without any formatting or timezone conversions, and all other timeframes can be referenced with conversion.
  #
  # References:
  # * https://github.com/snowplow-proservices/ca.bc.gov-snowplow-pipeline/blob/master/jobs/webmodel/README.md
  dimension_group: session_end {
    description: "The end time of the last page view of a given session."
    type: time
    timeframes: [raw, time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.end_tstamp ;;
    #X# group_label:"Session Time"
    # hidden: yes
  }

  # Engagement

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

  dimension: engaged_time {
    type: number
    sql: ${TABLE}.engaged_time_in_s ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: engaged_time_tier {
    type: tier
    tiers: [0, 10, 30, 60, 120, 240]
    style: integer
    sql: ${engaged_time} ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: absolute_time {
    type: number
    sql: ${TABLE}.absolute_time_in_s ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: absolute_time_tier {
    type: tier
    tiers: [0, 10, 30, 60, 120, 240]
    style: integer
    sql: ${absolute_time} ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: bounced_session {
    type: yesno
    sql: ${page_views} = 1 ;; #AND ${engaged_time} = 0 ;;
    group_label: "Engagement"
  }
  dimension: bounced_user {
    type: yesno
    sql: ${page_views} = 1 ;; #AND ${engaged_time} = 0 ;;
    group_label: "Engagement"
  }

  #dimension: user_engaged {
  #  type: yesno
  #  sql: ${page_views} > 2 AND ${engaged_time} > 59 ;;
  #  group_label: "Engagement"
  #}

  # First Page

  dimension: first_page_url {
    description: "The URL of the page where a session began."
    type: string
    sql: ${TABLE}.first_page_url ;;
    group_label: "First Page"
  }

  dimension: first_page_urlscheme {
    type: string
    sql: ${TABLE}.first_page_urlscheme ;;
    group_label: "First Page"
    hidden: yes
  }

  dimension: first_page_urlpath {
    description: "The URL path of the page where a session began."
    type: string
    sql: ${TABLE}.first_page_urlpath ;;
    group_label: "First Page"
  }

  dimension: first_page_display_url {
    label: "First Page Display URL"
    # when editing also see clicks.truncated_target_url_nopar_case_insensitive
    description: "Cleaned URL of the page where a session began without query string or standard file names like index.html"
    sql:  ${TABLE}.first_page_urlscheme || '://' || ${TABLE}.first_page_urlhost || regexp_replace(${TABLE}.first_page_urlpath, 'index.(html|htm|aspx|php|cgi|shtml|shtm)$','');;
    group_label: "First Page"
    link: {
      label: "Visit Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: first_page_engagement {
    description: "The identifier for an engagement on engage.gov.bc.ca."
    type: string
    sql: SPLIT_PART(${TABLE}.first_page_urlpath,'/',2) ;;
    group_label: "First Page"
  }

  dimension: first_page_section {
    description: "The identifier for a section of a website. The part of the URL after the domain before the next '/'"
    type: string
    sql: SPLIT_PART(${first_page_urlpath},'/',2) ;;
    group_label: "First Page"
  }
  dimension: first_page_sub_section {
    description: "The identifier for a subsection of a website. The part of the URL between the second and third '/' in the path"
    type: string
    sql: SPLIT_PART(${first_page_urlpath},'/',3) ;;
    group_label: "First Page"
  }
  dimension: first_page_section_exclude {
    description: "An exclusion filter for the identifier for a section of a website used to block sections of a site matching the pattern below. The part of the URL after the domain before the next '/'."
    type: string
    sql: CASE WHEN SPLIT_PART(${TABLE}.first_page_urlpath,'/',2) IN ('empr','agri','mirr','flnrord','env','eao','csnr') THEN '1' ELSE '0' END ;;
    group_label: "First Page"
  }

  dimension: first_page_node_id {
    description: "The identifier of the page where a session began."
    type: string
    sql: ${TABLE}.node_id ;;
    group_label: "First Page"
  }


  dimension: first_page_urlhost {
    description: "The host name of the page where a session began."
    type: string
    sql: ${TABLE}.first_page_urlhost ;;
    suggest_explore: site_cache
    suggest_dimension: site_cache.page_urlhost
    group_label: "First Page"
  }

  dimension: first_page_exclusion_filter {
    description: "The URL when a session began matches the exclusion filter. For example subsites of the NRS intranet."
    type: string
    sql: ${TABLE}.first_page_exclusion_filter ;;
    group_label: "First Page"
  }


  dimension: first_page_urlquery {
    description: "The URL query of the page where a session began."
    type: string
    sql: ${TABLE}.first_page_urlquery ;;
    group_label: "First Page"
  }


  dimension: first_page_title {
    description: "The Title for the page where a session began."
    type: string
    sql: ${TABLE}.first_page_title ;;
    group_label: "First Page"
  }

  dimension: session_length {
    type: number
    sql:  ${TABLE}.absolute_time_in_s ;;
    #sql: DATEDIFF(SECONDS, ${session_start_raw}, ${session_end_raw}) ;;
  }

  dimension: session_index {
    sql: ${TABLE}.domain_sessionidx ;;
  }

  # MEASURES

  measure: average_session_length {
    type: average
    sql: ${session_length} / 86400.0;;
    value_format: "[h]:mm:ss"
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
    #drill_fields: [session_count]
  }

  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
    #drill_fields: [user_count]
  }

  measure: new_user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    filters: {
      field: session_index
      value: "1"
    }
    group_label: "Counts"
    #drill_fields: [new_user_count]
  }

  measure: bounced_user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    filters: {
      field: bounced_user
      value: "yes"
    }
    filters: {
      field: session_index
      value: "1"
    }
    group_label: "Counts"
  }
  measure: bounced_session_count {
    type: count_distinct
    sql: ${session_id} ;;
    filters: {
      field: bounced_session
      value: "yes"
    }
    group_label: "Counts"
  }

#  measure: engaged_user_count {
#    type: count_distinct
#    sql: ${domain_userid} ;;
#    filters: {
#      field: user_engaged
#      value: "yes"
#    }
#    group_label: "Counts"
#  }

  # Engagement

  measure: engaged_time_total {
    type: sum
    sql: ${engaged_time} ;;
    value_format: "#,##0\"s\""
    group_label: "Engagement"
  }

  measure: engaged_time_average {
    type: average
    sql: ${engaged_time} ;;
    value_format: "0.00\"s\""
    group_label: "Engagement"
  }
  measure: absolute_time_total {
    type: sum
    sql: ${absolute_time} ;;
    value_format: "#,##0\"s\""
    group_label: "Engagement"
  }

  measure: absolute_time_average {
    type: average
    sql: ${absolute_time} ;;
    value_format: "0.00\"s\""
    group_label: "Engagement"
  }


  dimension: marketing_ministry {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_team {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_campaign_id {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_sequence {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_cta {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_platform {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_sender_placement {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_lang {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_audience {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_sub_audience {
    drill_fields: [first_page_display_url, marketing_drills*]
  }
  dimension: marketing_ad_type {
    drill_fields: [first_page_display_url, marketing_drills*]
  }

  dimension: primary_impact {
    group_label: "IAB"
  }
  dimension: category {
    group_label: "IAB"
  }
  dimension: reason {
    group_label: "IAB"
  }
  dimension: spider_or_robot {
    group_label: "IAB"
    type: yesno
  }
}
