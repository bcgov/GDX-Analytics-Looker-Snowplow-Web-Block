view: workbc_careertoolkit {
  derived_table: {
    sql: SELECT wp.id AS page_view_id, action, current, option,
          cnoc.description AS current_description,
          cnoc.grouping AS current_grouping,
          onoc.description AS option_description,
          onoc.grouping AS option_grouping,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', ct.root_tstamp) AS timestamp,
          CASE WHEN action = 'select' THEN 1 ELSE 0 END AS select_count,
          CASE WHEN action = 'view' THEN 1 ELSE 0 END AS view_count,
          CASE WHEN action = 'clear' THEN 1 ELSE 0 END AS clear_count,
          CASE WHEN action = 'find' THEN 1 ELSE 0 END AS find_count,
          CASE WHEN action = 'cancel' THEN 1 ELSE 0 END AS cancel_count
        FROM atomic.ca_bc_gov_workbc_careertransitiontool_1 AS ct
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON ct.root_id = wp.root_id AND ct.root_tstamp = wp.root_tstamp
          LEFT JOIN microservice.careertoolkit_workbc AS cnoc -- the "00" trick is temporarily needed until the lookup table gets fixed
              ON cnoc.noc = ct.current OR ct.current = '0' || cnoc.noc OR ct.current = '00' || cnoc.noc OR ct.current = '00' || cnoc.noc
          LEFT JOIN microservice.careertoolkit_workbc AS onoc
              ON onoc.noc = ct.option OR ct.option = '0' || onoc.noc OR ct.option = '00' || onoc.noc OR ct.option = '00' || onoc.noc
          ;;
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

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }
  dimension: current_noc {
    type: string
    sql: ${TABLE}.current ;;
    drill_fields: [option_noc, option_grouping, option_description]
    label: "Current NOC"
    link: {
      label: "Visit Current Career Profile"
      url: "https://www.workbc.ca/Jobs-Careers/Explore-Careers/Browse-Career-Profile/{{ value }}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
    group_label: "Current Selection"
  }
  dimension: current_description {
    type: string
    sql: ${TABLE}.current_description ;;
    drill_fields: [option_noc, option_grouping, option_description]
    label: "Current NOC Description"
    link: {
      label: "Visit Current Career Profile"
      url: "https://www.workbc.ca/Jobs-Careers/Explore-Careers/Browse-Career-Profile/{{ current_noc }}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
    group_label: "Current Selection"
  }
  dimension: current_grouping {
    type: string
    sql: ${TABLE}.current_grouping ;;
    label: "Current NOC Grouping"
    drill_fields: [current_description, current_noc, option_noc, option_grouping, option_description]
    group_label: "Current Selection"
  }
  dimension: option_noc {
    type: string
    sql: ${TABLE}.option ;;
    label: "Career Option NOC"
    link: {
      label: "Visit Career Option Profile"
      url: "https://www.workbc.ca/Jobs-Careers/Explore-Careers/Browse-Career-Profile/{{ value }}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
    group_label: "Career Option"
  }
  dimension: option_description {
    type: string
    sql: ${TABLE}.option_description ;;
    label: "Career Option NOC Description"
    link: {
      label: "Visit Career Option Profile"
      url: "https://www.workbc.ca/Jobs-Careers/Explore-Careers/Browse-Career-Profile/{{ option_noc }}"
      icon_url: "https://www.workbc.ca/App_Themes/Default/Images/favicon.ico"
    }
    group_label: "Career Option"
  }
  dimension: option_grouping {
    type: string
    sql: ${TABLE}.option_grouping ;;
    label: "Career Option NOC Grouping"
    drill_fields: [option_description, option_noc]
    group_label: "Career Option"
  }
  measure: select_count {
    type: sum
    sql: ${TABLE}.select_count ;;
  }
  measure: view_count {
    type: sum
    sql: ${TABLE}.view_count ;;
  }
  measure: clear_count {
    type: sum
    sql: ${TABLE}.clear_count ;;
  }
  measure: cancel_count {
    type: sum
    sql: ${TABLE}.cancel_count ;;
  }
  measure: find_count {
    type: sum
    sql: ${TABLE}.find_count ;;
  }

}
