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
# Version:     0.1.0
#
# Authors:     Christophe Bogaert, Keane Robinson
# Copyright:   Copyright (c) 2016 Snowplow Analytics Ltd
# License:     Apache License Version 2.0


connection: "redshift_pacific_time"
# Set the week start day to Sunday. Default is Monday
week_start_day: sunday

# include all views in this project
include: "*.view"

# include all dashboards in this project
include: "*.dashboard"

explore: page_views {
  persist_for: "10 minutes"
  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
      AND ${page_url} NOT LIKE '%$/%'
      AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%' ;;

  access_filter: {
    field: browser_family
    user_attribute: browser
  }
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


  fields: [ALL_FIELDS*,-page_views.last_page_title]
  # sql_always_where: ${page_url} NOT LIKE '%video.web.%' ;; -- Causing problems with Dan's video analytics
  join: sessions {
    type: left_outer
    sql_on: ${sessions.session_id} = ${page_views.session_id};;
    relationship: many_to_many
  }

  join: max_page_view_rollup {
    type: left_outer
    sql_on: ${max_page_view_rollup.page_view_id} = ${page_views.page_view_id} ;;
    relationship: many_to_one
  }

  join: users {
    sql_on: ${page_views.domain_userid} = ${users.domain_userid} ;;
    relationship: many_to_one
  }

  join: page_views_rollup {
    sql_on: ${page_views_rollup.session_start_raw} = ${sessions.session_start_date} ;;
    relationship: one_to_many
  }

  join: cmslite_themes {
    type: left_outer
    sql_on: ${page_views.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: cmslite_themes.theme_id
    user_attribute: theme
  }


#   join: sessions_rollup {
#     sql_on: ${sessions_rollup.session_id} = ${sessions.session_id}
#       AND ${page_views.page_view_index} = ${sessions_rollup.max_page_view_index} ;;
#     type: left_outer
#     relationship: many_to_many
#   }
}

# explore: sessions {
#   join: page_views_2 {
#     fields: [page_views_2.page_title, page_views_2.session_count]
#     from: page_views
#     type: left_outer
#     sql_on: ${sessions.session_id} = ${page_views_2.session_id}
#             and ${page_views_2.page_view_in_session_index} = 2
#             and ${page_views_2.page_title} != ${sessions.first_page_title};;
#   }
#   join: page_views_3 {
#     fields: [page_views_3.page_title, page_views_3.session_count]
#     from: page_views
#     type: left_outer
#     sql_on: ${sessions.session_id} = ${page_views_3.session_id}
#             and ${page_views_3.page_view_in_session_index} = 3
#             and ${page_views_3.page_title} != ${sessions.first_page_title}
#             and ${page_views_3.page_title} != ${page_views_2.page_title};;
#   }
# }

explore: sessions {
  persist_for: "10 minutes"

  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  # Note that we are using first_page here instead of page, as there is no "page" for sessions
  sql_always_where: (${first_page_urlhost} <> 'localhost' OR ${first_page_urlhost} IS NULL)
      AND ${first_page_url} NOT LIKE '%$/%'
      AND ${first_page_url} NOT LIKE 'file://%' AND ${first_page_url} NOT LIKE '-file://%' AND ${first_page_url} NOT LIKE 'mhtml:file://%';;

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
    field: first_page_urlhost
    user_attribute: urlhost
  }

}

explore: users {
  persist_for: "10 minutes"

  # sql_always_where: ${first_page_url} NOT LIKE '%video.web.%' ;; -- Causing problems with Dan's video analytics
}

explore: clicks{
  persist_for: "10 minutes"

  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
      AND ${page_url} NOT LIKE '%$/%'
      AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%' ;;

  join: cmslite_themes {
    type: left_outer
    sql_on: ${clicks.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }

}

explore: searches {
  persist_for: "10 minutes"
  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
      AND ${page_url} NOT LIKE '%$/%'
      AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%';;

  join: cmslite_themes {
    type: left_outer
    sql_on: ${searches.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }

}
