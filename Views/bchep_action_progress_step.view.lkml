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
          dvce_ismobile AS is_mobile,
          CASE WHEN section = 'landing' THEN 1
          WHEN section = 'login' THEN 2
          WHEN section = 'pin-request' THEN 3
          WHEN section = 'energuide-upload' THEN 4
          -- Returning-user-flow
          WHEN section = 'questionnaire-energy-report' THEN 5
          -- Rating-estimate
          WHEN section = 'energy-report' THEN 6
          WHEN section = 'questionnaire-upgrade-plan' THEN 7
          WHEN section = 'questionnaire-energy-plan' THEN 8
          WHEN section = 'upgrade-plan' THEN 9
          WHEN section = 'energy-plan' THEN 10
          WHEN section = 'support' THEN 11
          ELSE NULL END AS section_order,

          step,
          CASE
            WHEN step = 'landing' THEN 1
            WHEN step = 'welcome' THEN 2
            WHEN step = 'addressConfirmation' THEN 3
            --WHEN step = 'addressIneligible' THEN 4
            WHEN step = 'access-newCodeRequest' THEN 4
            WHEN step = 'access-contactAddress' THEN 5
            WHEN step = 'access-requestConfirmation' THEN 6
            WHEN step = 'access-getStarted' THEN 7
            WHEN step = 'energuideAssessment' THEN 8
            -- WHEN step = 'returningUser' THEN 10
            -- WHEN step = '--energyScoreEstimate' THEN --
            WHEN step = 'refineScore' THEN 9
            WHEN step = 'yearBuilt' THEN 10
            WHEN step = 'foundationType' THEN 11
            WHEN step = 'basementType' THEN 12
            WHEN step = 'storeys' THEN 13
            WHEN step = 'floorAreas' THEN 14
            WHEN step = 'replaced' THEN 15
            WHEN step = 'roomHeating' THEN 16
            WHEN step = 'heatPump' THEN 17
            WHEN step = 'waterHeating' THEN 18
            WHEN step = 'additional' THEN 19
            WHEN step = 'glassPanes' THEN 20
            WHEN step = 'inputConfirmation' THEN 21
            WHEN step = 'reportLoading' THEN 22
            WHEN step = 'EnergyReport' THEN 23
            WHEN step = 'questionsIntro' THEN 24
            WHEN step = 'upgradeGoals' THEN 25
            WHEN step = 'propertyIssues' THEN 26
            --WHEN step = 'upgradePreference' THEN 29
            WHEN step = 'upgradePlanLoading' THEN 27
            --WHEN step = 'noRefinement' THEN 31
            WHEN step = 'upgradePlan' THEN 28
            --WHEN step = 'getSupport' THEN 33
            --WHEN step = 'dataPrivacy' THEN 34
          ELSE NULL END AS step_order,

    CONVERT_TIMEZONE('UTC', 'America/Vancouver', vba.root_tstamp) AS timestamp
    FROM atomic.ca_bc_gov_vhers_bchep_action_1  AS vba
    LEFT JOIN atomic.events ON vba.root_id = events.event_id AND vba.root_tstamp = events.collector_tstamp
    WHERE
     {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key

    --- We exclude Support from the list and ignore any sections not listed
    --- NOTE: this list needs to be reflected in the latest section dimension below
    --- 2024-11-05 also removed returning-user-flow and rating-estimate
    AND section IN ('landing','login','pin-request','energuide-upload',
          'questionnaire-energy-report','energy-report','questionnaire-upgrade-plan','questionnaire-energy-plan',
          'upgrade-plan','energy-plan')
    -- Removed upgradePreference, noRefinement, getSupport, dataPrivacy, returningUser, addressIneligible
    AND step IN ('landing', 'welcome', 'addressConfirmation', 'access-contactAddress',
      'access-getStarted', 'access-newCodeRequest', 'access-requestConfirmation', 'energuideAssessment',
      'refineScore', 'yearBuilt', 'foundationType', 'basementType', 'storeys', 'floorAreas',
      'replaced', 'roomHeating', 'heatPump', 'waterHeating', 'additional', 'glassPanes', 'inputConfirmation',
      'reportLoading', 'EnergyReport', 'questionsIntro', 'upgradeGoals', 'propertyIssues',
      'upgradePlanLoading', 'upgradePlan')
    )
    SELECT
    page_urlhost,
    rl.session_id,
    is_mobile,
    --fs.section,
    --section,
    --section_order,
    MIN(timestamp) AS min_timestamp, MAX(timestamp) AS max_timestamp,
    MAX(step_order) AS step_order
    FROM raw_list AS rl
    --JOIN final_step AS fs ON fs.session_id = rl.session_id AND fs.session_id_ranked = 1
    GROUP BY 1,2,3


    ;;
  distribution: "session_id"
  sortkeys: ["session_id","min_timestamp"]
  datagroup_trigger: datagroup_healthgateway_updated
  increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
  # to reprocess up to 3 hours of results
  increment_offset: 3
}

