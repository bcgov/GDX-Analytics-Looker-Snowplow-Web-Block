view: bchep_sections_and_steps {
  label: "BCHEP Sections and Steps"
  derived_table: {
    sql:
      SELECT 'section' AS category, 'landing' AS label, 1 AS order
        UNION
      SELECT 'section' AS category, 'login' AS label, 2 AS order
        UNION
      SELECT 'section' AS category, 'pin-request' AS label, 3 AS order
        UNION
      SELECT 'section' AS category, 'returning-user-flow' AS label, 4 AS order
        UNION
      SELECT 'section' AS category, 'energuide-upload' AS label, 5 AS order
        UNION
      SELECT 'section' AS category, 'rating-estimate' AS label, 6 AS order
        UNION
      SELECT 'section' AS category, 'questionnaire-energy-report' AS label, 7 AS order
        UNION
      SELECT 'section' AS category, 'energy-report' AS label, 8 AS order
        UNION
      SELECT 'section' AS category, 'questionnaire-upgrade-plan' AS label, 9 AS order
        UNION
      SELECT 'section' AS category, 'questionnaire-energy-plan' AS label, 10 AS order
        UNION
      SELECT 'section' AS category, 'upgrade-plan' AS label, 11 AS order
        UNION
      SELECT 'section' AS category, 'energy-plan' AS label, 12 AS order
        UNION
--      SELECT 'section' AS category, 'support' AS label, 13 AS order
--- STEPS
SELECT 'step' AS category, 'landing' AS label, 1 AS order
  UNION
SELECT 'step' AS category, 'welcome' AS label, 2 AS order
  UNION
SELECT 'step' AS category, 'addressConfirmation' AS label, 3 AS order
  UNION
SELECT 'step' AS category, 'addressIneligible' AS label, 4 AS order
  UNION
SELECT 'step' AS category, 'access-contactAddress' AS label, 5 AS order
  UNION
SELECT 'step' AS category, 'access-getStarted' AS label, 6 AS order
  UNION
SELECT 'step' AS category, 'access-newCodeRequest' AS label, 7 AS order
  UNION
SELECT 'step' AS category, 'access-requestConfirmation' AS label, 8 AS order
  UNION
SELECT 'step' AS category, 'energuideAssessment' AS label, 9 AS order
  UNION
SELECT 'step' AS category, 'returningUser' AS label, 10 AS order
  UNION
SELECT 'step' AS category, 'refineScore' AS label, 11 AS order
  UNION
SELECT 'step' AS category, 'yearBuilt' AS label, 12 AS order
  UNION
SELECT 'step' AS category, 'foundationType' AS label, 13 AS order
  UNION
SELECT 'step' AS category, 'basementType' AS label, 14 AS order
  UNION
SELECT 'step' AS category, 'storeys' AS label, 15 AS order
  UNION
SELECT 'step' AS category, 'floorAreas' AS label, 16 AS order
  UNION
SELECT 'step' AS category, 'replaced' AS label, 17 AS order
  UNION
SELECT 'step' AS category, 'roomHeating' AS label, 18 AS order
  UNION
SELECT 'step' AS category, 'heatPump' AS label, 19 AS order
  UNION
SELECT 'step' AS category, 'waterHeating' AS label, 20 AS order
  UNION
SELECT 'step' AS category, 'additional' AS label, 21 AS order
  UNION
SELECT 'step' AS category, 'glassPanes' AS label, 22 AS order
  UNION
SELECT 'step' AS category, 'inputConfirmation' AS label, 23 AS order
  UNION
SELECT 'step' AS category, 'reportLoading' AS label, 24 AS order
  UNION
SELECT 'step' AS category, 'EnergyReport' AS label, 25 AS order
  UNION
SELECT 'step' AS category, 'questionsIntro' AS label, 26 AS order
  UNION
SELECT 'step' AS category, 'upgradeGoals' AS label, 27 AS order
  UNION
SELECT 'step' AS category, 'propertyIssues' AS label, 28 AS order
  UNION
SELECT 'step' AS category, 'upgradePreference' AS label, 29 AS order
  UNION
SELECT 'step' AS category, 'upgradePlanLoading' AS label, 30 AS order
  UNION
SELECT 'step' AS category, 'noRefinement' AS label, 31 AS order
  UNION
SELECT 'step' AS category, 'upgradePlan' AS label, 32 AS order
  UNION
SELECT 'step' AS category, 'getSupport' AS label, 33 AS order
  UNION
SELECT 'step' AS category, 'dataPrivacy' AS label, 34 AS order

      ;;
    }



  dimension: category {}
  dimension: label {}
  dimension: order {
    type: number
  }
}
