view: cmslite_metadata {
  derived_table: {
    sql:  SELECT
            cm.node_id,
            cm.title,
            cm.hr_url,
            cm.language_code,
            cm.language_name,
            cdl.value AS cdl_language,
            published_date
          FROM cmslite.metadata AS cm
          LEFT JOIN cmslite.metadata_languages AS cml ON cm.node_id = cml.node_id
          LEFT JOIN cmslite.dcterms_languages AS cdl ON cdl.id = cml.id;;

    distribution_style: all
    persist_for: "24 hours"
    }
  dimension: node_id {}
  dimension: title {}
  dimension: hr_url {}
  dimension: cdl_language {
    label: "Metadata Language Tags"
    description: "The language tags from the CMS Lite Metadata tab."
  }
  dimension: language {
    type: string
    sql: ${TABLE}.language_name ;;
    description: "The language specified in the CMS Lite page settings tab."
  }
  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
    description: "The language code specified in the CMS Lite page settings tab."
  }

  dimension_group: published {
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
    sql: ${TABLE}.published_date ;;
  }
}
