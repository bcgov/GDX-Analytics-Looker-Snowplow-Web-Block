include: "/Includes/date_comparisons_common.view"

view: asset_downloads {
  sql_table_name: microservice.asset_downloads_derived ;;
  label: "Asset Downloads "

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.date_timestamp  ;;
  }

  dimension_group: download_time {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.date_timestamp ;;
    group_label: "Download"
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
    description: "The user's IP address, with the final octet replaced with \"x\" to remove personally identifiable information."
  }

  dimension: proxy {
    type: number
    sql: ${TABLE}.proxy ;;
  }

  dimension: status_code {
    type: number
    sql: ${TABLE}.status_code ;;
    description: "The HTTP status code. Filter out non-200 codes or you will end up with invalid data."
    group_label: "Download"
  }

  dimension: return_size {
    type:  number
    sql:   ${TABLE}.return_size ;;
    description: "The size of response in bytes, excluding HTTP headers"
    label: "Return Size"
    group_label: "Asset"
  }

  dimension: request_header {
    type: string
    sql: ${TABLE}.request_string ;;
    description: "The request line in quotes, composed of the request method, the url, and the HTTP version"
  }

  dimension: is_efficiencybc_dev {
    type: yesno
    sql:  ${TABLE}.is_efficiencybc_dev ;;
  }

  dimension: is_government {
    type: yesno
    sql:  ${TABLE}.is_government ;;
    description: "Yes if the IP address maps to a known BC Government network."
  }

  dimension: is_offsite {
    type: string
    sql: CASE
      WHEN asset_downloads.asset_host = asset_downloads.referrer_urlhost_derived THEN FALSE
        ELSE TRUE END ;;
    description: "Yes if the Asset download requests originates from off the Asset Host."
  }

  dimension: referrer {
    type:  string
    sql:  ${TABLE}.referrer ;;
    label: "Page Referrer "
    group_label: "Referrer"
  }

  dimension: referrer_urlhost {
    type:  string
    sql:  ${TABLE}.referrer_urlhost_derived ;;
    label: "Referrer Urlhost"
    group_label: "Referrer"
    drill_fields: [referrer,asset_display_url]
    link: {
      label: "Visit Referrer"
      url: "https://{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: referrer_medium {
    type: string
    sql:  ${TABLE}.referrer_medium;;
    label: "Referrer Medium"
    group_label: "Referrer"
  }

  dimension: referrer_urlpath {
    type: string
    sql: ${TABLE}.referrer_urlpath ;;

    label: "Referrer Urlpath"
    group_label: "Referrer"
  }

  dimension: referrer_urlquery {
    type: string
    sql:  ${TABLE}.referrer_urlquery ;;
    label: "Referrer Urlquery"
    group_label: "Referrer"
  }

  dimension: asset_url {
    type: string
    sql: ${TABLE}.asset_url ;;
    group_label: "Asset"
    link: {
      label: "Visit Asset"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: asset_display_url {
    type: string
    sql: SPLIT_PART(SPLIT_PART(${TABLE}.asset_url,'?', 1), '#', 1) ;;
    group_label: "Asset"
    drill_fields: [page_referrer_display_url]
    link: {
      label: "Visit Asset"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }

  }

  dimension: asset_host {
    type: string
    sql: ${TABLE}.asset_host ;;
    label: "Asset Host"
    group_label: "Asset"
    link: {
      label: "Visit Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: asset_source {
    type:  string
    group_label: "Asset"
    sql:  ${TABLE}.asset_source ;;
  }

  # Substring select the filename with extension.
  # Update clicks dimension target_file at the same time.
  dimension: asset_file {
    type: string
    sql: ${TABLE}.asset_file ;;
    drill_fields: [asset_display_url]
    group_label: "Asset"
  }

  # substring select the extension only
  # Update clicks dimension target_extension at the same time.
  dimension: asset_ext {
    type: string
    sql: ${TABLE}.asset_ext ;;
    drill_fields: [asset_display_url]
    group_label: "Asset"
  }

  dimension: is_mobile {
    type: yesno
    sql:  ${TABLE}.is_mobile;;
    description: "True if the viewing device is mobile, False otherwise."
    group_label: "Device"
  }

  dimension: device {
    type: string
    sql:  ${TABLE}.device;;
    description: "A label that describes the viewing device type as Mobile or Computer."
    label: "Device Type"
    group_label: "Device"
  }

  dimension: os_family {
    type: string
    sql:  ${TABLE}.os_family;;
    group_label: "OS"
  }

  dimension: os_version {
    type: string
    sql:  ${TABLE}.os_version;;
    group_label: "OS"
  }

  dimension: browser_version {
    description: "The specific version number of the browser."
    type: string
    sql:  ${TABLE}.browser_version;;
    group_label: "Browser"
  }

  dimension: browser_family {
    description: "The major family of browser, regardless of name or version. eg., Chrome, Safari, Internet Explorer, etc."
    type: string
    sql:  ${TABLE}.browser_family;;
    group_label: "Browser"
  }

  dimension: user_agent_string {
    type: string
    sql: ${TABLE}.user_agent_http_request_header ;;
    description: "The full user agent request string"
    group_label: "Browser"
  }

  dimension: offsite_download {
    type:  string
    sql:  ${TABLE}.offsite_download;;
  }

  dimension: direct_download {
    type:  string
    sql:  ${TABLE}.direct_download;;
  }

  dimension: page_referrer_display_url {
    type: string
    sql: ${TABLE}.page_referrer_display_url ;;
    group_label: "Referrer"
    drill_fields: [asset_display_url]
    link: {
      label: "Visit Referrer"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: referrer_urlscheme {
    description: "The scheme componenent of the referrer URL such as http or https."
    type: string
    sql: ${TABLE}.referrer_urlscheme ;;
    group_label: "Referrer"
    hidden: yes
  }

  dimension: asset_url_case_insensitive {
    description: "The asset url enforced to lower case."
    type: string
    sql: ${TABLE}.asset_url_case_insensitive ;;
    group_label: "Asset"
    link: {
      label: "Visit Asset"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: asset_url_nopar {
    description: "The asset url with the query parameters removed."
    type: string
    #This removes the parameters from the url, anything including the ?
    sql: ${TABLE}.asset_url_nopar ;;
    group_label: "Asset"
    link: {
      label: "Visit Asset"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: asset_url_nopar_case_insensitive {
    description: "The asset url enforced to lower case with the query parameters removed."
    type: string
    sql: ${TABLE}.asset_url_nopar_case_insensitive ;;
    group_label: "Asset"
    link: {
      label: "Visit Asset"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: is_partial {
    description: "Yes if HTTP response status code equal to 206."
    type: yesno
    sql: CASE WHEN ${status_code} = 206 THEN TRUE ELSE FALSE END ;;
    }

  dimension: truncated_asset_url_nopar_case_insensitive {
    type: string
    #when editing, also see shared_fields_common.page_display_url
    sql: ${TABLE}.asset_url_nopar_case_insensitive ;;
    group_label: "Asset"
    link: {
      label: "Visit Asset"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: avg_return_size {
    description: "The average return size"
    type: average
    sql: ${return_size} ;;
    value_format: "[<1000000]#,##0.00,\" Kb\";[<1000000000]#,##0.00,,\" Mb\";#,##0.00,,,\" Gb\""

  }

  measure: total_return_size {
    description: "The total return size"
    type: sum
    sql: ${return_size} ;;
    value_format: "[<1000000]#,##0.00,\" Kb\";[<1000000000]#,##0.00,,\" Mb\";#,##0.00,,,\" Gb\""
  }
}
