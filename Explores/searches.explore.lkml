# This explore file contains the Aggregate Aware tables for the searches explore

# include all include files
include: "/Includes/*.view"

include: "/snowplow_web_block.model"

explore: +searches {
  aggregate_table: aa__top_gov_searches__7_complete_days__row_count {
    query: {
      dimensions: [
        searches.search_terms_gov,
        cmslite_themes.node_id,
        cmslite_themes.theme_id,
        cmslite_themes.theme,
        cmslite_themes.topic,
        cmslite_themes.subtheme,
        searches.search_terms,
        searches.node_id,
        searches.page_display_url,
        searches.page_title,
        searches.page_urlhost,
        searches.page_exclusion_filter,
        searches.app_id,
        searches.page_section,
        searches.page_sub_section,
        searches.search_time_date
      ]
      measures: [searches.row_count]
      filters: [
        searches.search_time_date: "7 days ago for 7 days"
      ]
    }

    materialization: {
      datagroup_trigger: aa_datagroup_cmsl_loaded
    }
  }
}
