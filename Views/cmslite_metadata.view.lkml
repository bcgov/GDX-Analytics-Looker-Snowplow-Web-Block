include: "//cmslite_metadata/views/metadata.view"
include: "//cmslite_metadata/views/metadata_languages.view"
include: "//cmslite_metadata/views/dcterms_languages.view"

view: cmslite_metadata {
  derived_table: {
    sql:  SELECT cm.*,
      cdl.value AS cdl_language
    FROM ${metadata.SQL_TABLE_NAME} AS cm
    LEFT JOIN ${metadata_languages.SQL_TABLE_NAME} AS cml ON cm.node_id = cml.node_id
    LEFT JOIN ${dcterms_languages.SQL_TABLE_NAME} AS cdl ON cdl.id = cml.id;;

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
}
