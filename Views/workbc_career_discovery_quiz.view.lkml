view: workbc_career_discovery_quiz {
  derived_table: {
    sql: WITH results AS (
            SELECT ev.domain_sessionid AS session_id,
              category, quiz,
              CONVERT_TIMEZONE('UTC', 'America/Vancouver', qr.root_tstamp) AS timestamp
            FROM atomic.ca_bc_gov_workbc_career_quiz_result_1  AS qr
            JOIN atomic.events AS ev ON
              qr.root_id = ev.event_id AND qr.root_tstamp = ev.collector_tstamp
          --  WHERE qr.root_tstamp > '2022-08-07'
          ),
          steps AS (
            SELECT ev.domain_sessionid AS session_id,
              category, quiz, status, step,
              CONVERT_TIMEZONE('UTC', 'America/Vancouver', qs.root_tstamp) AS timestamp
            FROM atomic.ca_bc_gov_workbc_career_quiz_step_1  AS qs
              JOIN atomic.events AS ev ON
                qs.root_id = ev.event_id AND qs.root_tstamp = ev.collector_tstamp
          --  WHERE qs.root_tstamp > '2022-08-07'
          ),
          step_sessions AS (
            SELECT session_id, category, quiz, MAX(step) AS last_step, MIN(timestamp) AS min_timestamp,MAX(timestamp) AS max_timestamp
            FROM steps
            GROUP BY 1, 2, 3
          ),
          result_sessions AS (
            SELECT session_id, category, quiz, MIN(timestamp) AS min_timestamp,MAX(timestamp) AS max_timestamp
            FROM results
            GROUP BY 1, 2, 3
          )
          SELECT ss.session_id, ss.category, ss.quiz, ss.min_timestamp,
            CASE WHEN rs.session_id IS NOT NULL THEN rs.max_timestamp ELSE ss.max_timestamp END AS max_timestamp,
            CASE WHEN rs.session_id IS NOT NULL THEN 'Completed' ELSE CAST(last_step AS CHAR) END AS last_step,
            CASE WHEN rs.session_id IS NOT NULL THEN DATEDIFF('seconds', ss.min_timestamp, rs.max_timestamp)
                ELSE DATEDIFF('seconds', ss.min_timestamp, ss.max_timestamp) END AS elapsed
            FROM step_sessions AS ss
          LEFT JOIN result_sessions AS rs ON rs.session_id = ss.session_id AND ss.category = rs.category AND ss.quiz = rs.quiz
        ;;
    distribution_style: all
    persist_for: "2 hours"
  }


  dimension: session_id {
    description: "Unique Session ID"
    type: string
    sql: ${TABLE}.session_id ;;
  }


  dimension: category {}
  dimension: quiz {}
  dimension: last_step {}

  dimension_group: event {
    sql: ${TABLE}.min_timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  dimension_group: end {
    sql: ${TABLE}.max_timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
  }

  measure: completed_count {
    type: sum
    sql: CASE WHEN last_step = 'Completed' THEN 1 ELSE 0 END ;;
  }

  measure: average_time {
    type: average
    sql: (1.00 * ${TABLE}.elapsed)/(60*60*24) ;;
    value_format: "[h]:mm:ss"
  }




}
