# Version 1.0.0

include: "/Includes/shared_fields_common.view"
include: "/Includes/shared_fields_no_session.view"
include: "/Includes/date_comparisons_common.view"


view: page_views {
  sql_table_name: derived.page_views ;;

  extends: [shared_fields_common,shared_fields_no_session,date_comparisons_common]

  dimension: is_external_referrer_theme {
    type:  yesno
    group_label: "Referrer"
    label: "Referrer is External Theme"
    description: "Referrer is not from the target pageview theme. This filter only compares
    the theme ID of the target page to theme ID of the referrer page. This means that a non-government page
    will have an empty string for theme ID and will be captured if this filter is set to Yes."
    sql: ${cmslite_themes.theme_id} <> ${cmslite_referrer_themes.theme_id} ;;
  }

    dimension: is_external_referrer_subtheme {
    type:  yesno
    group_label: "Referrer"
    label: "Referrer is External Subtheme"
    description: "Referrer is not from the target pageview subtheme. This filter only compares
    the subtheme ID of the target page to subtheme ID of the referrer page. This means that a non-government page
    will have an empty string for subtheme ID and will be captured if this filter is set to Yes."
    sql: ${cmslite_themes.subtheme_id} <> ${cmslite_referrer_themes.subtheme_id} ;;
  }


  dimension: refr_theme {
    description: "The theme in CMSLite of the referrer."
    group_label: "Referrer"
    type: string
    sql:  ${cmslite_referrer_themes.theme} ;;
  }

  dimension: refr_subtheme {
    description: "The subtheme in CMSLite of the referrer."
    group_label: "Referrer"
    type: string
    sql:  ${cmslite_referrer_themes.subtheme} ;;
  }

  dimension_group: filter_start {
    sql: ${TABLE}.page_view_start_time ;;
  }

  # Modifying extended fields
  dimension: os_version { hidden: yes }
  dimension: geo_country { drill_fields: [page_display_url] }

  dimension: p_key {
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${page_view_id} ;;
  }

  # Addititonal Drills
  dimension: browser_language {
    drill_fields: [page_display_url]
  }

  dimension: referrer_medium {
    drill_fields: [referrer_medium, referrer_source, referrer_urlhost, page_referrer_display_url]
  }


  # DIMENSIONS

  # Page View

  dimension: page_view_id {
    type: string
    sql: ${TABLE}.page_view_id ;;
    group_label: "Page View"
  }

#   dimension: page_view_index {
#     type: number
#     # index across all sessions
#     sql: ${TABLE}.page_view_index ;;
#     group_label: "Page View"
#   }

  dimension: page_view_in_session_index {
    type: number
    # index within each session
    sql: ${TABLE}.page_view_in_session_index ;;
    group_label: "Page View"
  }

  # Page View Time

  dimension_group: page_view_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_start_time ;;
    #X# group_label:"Page View Time"
  }

  dimension: bc_bid_page_view_start_week {
    label: "Week"
    type: date
    sql: date_trunc('week', ${TABLE}.page_view_start_time);;
    description: "For BC Bid, weeks start on Monday"
    group_label: "BC Bid Dimensions"
  }

  dimension_group: page_view_start_marketing_drill {
    description: "The start time of the first page view of a given session."
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_start_time ;;
    drill_fields: [page_display_url, marketing_drills*]
    label: "Page View Start"
    group_label: "Page View Date (Marketing Drill)"
  }


  dimension_group: page_view_end {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_end_time ;;
    #X# group_label:"Page View Time"
    hidden: yes
  }

  # Page View Time (User Timezone)

  dimension_group: page_view_start_device_created {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_min_dvce_created_tstamp ;;
    #X# group_label:"Page View Time (User Timezone)"
  }

  dimension_group: page_view_end_device_created {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.page_view_max_dvce_created_tstamp ;;
    #X# group_label:"Page View Time (User Timezone)"
    hidden: yes
  }

  # Engagement

  dimension: time_engaged {
    type: number
    sql: ${TABLE}.time_engaged_in_s ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: time_engaged_tier {
    type: tier
    tiers: [0, 10, 30, 60, 120]
    style: integer
    sql: ${time_engaged} ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  dimension: x_pixels_scrolled {
    type: number
    sql: ${TABLE}.horizontal_pixels_scrolled ;;
    group_label: "Engagement"
    value_format: "0\"px\""
  }

  dimension: y_pixels_scrolled {
    type: number
    sql: ${TABLE}.vertical_pixels_scrolled ;;
    group_label: "Engagement"
    value_format: "0\"px\""
  }

  dimension: x_percentage_scrolled {
    type: number
    sql: ${TABLE}.horizontal_percentage_scrolled ;;
    group_label: "Engagement"
    value_format: "0\%"
  }

  dimension: y_percentage_scrolled {
    type: number
    sql: ${TABLE}.vertical_percentage_scrolled ;;
    group_label: "Engagement"
    value_format: "0\%"
  }

  dimension: y_percentage_scrolled_tier {
    type: tier
    tiers: [0, 25, 50, 75, 101]
    style: integer
    sql: ${y_percentage_scrolled} ;;
    group_label: "Engagement"
    value_format: "0\%"
  }

  dimension: user_bounced {
    type: yesno
    sql: ${time_engaged} = 0 ;;
    group_label: "Engagement"
  }

  dimension: user_engaged {
    type: yesno
    sql: ${time_engaged} >= 30 AND ${y_percentage_scrolled} >= 25 ;;
    group_label: "Engagement"
  }

  dimension: bounce {
    type: number
    sql: ${TABLE}.bounce ;;
    group_label: "Engagement"
  }

  dimension: entrance {
    type: number
    sql: ${TABLE}.entrance ;;
    group_label: "Engagement"
  }

  dimension: exit {
    type: number
    sql: ${TABLE}.exit ;;
    group_label: "Engagement"
  }

  dimension: new_user {
    type: number
    sql: ${TABLE}.new_user ;;
    group_label: "Engagement"
  }

  #page

  dimension: first_page_title {
    description: "The title of the first page visited in the session."
    type: string
    sql: CASE WHEN ${page_view_in_session_index} = 1 THEN ${page_title} ELSE NULL END ;;
  }

  # hidden to avoid requiring sessions_rollup (for optimization reasons)
  #dimension: last_page_title {
  #  description: "The title of the last page visited in the session."
  #  type: string
  #  sql: CASE WHEN ${page_view_in_session_index} = ${sessions_rollup.max_page_view_index} THEN ${page_title} ELSE NULL END ;;
  #}

  # Custom dimensions for WorkBC
  dimension: workbc_blueprint_page {
    label: "WorkBC Blueprint Page"
    type: string
    sql:  CASE WHEN ${TABLE}.page_display_url IN ('https://www.workbc.ca/BlueprintBuilder/','https://www.workbc.ca/BlueprintBuilder') THEN
            CASE
              WHEN ${TABLE}.page_urlquery LIKE '%page=2%' THEN 'Build'
              WHEN ${TABLE}.page_urlquery LIKE '%page=3%' THEN 'View'
              ELSE 'Register'
            END
          ELSE NULL
          END;;
    group_label: "WorkBC Dimensions"
    order_by_field: workbc_blueprint_page_sort
  }

  dimension: workbc_blueprint_page_sort {
    label: "WorkBC Blueprint Page Sort"
    type: string
    hidden: yes
    sql:  CASE WHEN ${TABLE}.page_display_url IN ('https://www.workbc.ca/BlueprintBuilder/','https://www.workbc.ca/BlueprintBuilder') THEN
            CASE
              WHEN ${TABLE}.page_urlquery LIKE '%page=2%' THEN '2Build'
              WHEN ${TABLE}.page_urlquery LIKE '%page=3%' THEN '3View'
              ELSE '1Register'
            END
          ELSE NULL
          END;;
    group_label: "WorkBC Dimensions"
  }


  dimension: workbc_quiz_name {
    label: "WorkBC Quiz Name"
    type: string
    sql:  CASE WHEN ${TABLE}.page_urlquery LIKE '%quiz=%' THEN SPLIT_PART(REGEXP_SUBSTR(${TABLE}.page_urlquery, 'quiz=([a-zA-Z]+)'),'=',2)
            ELSE 'Quiz Home'
            END ;;
    group_label: "WorkBC Dimensions"
    order_by_field: workbc_quiz_name_sort
  }

  dimension: workbc_quiz_name_sort {
    label: "WorkBC Quiz Name Sort"
    hidden: yes
    type: string
    sql:  CASE WHEN ${TABLE}.page_urlquery LIKE '%quiz=%' THEN SPLIT_PART(REGEXP_SUBSTR(${TABLE}.page_urlquery, 'quiz=([a-zA-Z]+)'),'=',2)
            ELSE '1Quiz Home'
            END ;;
    group_label: "WorkBC Dimensions"
  }
  dimension: workbc_quiz_result {
    label: "WorkBC Quiz Result"
    type: string
    sql:  CASE WHEN ${TABLE}.page_urlquery LIKE 'id%quiz=%' THEN SPLIT_PART(REGEXP_SUBSTR(${TABLE}.page_urlquery, 'id=([0-9]+)'),'=',2)
            ELSE NULL
            END ;;
    group_label: "WorkBC Dimensions"

    link: {
      label: "View Quiz Result"
      url: "https://www.workbc.ca/CareerCompass/Result?id={{ value }}&quiz={{workbc_quiz_name}}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
  }

  dimension: workbc_page_section {
    label: "WorkBC Page Section"
    description: "The identifier for a section of the WorkBC site."
    type: string
    sql: SPLIT_PART(SPLIT_PART(${TABLE}.page_urlpath,'/',2),'.',1) ;;
    group_label: "WorkBC Dimensions"
  }

  dimension: workbc_page_sub_section {
    label: "WorkBC Page Sub Section"
    description: "The identifier for a subsection of the WorkBC site. The part of the URL between the second and third '/' in the path"
    type: string
    sql: CASE WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',3) <> ''
            THEN SPLIT_PART(SPLIT_PART(${TABLE}.page_urlpath,'/',3),'.',1)
            ELSE 'Main Page'
          END ;;
    group_label: "WorkBC Dimensions"
    drill_fields: [page_display_url]
    order_by_field: workbc_page_sub_section_sort
  }

  dimension: workbc_page_sub_section_sort {
    label: "WorkBC Page Sub Section Sort"
    hidden: yes
    description: "The identifier for a subsection of the WorkBC site. The part of the URL between the second and third '/' in the path"
    type: string
    sql: CASE WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',3) <> ''
            THEN SPLIT_PART(SPLIT_PART(${TABLE}.page_urlpath,'/',3),'.',1)
            ELSE '111Main Page'
          END ;;
    group_label: "WorkBC Dimensions"
  }

# Custom Dimensions for Chatbot
dimension: chatbot_page_display_url {
  type: string
    label: "Chatbot Page Display URL"
    # when editing also see clicks.truncated_target_url_nopar_case_insensitive
    description: "Cleaned URL of the page without query string or standard file names like index.html for Chatbot"
    sql: ${TABLE}.page_display_url ;;
    group_label: "Chatbot"
    drill_fields: [page_views.page_referrer, chatbot.intent, chatbot.intent_category]
    link: {
      label: "Visit Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
}

  # Custom dimensions for LGIS
  dimension: lgis_section {
    label: "LGIS Section"
    description: "The identifier for a section of the LGIS site. The part of the URL between the third and fourth '/' in the path"
    type: string
    sql: CASE
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',2) = 'EXT' AND SPLIT_PART(${TABLE}.page_urlpath,'/',3) = 'Default.aspx' THEN 'Main Page'
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',2) = 'EXT' THEN SPLIT_PART(${TABLE}.page_urlpath,'/',3)
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',4) = '' OR SPLIT_PART(${TABLE}.page_urlpath,'/',4) IN ('default.aspx','Default.aspx','welcome') THEN 'Main Page'
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',4) <> '' THEN SPLIT_PART(${TABLE}.page_urlpath,'/',4)
            ELSE NULL
          END ;;
    group_label: "LGIS Dimensions"
    drill_fields: [page_display_url]
    order_by_field: lgis_section_sort
  }

  dimension: lgis_section_sort {
    label: "LGIS Section"
    hidden: yes
    description: "The identifier for a section of the LGIS site. The part of the URL between the third and fourth '/' in the path"
    type: string
    sql: CASE
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',2) = 'EXT' AND SPLIT_PART(${TABLE}.page_urlpath,'/',3) = 'Default.aspx' THEN '00-Main Page'
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',2) = 'EXT' THEN SPLIT_PART(${TABLE}.page_urlpath,'/',3)
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',4) = '' OR SPLIT_PART(${TABLE}.page_urlpath,'/',4) IN ('default.aspx','Default.aspx','welcome') THEN '00-Main Page'
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',4) <> '' THEN SPLIT_PART(${TABLE}.page_urlpath,'/',4)
            ELSE NULL
          END ;;
    group_label: "LGIS Dimensions"
  }

  # Custom dimensions for LGIS
  dimension: lgis_user_type {
    label: "LGIS User Type"
    description: "The use type of a page on the LGIS site. The part of the URL between the second and third '/' in the path"
    type: string
    sql: CASE
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',2) = 'EXT' THEN 'External'
            WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',3) <> '' THEN SPLIT_PART(${TABLE}.page_urlpath,'/',2) || '/' || SPLIT_PART(${TABLE}.page_urlpath,'/',3)
            ELSE NULL
          END ;;
    group_label: "LGIS Dimensions"
    drill_fields: [page_display_url]
  }


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


  # MEASURES

  measure: row_count {
    type: count
    group_label: "Counts"
  }

  measure: page_view_count {
    type: count_distinct
    sql: ${page_view_id} ;;
    group_label: "Counts"
  }

  measure: bounced_page_view_count {
    type: count_distinct
    sql: ${page_view_id} ;;
    filters: {
      field: user_bounced
      value: "yes"
    }
    group_label: "Counts"
  }

  measure: max_page_view_index {
    type: max
    sql: ${page_view_in_session_index} ;;
  }

  measure: engaged_page_view_count {
    type: count_distinct
    sql: ${page_view_id} ;;
    filters: {
      field: user_engaged
      value: "yes"
    }
    group_label: "Counts"
  }

  measure: landing_page_count {
    type: count_distinct
    sql: ${page_view_id} ;;
    filters: {
      field: page_view_in_session_index
      value: "1"
    }
  }

  measure: exit_page_count {
    type: sum
    sql: ${TABLE}.exit ;;
  }

  measure: session_count {
    type: count_distinct
    sql: ${session_id} ;;
    group_label: "Counts"
  }


  measure: LGIS_page_view_count {
    label: "LGIS Page View Count"
    type: count_distinct
    sql: ${page_view_id} ;;
    group_label: "Counts"
    drill_fields: [page_display_url,lgis_section,lgis_user_type,session_count,page_view_count]
  }


  measure: LGIS_session_count {
    label: "LGIS Session Count"
    type: count_distinct
    sql: ${session_id} ;;
    group_label: "Counts"
    drill_fields: [page_display_url,lgis_section,lgis_user_type,page_view_count,session_count]
  }



  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
  }

  # Engagement

  # measure: page_2_count {
  #   type: count_distinct
  #   sql: ${page_views_2.page_title} ;;
  # }

  measure: total_time_engaged {
    type: sum
    sql: ${time_engaged} ;;
    value_format: "#,##0\"s\""
    group_label: "Engagement"
  }

  measure: average_page_views_per_visit {
    type: average
    sql: ${page_view_in_session_index} ;;
    group_label: "Engagement"
  }

  measure: average_time_engaged {
    type: average
    sql: ${time_engaged} ;;
    value_format: "0.00\"s\""
    group_label: "Engagement"
  }

  measure: average_percentage_scrolled {
    type: average
    sql: ${y_percentage_scrolled} ;;
    value_format: "0.00\%"
    group_label: "Engagement"
  }

  measure: desktop_page_views {
    type: sum
    sql: CASE WHEN page_views.dvce_type = 'Computer' THEN 1 ELSE 0 END;;
  }
  measure: mobile_page_views {
    type: sum
    sql: CASE WHEN page_views.dvce_type IN ('Mobile','Tablet') THEN 1 ELSE 0 END;;
  }
}

# If necessary, uncomment the line below to include explore_source.
# include: "snowplow_web_block.model.lkml"
explore: max_page_view_rollup {}
view: max_page_view_rollup {
  derived_table: {
    explore_source: page_views {
      column: page_view_id {}
      column: page_title {}
      column: max_page_view_index {}
      derived_column: p_key {
        sql: ROW_NUMBER() OVER (order by true) ;;
      }
    }
  }
  dimension: page_view_id {}
  dimension: page_title {}
  dimension: max_page_view_index {
    type: number
  }
}
