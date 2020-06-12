view: youtube_embed_video {

  sql_table_name: atomic.ca_bc_gov_youtube_youtube_playerstate_2 ;;

  # # Define your dimensions and measures here, like this:
  dimension: root_id {
    description: "Unique ID of the event"
    type: string
    sql: ${TABLE}.root_id ;;
  }

  dimension: video_id {
    description: "Unique ID of the video"
    type: string
    sql: ${TABLE}.video_id ;;
  }

  dimension: author {
    description: "The author of the video."
    type: string
    sql: ${TABLE}.author ;;
  }

  dimension: video_src {
    description: "The URI of the video."
    type: string
    sql: ${TABLE}.video_src ;;
  }

  dimension: title {
    description: "The video title."
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: status {
    description: "The playback status of the video."
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: root_tstamp {
    description: "The timestamp of the video event."
    type: string
    sql: ${TABLE}.root_tstamp ;;
  }

  dimension: schema_vendor {
    description: "The schema vendor."
    type: string
    sql: ${TABLE}.schema_vendor ;;
  }

  dimension: schema_name {
    description: "The schema name."
    type: string
    sql: ${TABLE}.schema_name ;;
  }

  dimension: schema_format {
    description: "The schema format."
    type: string
    sql: ${TABLE}.schema_format ;;
  }

  dimension: schema_version {
    description: "The schema version."
    type: string
    sql: ${TABLE}.schema_version ;;
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

  #dimension: page_url {
  #  description: "The URL of the page hosting the video embed."
  #  sql: ${TABLE}.page_url ;;
  #}

  measure: status_count {
    description: "Count of video Status"
    type: count_distinct
    sql: ${status} ;;
  }
}
