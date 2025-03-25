view: bchep_sections_and_steps {
  label: "BCHEP Sections and Steps"
  derived_table: {
    sql:
      SELECT 'section' AS category, 'landing' AS label, 'Homepage' AS newlabel, 1 AS order
        UNION
      SELECT 'section' AS category, 'login' AS label, 'Welcome' AS newlabel, 2 AS order
        UNION
      SELECT 'section' AS category, 'pin-request' AS label, 'pin-request' AS newlabel, 3 AS order
        UNION
      SELECT 'section' AS category, 'energuide-upload' AS label, 'EnerGuide upload' AS newlabel, 4 AS order
        UNION
      SELECT 'section' AS category, 'questionnaire-energy-report' AS label, 'House questionnaire' AS newlabel, 5 AS order
        UNION
      SELECT 'section' AS category, 'energy-report' AS label, 'energy-report' AS newlabel, 6 AS order
        UNION
      SELECT 'section' AS category, 'questionnaire-upgrade-plan' AS label, 'Decision aid launch and questions' AS newlabel, 7 AS order
        UNION
      SELECT 'section' AS category, 'questionnaire-energy-plan' AS label, 'questionnaire-energy-plan' AS newlabel, 8 AS order
        UNION
      SELECT 'section' AS category, 'upgrade-plan' AS label, 'Home energy plan through to next steps' AS newlabel, 9 AS order
        UNION
      SELECT 'section' AS category, 'energy-plan' AS label, 'energy-plan' AS newlabel, 11 AS order
        UNION
--      SELECT 'section' AS category, 'support' AS label, 13 AS order
--- STEPS
SELECT 'step' AS category, 'landing' AS label, 'Homepage' AS newlabel, 1 AS order
  UNION
SELECT 'step' AS category, 'welcome' AS label, 'Welcome' AS newlabel, 2 AS order
  UNION
SELECT 'step' AS category, 'addressConfirmation' AS label, 'Get started!' AS newlabel, 3 AS order
  UNION
--SELECT 'step' AS category, 'addressIneligible' AS label, '' AS newlabel, 4 AS order
--  UNION
SELECT 'step' AS category, 'access-newCodeRequest' AS label, 'Get access' AS newlabel, 4 AS order
  UNION
SELECT 'step' AS category, 'access-contactAddress' AS label, 'Mailing address' AS newlabel, 5 AS order
  UNION
SELECT 'step' AS category, 'access-requestConfirmation' AS label, 'Thanks for request' AS newlabel, 6 AS order
  UNION
SELECT 'step' AS category, 'access-getStarted' AS label, 'Homeowner login' AS newlabel, 7 AS order
  UNION
SELECT 'step' AS category, 'energuideAssessment' AS label, 'EnerGuide upload' AS newlabel, 8 AS order
  UNION
--SELECT 'step' AS category, 'returningUser' AS label, '' AS newlabel, 10 AS order
--  UNION
SELECT 'step' AS category, 'refineScore' AS label, '' AS newlabel, 9 AS order
  UNION
SELECT 'step' AS category, 'yearBuilt' AS label, 'Year built' AS newlabel, 10 AS order
  UNION
SELECT 'step' AS category, 'foundationType' AS label, 'Foundation' AS newlabel, 1 AS order
  UNION
SELECT 'step' AS category, 'basementType' AS label, 'Basement' AS newlabel, 12 AS order
  UNION
SELECT 'step' AS category, 'storeys' AS label, '' AS newlabel, 13 AS order
  UNION
SELECT 'step' AS category, 'floorAreas' AS label, 'Floor areas' AS newlabel, 14 AS order
  UNION
SELECT 'step' AS category, 'replaced' AS label, 'Replacements' AS newlabel, 15 AS order
  UNION
SELECT 'step' AS category, 'roomHeating' AS label, 'Space heating' AS newlabel, 16 AS order
  UNION
SELECT 'step' AS category, 'heatPump' AS label, 'Heat pump' AS newlabel, 17 AS order
  UNION
SELECT 'step' AS category, 'waterHeating' AS label, 'Water heating' AS newlabel, 18 AS order
  UNION
SELECT 'step' AS category, 'additional' AS label, 'Additional items' AS newlabel, 19 AS order
  UNION
SELECT 'step' AS category, 'glassPanes' AS label, 'Window panes' AS newlabel, 20 AS order
  UNION
SELECT 'step' AS category, 'inputConfirmation' AS label, 'Confirm answers' AS newlabel, 21 AS order
  UNION
SELECT 'step' AS category, 'reportLoading' AS label, 'Report loading' AS newlabel, 22 AS order
  UNION
SELECT 'step' AS category, 'EnergyReport' AS label, 'Energy report' AS newlabel, 23 AS order
  UNION
SELECT 'step' AS category, 'questionsIntro' AS label, 'Decision aid launch' AS newlabel, 24 AS order
  UNION
SELECT 'step' AS category, 'upgradeGoals' AS label, 'Decision aid motivations' AS newlabel, 25 AS order
  UNION
SELECT 'step' AS category, 'propertyIssues' AS label, 'Decision aid issues' AS newlabel, 26 AS order
  UNION
-- SELECT 'step' AS category, 'upgradePreference' AS label, '' AS newlabel, 29 AS order
--   UNION
SELECT 'step' AS category, 'upgradePlanLoading' AS label, 'Plan loading' AS newlabel, 27 AS order
--   UNION
-- SELECT 'step' AS category, 'noRefinement' AS label, '' AS newlabel, 31 AS order
  UNION
SELECT 'step' AS category, 'upgradePlan' AS label, '' AS newlabel, 28 AS order
--   UNION
-- SELECT 'step' AS category, 'getSupport' AS label, '' AS newlabel, 33 AS order
--   UNION
-- SELECT 'step' AS category, 'dataPrivacy' AS label, '' AS newlabel, 34 AS order

      ;;
    }



  dimension: category {}
  dimension: label {}
  dimension: newlabel {
    sql: CASE WHEN ${TABLE}.newlabel <> '' THEN ${TABLE}.newlabel ELSE ${TABLE}.label END ;;
  }
  dimension: order {
    type: number
  }
}
