# This explore file contains the Aggregate Aware tables for the page_views explore

# include all include files
include: "/Includes/*.view"

include: "/snowplow_web_block.model"

explore: +page_views {
  aggregate_table: aa__top_pages__7_complete_days__row_count{
    query: {
      dimensions: [
        page_views.page_urlhost,
        page_views.node_id,
        page_views.page_exclusion_filter,
        page_views.app_id,
        page_views.page_section,
        page_views.page_sub_section,
        cmslite_themes.theme_id,
        cmslite_themes.theme,
        cmslite_themes.subtheme,
        cmslite_themes.topic,
        page_views.page_title,
        page_views.page_display_url,
        page_views.page_view_start_date
      ]
      measures: [page_views.row_count]
      filters: [
        page_views.page_view_start_date: "7 days ago for 7 days"
      ]
    }

    materialization: {
      datagroup_trigger: aa_datagroup_cmsl_loaded
    }
  }
}
explore: +page_views {  # This matches the previous AA, but adds to referrer fields.
  # This increases the row count by about 1.75x, but supports more reports
  aggregate_table: aa__page_views_with_referrers__7_complete_days__row_count {
    query: {
      dimensions: [
        page_views.page_urlhost,
        page_views.page_referrer,
        page_views.referrer_urlhost,
        page_views.page_referrer_display_url,
        page_views.node_id,
        page_views.page_exclusion_filter,
        page_views.app_id,
        page_views.page_section,
        page_views.page_sub_section,
        page_views.referrer_medium,
        cmslite_themes.theme_id,
        cmslite_themes.theme,
        cmslite_themes.subtheme,
        cmslite_themes.topic,
        page_views.page_title,
        page_views.page_display_url,
        page_views.page_view_start_date
      ]
      measures: [page_views.row_count]
      filters: [
        page_views.page_view_start_date: "7 days ago for 7 days"
      ]
    }

    materialization: {
      datagroup_trigger: aa_datagroup_cmsl_loaded
    }
  }
}

explore: +page_views {
  aggregate_table: aa__top_landing_pages__7_complete_days__row_count{
    query: {
      dimensions: [
        page_views.page_urlhost,
        page_views.page_referrer,
        page_views.node_id,
        page_views.page_exclusion_filter,
        page_views.app_id,
        page_views.page_section,
        page_views.page_sub_section,
        cmslite_themes.theme_id,
        cmslite_themes.theme,
        cmslite_themes.subtheme,
        cmslite_themes.topic,
        page_views.page_title,
        page_views.page_display_url,
        page_views.page_view_start_date
      ]
      measures: [page_views.row_count]
      filters: [
        page_views.page_view_start_date: "7 days ago for 7 days",
        page_views.page_view_in_session_index: "1"
      ]
    }

    materialization: {
      datagroup_trigger: aa_datagroup_cmsl_loaded
    }
  }
}

explore: +page_views {
  aggregate_table: aa__page_views_kpi{
    query: {
      dimensions: [
        cmslite_themes.theme_id,
        page_views.app_id,
        page_views.node_id,
        page_views.page_exclusion_filter,
        page_views.page_section,
        page_views.page_sub_section,
        page_views.page_urlhost,
        date_window
      ]
      measures: [row_count]
      filters: [
        page_views.flexible_filter_date_range: "7 days ago for 7 days",
        page_views.is_in_current_period_or_last_period: "Yes"
      ]
    }

    materialization: {
      datagroup_trigger: aa_datagroup_cmsl_loaded
    }
  }
}
