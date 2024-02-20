# Version: 1.1.0
include: "/Includes/date_comparisons_common.view"

view: corp_calendar_searches {
  derived_table: {
    sql: SELECT wp.id AS page_view_id, action,
          domain_sessionid AS session_id,
          events.page_url,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          count AS results_count,
          "filters.category" AS categories,
          "filters.comm_contact" AS comm_contact,
          "filters.date_confirmed" AS date_confirmed,
          "filters.distribution" AS distribution,
          TO_DATE("filters.from_date", 'YYYY-MM-DD') AS from_date,
          "filters.intiative" AS intiative,
          "filters.issue" AS issue,
          "filters.look_ahead_filter" AS look_ahead_filter,
          "filters.ministry" AS ministry,
          "filters.premier_requested" AS premier_requested,
          "filters.representative" AS representative,
          "filters.search_text" AS search_text,
          "filters.status" AS status,
          CASE WHEN "filters.this_day_only" = 't' THEN TRUE
                WHEN "filters.this_day_only" = 'f' THEN FALSE
                ELSE NULL END AS this_day_only,
          TO_DATE("filters.to_date", 'YYYY-MM-DD') AS to_date,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', ca.root_tstamp) AS timestamp,
          CASE WHEN "filters.category" IS NOT NULL THEN 1 ELSE 0 END AS categories_count,
          CASE WHEN "filters.comm_contact" IS NOT NULL THEN 1 ELSE 0 END AS comm_contact_count,
          CASE WHEN "filters.date_confirmed" IS NOT NULL THEN 1 ELSE 0 END AS date_confirmed_count,
          CASE WHEN "filters.distribution" IS NOT NULL THEN 1 ELSE 0 END AS distribution_count,
          CASE WHEN "filters.from_date" IS NOT NULL THEN 1 ELSE 0 END AS from_date_count,
          CASE WHEN "filters.intiative" IS NOT NULL THEN 1 ELSE 0 END AS intiative_count,
          CASE WHEN "filters.issue" IS NOT NULL THEN 1 ELSE 0 END AS issue_count,
          CASE WHEN "filters.look_ahead_filter" <> 'Show All' THEN 1 ELSE 0 END AS look_ahead_filter_count,
          CASE WHEN "filters.ministry" IS NOT NULL THEN 1 ELSE 0 END AS ministry_count,
          CASE WHEN "filters.premier_requested" IS NOT NULL THEN 1 ELSE 0 END AS premier_requested_count,
          CASE WHEN "filters.representative" IS NOT NULL THEN 1 ELSE 0 END AS representative_count,
          CASE WHEN "filters.search_text" IS NOT NULL THEN 1 ELSE 0 END AS search_text_count,
          CASE WHEN "filters.status" IS NOT NULL THEN 1 ELSE 0 END AS status_count,
          CASE WHEN "filters.this_day_only" = 't' THEN 1 ELSE 0 END AS this_day_only_count,
          CASE WHEN "filters.to_date" IS NOT NULL THEN 1 ELSE 0 END AS to_date_count
        FROM atomic.ca_bc_gov_bcs_calendar_action_1 AS ca
          LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON ca.root_id = wp.root_id AND ca.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON ca.root_id = events.event_id AND ca.root_tstamp = events.collector_tstamp
                 WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        ;;
    datagroup_trigger: datagroup_25_55
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
    distribution_style: all
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
  }


  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }
  dimension: page_url {}


  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension_group: event {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }


  dimension: count {
    type: number
    sql:  ${TABLE}.results_count ;;
  }
  dimension: categories {
    label: "Category"
  }
  dimension: comm_contact {}
  dimension: distribution {}
  dimension: intiative {}
  dimension: issue {}
  dimension: look_ahead_filter {}
  dimension: ministry {}
  dimension: premier_requested {}
  dimension: representative {}
  dimension: search_text {}
  dimension: status {}
  dimension: this_day_only {
    type: yesno
  }

  dimension: date_confirmed {
    type: string
  }
  dimension_group: from_date {
    type: time
    timeframes: [date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension_group: to_date {
    type: time
    timeframes: [date, day_of_month, day_of_week, week, month, quarter, year]
  }


    measure: categories_count {
      label: "Category Count"
      type: sum
    }
    measure: comm_contact_count {
      type: sum
    }
    measure: date_confirmed_count {
      type: sum
    }
    measure: distribution_count {
      type: sum
    }
    measure: from_date_count {
      type: sum
    }
    measure: intiative_count {
      type: sum
    }
    measure: issue_count {
      type: sum
    }
    measure: look_ahead_filter_count {
      type: sum
    }
    measure: ministry_count {
      type: sum
    }
    measure: premier_requested_count {
      type: sum
    }
    measure: representative_count {
      type: sum
    }
    measure: search_text_count {
      type: sum
    }
    measure: status_count {
      type: sum
    }
    measure: this_day_only_count {
      type: sum
    }
    measure: to_date_count {
      type: sum
    }

    measure: individual_count {
      type: count
    }

    measure: session_count {
      description: "Count of the outcome over distinct Session IDs"
      type: count_distinct
      sql_distinct_key: ${TABLE}.session_id ;;
      sql: ${TABLE}.session_id  ;;
    }

}
