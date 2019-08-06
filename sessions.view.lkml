include: "shared_fields_common.view"
include: "date_comparisons_common.view"

view: sessions {
  sql_table_name: derived.sessions ;;

  extends: [date_comparisons_common,shared_fields_common]

  # NECESSARY for date_comparisons_common
  dimension_group: filter_start {
    sql: ${TABLE}.session_start ;;
  }

  # Modifying extended fields
  dimension: browser_view_height { hidden: yes }
  dimension: browser_view_width { hidden: yes }
  dimension: os_version { hidden: yes }
  dimension: node_id { hidden: yes }
  dimension: p_key { hidden: yes }
  dimension: page_height { hidden: yes }
  dimension: page_title { hidden: yes }
  dimension: page_url { hidden: yes }
  dimension: page_display_url { hidden: yes }
  dimension: page_section { hidden: yes }
  dimension: page_section_exclude { hidden: yes }
  dimension: page_urlhost { hidden: yes }
  dimension: page_urlpath { hidden: yes }
  dimension: page_urlquery { hidden: yes }
  dimension: page_width { hidden: yes }
  dimension: search_field { hidden: yes }
  dimension: page_absolute_uri { hidden: yes }
  dimension: page_engagement { hidden: yes }
  dimension: page_campaign_urlhost { hidden: yes }


  dimension: geo_country {
    drill_fields: [first_page_display_url]
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
    timeframes: [raw, time, minute10, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.session_start ;;
    #X# group_label:"Session Time"
  }

  dimension_group: session_start_marketing_drill {
    description: "The start time of the first page view of a given session."
    type: time
    timeframes: [raw, time, minute10, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.session_start ;;
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
    sql: ${TABLE}.session_end ;;
    #X# group_label:"Session Time"
    # hidden: yes
  }

  # Session Time (User Timezone)

  # dimension_group: session_start_local {
  # type: time
  # timeframes: [time, time_of_day, hour_of_day, day_of_week]
  # sql: ${TABLE}.session_start_local ;;
  #X# group_label:"Session Time (User Timezone)"
  # convert_tz: no
  # }

  # dimension_group: session_end_local {
  # type: time
  # timeframes: [time, time_of_day, hour_of_day, day_of_week]
  # sql: ${TABLE}.session_end_local ;;
  #X# group_label:"Session Time (User Timezone)"
  # convert_tz: no
  # hidden: yes
  # }

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

  dimension: time_engaged {
    type: number
    sql: ${TABLE}.time_engaged_in_s ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: time_engaged_tier {
    type: tier
    tiers: [0, 10, 30, 60, 120, 240]
    style: integer
    sql: ${time_engaged} ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: user_bounced {
    type: yesno
    sql: ${page_views} = 1 AND ${time_engaged} = 0 ;;
    group_label: "Engagement"
  }

  dimension: user_engaged {
    type: yesno
    sql: ${page_views} > 2 AND ${time_engaged} > 59 ;;
    group_label: "Engagement"
  }

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
    sql: CASE WHEN ${TABLE}.first_page_urlpath = '/gov/search' THEN 'https://www2.gov.bc.ca/gov/search?' || ${TABLE}.first_page_urlquery
          ELSE ${first_page_urlscheme} || '://' || ${first_page_urlhost} || regexp_replace(${first_page_urlpath}, 'index.(html|htm|aspx|php|cgi|shtml|shtm)$','')
         END;;
    group_label: "Page"
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
    sql: SPLIT_PART(${TABLE}.first_page_urlpath,'/',2) ;;
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

  dimension: first_page_campaign_urlhost {
    description: "The web page domain when a session began is on the list of campaign sites from the GCPE marketing team (1 if yes, 0 if no)"
    type: string
    sql:  CASE WHEN LOWER(${TABLE}.first_page_urlhost) IN ('cannabis.gov.bc.ca','cleanbc.gov.bc.ca','adopt.gov.bc.ca','fosternow.gov.bc.ca','buybc.gov.bc.ca','www.stopoverdose.gov.bc.ca','www.bcbudget.gov.bc.ca','upgrade.gov.bc.ca','budget.gov.bc.ca','bcwildfire.ca','erase.gov.bc.ca','childcare.gov.bc.ca') THEN '1' ELSE '0' END ;;
    group_label: "First Page"
  }

  dimension: first_page_urlhost_filter {
    description: "Temporary fix for bug in CLD-2823"
    type: string
    sql: CASE
       WHEN LOWER(${TABLE}.first_page_urlhost) = 'www2.gov.bc.ca' THEN 'https://www2.gov.bc.ca'
       WHEN LOWER(${TABLE}.first_page_urlhost) = 'intranet.gov.bc.ca' THEN 'https://intranet.gov.bc.ca'
       ELSE LOWER(${TABLE}.first_page_urlhost) END
    ;;
    group_label: "Page"
    hidden: yes
  }

  # dimension: first_page_urlport {
  # type: number
  # sql: ${TABLE}.first_page_urlport ;;
  # group_label: "First Page"
  # hidden: yes
  # }

  dimension: first_page_urlquery {
    description: "The URL query of the page where a session began."
    type: string
    sql: ${TABLE}.first_page_urlquery ;;
    group_label: "First Page"
  }

  # dimension: first_page_urlfragment {
  # type: string
  # sql: ${TABLE}.first_page_urlfragment ;;
  # group_label: "First Page"
  # }

  dimension: first_page_title {
    description: "The Title for the page where a session began."
    type: string
    sql: ${TABLE}.first_page_title ;;
    group_label: "First Page"
  }

  dimension: session_length {
    type: number
    sql: DATEDIFF(SECONDS, ${session_start_raw}, ${session_end_raw}) ;;
  }

  # MEASURES

  measure: average_session_length {
    type: average
    sql: ${session_length} / 86400.0;;
    value_format: "h:mm:ss"
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
  #set: session_count{
  #  fields: [session_id, session_start_date, first_page_url, referrer_medium, page_view_count, total_time_engaged]
  #}

  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
    #drill_fields: [user_count]
  }
  #set: user_count{
  #  fields: [domain_userid, users.first_page_url, session_count, average_time_engaged, total_time_engaged]
  #}

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
  #set: new_user_count{
  #  fields: [domain_userid, users.first_page_url, session_count, average_time_engaged, total_time_engaged]
  #}

  measure: bounced_user_count {
    type: count_distinct
    sql: ${domain_userid} ;;

    filters: {
      field: user_bounced
      value: "yes"
    }

    group_label: "Counts"
  }

  measure: engaged_user_count {
    type: count_distinct
    sql: ${domain_userid} ;;

    filters: {
      field: user_engaged
      value: "yes"
    }

    group_label: "Counts"
  }

  # Engagement

  measure: total_time_engaged {
    type: sum
    sql: ${time_engaged} ;;
    value_format: "#,##0\"s\""
    group_label: "Engagement"
  }

  measure: average_time_engaged {
    type: average
    sql: ${time_engaged} ;;
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

}
