# This explore file contains the Aggregate Aware tables for the sessions explore

include: "/Includes/*.view"

include: "/snowplow_web_block.model"

explore: +sessions {
  aggregate_table: rollup__date_window {
    query: {
      dimensions: [
        cmslite_themes.node_id,
        cmslite_themes.theme_id,
        cmslite_themes.theme,
        cmslite_themes.topic,
        cmslite_themes.subtheme,
        sessions.app_id,
        sessions.first_page_exclusion_filter,
        sessions.first_page_section,
        sessions.first_page_sub_section,
        sessions.first_page_urlhost,
        sessions.node_id,
        date_window
      ]
      measures: [average_session_length]
      filters: [
        sessions.flexible_filter_date_range: "7 days ago for 7 days",
        sessions.is_in_current_period_or_last_period: "Yes"
      ]
      sorts: [
        sessions.node_id: desc
      ]
    }
    materialization: {
      datagroup_trigger: aa_datagroup_cmsl_loaded
    }
  }
}
