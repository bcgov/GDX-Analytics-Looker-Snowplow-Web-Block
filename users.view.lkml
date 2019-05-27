view: users {
  sql_table_name: derived.users ;;
  # DIMENSIONS

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
    sql: ${TABLE}.network_userid;;
    group_label: "User"
    hidden: yes
  }

  # First Session Time

  # First Session Start does not appear in the Users Explore; but it does appear in the Page Views Explore.
  # As a result, this dimension cannot be explored, since the value for it requires an explore join to sessions.
  # In the Snowplow Web Block model, `explore: users` does not join sessions on domain_userid.
  # TODO: understand why First Session Start does not appear in explores.
  dimension_group: first_session_start {
    description: "The earliest session start time."
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.first_session_start ;;
    #X# group_label:"First Session Time"
  }

  # First Session Start Window
  # Is hidden and unused elsewhere in this view.
  # TODO: flagging for removal.
  dimension: first_session_start_window {
    description: "Labels as current or previous period period: \"current session\" is where the earliest session starts after 28 days; \"previous session\" is where the earliest session between 28 days and 56 days."
    case: {
      when: {
        sql: ${TABLE}.first_session_start >= DATEADD(day, -28, GETDATE()) ;;
        label: "current_period"
      }

      when: {
        sql: ${TABLE}.first_session_start >= DATEADD(day, -56, GETDATE()) AND ${TABLE}.first_session_start < DATEADD(day, -28, GETDATE()) ;;
        label: "previous_period"
      }

      else: "unknown"
    }

    hidden: yes
  }

  # Last Session Time

  # Last session end
  # does appear in Users Explore
  # TODO: understand why First Session Start does not appear in explores.
  dimension_group: last_session_end {
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.last_session_end ;;
    #X# group_label:"Last Session Time"
  }

  # Engagement
  ## These are aggregated values from the derived prep table.

  dimension: page_views {
    description: "The sum of page views."
    type: number
    sql: ${TABLE}.page_views ;;
    group_label: "Engagement"
  }

  dimension: clicks {
    description: "The sum of clicks."
    type: number
    sql: ${TABLE}.clicks ;;
    group_label: "Engagement"
  }

  dimension: searches {
    description: "The sum of searches."
    type: number
    sql: ${TABLE}.searches ;;
    group_label: "Engagement"
  }

  dimension: sessions {
    description: "The count sessions."
    type: number
    sql: ${TABLE}.sessions ;;
    group_label: "Engagement"
  }

  dimension: time_engaged {
    description: "The sum of time engaged in seconds."
    type: number
    sql: ${TABLE}.time_engaged_in_s ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  # First Page

  dimension: first_page_url {
    type: string
    sql: ${TABLE}.first_page_url ;;
    group_label: "First Page"
  }

  # dimension: first_page_urlscheme {
  # type: string
  # sql: ${TABLE}.first_page_urlscheme ;;
  # group_label: "First Page"
  # hidden: yes
  # }

  dimension: first_page_urlhost {
    type: string
    sql: ${TABLE}.first_page_urlhost ;;
    group_label: "First Page"
  }

  # dimension: first_page_urlport {
  # type: number
  # sql: ${TABLE}.first_page_urlport ;;
  # group_label: "First Page"
  # hidden: yes
  # }

  dimension: first_page_urlpath {
    type: string
    sql: ${TABLE}.first_page_urlpath ;;
    group_label: "First Page"
  }

  dimension: first_page_urlquery {
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
    type: string
    sql: ${TABLE}.first_page_title ;;
    group_label: "First Page"
  }

  # Referer

  dimension: referer_url {
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

  # dimension: referer_urlport {
  # type: number
  # sql: ${TABLE}.refr_urlport ;;
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

  # dimension: referer_urlfragment {
  # type: string
  # sql: ${TABLE}.refr_urlfragment ;;
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

  dimension: marketing_channel {
    type: string
    sql: ${TABLE}.channel ;;
    group_label: "Marketing"
  }

  # Application

  dimension: app_id {
    description: "The application identifier from which the event originated."
    type: string
    sql: ${TABLE}.app_id ;;
    group_label: "Application"
  }

  # MEASURES

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

  measure: search_count {
    type: sum
    sql: ${searches} ;;
    group_label: "Counts"
  }

  measure: session_count {
    type: sum
    sql: ${sessions} ;;
    group_label: "Counts"
  }

  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
  }
}
