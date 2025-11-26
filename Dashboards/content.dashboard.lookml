---
- dashboard: web_analytics_dashboard__content
  title: Web Analytics Dashboard - Content
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: EepmJjM7r3saAJ51JxlgvS
  elements:
  - name: Top Downloaded Clicks
    title: Top Downloaded Clicks
    model: snowplow_web_block
    explore: clicks
    type: looker_grid
    fields: [clicks.target_url, clicks.row_count]
    filters:
      clicks.click_type: download
    sorts: [clicks.row_count desc]
    limit: 20
    total: true
    dynamic_fields:
    - table_calculation: of_downloads
      label: "% of Downloads"
      expression: "${clicks.row_count}/${clicks.row_count:total}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    show_view_names: true
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '11'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      clicks.download_click_count: Download Count
      clicks.target_url: Downloaded File
      clicks.session_count: Sessions
      clicks.row_count: Download Count
    series_column_widths:
      clicks.row_count: 147
      of_downloads: 121
    series_cell_visualizations:
      clicks.row_count:
        is_active: false
    series_text_format:
      of_downloads:
        align: right
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    conditional_formatting: [{type: low to high, value: !!null '', background_color: !!null '',
        font_color: !!null '', palette: {name: Red to Yellow to Green, colors: ["#F36254",
            "#FCF758", "#4FBC89"]}, bold: false, italic: false, strikethrough: false,
        fields: !!null ''}]
    truncate_column_names: false
    subtotals_at_bottom: false
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: "A Download click shows the count that users have clicked to download\
      \ an asset linked to on your page. \n\nThe asset is a file type that is likely\
      \ to be downloaded versus being viewed in a browser. Example assets include:\
      \ .pdf, .xls, .xlsx, .doc, .docx, .ppt, etc."
    listen:
      Date Range: clicks.click_time_date
      Site: clicks.page_urlhost
      City: clicks.geo_city_and_region
      Internal Gov Traffic: clicks.is_government
      ISP: clicks.ip_isp
      Is Mobile: clicks.device_is_mobile
      URL: clicks.page_display_url
      Title: clicks.page_title
      Section: clicks.page_section
      2-letter Country Code: clicks.geo_country
      Sub Section: clicks.page_sub_section
    row: 32
    col: 12
    width: 12
    height: 8
  - name: Top Landing Page
    title: Top Landing Page
    model: snowplow_web_block
    explore: page_views
    type: looker_grid
    fields: [page_views.page_title, page_views.page_display_url, page_views.row_count]
    filters:
      page_views.page_view_in_session_index: '1'
    sorts: [page_views.row_count desc]
    limit: 15
    column_limit: 50
    total: true
    dynamic_fields:
    - table_calculation: of_landing_page_views
      label: "% of Landing Page Views"
      expression: "${page_views.row_count}/${page_views.row_count:total}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    show_view_names: true
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '11'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      page_views.landing_page_count: Landing Page View Count
      page_views.page_display_url: URL
      page_views.row_count: Landing Page View Count
      page_views.page_title: Page Title
    series_column_widths:
      page_views.row_count: 113
      of_landing_page_views: 95
    series_cell_visualizations:
      page_views.row_count:
        is_active: false
    series_text_format:
      of_landing_page_views:
        align: right
    truncate_column_names: false
    subtotals_at_bottom: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: The web page on the website that a user first visits during a session.
    listen:
      Date Range: page_views.page_view_start_date
      Site: page_views.page_urlhost
      City: page_views.geo_city_and_region
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      URL: page_views.page_display_url
      Title: page_views.page_title
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 2
    col: 0
    width: 12
    height: 10
  - name: Top Offsite Links
    title: Top Offsite Links
    model: snowplow_web_block
    explore: clicks
    type: looker_grid
    fields: [clicks.target_url, clicks.row_count]
    filters:
      clicks.click_type: '"link_click"'
      clicks.offsite_click: 'Yes'
    sorts: [clicks.row_count desc]
    limit: 20
    column_limit: 50
    total: true
    dynamic_fields:
    - table_calculation: of_offsite_clicks
      label: "% of Offsite Clicks"
      expression: "${clicks.row_count}/${clicks.row_count:total}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    show_view_names: true
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '11'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      clicks.target_url: Offsite Links
      clicks.click_count: Offsite Click Count
      clicks.target_url_nopar: Offsite Link
      clicks.session_count: Session Count
      clicks.row_count: Offsite Click Count
    series_column_widths:
      clicks.row_count: 155
      of_offsite_clicks: 138
    series_cell_visualizations:
      clicks.row_count:
        is_active: false
    series_text_format:
      of_offsite_clicks:
        align: right
    conditional_formatting: [{type: low to high, value: !!null '', background_color: !!null '',
        font_color: !!null '', palette: {name: Red to Yellow to Green, colors: ["#F36254",
            "#FCF758", "#4FBC89"]}, bold: false, italic: false, strikethrough: false,
        fields: !!null ''}]
    truncate_column_names: false
    subtotals_at_bottom: false
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: An Offsite link click on your page is a click on a URL link that does
      not contain your website's domain.
    listen:
      Date Range: clicks.click_time_date
      Site: clicks.page_urlhost
      City: clicks.geo_city_and_region
      Internal Gov Traffic: clicks.is_government
      ISP: clicks.ip_isp
      Is Mobile: clicks.device_is_mobile
      URL: clicks.page_display_url
      Title: clicks.page_title
      Section: clicks.page_section
      2-letter Country Code: clicks.geo_country
      Sub Section: clicks.page_sub_section
    row: 32
    col: 0
    width: 12
    height: 8
  - name: Top Site Search Terms
    title: Top Site Search Terms
    model: snowplow_web_block
    explore: searches
    type: looker_grid
    fields: [searches.search_terms, searches.row_count]
    filters:
      searches.search_terms: "-EMPTY"
    sorts: [searches.row_count desc]
    limit: 20
    column_limit: 50
    total: true
    dynamic_fields:
    - table_calculation: of_searches
      label: "% of Searches"
      expression: "${searches.row_count}/${searches.row_count:total}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    show_view_names: true
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '11'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      searches.terms: Search Term
      searches.search_terms: Search Term
      searches.row_count: Search Count
    series_column_widths:
      searches.row_count: 129
      of_searches: 118
    series_cell_visualizations:
      searches.row_count:
        is_active: false
    series_text_format:
      of_searches:
        align: right
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '20'
    conditional_formatting: [{type: low to high, value: !!null '', background_color: !!null '',
        font_color: !!null '', palette: {name: Red to Yellow to Green, colors: ["#F36254",
            "#FCF758", "#4FBC89"]}, bold: false, italic: false, strikethrough: false,
        fields: !!null ''}]
    truncate_column_names: true
    subtotals_at_bottom: false
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: Displays the phrases and the number of its searches within the site's
      search box which led the user to a page within the site.
    listen:
      Date Range: searches.search_time_date
      Site: searches.page_urlhost
      City: searches.geo_city_and_region
      Internal Gov Traffic: searches.is_government
      ISP: searches.ip_isp
      Is Mobile: searches.device_is_mobile
      URL: searches.page_display_url
      Title: searches.page_title
      Section: searches.page_section
      2-letter Country Code: searches.geo_country
      Sub Section: searches.page_sub_section
    row: 22
    col: 0
    width: 12
    height: 10
  - name: Page Views by Traffic Channel
    title: Page Views by Traffic Channel
    model: snowplow_web_block
    explore: page_views
    type: looker_column
    fields: [page_views.referrer_medium, page_views.row_count, page_views.page_view_start_date]
    pivots: [page_views.referrer_medium]
    fill_fields: [page_views.page_view_start_date]
    sorts: [page_views.page_view_start_date desc, page_views.referrer_medium]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Page View Count, orientation: left, series: [{axisId: direct
              - page_views.row_count, id: direct - page_views.row_count, name: direct},
          {axisId: email - page_views.row_count, id: email - page_views.row_count,
            name: email}, {axisId: internal - page_views.row_count, id: internal -
              page_views.row_count, name: internal}, {axisId: other - page_views.row_count,
            id: other - page_views.row_count, name: other}, {axisId: paid - page_views.row_count,
            id: paid - page_views.row_count, name: paid}, {axisId: search - page_views.row_count,
            id: search - page_views.row_count, name: search}, {axisId: social - page_views.row_count,
            id: social - page_views.row_count, name: social}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    x_axis_label: Date
    colors: ["#5245ed", "#ed6168", "#1ea8df", "#353b49", "#49cec1", "#b3a0dd", "#db7f2a",
      "#706080", "#a2dcf3", "#776fdf", "#e9b404", "#635189"]
    font_size: '12'
    series_colors:
      direct - page_views.row_count: "#bae6ff"
      email - page_views.row_count: "#82cfff"
      internal - page_views.row_count: "#33b1ff"
      other - page_views.row_count: "#1192e8"
      paid - page_views.row_count: "#0072c3"
      search - page_views.row_count: "#00539a"
      social - page_views.row_count: "#003a6d"
    series_labels:
      page_views.row_count: Page View Count
    hidden_fields: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: An indicator of where traffic to the website/web page comes from. Traffic
      channels are separated into a number of groups. For details about the different
      traffic channels, please visit the Glossary.
    listen:
      Date Range: page_views.page_view_start_date
      Site: page_views.page_urlhost
      City: page_views.geo_city_and_region
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      URL: page_views.page_display_url
      Title: page_views.page_title
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 2
    col: 12
    width: 12
    height: 10
  - name: Top Pages
    title: Top Pages
    model: snowplow_web_block
    explore: page_views
    type: looker_grid
    fields: [page_views.page_title, page_views.page_display_url, page_views.row_count]
    sorts: [page_views.row_count desc]
    limit: 20
    column_limit: 50
    total: true
    dynamic_fields:
    - table_calculation: of_page_views
      label: "% of Page Views"
      expression: "${page_views.row_count}/${page_views.row_count:total}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '11'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      page_views.page_display_url: URL
      page_views.page_title: Page Title
      page_views.row_count: Page View Count
    series_column_widths:
      page_views.row_count: 97
      of_page_views: 104
    series_cell_visualizations:
      page_views.row_count:
        is_active: false
    series_text_format:
      page_views.row_count:
        align: right
      of_page_views:
        align: right
    truncate_column_names: false
    subtotals_at_bottom: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: Displays the top performing pages based on page view count.
    listen:
      Date Range: page_views.page_view_start_date
      Site: page_views.page_urlhost
      City: page_views.geo_city_and_region
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      URL: page_views.page_display_url
      Title: page_views.page_title
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 12
    col: 0
    width: 12
    height: 10
  - name: Top Referrer URL Hosts
    title: Top Referrer URL Hosts
    model: snowplow_web_block
    explore: page_views
    type: looker_grid
    fields: [page_views.referrer_urlhost, page_views.row_count]
    sorts: [page_views.row_count desc]
    limit: 20
    total: true
    dynamic_fields:
    - table_calculation: of_referrals
      label: "% of Referrals"
      expression: "${page_views.row_count} / sum(${page_views.row_count})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '11'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      page_views.session_count: Referral Count
      page_views.row_count: Referral Count
    series_column_widths:
      page_views.row_count: 149
      of_referrals: 122
    series_cell_visualizations:
      page_views.row_count:
        is_active: false
    series_text_format:
      of_referrals:
        align: right
    truncate_column_names: false
    subtotals_at_bottom: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    point_style: none
    y_axes: [{label: '', orientation: left, series: [{id: page_views.session_count,
            name: Session Count, axisId: page_views.session_count}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: !!null '', orientation: right, series: [{id: of_all_referrals,
            name: "% of all referrals", axisId: of_all_referrals}], showLabels: true,
        showValues: true, maxValue: 1, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: |-
      Users landing on the website/web page from other websites, search engines, etc.

      If you see this result "statics.teams.cdn.office.net", the referrer is coming from a Microsoft Teams environment.

      For example, you shared the website link in a Teams chat, and folks are clicking on that link.
    listen:
      Date Range: page_views.page_view_start_date
      Site: page_views.page_urlhost
      City: page_views.geo_city_and_region
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      URL: page_views.page_display_url
      Title: page_views.page_title
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 12
    col: 12
    width: 12
    height: 10
  - name: Top Referral URLs
    title: Top Referral URLs
    model: snowplow_web_block
    explore: page_views
    type: looker_grid
    fields: [page_views.page_referrer, page_views.row_count]
    sorts: [page_views.row_count desc]
    limit: 20
    total: true
    dynamic_fields:
    - table_calculation: of_all_page_views
      label: "% of all Page Views"
      expression: "${page_views.row_count}/${page_views.row_count:total}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '11'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      page_views.page_view_count: Page Views
      page_views.page_referrer: Referral URL
      page_views.row_count: Page Views
    series_column_widths:
      page_views.row_count: 124
      of_all_page_views: 143
    series_cell_visualizations:
      page_views.row_count:
        is_active: false
    series_text_format:
      of_all_page_views:
        align: right
    truncate_column_names: false
    subtotals_at_bottom: false
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: "Users landing on the website/web page from other websites, search\
      \ engines, etc. \nIf you see a result containing this \"statics.teams.cdn.office.net\"\
      , the referrer is coming from a Microsoft Teams environment.\nFor example, you\
      \ shared the website link in a Teams chat, and folks are clicking on that link."
    listen:
      Date Range: page_views.page_view_start_date
      Site: page_views.page_urlhost
      City: page_views.geo_city_and_region
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      URL: page_views.page_display_url
      Title: page_views.page_title
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 22
    col: 12
    width: 12
    height: 10
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "<p style=\"background-color:#d9eaf7; border: 1px solid transparent;\
      \ border-radius: 4px; color:#313132; font-size: 16px; padding: 15px;\">\n<b>Help\
      \ Resources</b>:\n<a href=\"https://engage.cloud.microsoft/main/groups/eyJfdHlwZSI6Ikdyb3VwIiwiaWQiOiI0NTkxMjA2NDAifQ/all\"\
      \ target=\"_blank\"><b>Office Hours & Intro Training Webinar</b></a><b>  | \
      \ \n<a href=\"https://engage.cloud.microsoft/main/groups/eyJfdHlwZSI6Ikdyb3VwIiwiaWQiOiI0NTkxMjA2NDAifQ/all\"\
      \ target=\"_blank\"><b>Viva Engage Analytics Community</b></a><b> |\n<a href=\"\
      https://www2.gov.bc.ca/gov/content/governments/services-for-government/service-experience-digital-delivery/web-content-development-guides/analytics\"\
      \ target=\"_blank\"><b>Web Analytics Guide & Glossary</b></a>\n"
    row: 0
    col: 0
    width: 24
    height: 2
  filters:
  - name: Date Range
    title: Date Range
    type: field_filter
    default_value: 7 days ago for 7 days
    allow_multiple_values: true
    required: true
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.page_view_start_date
  - name: Site
    title: Site
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.page_urlhost
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.geo_city_and_region
  - name: 2-letter Country Code
    title: 2-letter Country Code
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.geo_country
  - name: Internal Gov Traffic
    title: Internal Gov Traffic
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.is_government
  - name: ISP
    title: ISP
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.ip_isp
  - name: Is Mobile
    title: Is Mobile
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.device_is_mobile
  - name: URL
    title: URL
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.page_display_url
  - name: Title
    title: Title
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.page_title
  - name: Section
    title: Section
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.page_section
  - name: Sub Section
    title: Sub Section
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.page_sub_section
