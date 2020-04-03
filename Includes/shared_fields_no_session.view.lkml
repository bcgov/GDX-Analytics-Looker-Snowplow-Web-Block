view: shared_fields_no_session {

# browser_view_height is not in Sessions

  dimension: browser_view_height {
    description: "The browser viewport height in pixels."
    type: number
    sql: ${TABLE}.br_viewheight ;;
    group_label: "Browser"
  }

  # browser_view_width is not in Sessions
  dimension: browser_view_width {
    description: "The browser viewport width in pixels."
    type: number
    sql: ${TABLE}.br_viewwidth ;;
    group_label: "Browser"
  }

  # dvce_screenheight is not in sessions
  dimension: devices_screen_height {
    description: "The device screen height in pixels."
    type: number
    sql: ${TABLE}.dvce_screenheight ;;
    group_label: "Device"
  }

  # dvce_screenwidth is not in sessions
  dimension: devices_screen_width {
    description: "The device screen width in pixels."
    type: number
    sql: ${TABLE}.dvce_screenwidth ;;
    group_label: "Device"
  }

  dimension: os_version {
    type: string
    sql: ${TABLE}.os_version ;;
    group_label: "OS"
  }

  ### Page
  dimension: page_height {
    type: number
    sql: ${TABLE}.doc_height ;;
    group_label: "Page"
  }

  dimension: page_title {
    description: "The web page title."
    type: string
    sql: ${TABLE}.page_title ;;
    group_label: "Page"
  }

  dimension: page_url {
    description: "The web page URL."
    type: string
    sql: ${TABLE}.page_url ;;
    group_label: "Page"
    link: {
      label: "Visit Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: page_section {
    description: "The identifier for a section of a website. The part of the URL after the domain before the next '/'"
    type: string
    sql: SPLIT_PART(${TABLE}.page_urlpath,'/',2) ;;
    group_label: "Page"
  }

  dimension: page_sub_section {
    description: "The identifier for a subsection of a website. The part of the URL between the second and third '/' in the path"
    type: string
    sql: SPLIT_PART(${TABLE}.page_urlpath,'/',3) ;;
    group_label: "Page"
  }

  dimension: page_section_exclude {
    description: "An exclusion filter for the identifier for a section of a website used to block sections of a site matching the pattern below.. The part of the URL after the domain before the next '/'."
    type: string
    sql: CASE WHEN SPLIT_PART(${TABLE}.page_urlpath,'/',2) IN ('empr','agri','mirr','flnrord','env','eao','csnr') THEN '1' ELSE '0' END ;;
    group_label: "Page"
  }

  dimension: page_urlquery {
    description: "The querystring of the URL."
    type: string
    sql: ${TABLE}.page_urlquery ;;
    group_label: "Page"
  }

  dimension: page_width {
    type: number
    sql: ${TABLE}.doc_width ;;
    group_label: "Page"
  }

  dimension: page_engagement {
    description: "The identifier for an engagement on engage.gov.bc.ca."
    type: string
    sql: CASE WHEN ${TABLE}.page_urlpath LIKE '/govtogetherbc/consultation/%'
      THEN SPLIT_PART(${TABLE}.page_urlpath,'/',4)
      ELSE SPLIT_PART(${TABLE}.page_urlpath,'/',2) END ;;
    group_label: "Page"
  }

  dimension: page_exclusion_filter {
    description: "The URL matches the exclusion filter. For example subsites of the NRS intranet."
    type: string
    sql: ${TABLE}.page_exclusion_filter;;
    group_label: "Page"
  }

  dimension: search_field {
    description: "The raw search query parameters"
    type: string
    # sql: decode(split_part(${page_url},'/search/',2),'%20', ' ');;
    sql: REPLACE(split_part(${page_url},'/search/',2), '%20', ' ')
      ;;
  }

  dimension: page_display_url {
    label: "Page Display URL"
    # when editing also see clicks.truncated_target_url_nopar_case_insensitive
    description: "Cleaned URL of the page without query string or standard file names like index.html"
    sql: ${TABLE}.page_display_url ;;
    group_label: "Page"
    link: {
      label: "Visit Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: page_urlpath {
    description: "The path of the page, after the domain."
    type: string
    sql: ${TABLE}.page_urlpath ;;
    group_label: "Page"
  }

  dimension: page_urlhost {
    description: "The web page domain or host."
    type: string
    sql: ${TABLE}.page_urlhost ;;
    suggest_explore: site_cache
    suggest_dimension: site_cache.page_urlhost
    group_label: "Page"
  }

  dimension: page_url_scheme {
    type: string
    sql: ${TABLE}.page_urlscheme ;;
    group_label: "Page"
    hidden: yes
  }



}
