# This explore file contains the Aggregate Aware tables for the clicks explore

# include all include files
include: "/Includes/*.view"

include: "/snowplow_web_block.model"

explore: +clicks {
  aggregate_table: aa__offsite_clicks__7_complete_days__row_count {
    query: {
      dimensions: [
        clicks.target_url,
        clicks.target_display_url,
        clicks.click_type,
        clicks.offsite_click,
        clicks.node_id,
        clicks.page_exclusion_filter,
        clicks.app_id,
        clicks.page_section,
        clicks.page_sub_section,
        cmslite_themes.theme,
        cmslite_themes.subtheme,
        cmslite_themes.theme_id,
        cmslite_themes.node_id,
        cmslite_themes.topic,
        clicks.page_title,
        clicks.page_display_url,
        clicks.page_urlhost,
        clicks.click_time_date,
        clicks.offsite_click_binary
      ]
      measures: [clicks.row_count]
      filters: [
        clicks.click_time_date: "7 days ago for 7 days"
      ]
    }

    materialization: {
      datagroup_trigger: aa_datagroup_cmsl_loaded
    }
  }
}
