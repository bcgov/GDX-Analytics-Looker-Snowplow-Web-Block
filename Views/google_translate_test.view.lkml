view: google_translate_test {
  derived_table: {
    sql:SELECT
          google_translate.root_id,
          google_translate.translation_data,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', google_translate.root_tstamp) AS root_tstamp,
          language_lookup.language_name,
          SPLIT_PART(google_translate.translation_data,'/',2) AS source_language,
          SPLIT_PART(google_translate.translation_data,'/',3) AS target_language_code,
          COALESCE(language_lookup.language_name, target_language_code) AS target_language_name,
          wp.id AS page_view_id
        FROM atomic.ca_bc_gov_googtrans_google_translate_1 AS google_translate
        LEFT JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON google_translate.root_id = wp.root_id
        AND google_translate.root_tstamp = wp.root_tstamp
        LEFT JOIN google.google_translate_languages AS language_lookup ON SPLIT_PART(google_translate.translation_data,'/',3) = language_lookup.language_code ;;
    distribution_style: all
    datagroup_trigger: datagroup_20_50
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    increment_offset: 3 # to reprocess up to 3 hours of results
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
    sql: ${TABLE}.source_language ;;
  }

  dimension: target_language_code {
    description: "The target language code of the translated site"
    type: string
    sql: ${TABLE}.target_language_code  ;;
  }

  dimension: target_language_name {
    description: "The target language of the translated site"
    type: string
    sql: ${TABLE}.target_language_name  ;;
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

  dimension_group: event {
    sql: ${TABLE}.timestamp ;;
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }

  # Measures

  measure: count_translations {
    description: "Count of translation events."
    type: count
    drill_fields: [target_language_name, count_translations, page_views.page_title, page_views.page_display_url]
  }
}
