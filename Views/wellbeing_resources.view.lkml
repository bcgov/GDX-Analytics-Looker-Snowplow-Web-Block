include: "/Includes/date_comparisons_common.view"

view: wellbeing_resources {
  label: "wellbeing.gov.bc.ca Resources"
  derived_table: {
    sql:
    WITH atom AS (
      (
        SELECT
            root_id,
            root_tstamp,
            results_count,
            search_type,
            audience,
            keyword,
            region,
            topic,
            "type" AS resource_type,
            NULL AS delivery,
            CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp
          FROM atomic.ca_bc_gov_wellbeing_wellbeing_resources_1
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      )
      UNION
      (
          SELECT
            root_id,
            root_tstamp,
            results_count,
            search_type,
            audience,
            keyword,
            region,
            topic,
            "type" AS resource_type,
            NULL AS delivery,
            CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp
          FROM atomic.ca_bc_gov_wellbeing_wellbeing_resources_2
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        )
     UNION
      (
          SELECT
            root_id,
            root_tstamp,
            results_count,
            search_type,
            audience,
            keyword,
            region,
            topic,
            "type" AS resource_type,
            delivery,
            CONVERT_TIMEZONE('UTC', 'America/Vancouver', root_tstamp) AS timestamp
          FROM atomic.ca_bc_gov_wellbeing_wellbeing_resources_3
          WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        )
      )

      SELECT
          atom.root_id AS root_id,
          wp.id AS page_view_id,domain_sessionid AS session_id,
          COALESCE(events.page_urlhost,'') AS page_urlhost,
          events.page_url,
          results_count,
          search_type,
          audience,
          keyword,
          region,
          topic,
          resource_type,
          delivery,
          --- Audiences
          CASE WHEN audience LIKE '%Child or youth%' THEN 1 ELSE 0 END AS child_or_youth_count,
          CASE WHEN audience LIKE '%Post-secondary student%' THEN 1 ELSE 0 END AS post_sec_count,
          CASE WHEN audience LIKE '%Adult%' THEN 1 ELSE 0 END AS adult_count,
          CASE WHEN audience LIKE '%Senior%' THEN 1 ELSE 0 END AS senior_count,
          CASE WHEN audience LIKE '%Person who uses drugs%' THEN 1 ELSE 0 END AS drugs_count,
          CASE WHEN audience LIKE '%Parent or caregiver%' THEN 1 ELSE 0 END AS parent_count,
          CASE WHEN audience LIKE '%Service provider%' THEN 1 ELSE 0 END AS provider_count,
          CASE WHEN audience LIKE '%Indigenous person%' THEN 1 ELSE 0 END AS indigenous_count,
          CASE WHEN audience LIKE '%First Nations person%' THEN 1 ELSE 0 END AS first_nations_count,
          CASE WHEN audience LIKE '%Inuit person%' THEN 1 ELSE 0 END AS inuit_count,
          CASE WHEN audience LIKE '%Métis person%' THEN 1 ELSE 0 END AS metis_count,
          CASE WHEN audience LIKE '%LGBTQ2S+ person%' THEN 1 ELSE 0 END AS lgbtq_count,
          CASE WHEN audience LIKE '%Person with a disability%' THEN 1 ELSE 0 END AS diasbility_count,
          CASE WHEN audience LIKE '%Newcomer%' THEN 1 ELSE 0 END AS newcomer_count,
          --- Regions
          CASE WHEN region LIKE '%Fraser Health%' THEN 1 ELSE 0 END AS fraser_count,
          CASE WHEN region LIKE '%Interior Health%' THEN 1 ELSE 0 END AS interior_count,
          CASE WHEN region LIKE '%Northern Health%' THEN 1 ELSE 0 END AS northern_count,
          CASE WHEN region LIKE '%Vancouver Coastal Health%' THEN 1 ELSE 0 END AS vancouver_count,
          CASE WHEN region LIKE '%Island Health%' THEN 1 ELSE 0 END AS island_count,
          --- Topics
          CASE WHEN topic LIKE '%Addiction and recovery%' THEN 1 ELSE 0 END AS addiction_count,
          CASE WHEN topic LIKE '%Understanding mental health%' THEN 1 ELSE 0 END AS understanding_count,
          CASE WHEN topic LIKE '%Mental health care%' THEN 1 ELSE 0 END AS mental_health_count,
          CASE WHEN topic LIKE '%Depression%' THEN 1 ELSE 0 END AS depression_count,
          CASE WHEN topic LIKE '%Alcohol%' THEN 1 ELSE 0 END AS alcohol_count,
          CASE WHEN topic LIKE '%Drug use%' THEN 1 ELSE 0 END AS drug_count,
          CASE WHEN topic LIKE '%Relationship or family violence%' THEN 1 ELSE 0 END AS violence_count,
          CASE WHEN topic LIKE '%Stress%' THEN 1 ELSE 0 END AS stress_count,
          CASE WHEN topic LIKE '%Eating and body image%' THEN 1 ELSE 0 END AS eating_count,
          CASE WHEN topic LIKE '%Anxiety%' THEN 1 ELSE 0 END AS anxiety_count,
          CASE WHEN topic LIKE '%Understanding wellness%' THEN 1 ELSE 0 END AS wellness_topic_count,
          CASE WHEN topic LIKE '%Grief and loss%' THEN 1 ELSE 0 END AS grief_count,
          CASE WHEN topic LIKE '%In crisis%' THEN 1 ELSE 0 END AS crisis_count,
          CASE WHEN topic LIKE '%Mental illness%' THEN 1 ELSE 0 END AS mentalillness_count,
          CASE WHEN topic LIKE '%Support needs%' THEN 1 ELSE 0 END AS supportneeds_count,
          CASE WHEN topic LIKE '%Victim support%' THEN 1 ELSE 0 END AS victimsupport_count,
          --- Resource Types
          CASE WHEN resource_type LIKE '%Counselling%' THEN 1 ELSE 0 END AS counselling_count,
          CASE WHEN resource_type LIKE '%Translation Services%' THEN 1 ELSE 0 END AS translation_count,
          CASE WHEN resource_type LIKE '%Information and tools%' THEN 1 ELSE 0 END AS tools_count,
          CASE WHEN resource_type LIKE '%Help navigating services%' THEN 1 ELSE 0 END AS navigating_count,
          CASE WHEN resource_type LIKE '%Help hotlines%' THEN 1 ELSE 0 END AS hotlines_count,
          CASE WHEN resource_type LIKE '%Support groups%' THEN 1 ELSE 0 END AS support_count,
          CASE WHEN resource_type LIKE '%In-person services%' THEN 1 ELSE 0 END AS in_person_count,
          CASE WHEN resource_type LIKE '%Culturally safe care%' THEN 1 ELSE 0 END AS culturally_count,
          CASE WHEN resource_type LIKE '%Wellness programs%' THEN 1 ELSE 0 END AS wellness_count,
          CASE WHEN resource_type LIKE '%Virtual supports%' THEN 1 ELSE 0 END AS virtual_count,
          CASE WHEN resource_type LIKE '%Treatment services%' THEN 1 ELSE 0 END AS treatment_count,
          CASE WHEN resource_type LIKE '%Mental health intake%' THEN 1 ELSE 0 END AS intake_count,
          CASE WHEN resource_type LIKE '%Peer support%' THEN 1 ELSE 0 END AS peer_count,
           --- Resource Types
          CASE WHEN delivery LIKE '%In Person"%' THEN 1 ELSE 0 END AS inperson_count,
          CASE WHEN delivery LIKE '%Virtual & Telephone%' THEN 1 ELSE 0 END AS virtualtel_count,
          ---
          atom.timestamp

        FROM atom
          LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON atom.root_id = wp.root_id AND atom.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON atom.root_id = events.event_id AND atom.root_tstamp = events.collector_tstamp
--        WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
        ;;
    distribution_style: all
    datagroup_trigger: datagroup_10_40
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
  }


  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }
  dimension: page_url {}

  dimension: results_count {}
  dimension: search_type {}
  dimension: audience {}
  dimension: keyword {}
  dimension: region {}
  dimension: topic {}
  dimension: resource_type {}
  dimension: delivery {}


  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  measure: count {
    type: count
  }

  measure: session_count {
    description: "Count of the outcome over distinct Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

  measure: child_or_youth_count {
    type: sum
    group_label: "Resource Counts"
    label: "Child or youth count"
  }
  measure: post_sec_count {
    type: sum
    group_label: "Resource Counts"
    label: "Post-secondary student count"
  }
  measure: adult_count {
    type: sum
    group_label: "Resource Counts"
    label: "Adult count"
  }
  measure: senior_count {
    type: sum
    group_label: "Resource Counts"
    label: "Senior count"
  }
  measure: drugs_count {
    type: sum
    group_label: "Resource Counts"
    label: "Person who uses drugs count"
  }
  measure: parent_count {
    type: sum
    group_label: "Resource Counts"
    label: "Parent or caregiver count"
  }
  measure: provider_count {
    type: sum
    group_label: "Resource Counts"
    label: "Service provider count"
  }
  measure: indigenous_count {
    type: sum
    group_label: "Resource Counts"
    label: "Indigenous person count"
  }
  measure: first_nations_count {
    type: sum
    group_label: "Resource Counts"
    label: "First Nations person count"
  }
  measure: inuit_count {
    type: sum
    group_label: "Resource Counts"
    label: "Inuit person count"
  }
  measure: metis_count {
    type: sum
    group_label: "Resource Counts"
    label: "Métis person count"
  }
  measure: lgbtq_count {
    type: sum
    group_label: "Resource Counts"
    label: "LGBTQ2S+ person count"
  }
  measure: diasbility_count {
    type: sum
    group_label: "Resource Counts"
    label: "Person with a disability count"
  }
  measure: newcomer_count {
    type: sum
    group_label: "Resource Counts"
    label: "Newcomer count"
  }

  measure: fraser_count {
    type: sum
    label: "Fraser Health count"
    group_label: "Region Counts"
  }
  measure: interior_count {
    type: sum
    label: "Interior Health count"
    group_label: "Region Counts"
  }
  measure: northern_count {
    type: sum
    label: "Northern Health count"
    group_label: "Region Counts"
  }
  measure: vancouver_count {
    type: sum
    label: "Vancouver Coastal Health count"
    group_label: "Region Counts"
  }
  measure: island_count {
    type: sum
    label: "Island Health count"
    group_label: "Region Counts"
  }

  measure: counselling_count {
    type: sum
    label: "Counselling count"
    group_label: "Resource Type Counts"
  }
  measure: translation_count {
    type: sum
    label: "Translation Services count"
    group_label: "Resource Type Counts"
  }
  measure: tools_count {
    type: sum
    label: "Information and tools count"
    group_label: "Resource Type Counts"
  }
  measure: navigating_count {
    type: sum
    label: "Help navigating services count"
    group_label: "Resource Type Counts"
  }
  measure: hotlines_count {
    type: sum
    label: "Help hotlines count"
    group_label: "Resource Type Counts"
  }
  measure: support_count {
    type: sum
    label: "Support groups count"
    group_label: "Resource Type Counts"
  }
  measure: in_person_count {
    type: sum
    label: "In-person services count"
    group_label: "Resource Type Counts"
  }
  measure: culturally_count {
    type: sum
    label: "Culturally safe care count"
    group_label: "Resource Type Counts"
  }
  measure: wellness_count {
    type: sum
    label: "Wellness programs count"
    group_label: "Resource Type Counts"
  }
  measure: virtual_count {
    type: sum
    label: "Virtual supports count"
    group_label: "Resource Type Counts"
  }
  measure: treatment_count {
    type: sum
    label: "Treatment services count"
    group_label: "Resource Type Counts"
  }
  measure: intake_count {
    type: sum
    label: "Mental health intake count"
    group_label: "Resource Type Counts"
  }
  measure: peer_count {
    type: sum
    label: "Peer support count"
    group_label: "Resource Type Counts"
  }


  measure: addiction_count {
    type: sum
    label: "Addiction and recovery count"
    group_label: "Topic Counts"
  }
  measure: understanding_count {
    type: sum
    label: "Understanding mental health count"
    group_label: "Topic Counts"
  }
  measure: mental_health_count {
    type: sum
    label: "Mental health care count"
    group_label: "Topic Counts"
  }
  measure: depression_count {
    type: sum
    label: "Depression count"
    group_label: "Topic Counts"
  }
  measure: alcohol_count {
    type: sum
    label: "Alcohol count"
    group_label: "Topic Counts"
  }
  measure: drug_count {
    type: sum
    label: "Drug use count"
    group_label: "Topic Counts"
  }
  measure: violence_count {
    type: sum
    label: "Relationship or family violence count"
    group_label: "Topic Counts"
  }
  measure: stress_count {
    type: sum
    label: "Stress count"
    group_label: "Topic Counts"
  }
  measure: eating_count {
    type: sum
    label: "Eating and body image count"
    group_label: "Topic Counts"
  }
  measure: anxiety_count {
    type: sum
    label: "Anxiety count"
    group_label: "Topic Counts"
  }
  measure: wellness_topic_count {
    type: sum
    label: "Understanding wellness count"
    group_label: "Topic Counts"
  }
  measure: grief_count {
    type: sum
    label: "Grief and loss count"
    group_label: "Topic Counts"
  }
  measure: crisis_count {
    type: sum
    label: "In crisis count"
    group_label: "Topic Counts"
  }
  measure: mentalillness_count {
    type: sum
    label: "Mental illness count"
    group_label: "Topic Counts"
  }
  measure: supportneeds_count {
    type: sum
    label: "Support needs count"
    group_label: "Topic Counts"
  }
  measure: victimsupport_count {
    type: sum
    label: "Victim support count"
    group_label: "Topic Counts"
  }

  measure: inperson_count {
    type: sum
    label: "In Person count"
    group_label: "Delivery Counts"
  }
  measure: virtualtel_count {
    type: sum
    label: "Virtual & Telephone count"
    group_label: "Delivery Counts"
  }
}
