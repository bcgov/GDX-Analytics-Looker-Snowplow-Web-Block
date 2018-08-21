view: users {
  derived_table: {
    sql: WITH prep AS (

        SELECT
          domain_userid,

          -- time
          MIN(session_start) AS first_session_start,
          MAX(session_end) AS last_session_end,

          -- engagement
          SUM(page_views) AS page_views,
          SUM(clicks) AS clicks,
          COUNT(*) AS sessions,
          SUM(time_engaged_in_s) AS time_engaged_in_s

        FROM derived.sessions

        GROUP BY 1
        ORDER BY 1

      )

      SELECT
        -- user
        a.user_id,
        a.domain_userid,
        a.network_userid,

        -- first sesssion: time
        b.first_session_start,

        -- last session: time
        b.last_session_end,

        -- engagement
        b.page_views,
        b.clicks,
        b.sessions,
        b.time_engaged_in_s,

        -- first page
        a.first_page_url,
        a.first_page_urlhost,
        a.first_page_urlpath,
        a.first_page_urlquery,
        a.first_page_title,

        -- referer
        a.page_referrer,
        a.refr_urlscheme,
        a.refr_urlhost,
        a.refr_urlpath,
        a.refr_urlquery,
        a.refr_medium,
        a.refr_source,
        a.refr_term,

        -- marketing
        a.mkt_medium,
        a.mkt_source,
        a.mkt_term,
        a.mkt_content,
        a.mkt_campaign,
        a.mkt_clickid,
        a.mkt_network,
        a.channel,

        -- application
        a.app_id

      FROM derived.sessions AS a

      INNER JOIN prep AS b
        ON a.domain_userid = b.domain_userid

      WHERE a.session_index = 1
       ;;
    sql_trigger_value: SELECT COUNT(*) FROM derived.sessions ;;
    distribution: "domain_userid"
    sortkeys: ["first_session_start"]
  }

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
    sql: ${TABLE}.network_userid
    group_label: "User"
    hidden: yes
  }

  # First Session Time

  dimension_group: first_session_start {
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.first_session_start ;;
    #X# group_label:"First Session Time"
  }

  dimension: first_session_start_window {
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

  dimension_group: last_session_end {
    type: time
    timeframes: [time, minute10, hour, date, week, month, quarter, year]
    sql: ${TABLE}.last_session_end ;;
    #X# group_label:"Last Session Time"
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

  dimension: sessions {
    type: number
    sql: ${TABLE}.sessions ;;
    group_label: "Engagement"
  }

  dimension: time_engaged {
    type: number
    sql: ${TABLE}.time_engaged_in_s ;;
    group_label: "Engagement"
    value_format: "0\"s\""
  }

  # First Page

  dimension: first_page_url {
    type: string
    sql: ${TABLE}.first_pageurl ;;
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
    sql: ${TABLE}.refr_url ;;
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
