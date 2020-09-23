include: "/Includes/date_comparisons_common.view"

view: performance_timing {

  sql_table_name: derived.performance_timing ;;

  extends: [date_comparisons_common]

  ### Dimensions

  dimension_group: filter_start {
    sql: ${TABLE}.collector_tstamp  ;;
  }

  dimension: app_id {
    type: string
    sql: ${TABLE}.app_id ;;
  }

  dimension: page_view_id {
    type: string
    sql: ${TABLE}.page_view_id ;;
    group_label: "Page View"
  }

  dimension_group: collector_timestamp {
    type:  time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.collector_tstamp ;;
    group_label: "Collector Timestamp"
  }

  dimension: redirect_time_in_ms {
    type: number
    sql: ${TABLE}.redirect_time_in_ms ;;
    label: "Redirect Time (ms)"
    description: "The time in ms for the request to follow the redirect."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "Redirect"
  }

  dimension: unload_time_in_ms {
    type: number
    sql: ${TABLE}.unload_time_in_ms ;;
    label: "Unload Time (ms)"
    description: "The time in ms for the browser to unload the previous document."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "Unload"
  }

  dimension: app_cache_time_in_ms {
    type: number
    sql: ${TABLE}.app_cache_time_in_ms ;;
    label: "App Cache Time (ms)"
    description: " The time in ms it takes the browser to retrieve resources from the Application Cache."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "App Cache"
  }

  dimension: dns_time_in_ms  {
    type: number
    sql: ${TABLE}.dns_time_in_ms ;;
    label: "DNS Time (ms)"
    description: "The time in ms it takes a domain lookup to occur."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "DNS"
  }

  dimension: tcp_time_in_ms  {
    type: number
    sql: ${TABLE}.tcp_time_in_ms ;;
    label: "TCP Time (ms)"
    description: "The time in ms it takes the browser to establish a connection with the server."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "TCP"
  }

  dimension: request_time_in_ms {
    type: number
    sql: ${TABLE}.request_time_in_ms ;;
    label: "Request Time (ms)"
    description: "The time in ms once the request for a resource has been sent to the server to when the server initially responds to the request"
    group_label: "Timing Dimensions (ms)"
    group_item_label: "Request"
  }

  dimension: response_time_in_ms {
    type: number
    sql: ${TABLE}.response_time_in_ms ;;
    label: "Response Time (ms)"
    description: "The time in ms from when the server initially responds to the request to when the request ends and the data is retrieved."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "Response"
  }

  dimension: processing_time_in_ms {
    type: number
    sql: ${TABLE}.processing_time_in_ms ;;
    label: "Processing Time (ms)"
    description: "The time in ms from once the browser has finished receiving the response to when the page and all its subresources (ex: images, CSS) are ready."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "Processing"
  }

  dimension: dom_loading_to_interactive_time_in_ms {
    type: number
    sql: ${TABLE}.dom_loading_to_interactive_time_in_ms ;;
    label: "DOM Loading to Interactive Time (ms)"
    description: "Represents when the parser finished its work on the main document.
    This property can be used to measure the speed of loading Web sites that users feels."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "DOM Loading to Interactive"
  }

  dimension: dom_interactive_to_complete_time_in_ms  {
    type: number
    sql: ${TABLE}.dom_interactive_to_complete_time_in_ms ;;
    label: "DOM Interactive to Complete Time (ms)"
    description: "The time in ms from when the browser finishes processing the DOM to when it has finished processing subresources like images and CSS."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "DOM Interactive to Complete"
  }

  dimension: onload_time_in_ms {
    type: number
    sql: ${TABLE}.onload_time_in_ms ;;
    label: "Onload Time (ms)"
    description: "The time in ms from when the browser has finished processing the document to when the page is finished loading."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "Onload"
  }

  dimension: total_time_in_ms {
    type: number
    sql: ${TABLE}.total_time_in_ms ;;
    label: "Total Time (ms)"
    description: "The time in ms from the start of navigation to the complete page load."
    group_label: "Timing Dimensions (ms)"
    group_item_label: "Total"
  }


  ### Measures
  measure: avg_total_time_in_ms {
    type: average
    sql: ${total_time_in_ms} ;;
    label: "Average Total Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "Total"
  }

  measure: median_total_time_in_ms {
    type: median
    sql: ${total_time_in_ms} ;;
    label: "Median Total Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "Total"
  }

  measure: avg_redirect_time_in_ms {
    type: average
    sql: ${redirect_time_in_ms} ;;
    label: "Average Redirect Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "Redirect"
  }

  measure: median_redirect_time_in_ms {
    type: median
    sql: ${redirect_time_in_ms} ;;
    label: "Median Redirect Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "Redirect"
  }

  measure: avg_unload_time_in_ms {
    type: average
    sql: ${unload_time_in_ms} ;;
    label: "Average Unload Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "Unload"
  }

  measure: median_unload_time_in_ms {
    type: median
    sql: ${unload_time_in_ms} ;;
    label: "Median Unload Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "Unload"
  }

  measure: avg_app_cache_time_in_ms {
    type: average
    sql: ${app_cache_time_in_ms} ;;
    label: "Average App Cache Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "App Cache"
  }

  measure: median_app_cache_time_in_ms {
    type: median
    sql: ${app_cache_time_in_ms} ;;
    label: "Median App Cache Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "App Cache"
  }

  measure: avg_dns_time_in_ms {
    type: average
    sql: ${dns_time_in_ms} ;;
    label: "Average DNS Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "DNS"
  }

  measure: median_dns_time_in_ms {
    type: median
    sql: ${dns_time_in_ms} ;;
    label: "Median DNS Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "DNS"
  }

  measure: avg_tcp_time_in_ms {
    type: average
    sql: ${tcp_time_in_ms} ;;
    label: "Average TCP Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "TCP"
  }

  measure: median_tcp_time_in_ms {
    type: median
    sql: ${tcp_time_in_ms} ;;
    label: "Median TCP Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "TCP"
  }

  measure: avg_request_time_in_ms {
    type: average
    sql: ${request_time_in_ms} ;;
    label: "Average Request Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "Request"
  }

  measure: median_request_time_in_ms {
    type: median
    sql: ${request_time_in_ms} ;;
    label: "Median Request Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "Request"
  }

  measure: avg_response_time_in_ms {
    type: average
    sql: ${response_time_in_ms} ;;
    label: "Average Response Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "Response"
  }

  measure: median_response_time_in_ms {
    type: median
    sql: ${response_time_in_ms} ;;
    label: "Median Response Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "Response"
  }

  measure: avg_processing_time_in_ms {
    type: average
    sql: ${processing_time_in_ms} ;;
    label: "Average Processing Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "Processing"
  }

  measure: median_processing_time_in_ms {
    type: median
    sql: ${processing_time_in_ms} ;;
    label: "Median Processing Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "Processing"
  }

  measure: avg_dom_loading_to_interactive_time_in_ms {
    type: average
    sql: ${dom_loading_to_interactive_time_in_ms} ;;
    label: "Average DOM Loading to Interactive Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "DOM Loading to Interactive"
  }

  measure: median_dom_loading_to_interactive_time_in_ms {
    type: median
    sql: ${dom_loading_to_interactive_time_in_ms} ;;
    label: "Median DOM Loading to Interactive Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "DOM Loading to Interactive"
  }

  measure: avg_dom_interactive_to_complete_time_in_ms {
    type: average
    sql: ${dom_interactive_to_complete_time_in_ms} ;;
    label: "Average DOM Interactive to Complete Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "DOM Interactive to Complete"
  }

  measure: median_dom_interactive_to_complete_time_in_ms {
    type: median
    sql: ${dom_interactive_to_complete_time_in_ms} ;;
    label: "Median DOM Interactive to Complete Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "DOM Interactive to Complete"
  }

  measure: avg_onload_time_in_ms {
    type: average
    sql: ${onload_time_in_ms} ;;
    label: "Average Onload Time (ms)"
    group_label: "Performance Averages (ms)"
    group_item_label: "Onload"
  }

  measure: median_onload_time_in_ms {
    type: median
    sql: ${onload_time_in_ms} ;;
    label: "Median Onload Time (ms)"
    group_label: "Performance Medians (ms)"
    group_item_label: "Onload"
  }

}
