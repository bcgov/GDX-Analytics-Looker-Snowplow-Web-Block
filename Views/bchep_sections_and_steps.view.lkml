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
--        UNION
--      SELECT 'section' AS category, 'support' AS label, 13 AS order
      ;;
    }



  dimension: category {}
  dimension: label {}
  dimension: order {
    type: number
  }
}
