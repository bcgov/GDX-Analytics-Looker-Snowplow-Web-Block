# Version: 1.0.0
include: "/Includes/date_comparisons_common.view"

view: bchep_action_progress  {
  label: "BCHEP Action Progress"
  derived_table: {
    sql:
      WITH raw_list AS (
        SELECT
          events.domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          section,
          CASE WHEN section = 'landing' THEN 1
          WHEN section = 'login' THEN 2
          WHEN section = 'pin-request' THEN 3
          WHEN section = 'returning-user-flow' THEN 4
          WHEN section = 'energuide-upload' THEN 5
          WHEN section = 'rating-estimate' THEN 6
          WHEN section = 'questionnaire-energy-report' THEN 7
          WHEN section = 'energy-report' THEN 8
          WHEN section = 'questionnaire-upgrade-plan' THEN 9
          WHEN section = 'questionnaire-energy-plan' THEN 10
          WHEN section = 'upgrade-plan' THEN 11
          WHEN section = 'energy-plan' THEN 12
          WHEN section = 'support' THEN 13
          ELSE NULL END AS section_order,

          CONVERT_TIMEZONE('UTC', 'America/Vancouver', vba.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_vhers_bchep_action_1  AS vba
      LEFT JOIN atomic.events ON vba.root_id = events.event_id AND vba.root_tstamp = events.collector_tstamp
      WHERE action = 'step-start'      )
      SELECT
            page_urlhost,
            rl.session_id, --fs.section,
            MIN(timestamp) AS min_timestamp, MAX(timestamp) AS max_timestamp,
            MAX(section_order) AS section_order
      FROM raw_list AS rl
      --JOIN final_step AS fs ON fs.session_id = rl.session_id AND fs.session_id_ranked = 1
      GROUP BY 1,2


        ;;
    sortkeys: ["session_id","min_timestamp"]
    distribution_style: all

    #datagroup_trigger: datagroup_healthgateway_updated
    #increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    #increment_offset: 3
    persist_for: "1 hour"
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
  }
  dimension: session_id {}
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }

  dimension: latest_section {
    sql: CASE WHEN ${TABLE}.section_order = 1 THEN 'landing'
      WHEN ${TABLE}.section_order = 2 THEN 'login'
      WHEN ${TABLE}.section_order = 3 THEN 'pin-request'
      WHEN ${TABLE}.section_order = 4 THEN 'returning-user-flow'
      WHEN ${TABLE}.section_order = 5 THEN 'energuide-upload'
      WHEN ${TABLE}.section_order = 6 THEN 'rating-estimate'
      WHEN ${TABLE}.section_order = 7 THEN 'questionnaire-energy-report'
      WHEN ${TABLE}.section_order = 8 THEN 'energy-report'
      WHEN ${TABLE}.section_order = 9 THEN 'questionnaire-energy-plan'
      WHEN ${TABLE}.section_order = 10 THEN 'energy-plan'
      WHEN ${TABLE}.section_order = 11 THEN 'support'
      ELSE NULL END;;
    type:  string

  }
  dimension: section_order {
    type: number

  }
  dimension_group: max_time {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.max_timestamp ;;
  }
  dimension_group: min_time {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.min_timestamp ;;
  }
  dimension: max_timestamp {}
  dimension: min_timestamp {}
  dimension: duration{
    sql: DATEDIFF('seconds', ${min_timestamp},${max_timestamp}) ;;
  }

  measure: count {
    type: count
    label: "Count"
  }


  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

}
