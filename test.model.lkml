connection: "redshift"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: test_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: test_default_datagroup

explore: ca_bc_gov_cfmspoc_addcitizen_1 {}

explore: ca_bc_gov_cfmspoc_additionalservice_1 {}

explore: ca_bc_gov_cfmspoc_addtoqueue_1 {}

explore: ca_bc_gov_cfmspoc_agent_1 {}

explore: ca_bc_gov_cfmspoc_agent_2 {}

explore: ca_bc_gov_cfmspoc_beginservice_1 {}

explore: ca_bc_gov_cfmspoc_chooseservice_1 {}

explore: ca_bc_gov_cfmspoc_chooseservice_2 {}

explore: ca_bc_gov_cfmspoc_citizen_1 {}

explore: ca_bc_gov_cfmspoc_citizen_2 {}

explore: ca_bc_gov_cfmspoc_citizen_3 {}

explore: ca_bc_gov_cfmspoc_customerleft_1 {}

explore: ca_bc_gov_cfmspoc_finish_1 {}

explore: ca_bc_gov_cfmspoc_hold_1 {}

explore: ca_bc_gov_cfmspoc_invitecitizen_1 {}

explore: ca_bc_gov_cfmspoc_invitefromhold_1 {}

explore: ca_bc_gov_cfmspoc_invitefromlist_1 {}

explore: ca_bc_gov_cfmspoc_office_1 {}

explore: ca_bc_gov_cfmspoc_returntoqueue_1 {}

explore: ca_bc_gov_meta_data_1 {}

explore: ca_bc_gov_poc_agent_1 {}

explore: ca_bc_gov_poc_application_1 {}

explore: ca_bc_gov_poc_arrival_1 {}

explore: ca_bc_gov_poc_citizen_1 {}

explore: ca_bc_gov_poc_information_1 {}

explore: ca_bc_gov_poc_office_1 {}

explore: ca_bc_gov_poc_referral_1 {}

explore: ca_bc_gov_poc_resolution_1 {}

explore: com_google_analytics_cookies_1 {}

explore: com_snowplowanalytics_snowplow_client_session_1 {}

explore: com_snowplowanalytics_snowplow_duplicate_1 {}

explore: com_snowplowanalytics_snowplow_geolocation_context_1 {}

explore: com_snowplowanalytics_snowplow_link_click_1 {}

explore: com_snowplowanalytics_snowplow_mobile_context_1 {}

explore: com_snowplowanalytics_snowplow_screen_view_1 {}

explore: com_snowplowanalytics_snowplow_timing_1 {}

explore: com_snowplowanalytics_snowplow_ua_parser_context_1 {}

explore: com_snowplowanalytics_snowplow_web_page_1 {}

explore: events {}

explore: manifest {}

explore: org_w3_performance_timing_1 {}

explore: snplow_monitor {}

explore: snplow_monitor_detail {}
