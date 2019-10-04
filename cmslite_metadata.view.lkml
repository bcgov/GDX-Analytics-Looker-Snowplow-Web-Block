view: cmslite_metadata {
  derived_table: {
    sql: SELECT cm.*, cdl.value AS language FROM cmslite.metadata AS cm
          LEFT JOIN cmslite.metadata_languages AS cml ON cm.node_id = cml.node_id
          LEFT JOIN cmslite.dcterms_languages AS cdl ON cdl.id = cml.id;;

    distribution_style: all
    persist_for: "24 hours"
    }

  dimension: node_id {}
  dimension: title {}
  dimension: hr_url {}
  dimension: language {}
  dimension: page_language {
    type: string
    sql: ${TABLE}.language_name ;;
    description: "The language specified in the CMS Lite page settings tab"
  }
  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
    description: "The language code specified in the CMS Lite page settings tab"
  }
}