extends: [date_comparisons_common]

dimension_group: filter_start {
  sql: ${TABLE}.min_timestamp ;;
}

dimension_group: event {
  sql: ${TABLE}.min_timestamp ;;
  type: time
  timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
}

dimension: session_id {}
dimension: page_urlhost {
  type: string
  sql: ${TABLE}.page_urlhost ;;
}
dimension: is_mobile {
  type: yesno
}
dimension: latest_step {
  sql:
    CASE
      WHEN ${TABLE}.step_order = 1 THEN 'landing'
      WHEN ${TABLE}.step_order = 2 THEN 'welcome'
      WHEN ${TABLE}.step_order = 3 THEN 'addressConfirmation'
      --WHEN ${TABLE}.step_order = 4 THEN 'addressIneligible'
      WHEN ${TABLE}.step_order = 4 THEN 'access-newCodeRequest'
      WHEN ${TABLE}.step_order = 5 THEN 'access-contactAddress'
      WHEN ${TABLE}.step_order = 6 THEN 'access-requestConfirmation'
      WHEN ${TABLE}.step_order = 7 THEN 'access-getStarted'
      WHEN ${TABLE}.step_order = 8 THEN 'energuideAssessment'
      -- WHEN ${TABLE}.step_order = 10 THEN 'returningUser'
--      WHEN ${TABLE}.step_order = -- THEN '--energyScoreEstimate'
      WHEN ${TABLE}.step_order = 9 THEN 'refineScore'
      WHEN ${TABLE}.step_order = 10 THEN 'yearBuilt'
      WHEN ${TABLE}.step_order = 11 THEN 'foundationType'
      WHEN ${TABLE}.step_order = 12 THEN 'basementType'
      WHEN ${TABLE}.step_order = 13 THEN 'storeys'
      WHEN ${TABLE}.step_order = 14 THEN 'floorAreas'
      WHEN ${TABLE}.step_order = 15 THEN 'replaced'
      WHEN ${TABLE}.step_order = 16 THEN 'roomHeating'
      WHEN ${TABLE}.step_order = 17 THEN 'heatPump'
      WHEN ${TABLE}.step_order = 18 THEN 'waterHeating'
      WHEN ${TABLE}.step_order = 19 THEN 'additional'
      WHEN ${TABLE}.step_order = 20 THEN 'glassPanes'
      WHEN ${TABLE}.step_order = 21 THEN 'inputConfirmation'
      WHEN ${TABLE}.step_order = 22 THEN 'reportLoading'
      WHEN ${TABLE}.step_order = 23 THEN 'EnergyReport'
      WHEN ${TABLE}.step_order = 24 THEN 'questionsIntro'
      WHEN ${TABLE}.step_order = 25 THEN 'upgradeGoals'
      WHEN ${TABLE}.step_order = 26 THEN 'propertyIssues'
      --WHEN ${TABLE}.step_order = 29 THEN 'upgradePreference'
      WHEN ${TABLE}.step_order = 27 THEN 'upgradePlanLoading'
      --WHEN ${TABLE}.step_order = 31 THEN 'noRefinement'
      WHEN ${TABLE}.step_order = 28 THEN 'upgradePlan'
      --WHEN ${TABLE}.step_order = 33 THEN 'getSupport'
      --WHEN ${TABLE}.step_order = 34 THEN 'dataPrivacy'
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
