include: "/Includes/shared_fields_common.view"
include: "/Includes/shared_fields_no_session.view"

view: searches {
  sql_table_name: test.searches ;;

  extends: [shared_fields_common,shared_fields_no_session]

  # Modifying extended fields
  dimension: geo_country { drill_fields: [page_display_url] }

  dimension: p_key {
    primary_key: yes
    sql: ${user_id} || ${domain_userid} || ${session_id} || ${search_id} ;;
  }

  # Search

  # duplicate from atomic.events (events.view.lkml)
  dimension_group: search_time {
    type: time
    timeframes: [hour,date,week,month,quarter,year,raw]
    sql:  ${TABLE}.collector_tstamp ;;
    group_label: "Search"
  }

  # search_id: string
  # Table reference - VARCHAR(255) ENCODE ZSTD NOT NULL
  # Unique ID for each click (equal to event_id in atomic.events)
  dimension: search_id {
    type: string
    sql: ${TABLE}.search_id ;;
    group_label: "Search"
  }

  # search_in_session_index: number
  # Table reference - INT8 ENCODE ZSTD
  #
  # This dimension is used in calculated fields that are more meaningful for Explores (max_search_index);
  #  on it's own, search_in_session_index it is difficult to describe succinctly, and may be more confusing
  #  than helpful to Looker users developing Explores, so it has been hidden.
  dimension: search_in_session_index {
    description: "The search index within a single session."
    type: number
    # index within each session
    sql: ${TABLE}.search_in_session_index ;;
    group_label: "Search"
    hidden: yes
  }

  # Search results

  # terms: string
  #
  # Table reference - VARCHAR(2048) ENCODE RAW
  # terms returns a string array of search terms
  # The array can have a size greater than 1 in multi-dimension searches
  # TODO: GDXDSD-1326
  dimension: raw_search_terms {
    type: string
    sql: ${TABLE}.terms ;;
    group_label: "Results"
    hidden: yes
  }

  # readable_terms: string
  #
  # removes wrapping [" "] from the terms dimension, array and
  # replaces + signs with ' ', rendering a readable string in
  # the case of the term string array containing a single element
  # TODO: GDXDSD-1326 handle multiple-term searches past the first index, and empty searches.
  dimension: search_terms {
    description: "The search term(s) that were queried."
    type:  string
    sql:  ${TABLE}.terms ;;
    group_label: "Results"
  }

  dimension: search_terms_lower {
    description: "The search term(s) that were queried converted to lowercase."
    type:  string
    sql:  ${TABLE}.terms_lower ;;
    group_label: "Results"
  }

  # readable_terms: string
  #
  # removes wrapping [" "] from the terms dimension, array and
  # replaces + signs with ' ', and '%2B' with ' '
  dimension: search_terms_v2 {
    description: "The search term(s) that were queried."
    type:  string
    sql:  REPLACE(REPLACE(REPLACE(SUBSTRING(${raw_search_terms},3,LENGTH(${raw_search_terms})-4),'+', ' '), '%2B', '+'), '", "', ' ') ;;
    group_label: "Results"
  }


  # readable_terms: string
  #
  # removes wrapping [" "] from the terms dimension, array and
  # replaces + signs with ' ', rendering a readable string in
  # the case of the term string array containing a single element
  # TODO: GDXDSD-1326 handle multiple-term searches past the first index, and empty searches.
  dimension: search_terms_gov {
    label: "Search Terms"
    description: "The search term(s) that were queried on www2.gov.bc.ca."
    type:  string
    sql:  ${TABLE}.terms ;;
    group_label: "Results"
    link: {
      label: "View Search"
      url: "https://www2.gov.bc.ca/gov/search?id=2E4C7D6BCAA4470AAAD2DCADF662E6A0&q={{ value }}"
      icon_url: "https://www2.gov.bc.ca/favicon.ico"
    }
  }

  dimension: search_terms_workbc {
    label: "WorkBC Search Terms"
    description: "The search term(s) that were queried on WorkBC."
    type:  string
    sql:  REPLACE(${TABLE}.terms,'%20',' ') ;;
    group_label: "Results"
    link: {
      label: "View Search"
      url: "https://www.workbc.ca/Search-Results.aspx?q={{ value }}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
  }

  # filters: string
  # Table reference - VARCHAR(2048) ENCODE RAW
  # e.g.: '{'category': 'books', 'sub-category': 'non-fiction'}'
  dimension: filters {
    description: "The search filters selected."
    type: string
    sql: ${TABLE}.filters ;;
    group_label: "Results"
  }

  # total_results: number
  # Table reference - INT ENCODE RAW
  dimension: total_results {
    description: "The number of search results found."
    type: number
    sql: ${TABLE}.total_results ;;
    group_label: "Results"
  }

  # page_results: number
  # Table reference - INT ENCODE RUNLENGTH
  dimension: page_results {
    description: "The number of results displayed on the first page"
    type: number
    sql: ${TABLE}.page_results ;;
    group_label: "Results"
  }

  # MEASURES
  # duplicates throughout this section

  measure: row_count {
    type: count
    group_label: "Counts"
  }

  # search_count
  # a distinct count of the unique searches returned
  # Unique ID for each click (equal to event_id in atomic.events)
  measure: search_count {
    description: "A distinct count of the unique searches returned in this Explore."
    type: count_distinct
    sql: ${search_id} ;;
    group_label: "Counts"
  }

  # max_search_index: number
  # Table reference - INT8 ENCODE ZSTD
  # returns the max value of search session indexes
  measure: max_search_index {
    description: "the highest number of searches that occurred over the sessions in the result set."
    type: max
    sql: ${search_in_session_index} ;;
  }

  # average_searches_per_visit: number
  # Table reference - INT8 ENCODE ZSTD
  # finds the average value of search session indexes
  measure: average_searches_per_visit {
    description: "the average number of searches that occurred over the sessions in the result set."
    type: average
    sql: ${search_in_session_index} ;;
    group_label: "Engagement"
  }

  # duplicate
  measure: session_count {
    type: count_distinct
    sql: ${session_id} ;;
    group_label: "Counts"
  }

  # duplicate
  measure: user_count {
    type: count_distinct
    sql: ${domain_userid} ;;
    group_label: "Counts"
  }
}
