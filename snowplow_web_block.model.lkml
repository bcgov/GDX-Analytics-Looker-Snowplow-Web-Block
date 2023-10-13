# Version:     2.5.0
#
# Copyright (c) 2016 Snowplow Analytics Ltd. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.
#
#
# Authors:     Christophe Bogaert, Keane Robinson
# Copyright:   Copyright (c) 2016 Snowplow Analytics Ltd
# License:     Apache License Version 2.0


connection: "redshift_pacific_time"
# Set the week start day to Sunday. Default is Monday
week_start_day: sunday

# include all views in this project
include: "/Views/*.view"

# include all include files
include: "/Includes/*.view"

# include all dashboards in this project
include: "/Dashboards/*.dashboard"

# Commenting out loading of AA tables until bug is fixed in GDXDSD-3584
# include all explores in this project
include: "/Explores/*.explore"

# hidden theme_cache explore supports suggest_explore for theme, subtheme, etc. filters
# include: "//cmslite_metadata/Explores/themes_cache.explore.lkml"

# Import asset_themes view for asset downloads explore
include: "//cmslite_metadata/Views/asset_themes.view.lkml"

# Import asset_themes view for asset downloads explore
include: "//cmslite_metadata/Views/defined_security_groups.view.lkml"
include: "//cmslite_metadata/Views/inherited_security_groups.view.lkml"


# Import metadata view from cmslite_metadata project
include: "//cmslite_metadata/Views/metadata.view"

# Import CFMS POC to merge SBC TheQ data to Online Appointment booking
include: "//cfms_block/Views/cfms_poc.view.lkml"

# hidden city_cache explore supports suggest_explore for the geo filters
explore: geo_cache {
  hidden: yes
}

# hidden site_cache explore supports suggest_explore for the site filter
explore: site_cache {
  hidden: yes

  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }
}

explore: page_views {
  persist_for: "10 minutes"
  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  #sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
  #    AND ${page_url} NOT LIKE '%$/%'
  #    AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%' ;;

  # adding this access filter to be used by the CMS Lite embed code generator
  #    to allow for page-level dashboards
  access_filter: {
    field: node_id
    user_attribute: node_id
  }
  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }
  access_filter: {
    field: page_exclusion_filter
    user_attribute: exclusion_filter
  }
  access_filter: {
    field: app_id
    user_attribute: app_id
  }

  #access filter based on the first part of the URL (eg https://site.com/section/page.html)
  access_filter: {
    field: page_section
    user_attribute: section
  }
  access_filter: {
    field: page_sub_section
    user_attribute: sub_section
  }
  access_filter: {
    field: cmslite_themes.theme_id
    user_attribute: theme
  }

  # sql_always_where: ${page_url} NOT LIKE '%video.web.%' ;; -- Causing problems with video.gov analytics
  join: sessions {
    type: left_outer
    sql_on: ${sessions.session_id} = ${page_views.session_id};;
    relationship: many_to_many
  }

  join: users {
    sql_on: ${page_views.domain_userid} = ${users.domain_userid} ;;
    relationship: many_to_one
  }

  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: many_to_one
  }

  join: cmslite_referrer_themes {
    from:  cmslite_themes
    type: left_outer
    relationship: many_to_one
    sql_on: ${page_views.page_referrer_display_url} = ${cmslite_referrer_themes.hr_url} ;;
  }

  join: gdx_analytics_whitelist {
    type: left_outer
    sql_on: ${page_views.page_urlhost} = ${gdx_analytics_whitelist.urlhost} ;;
    relationship: many_to_one
  }

  join: cmslite_metadata {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_metadata.node_id};;
    relationship: one_to_one
  }

  join: myfs_component_name {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${myfs_component_name.id} ;;
    relationship: one_to_one
  }

  join: myfs_estimates {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${myfs_estimates.id} ;;
    relationship: one_to_one
  }

  join: performance_timing {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${performance_timing.page_view_id} ;;
    relationship: one_to_one
  }

  join: covid_language_matrix {
    type: left_outer
    sql_on:  ${page_views.page_covid_display_url} = ${covid_language_matrix.translated_url} ;;
    relationship: many_to_one
  }
  join: embc_language_matrix {
    type: left_outer
    sql_on:  ${page_views.page_display_url} = ${embc_language_matrix.translated_url} ;;
    relationship: many_to_one
  }

  join: google_translate {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${google_translate.page_view_id} ;;
    relationship: many_to_one
  }

  join: language_cohorts_sessions {
    type: left_outer
    relationship: one_to_one
    sql_on: ${page_views.session_id} = ${language_cohorts_sessions.session_id} ;;
  }

  join: language_cohorts_users {
    type: left_outer
    relationship: one_to_one
    sql_on: ${page_views.domain_userid} = ${language_cohorts_users.domain_userid} ;;
  }

  join: ldb_sku {
    type: left_outer
    relationship: one_to_one
    sql_on: ${page_views.ldb_sku} = ${ldb_sku.sku} ;;
  }


}

