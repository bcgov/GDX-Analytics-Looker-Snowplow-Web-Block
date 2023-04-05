view: workbc_careersearch_compare_test_incremental {
  derived_table: {
    sql:
    (
    SELECT wp.id AS page_view_id, action,
          noc_1 AS noc, noc1.description AS description,
          1 AS position,
          --noc_2, noc2.description AS description_2,
          --noc_3, noc3.description AS description_3,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', cc.root_tstamp) AS timestamp,
          CASE WHEN action = 'compare' THEN 1 ELSE 0 END AS compare_count,
          CASE WHEN action = 'clear' THEN 1 ELSE 0 END AS clear_count
        FROM atomic.ca_bc_gov_workbc_compare_careers_1 AS cc
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON cc.root_id = wp.root_id AND cc.root_tstamp = wp.root_tstamp
          LEFT JOIN microservice.careertoolkit_workbc AS noc1 -- the "00" trick is temporarily needed until the lookup table gets fixed
              ON noc1.noc = cc.noc_1 OR cc.noc_1 = '0' || noc1.noc OR cc.noc_1 = '00' || noc1.noc OR cc.noc_1 = '00' || noc1.noc
--          LEFT JOIN microservice.careertoolkit_workbc AS noc2 -- the "00" trick is temporarily needed until the lookup table gets fixed
--              ON noc2.noc = cc.noc_2 OR cc.noc_2 = '0' || noc2.noc OR cc.noc_2 = '00' || noc2.noc OR cc.noc_2 = '00' || noc2.noc
--          LEFT JOIN microservice.careertoolkit_workbc AS noc3 -- the "00" trick is temporarily needed until the lookup table gets fixed
--              ON noc3.noc = cc.noc_3 OR cc.noc_3 = '0' || noc3.noc OR cc.noc_3 = '00' || noc3.noc OR cc.noc_3 = '00' || noc3.noc
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %}
      )
      UNION
      (
        SELECT wp.id AS page_view_id, action,
          noc_2 AS noc, noc2.description AS description,
          2 AS position,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', cc.root_tstamp) AS timestamp,
          CASE WHEN action = 'compare' THEN 1 ELSE 0 END AS compare_count,
          CASE WHEN action = 'clear' THEN 1 ELSE 0 END AS clear_count
        FROM atomic.ca_bc_gov_workbc_compare_careers_1 AS cc
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON cc.root_id = wp.root_id AND cc.root_tstamp = wp.root_tstamp
          LEFT JOIN microservice.careertoolkit_workbc AS noc2 -- the "00" trick is temporarily needed until the lookup table gets fixed
              ON noc2.noc = cc.noc_2 OR cc.noc_2 = '0' || noc2.noc OR cc.noc_2 = '00' || noc2.noc OR cc.noc_2 = '00' || noc2.noc
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %}
      )
      UNION
      (
        SELECT wp.id AS page_view_id, action,
          noc_3 AS noc, noc3.description AS description,
          3 AS position,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', cc.root_tstamp) AS timestamp,
          CASE WHEN action = 'compare' THEN 1 ELSE 0 END AS compare_count,
          CASE WHEN action = 'clear' THEN 1 ELSE 0 END AS clear_count
        FROM atomic.ca_bc_gov_workbc_compare_careers_1 AS cc
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON cc.root_id = wp.root_id AND cc.root_tstamp = wp.root_tstamp
          LEFT JOIN microservice.careertoolkit_workbc AS noc3 -- the "00" trick is temporarily needed until the lookup table gets fixed
              ON noc3.noc = cc.noc_3 OR cc.noc_3 = '0' || noc3.noc OR cc.noc_3 = '00' || noc3.noc OR cc.noc_3 = '00' || noc3.noc
        WHERE {% incrementcondition %} timestamp {% endincrementcondition %}
      )
                    ;;
    distribution_style: all
    datagroup_trigger: datagroup_15_45
    increment_key: "event_hour"
    increment_offset: 3
  }

  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }

  dimension: root_id {
    description: "Unique ID of the event"
    primary_key: yes
    type: string
    sql: ${TABLE}.root_id ;;
  }

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }
  dimension: noc {
    link: {
      label: "View Profile"
      url: "https://workbc.ca/Jobs-Careers/Explore-Careers/Browse-Career-Profile/{{noc}}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
    link: {
      label: "View Job Search"
      url: "https://workbc.ca/jobs-careers/find-jobs/jobs.aspx?searchNOC={{noc}}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
  }
  dimension: description {
    link: {
      label: "View Profile"
      url: "https://workbc.ca/Jobs-Careers/Explore-Careers/Browse-Career-Profile/{{noc}}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
    link: {
      label: "View Job Search"
      url: "https://workbc.ca/jobs-careers/find-jobs/jobs.aspx?searchNOC={{noc}}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
  }
  dimension: position {}
  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  measure: compare_count {
    type: sum
    sql: ${TABLE}.compare_count ;;
  }
  measure: clear_count {
    type: sum
    sql: ${TABLE}.clear_count ;;
  }
}
