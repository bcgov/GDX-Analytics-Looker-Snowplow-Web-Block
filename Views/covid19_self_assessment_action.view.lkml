# Version: 1.0.1
view: covid19_self_assessment_action {
  derived_table: {
    sql: SELECT
          action,
          ref_parent,
          ref_root,
          ref_tree,
          root_id,
          root_tstamp,
          schema_format,
          schema_name,
          schema_vendor,
          stage_id,
          stage_name,
          symptom_list,
          CASE WHEN symptom_list like '%Fever%' then 1 ELSE 0 END AS fever_count,
          CASE WHEN symptom_list like '%Cough%' then 1 ELSE 0 END AS cough_count,
          CASE WHEN symptom_list like '%Difficult Breathing%' then 1 ELSE 0 END AS difficult_breathing_count,
          CASE WHEN symptom_list like '%Sore Throat%' then 1 ELSE 0 END AS sore_throat_count,
          CASE WHEN symptom_list like '%Loss of Taste or Smell%' then 1 ELSE 0 END AS loss_of_taste_or_smell_count,
          CASE WHEN symptom_list like '%Headache%' then 1 ELSE 0 END AS headache_count,
          CASE WHEN symptom_list like '%Fatigue%' then 1 ELSE 0 END AS fatigue_count,
          CASE WHEN symptom_list like '%Runny nose%' then 1 ELSE 0 END AS runny_nose_count,
          CASE WHEN symptom_list like '%Sneezing%' then 1 ELSE 0 END AS sneezing_count,
          CASE WHEN symptom_list like '%Diarrhea%' then 1 ELSE 0 END AS diarrhea_count,
          CASE WHEN symptom_list like '%Loss of Appetite%' then 1 ElSE 0 END AS loss_of_appetite_count,
          CASE WHEN symptom_list like '%Nausea Vomiting%' then 1 ELSE 0 END AS nausea_vomiting_count,
          CASE WHEN symptom_list like '%Body Aches%' then 1 ELSE 0 END AS body_aches_count,
          CASE WHEN symptom_list like '%None%' then 1 ELSE 0 END AS no_symptoms
        FROM atomic.ca_bc_gov_gateway_covid19_self_assessment_action_1 as action ;;
    distribution_style: all
    persist_for: "2 hours"
  }

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension: ref_parent {
    type: string
    sql: ${TABLE}.ref_parent ;;
  }

  dimension: ref_root {
    type: string
    sql: ${TABLE}.ref_root ;;
  }

  dimension: ref_tree {
    type: string
    sql: ${TABLE}.ref_tree ;;
  }

  dimension: root_id {
    type: string
    sql: ${TABLE}.root_id ;;
  }

  dimension_group: root_tstamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.root_tstamp ;;
  }

  dimension: schema_format {
    type: string
    sql: ${TABLE}.schema_format ;;
  }

  dimension: schema_name {
    type: string
    sql: ${TABLE}.schema_name ;;
  }

  dimension: schema_vendor {
    type: string
    sql: ${TABLE}.schema_vendor ;;
  }

  dimension: schema_version {
    type: string
    sql: ${TABLE}.schema_version ;;
  }

  dimension: stage_id {
    type: number
    sql: ${TABLE}.stage_id ;;
  }

  dimension: stage_name {
    type: string
    sql: ${TABLE}.stage_name ;;
  }

  dimension: symptom_list {
    type: string
    sql: ${TABLE}.symptom_list ;;
  }

  measure: count {
    type: count
  }

  measure: fever_count {
    type:  sum
    sql:${TABLE}.fever_count ;;
  }
  measure: cough_count {
    type:  sum
    sql:${TABLE}.cough_count ;;
  }
  measure: difficult_breathing_count {
    type:  sum
    sql:${TABLE}.difficult_breathing_count ;;
  }
  measure: sore_throat_count {
    type:  sum
    sql:${TABLE}.sore_throat_count ;;
  }
  measure: loss_of_taste_or_smell_count {
    type:  sum
    sql:${TABLE}.loss_of_taste_or_smell_count ;;
  }
  measure: headache_count {
    type:  sum
    sql:${TABLE}.headache_count ;;
  }
  measure: fatigue_count {
    type:  sum
    sql:${TABLE}.fatigue_count ;;
  }
  measure: runny_nose_count {
    type:  sum
    sql:${TABLE}.runny_nose_count ;;
  }
  measure: sneezing_count {
    type:  sum
    sql:${TABLE}.sneezing_count ;;
  }
  measure: diarrhea_count {
    type:  sum
    sql:${TABLE}.diarrhea_count ;;
  }
  measure: loss_of_appetite_count {
    type:  sum
    sql:${TABLE}.loss_of_appetite_count ;;
  }
  measure: nausea_vomiting_count {
    type:  sum
    sql:${TABLE}.nausea_vomiting_count ;;
  }
  measure: body_aches_count {
    type:  sum
    sql:${TABLE}.body_aches_count ;;
  }
  measure: no_symptoms_count{
    type:  sum
    sql:${TABLE}.no_symptoms ;;
  }

}