explore: ldb_summary {
  label: "LDB Summary"
}


explore: page_views_bdp {
  persist_for: "10 minutes"
  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  #sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
  #    AND ${page_url} NOT LIKE '%$/%'
  #    AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%' ;;

  # adding this access filter to be used by the CMS Lite embed code generator
  #    to allow for page-level dashboards

  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }
  access_filter: {
    field: app_id
    user_attribute: app_id
  }
  join: sessions_bdp {
    type: left_outer
    sql_on: ${sessions_bdp.session_id} = ${page_views_bdp.session_id};;
    relationship: many_to_many
  }
  join: ldb_sku {
    type: left_outer
    relationship: one_to_one
    sql_on: ${page_views_bdp.ldb_sku} = ${ldb_sku.sku} ;;
  }
}

explore: sessions_bdp {
  persist_for: "10 minutes"

  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  # Note that we are using first_page here instead of page, as there is no "page" for sessions
  #sql_always_where: (${first_page_urlhost} <> 'localhost' OR ${first_page_urlhost} IS NULL)
  #    AND ${first_page_url} NOT LIKE '%$/%'
  #    AND ${first_page_url} NOT LIKE 'file://%' AND ${first_page_url} NOT LIKE '-file://%' AND ${first_page_url} NOT LIKE 'mhtml:file://%';;

  #join: users {
  #  sql_on: ${sessions_bdp.domain_userid} = ${users.domain_userid} ;;
  #  relationship: many_to_one
  #}

  access_filter: {
    field: first_page_urlhost
    user_attribute: urlhost
  }
  access_filter: {
    field: app_id
    user_attribute: app_id
  }
}

explore: myfs_estimates {
  persist_for: "10 minutes"
  label: "MyFS Estimates"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${myfs_estimates.id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
}

explore: chatbot {
  persist_with: aa_datagroup_cmsl_loaded
  label: "Chatbot"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${chatbot.id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}

explore: chatbot_intents_and_clicks { #view that only includes intents, in hopes of making it faster
  label: "Chatbot Intents and Clicks"
  persist_with: aa_datagroup_cmsl_loaded
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${chatbot_intents_and_clicks.id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: chatbot_intents_and_clicks.page_urlhost
    user_attribute: urlhost
  }
}

explore: chatbot_errors {
  label: "Chatbot Errors"
  persist_for: "2 hours"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme
    ]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${chatbot_errors.id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: chatbot_errors.page_urlhost
    user_attribute: urlhost
  }
}

explore: feedbc_search {
  label: "FeedBC Search"
  persist_for: "1 hours"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme
  ]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${feedbc_search.page_view_id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: feedbc_search.page_urlhost
    user_attribute: urlhost
  }
}


