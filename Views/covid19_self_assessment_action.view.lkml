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
          CASE when symptom_list like '%Fever%' then 1 else 0 END as fever_count,
          CASE when symptom_list like '%Cough%' then 1 else 0 END as cough_count,
          CASE when symptom_list like '%Difficult Breathing%' then 1 else 0 END as difficult_breathing_count,
          CASE when symptom_list like '%Sore Throat%' then 1 else 0 END as sore_throat_count,
          CASE when symptom_list like '%Loss of Taste or Smell%' then 1 else 0 END as loss_of_taste_or_smell_count,
          CASE when symptom_list like '%Headache%' then 1 else 0 END as headache_count,
          CASE when symptom_list like '%Fatigue%' then 1 else 0 END as fatigue_count,
          CASE when symptom_list like '%Runny nose%' then 1 else 0 END as runny_nose_count,
          CASE when symptom_list like '%Sneezing%' then 1 else 0 END as sneezing_count,
          CASE when symptom_list like '%Diarrhea%' then 1 else 0 END as diarrhea_count,
          CASE when symptom_list like '%Loss of Appetite%' then 1 else 0 END as loss_of_appetite_count,
          CASE when symptom_list like '%Nausea Vomiting%' then 1 else 0 END as nausea_vomiting_count,
          CASE when symptom_list like '%Body Aches%' then 1 else 0 END as body_aches_count
        FROM atomic.ca_bc_gov_gateway_covid19_self_assessment_action_1 ;;
    distribution_style: all
    persist_for: "2 hours"
  }
  #sql_table_name: atomic.ca_bc_gov_gateway_covid19_self_assessment_action_1 ;;

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

  dimension: symptom {
    sql: CASE
      WHEN symptom_list like '%Fever%' THEN 'Fever'
      WHEN symptom_list like '%Cough%' THEN 'Cough'
      WHEN symptom_list like '%Difficult Breathing%' THEN 'Difficult Breathing'
      WHEN symptom_list like '%Sore Throat%' THEN 'Sore Throat'
      WHEN symptom_list like '%Loss of Taste or Smell%' THEN 'Loss of Taste or Smell'
      WHEN symptom_list like '%Headache%' THEN 'Headache'
      WHEN symptom_list like '%Fatigue%' THEN 'Fatigue'
      WHEN symptom_list like '%Runny nose%' THEN 'Runny nose'
      WHEN symptom_list like '%Sneezing%' THEN 'Sneezing'
      WHEN symptom_list like '%Diarrhea%' THEN 'Diarrhea'
      WHEN symptom_list like '%Loss of Appetite%' THEN 'Loss of Appetite'
      WHEN symptom_list like '%Nausea Vomiting%' THEN 'Nausea Vomiting'
      WHEN symptom_list like '%Body Aches%' THEN 'Body Aches' ELSE NULL END
    ;;
  }

  measure: count {
    type: count
  }

}
