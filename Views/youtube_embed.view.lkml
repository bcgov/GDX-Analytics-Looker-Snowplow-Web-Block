view: youtube_embed_video {
  derived_table: {
    sql:SELECT yt.*, wp.id as page_view_id
        FROM  (
          SELECT * from atomic.ca_bc_gov_youtube_youtube_playerstate_2
          UNION SELECT * from atomic.ca_bc_gov_youtube_youtube_playerstate_3
        )
        AS yt
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON yt.root_id = wp.root_id
        AND yt.root_tstamp = wp.root_tstamp ;;
    distribution_style: all
    persist_for: "2 hours"
  }

  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }

  dimension: root_id {
    description: "Unique ID of the event"
    primary_key: yes
    type: string
    sql: ${TABLE}.root_id ;;
  }

  dimension: video_id {
    description: "Unique ID of the video"
    type: string
    label: "ID"
    link: {
      label: "YouTube Video Link"
      url: "https://www.youtube.com/watch?v={{ video_id }}"
    }
    sql: ${TABLE}.video_id ;;
  }

  dimension: author {
    description: "The author of the video."
    label: "Author"
    type: string
    sql: ${TABLE}.author ;;
  }

  dimension: video_source {
    description: "The URI of the video."
    label: "Source"
    type: string
    sql: ${TABLE}.video_src ;;
  }

  dimension: title {
    description: "The video title."
    type: string
    label: "Title"
    drill_fields: [youtube_embed_video.video_display_source]
    link: {
      label: "YouTube Video Link"
      url: "{{ video_display_source }}"
    }
    sql: ${TABLE}.title ;;
  }

  dimension: status {
    description: "The playback status of the video."
    type: string
    label: "Status"
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

  dimension: video_display_source {
    description: "The video source URL without timestamp"
    label: "Source"
    type: string
    sql: 'https://www.youtube.com/watch?v=' || ${video_id};;
  }

  measure: status_count {
    description: "Count of all playback events: ready, playing, paused, and finished."
    type: count
  }

  measure: count_plays {
    description: "Count of Video Plays"
    type: count
    filters: {
      field: status
      value: "Playing"
    }
  }

  measure: count_ended {
    description: "Count of Finished Plays"
    type: count
    filters: {
      field: status
      value: "Ended"
    }
  }

}
