# Version: 1.0.0
include: "/Includes/date_comparisons_common.view"

view: bchep_action_progress_step  {
  label: "BCHEP Action Progress Step"
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

          step,
          CASE
            WHEN step = 'landing' THEN 1
            WHEN step = 'welcome' THEN 2
            WHEN step = 'addressConfirmation' THEN 3
            WHEN step = 'addressIneligible' THEN 4
            WHEN step = 'access-contactAddress' THEN 5
            WHEN step = 'access-getStarted' THEN 6
            WHEN step = 'access-newCodeRequest' THEN 7
            WHEN step = 'access-requestConfirmation' THEN 8
            WHEN step = 'energuideAssessment' THEN 9
            WHEN step = 'returningUser' THEN 10
            -- WHEN step = '--energyScoreEstimate' THEN --
            WHEN step = 'refineScore' THEN 11
            WHEN step = 'yearBuilt' THEN 12
            WHEN step = 'foundationType' THEN 13
            WHEN step = 'basementType' THEN 14
            WHEN step = 'storeys' THEN 15
            WHEN step = 'floorAreas' THEN 16
            WHEN step = 'replaced' THEN 17
            WHEN step = 'roomHeating' THEN 18
            WHEN step = 'heatPump' THEN 19
            WHEN step = 'waterHeating' THEN 20
            WHEN step = 'additional' THEN 21
            WHEN step = 'glassPanes' THEN 22
            WHEN step = 'inputConfirmation' THEN 23
            WHEN step = 'reportLoading' THEN 24
            WHEN step = 'EnergyReport' THEN 25
            WHEN step = 'questionsIntro' THEN 26
            WHEN step = 'upgradeGoals' THEN 27
            WHEN step = 'propertyIssues' THEN 28
            WHEN step = 'upgradePreference' THEN 29
            WHEN step = 'upgradePlanLoading' THEN 30
            WHEN step = 'noRefinement' THEN 31
            WHEN step = 'upgradePlan' THEN 32
            WHEN step = 'getSupport' THEN 33
            WHEN step = 'dataPrivacy' THEN 34
          ELSE NULL END AS step_order,

    CONVERT_TIMEZONE('UTC', 'America/Vancouver', vba.root_tstamp) AS timestamp
    FROM atomic.ca_bc_gov_vhers_bchep_action_1  AS vba
    LEFT JOIN atomic.events ON vba.root_id = events.event_id AND vba.root_tstamp = events.collector_tstamp
    WHERE action = 'step-start'
    --- We exclude Support from the list and ignore any sections not listed
    --- NOTE: this list needs to be reflected in the latest section dimension below
    AND section IN ('landing','login','pin-request','returning-user-flow','energuide-upload','rating-estimate',
      'questionnaire-energy-report','energy-report','questionnaire-upgrade-plan','questionnaire-energy-plan',
      'upgrade-plan','energy-plan')
    AND step IN ('landing', 'welcome', 'addressConfirmation', 'addressIneligible', 'access-contactAddress',
      'access-getStarted', 'access-newCodeRequest', 'access-requestConfirmation', 'energuideAssessment',
      'returningUser', 'refineScore', 'yearBuilt', 'foundationType', 'basementType', 'storeys', 'floorAreas',
      'replaced', 'roomHeating', 'heatPump', 'waterHeating', 'additional', 'glassPanes', 'inputConfirmation',
      'reportLoading', 'EnergyReport', 'questionsIntro', 'upgradeGoals', 'propertyIssues', 'upgradePreference',
      'upgradePlanLoading', 'noRefinement', 'upgradePlan', 'getSupport', 'dataPrivacy')
    )
    SELECT
    page_urlhost,
    rl.session_id, --fs.section,
    --section,
    --section_order,
    MIN(timestamp) AS min_timestamp, MAX(timestamp) AS max_timestamp,
    MAX(step_order) AS step_order
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

dimension: latest_step {
  sql:
    CASE
      WHEN ${TABLE}.step_order = 1 THEN 'landing'
      WHEN ${TABLE}.step_order = 2 THEN 'welcome'
      WHEN ${TABLE}.step_order = 3 THEN 'addressConfirmation'
      WHEN ${TABLE}.step_order = 4 THEN 'addressIneligible'
      WHEN ${TABLE}.step_order = 5 THEN 'access-contactAddress'
      WHEN ${TABLE}.step_order = 6 THEN 'access-getStarted'
      WHEN ${TABLE}.step_order = 7 THEN 'access-newCodeRequest'
      WHEN ${TABLE}.step_order = 8 THEN 'access-requestConfirmation'
      WHEN ${TABLE}.step_order = 9 THEN 'energuideAssessment'
      WHEN ${TABLE}.step_order = 10 THEN 'returningUser'
--      WHEN ${TABLE}.step_order = -- THEN '--energyScoreEstimate'
      WHEN ${TABLE}.step_order = 11 THEN 'refineScore'
      WHEN ${TABLE}.step_order = 12 THEN 'yearBuilt'
      WHEN ${TABLE}.step_order = 13 THEN 'foundationType'
      WHEN ${TABLE}.step_order = 14 THEN 'basementType'
      WHEN ${TABLE}.step_order = 15 THEN 'storeys'
      WHEN ${TABLE}.step_order = 16 THEN 'floorAreas'
      WHEN ${TABLE}.step_order = 17 THEN 'replaced'
      WHEN ${TABLE}.step_order = 18 THEN 'roomHeating'
      WHEN ${TABLE}.step_order = 19 THEN 'heatPump'
      WHEN ${TABLE}.step_order = 20 THEN 'waterHeating'
      WHEN ${TABLE}.step_order = 21 THEN 'additional'
      WHEN ${TABLE}.step_order = 22 THEN 'glassPanes'
      WHEN ${TABLE}.step_order = 23 THEN 'inputConfirmation'
      WHEN ${TABLE}.step_order = 24 THEN 'reportLoading'
      WHEN ${TABLE}.step_order = 25 THEN 'EnergyReport'
      WHEN ${TABLE}.step_order = 26 THEN 'questionsIntro'
      WHEN ${TABLE}.step_order = 27 THEN 'upgradeGoals'
      WHEN ${TABLE}.step_order = 28 THEN 'propertyIssues'
      WHEN ${TABLE}.step_order = 29 THEN 'upgradePreference'
      WHEN ${TABLE}.step_order = 30 THEN 'upgradePlanLoading'
      WHEN ${TABLE}.step_order = 31 THEN 'noRefinement'
      WHEN ${TABLE}.step_order = 32 THEN 'upgradePlan'
      WHEN ${TABLE}.step_order = 33 THEN 'getSupport'
      WHEN ${TABLE}.step_order = 34 THEN 'dataPrivacy'
    ELSE NULL END;;
  type:  string

}
dimension: step_order {
  type: number
}

#dimension: section {
#  order_by_field: section_order
#}
#dimension: section_order {
#  type: number
#}

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
