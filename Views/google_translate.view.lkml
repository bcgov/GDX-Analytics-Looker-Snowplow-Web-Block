view: google_translate {
  derived_table: {
    sql:SELECT google_translate.*, language_lookup.language_name, wp.id as page_view_id
        FROM atomic.ca_bc_gov_googtrans_google_translate_1 AS google_translate
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON google_translate.root_id = wp.root_id
        AND google_translate.root_tstamp = wp.root_tstamp
        JOIN google.google_translate_languages as language_lookup on SPLIT_PART(google_translate.translation_data,'/',3) =  language_lookup.language_code ;;
    distribution_style: all
    persist_for: "2 hours"
  }

  # Dimensions

  dimension: translation_data {
    description: "The raw googtrans cookie value"
    type: string
    sql: ${TABLE}.translation_data ;;
  }

  dimension: source_language {
    description: "The original language of the translated site"
    type: string
    sql: SPLIT_PART(${TABLE}.translation_data,'/',2)  ;;
  }

  dimension: target_language_code {
    description: "The target language code of the translated site"
    type: string
    sql: SPLIT_PART(${TABLE}.translation_data,'/',3)  ;;
  }

  dimension: target_language_name {
    description: "The target language of the translated site"
    type: string
    sql: ${TABLE}.language_name  ;;
    drill_fields: [page_views.page_display_url, page_views.page_title]
  }

  dimension: page_view_id {
    description: "Unique page view ID"
    primary_key: yes
    type: string
    sql: ${TABLE}.page_view_id ;;
  }

  dimension: root_tstamp {
    description: "The timestamp of the translation event."
    type: string
    sql: ${TABLE}.root_tstamp ;;
  }

  dimension: schema_vendor {
    description: "The schema vendor."
    type: string
    sql: ${TABLE}.schema_vendor ;;
  }

  dimension: schema_name {
    description: "The schema name."
    type: string
    sql: ${TABLE}.schema_name ;;
  }

  dimension: schema_format {
    description: "The schema format."
    type: string
    sql: ${TABLE}.schema_format ;;
  }

  dimension: schema_version {
    description: "The schema version."
    type: string
    sql: ${TABLE}.schema_version ;;
  }

  dimension: ref_root {
    hidden:  yes
    type: string
    sql: ${TABLE}.ref_root ;;
  }

  dimension: ref_tree {
    hidden:  yes
    sql: ${TABLE}.ref_tree ;;
  }

  dimension: ref_parents {
    hidden:  yes
    sql: ${TABLE}.ref_parents ;;
  }

  # Measures

  measure: count_translations {
    description: "Count of translation events."
    type: count
    drill_fields: [target_language_name, count_translations, page_views.page_title, page_views.page_display_url]
  }
}
