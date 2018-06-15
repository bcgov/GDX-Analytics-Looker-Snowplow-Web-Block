view: users {
  derived_table: {
    sql: WITH prep AS (

        SELECT

          domain_userid,

          -- time

          MIN(session_start) AS first_session_start,
          -- MIN(session_start_local) AS first_session_start_local,

          MAX(session_end) AS last_session_end,

          -- engagement

          SUM(page_views) AS page_views,
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

          -- example derived dimensions

          -- TO_CHAR(b.first_session_start, 'YYYY-MM-DD HH24:MI:SS') AS first_session_time,
          -- TO_CHAR(b.first_session_start, 'YYYY-MM-DD HH24:MI') AS first_session_minute,
          -- TO_CHAR(b.first_session_start, 'YYYY-MM-DD HH24') AS first_session_hour,
          -- TO_CHAR(b.first_session_start, 'YYYY-MM-DD') AS first_session_date,
          -- TO_CHAR(DATE_TRUNC('week', b.first_session_start), 'YYYY-MM-DD') AS first_session_week,
          -- TO_CHAR(b.first_session_start, 'YYYY-MM') AS first_session_month,
          -- TO_CHAR(DATE_TRUNC('quarter', b.first_session_start), 'YYYY-MM') AS first_session_quarter,
          -- DATE_PART(Y, b.first_session_start)::INTEGER AS first_session_year,

        -- first session: time in the user's local timezone

        -- b.first_session_start_local,

          -- example derived dimensions

          -- TO_CHAR(b.first_session_start_local, 'YYYY-MM-DD HH24:MI:SS') AS first_session_local_time,
          -- TO_CHAR(b.first_session_start_local, 'HH24:MI') AS first_session_local_time_of_day,
          -- DATE_PART(hour, b.first_session_start_local)::INTEGER AS first_session_local_hour_of_day,
          -- TRIM(TO_CHAR(b.first_session_start_local, 'd')) AS first_session_local_day_of_week,
          -- MOD(EXTRACT(DOW FROM b.first_session_start_local)::INTEGER - 1 + 7, 7) AS first_session_local_day_of_week_index,

        -- last session: time

        b.last_session_end,

        -- engagement

        b.page_views,
        b.sessions,

        b.time_engaged_in_s,

        -- first page

        a.first_page_url,

        -- a.first_page_url_scheme,
        a.first_page_urlhost,
        -- a.first_page_url_port,
        a.first_page_urlpath,
        a.first_page_urlquery,
        -- a.first_page_url_fragment,

        a.first_page_title,

        -- referer

        a.page_referer,

        a.refr_urlscheme,
        a.refr_urlhost,
        -- a.referer_url_port,
        a.refr_urlpath,
        a.refr_urlquery,
        -- a.referer_url_fragment,

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
    sql: ${TABLE}.network_userid ;;
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
        sql: ${first_session_start_time} >= DATEADD(day, -28, GETDATE()) ;;
        label: "current_period"
      }

      when: {
        sql: ${first_session_start_time} >= DATEADD(day, -56, GETDATE()) AND ${first_session_start_time} < DATEADD(day, -28, GETDATE()) ;;
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

  # First Session Time (User Timezone)

  # dimension_group: first_session_start_local {
    # type: time
    # timeframes: [time, time_of_day, hour_of_day, day_of_week]
    # sql: ${TABLE}.first_session_start_local ;;
    #X# group_label:"First Session Time (User Timezone)"
    # convert_tz: no
  # }

  # Engagement

  dimension: page_views {
    type: number
    sql: ${TABLE}.page_views ;;
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
    sql: ${TABLE}.first_page_url ;;
    group_label: "First Page"
  }

  # dimension: first_page_url_scheme {
    # type: string
    # sql: ${TABLE}.first_page_url_scheme ;;
    # group_label: "First Page"
    # hidden: yes
  # }

  dimension: first_page_urlhost {
    type: string
    sql: ${TABLE}.first_page_urlhost ;;
    group_label: "First Page"
  }

  # dimension: first_page_url_port {
    # type: number
    # sql: ${TABLE}.first_page_url_port ;;
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

  # dimension: first_page_url_fragment {
    # type: string
    # sql: ${TABLE}.first_page_url_fragment ;;
    # group_label: "First Page"
  # }

  dimension: first_page_title {
    type: string
    sql: ${TABLE}.first_page_title ;;
    group_label: "First Page"
  }

  # Referer

  dimension: page_referer {
    type: string
    sql: ${TABLE}.page_referer ;;
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

  # dimension: referer_url_port {
    # type: number
    # sql: ${TABLE}.referer_url_port ;;
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

  # dimension: referer_url_fragment {
    # type: string
    # sql: ${TABLE}.referer_url_fragment ;;
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

  dimension: refr_term {
    type: string
    sql: ${TABLE}.referer_term ;;
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