explore: sessions {
  persist_for: "10 minutes"

  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  # Note that we are using first_page here instead of page, as there is no "page" for sessions
  #sql_always_where: (${first_page_urlhost} <> 'localhost' OR ${first_page_urlhost} IS NULL)
  #    AND ${first_page_url} NOT LIKE '%$/%'
  #    AND ${first_page_url} NOT LIKE 'file://%' AND ${first_page_url} NOT LIKE '-file://%' AND ${first_page_url} NOT LIKE 'mhtml:file://%';;

  join: users {
    sql_on: ${sessions.domain_userid} = ${users.domain_userid} ;;
    relationship: many_to_one
  }

  join: cmslite_themes {
    type: left_outer
    sql_on: ${sessions.first_page_node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: node_id
    user_attribute: node_id
  }
  access_filter: {
    field: first_page_urlhost
    user_attribute: urlhost
  }
  access_filter: {
    field: first_page_exclusion_filter
    user_attribute: exclusion_filter
  }
  access_filter: {
    field: app_id
    user_attribute: app_id
  }

  #access filter based on the first part of the URL (eg https://site.com/section/page.html)
  access_filter: {
    field: first_page_section
    user_attribute: section
  }
  access_filter: {
    field: first_page_sub_section
    user_attribute: sub_section
  }
  access_filter: {
    field: cmslite_themes.theme_id
    user_attribute: theme
  }
}

explore: users {
  persist_for: "10 minutes"



  # sql_always_where: ${first_page_url} NOT LIKE '%video.web.%' ;; -- Causing problems with Dan's video analytics
}

explore: clicks{
  persist_for: "10 minutes"

  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  #sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
  #    AND ${page_url} NOT LIKE '%$/%'
  #    AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%' ;;

  join: cmslite_themes {
    type: left_outer
    sql_on: ${clicks.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  join: covid_language_matrix {
    type: left_outer
    sql_on:  ${clicks.page_covid_display_url} = ${covid_language_matrix.translated_url} ;;
    relationship: many_to_one
  }
  join: embc_language_matrix {
    type: left_outer
    sql_on:  ${clicks.page_display_url} = ${embc_language_matrix.translated_url} ;;
    relationship: many_to_one
  }
  access_filter: {
    field: node_id
    user_attribute: node_id
  }
  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }
  access_filter: {
    field: page_exclusion_filter
    user_attribute: exclusion_filter
  }
  access_filter: {
    field: app_id
    user_attribute: app_id
  }
  #access filter based on the first part of the URL (eg https://site.com/section/page.html)
  access_filter: {
    field: page_section
    user_attribute: section
  }
  access_filter: {
    field: page_sub_section
    user_attribute: sub_section
  }
  access_filter: {
    field: cmslite_themes.theme_id
    user_attribute: theme
  }
}

explore: searches {
  persist_for: "10 minutes"
  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  #sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
  #    AND ${page_url} NOT LIKE '%$/%'
  #    AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%';;

  join: cmslite_themes {
    type: left_outer
    sql_on: ${searches.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: node_id
    user_attribute: node_id
  }
  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }
  access_filter: {
    field: page_exclusion_filter
    user_attribute: exclusion_filter
  }
  access_filter: {
    field: app_id
    user_attribute: app_id
  }

  #access filter based on the first part of the URL (eg https://site.com/section/page.html)
  access_filter: {
    field: page_section
    user_attribute: section
  }
  access_filter: {
    field: page_sub_section
    user_attribute: sub_section
  }
  access_filter: {
    field: cmslite_themes.theme_id
    user_attribute: theme
  }
}

explore: form_action {
  label: "Form Actions"
  fields: [ALL_FIELDS*,
          -page_views.is_external_referrer_theme,
          -page_views.is_external_referrer_subtheme,
          -page_views.refr_theme,
          -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${form_action.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${form_action.formid} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  join: metadata {
    type: left_outer
    sql_on: ${page_views.node_id} = ${metadata.node_id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: form_action.page_urlhost
    user_attribute: urlhost
  }
}
explore: form_error {
  label: "Form Errors"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${form_error.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${form_error.formid} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }

  join: metadata {
    type: left_outer
    sql_on: ${page_views.node_id} = ${metadata.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: form_error.page_urlhost
    user_attribute: urlhost
  }
}

explore: cmslite_metadata {
  persist_for: "60 minutes"

  access_filter: {
    field: node_id
    user_attribute: node_id
  }

  join: cmslite_themes {
    type: left_outer
    sql_on: ${cmslite_metadata.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }

  join: defined_security_groups {
    type: left_outer
    sql_on:  ${cmslite_metadata.node_id} = ${defined_security_groups.node_id};;
    relationship: one_to_many
  }

  join: inherited_security_groups {
    type: left_outer
    sql_on:  ${cmslite_metadata.node_id} = ${inherited_security_groups.node_id};;
    relationship: one_to_many
  }
}

explore: esb_se_pathways {
  persist_for: "60 minutes"
  label: "ESB SE Pathways"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_urlquery} LIKE 'id=' + ${esb_se_pathways.id} + '%';;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
}

explore: youtube_embed_video {
  persist_for: "60 minutes"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${youtube_embed_video.page_view_id} ;;
    relationship: many_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
}

explore: sbc_online_appointments{
  label: "SBC Online Appointments"
  persist_for: "2 hours"

  join: cfms_poc {
    type: left_outer
    sql_on: ${cfms_poc.client_id} = ${sbc_online_appointments.client_id} AND ${cfms_poc.service_count}=1 ;;
    relationship: one_to_one
  }
}
explore: sbc_online_appointments_clicks{
  label: "SBC Online Appointments Clicks"
  persist_for: "2 hours"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${sbc_online_appointments_clicks.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}


explore: workbc_careersearch_click{
  label: "WorkBC Career Search Tool Clicks"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${workbc_careersearch_click.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}
explore: workbc_careersearch_find {
  label: "WorkBC Career Search Find"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${workbc_careersearch_find.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}
explore: workbc_careersearch_compare {
  label: "WorkBC Career Search Compare Tool"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${workbc_careersearch_compare.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}
explore: workbc_careertoolkit {
  label: "WorkBC Career Transition Toolkit"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${workbc_careertoolkit.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}

explore: workbc_careereducation_find {
  label: "WorkBC Career Education Tool"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${workbc_careereducation_find.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}

explore: workbc_careereducation_click {
  label: "WorkBC Career Education Tool Clicks"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${workbc_careereducation_click.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}


explore: workbc_career_discovery_click{
  label: "WorkBC Career Discovery Clicks"
  persist_for: "2 hours"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${workbc_career_discovery_click.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}

explore: workbc_career_discovery_compare {
  label: "WorkBC Career Discovery Compare Tool"
  persist_for: "2 hours"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${workbc_career_discovery_compare.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }
}

explore: workbc_career_discovery_quiz {
  label: "WorkBC Career Discovery Quiz"
  persist_for: "2 hours"
}
explore: forms {
  persist_for: "60 minutes"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${forms.page_view_id} ;;
    relationship: many_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
}

explore: asset_downloads {
  persist_for: "60 minutes"

  access_filter: {
    field: asset_themes.asset_theme_id
    user_attribute: asset_theme_id
  }

  access_filter: {
    field: asset_downloads.asset_host
    user_attribute: urlhost
  }

  access_filter: {
    field: asset_downloads.asset_display_url
    user_attribute: asset_display_url
  }

  join: cmslite_metadata {
    type: left_outer
    sql_on: ${asset_downloads.asset_display_url} = ${cmslite_metadata.hr_url} ;;
    relationship: one_to_one
  }

  join: asset_themes {
    type: left_outer
    sql_on: ${asset_downloads.asset_display_url} = ${asset_themes.hr_url} ;;
    relationship: one_to_one
  }
}

explore: performance_timing {
  persist_for: "60 minutes"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }

  join: page_views {
    type:  left_outer
    sql_on: ${performance_timing.page_view_id} = ${page_views.page_view_id} ;;
    relationship: one_to_one
  }

  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
}


explore: healthgateway_actions {
  label: "Health Gateway Actions"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${healthgateway_actions.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: healthgateway_actions.page_urlhost
    user_attribute: urlhost
  }
}

#explore: health_app_views {
#  label: "Health App Views"
#
#  access_filter: {
#    field: health_app_views.app_type
#    user_attribute: urlhost
#  }
#}

explore: health_app_actions {
  label: "Health App Actions"

  access_filter: {
    field: health_app_actions.app_type
    user_attribute: urlhost
  }
}

explore: ldb_clicks {
  label: "LDB Actions"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${ldb_clicks.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  join: ldb_sku {
    type:  left_outer
    sql_on: ${ldb_sku.sku} = ${ldb_clicks.sku} ;;
    relationship: many_to_one
  }
  access_filter: {
    field: ldb_clicks.page_urlhost
    user_attribute: urlhost
  }
}
explore: corp_calendar_clicks {
  label: "Corp Cal Clicks"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${corp_calendar_clicks.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: corp_calendar_clicks.page_urlhost
    user_attribute: urlhost
  }
}

explore: wellbeing_clicks {
  label: "wellbeing.gov.bc.ca Clicks"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${wellbeing_clicks.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: wellbeing_clicks.page_urlhost
    user_attribute: urlhost
  }
}

explore: wellbeing_resources {
  label: "wellbeing.gov.bc.ca Resources"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${wellbeing_resources.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: wellbeing_resources.page_urlhost
    user_attribute: urlhost
  }
}
explore: cit_userstory {
  label: "CIT User Story"
}

explore: mobile_screen_views {
  access_filter: {
    field: app_id
    user_attribute: app_id
  }
}
explore: mobile_sessions {
  access_filter: {
    field: app_id
    user_attribute: app_id
  }

}
explore: mobile_application_errors {
  access_filter: {
    field: app_id
    user_attribute: app_id
  }
}
explore: idim_mobile_errors {
  access_filter: {
    field: app_id
    user_attribute: app_id
  }
  join: mobile_screen_views {
    type:  left_outer
    sql_on: ${mobile_screen_views.screen_view_id} = ${idim_mobile_errors.screen_view_id} ;;
    relationship: many_to_one
  }
  join: mobile_sessions {
    type:  left_outer
    sql_on: ${mobile_sessions.session_id} = ${idim_mobile_errors.session_id} ;;
    relationship: many_to_one
  }


}

explore: csrs_clicks {
  label: "CSRS Clicks"
}
explore: csrs_overall {
  label: "CSRS Overall"
}
explore: csrs_steps {
  label: "CSRS Steps"
}

explore: corp_calendar_searches {
  label: "Corp Cal Searches"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${corp_calendar_searches.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: corp_calendar_searches.page_urlhost
    user_attribute: urlhost
  }
}

explore: google_translate {
  persist_for: "60 minutes"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  access_filter: {
    field: page_views.page_urlhost
    user_attribute: urlhost
  }

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${google_translate.page_view_id} ;;
    relationship: many_to_one
  }

  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
}

explore: wfnews_actions {
  label: "Wildfire News Actions"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  access_filter: {
    field: wfnews_actions.page_urlhost
    user_attribute: urlhost
  }

  join: page_views {
    type: left_outer
    sql_on: ${page_views.page_view_id} = ${wfnews_actions.page_view_id} ;;
    relationship: many_to_one
  }

  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
}

explore: pims_listing_clicks {
  label: "PIMS Listing Clicks"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${pims_listing_clicks.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: pims_listing_clicks.page_urlhost
    user_attribute: urlhost
  }
}

explore: pims_errors {
  label: "PIMS Errors"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${pims_errors.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: pims_errors.page_urlhost
    user_attribute: urlhost
  }
}
explore: pims_searches {
  label: "PIMS Searches"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${pims_searches.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: pims_searches.page_urlhost
    user_attribute: urlhost
  }
}

explore: drivebc_actions {
  label: "DriveBC Actions"
  fields: [ALL_FIELDS*,
    -page_views.is_external_referrer_theme,
    -page_views.is_external_referrer_subtheme,
    -page_views.refr_theme,
    -page_views.refr_subtheme]

  join: page_views {
    type:  left_outer
    sql_on: ${page_views.page_view_id} = ${drivebc_actions.page_view_id} ;;
    relationship: one_to_one
  }
  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: drivebc_actions.page_urlhost
    user_attribute: urlhost
  }
}

explore: covid19_self_assessment_action {}
explore: covid19_self_assessment_recommendation {}

### Datagroups
## NOTE: These groups are set to run outside of the "overnight-defrag" window.
##        As such, no incremental jobs should run between 3:45 and 5:15 AM Pacific Time
datagroup: aa_datagroup_cmsl_loaded {
  label: "Updates with todays date at 5:45AM"
  description: "Triggers CMS Lite Metadata dependent Aggregate Aware tables to rebuild after each new day and after nightly cmslitemetadata microservice has run."
  sql_trigger: SELECT DATE(timezone('America/Vancouver', now() - interval '345 minutes')) ;;
}

datagroup: datagroup_tibc_ready {
  label: "Updates with todays date at 5:15AM"
  description: "Triggers PDTs for TIBC 30 minutes before CMS AA."
  sql_trigger: SELECT DATE(timezone('America/Vancouver', now() - interval '315 minutes')) ;;
}

datagroup: datagroup_sbc_online_appointments {
  label: "Updates with todays date at 5:30AM"
  description: "Triggers PDTS for sbc_online_appointments 15 minutes before CMS AA."
  sql_trigger: SELECT DATE(timezone('America/Vancouver', now() - interval '330 minutes')) ;;
}


## To avoid the "overnight-defrag" window, when the hour is 3, 4, or 5, return a fixed time
##    of the last run before 3:15am so these are "paused" during that window
##    The common code looks like:
##        SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
##                  THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
##            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 25
##              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now()))
##            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) >= 25 AND DATE_PART('minute',timezone('America/Vancouver', now())) < 55
##              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes'
##            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '60 minutes'
##            END ;;
##    When it is before the first time cut, it will report the current hour.
##        Between time cuts, it will report 30 minutes past the hour.
##        After the second time cut it will report the next hour (and
##            stay that way until it passes the first time cut in the next hour)


datagroup: datagroup_healthgateway_updated {
  label: "Health Gateway Datagroup"
  description: "Update every 30 minutes to drive the Health Gateway incremental PDT on the hour and half hour"
# Note that for the 0 minute and 30 minute trigger, there is one fewer CASE to deal with
  sql_trigger: SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
                  THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 30
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes'
            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '60 minutes'
            END ;;
}

datagroup: datagroup_05_35 {
  label: "05 and 35 Minute Datagroup"
  description: "Update every 30 minutes to drive incrementals PDT at 05 and 35 past the hour"
  sql_trigger: SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
                  THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 5
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now()))
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) >= 5 AND DATE_PART('minute',timezone('America/Vancouver', now())) < 35
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes'
            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '60 minutes'
            END ;;
}

datagroup: datagroup_10_40 {
  label: "10 and 40 Minute Datagroup"
  description: "Update every 30 minutes to drive incrementals PDT at 10 and 40 past the hour"
  sql_trigger: SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
                  THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 10
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now()))
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) >= 10 AND DATE_PART('minute',timezone('America/Vancouver', now())) < 40
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes'
            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '60 minutes'
            END ;;
}

datagroup: datagroup_15_45 {
  label: "15 and 45 Minute Datagroup"
  description: "Update every 30 minutes to drive incrementals PDT at 15 and 45 past the hour"
  sql_trigger: SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
                  THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 15
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now()))
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) >= 15 AND DATE_PART('minute',timezone('America/Vancouver', now())) < 45
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes'
            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '60 minutes'
            END ;;
}

datagroup: datagroup_20_50 {
  label: "20 and 50 Minute Datagroup"
  description: "Update every 30 minutes to drive incrementals PDT at 20 and 50 past the hour"
  sql_trigger: SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
                  THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 20
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now()))
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) >= 20 AND DATE_PART('minute',timezone('America/Vancouver', now())) < 50
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes'
            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '60 minutes'
            END ;;
}

datagroup: datagroup_25_55 {
  label: "25 and 55 Minute Datagroup"
  description: "Update every 30 minutes to drive incrementals PDT at 25 and 55 past the hour"
  sql_trigger: SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
                  THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 25
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now()))
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) >= 25 AND DATE_PART('minute',timezone('America/Vancouver', now())) < 55
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes'
            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '60 minutes'
            END ;;
}
