---
- dashboard: web_analytics_dashboard__traffic
  title: Web Analytics Dashboard - Traffic
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: Wb6x9HX8Bm2eg5FfhIW9kw
  elements:
  - name: Page Views Comparison
    title: Page Views Comparison
    model: snowplow_web_block
    explore: page_views
    type: looker_line
    fields: [page_views.comparison_date, page_views.page_view_count, page_views.date_window]
    pivots: [page_views.date_window]
    filters:
      page_views.is_in_current_period_or_last_period: 'Yes'
    sorts: [page_views.comparison_date, page_views.date_window 0]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: A chart comparing page views during the current period and the last
      period, according to the date range selected.
    listen:
      Date Range: page_views.flexible_filter_date_range
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 4
    col: 12
    width: 12
    height: 8
  - name: Average Session Duration this Period and Percent Change Since Last Period
    title: Average Session Duration this Period and Percent Change Since Last Period
    model: snowplow_web_block
    explore: sessions
    type: single_value
    fields: [sessions.date_window, sessions.average_session_length]
    filters:
      sessions.is_in_current_period_or_last_period: 'Yes'
    sorts: [sessions.date_window]
    limit: 500
    dynamic_fields:
    - table_calculation: last_period
      label: last period
      expression: "(${sessions.average_session_length} / offset(${sessions.average_session_length},\
        \ 1)) - 1"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    custom_color_enabled: false
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: forestgreen
    single_value_title: Avg Session Duration
    comparison_label: from last period
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
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
    note_text: The “average session duration” calculates the average amount of time
      people stay on gov.bc.ca when they visit your pages. The percentage shows by
      how much the length of user sessions has increased or decreased over the selected
      date range.
    listen:
      Date Range: sessions.flexible_filter_date_range
      City: sessions.geo_city_and_region
      Site: sessions.first_page_urlhost
      Internal Gov Traffic: sessions.is_government
      ISP: sessions.ip_isp
      Is Mobile: sessions.device_is_mobile
      Title: sessions.first_page_title
      URL: sessions.first_page_display_url
      Section: sessions.first_page_section
      2-letter Country Code: sessions.geo_country
      Sub Section: sessions.first_page_sub_section
    row: 2
    col: 6
    width: 6
    height: 2
  - name: Top Browsers
    title: Top Browsers
    model: snowplow_web_block
    explore: page_views
    type: looker_grid
    fields: [page_views.session_count, page_views.user_count, page_views.browser_family]
    sorts: [page_views.user_count desc]
    limit: 20
    column_limit: 50
    total: true
    dynamic_fields:
    - table_calculation: of_sessions
      label: "% of Sessions"
      expression: "${page_views.session_count}/${page_views.session_count:total}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: of_users
      label: "% of Users"
      expression: "${page_views.user_count}/${page_views.user_count:total}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    show_view_names: false
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
      page_views.browser_name: Browser
    series_column_widths:
      page_views.user_count: 121
      page_views.session_count: 125
      of_sessions: 122
      of_users: 111
    series_cell_visualizations:
      page_views.session_count:
        is_active: false
    series_text_format:
      of_sessions:
        align: right
      of_users:
        align: right
    truncate_column_names: false
    subtotals_at_bottom: false
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: A table of browsers, users, sessions, and percent of sessions ordered
      by users count.
    listen:
      Date Range: page_views.page_view_start_date
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 25
    col: 12
    width: 12
    height: 8
  - name: Time of Day and Day of Week Heatmap
    title: Time of Day and Day of Week Heatmap
    model: snowplow_web_block
    explore: page_views
    type: looker_grid
    fields: [page_views.session_count, page_views.page_view_start_day_of_week, page_views.page_view_start_hour_of_day]
    pivots: [page_views.page_view_start_day_of_week]
    fill_fields: [page_views.page_view_start_hour_of_day, page_views.page_view_start_day_of_week]
    sorts: [page_views.page_view_start_day_of_week 0, page_views.page_view_start_hour_of_day]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '11'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: true
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      page_views.page_view_start_hour_of_day: Hour of Day
      page_views.page_view_start_day_of_week: Day of Week
    series_column_widths:
      page_views.page_view_start_hour_of_day: 106
    series_cell_visualizations:
      page_views.session_count:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', palette: {name: Red to Yellow to Green, colors: ["#F36254",
            "#FCF758", "#4FBC89"]}, bold: false, italic: false, strikethrough: false,
        fields: [page_views.session_count], color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab, options: {steps: 5, reverse: false}}}]
    truncate_column_names: false
    subtotals_at_bottom: false
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: A table showing the day of week as columns and hour of day rows, counting
      sessions for each over the time frame specified by the date range in the filter
      section.
    listen:
      Date Range: page_views.page_view_start_date
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 12
    col: 0
    width: 12
    height: 13
  - name: Page Views this Period and Percent Change Since Last Period - page views
    title: Page Views this Period and Percent Change Since Last Period - page views
    model: snowplow_web_block
    explore: page_views
    type: single_value
    fields: [page_views.date_window, page_views.row_count]
    filters:
      page_views.is_in_current_period_or_last_period: 'Yes'
    sorts: [page_views.date_window]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: last_period
      label: last period
      expression: "(${page_views.row_count}/ offset(${page_views.row_count}, 1)) -\
        \ 1"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    custom_color_enabled: false
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: forestgreen
    single_value_title: Page Views
    comparison_label: from last period
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: The number of times a web page has been viewed. A user can have multiple
      page views during a session. A high number of page views within a session may
      indicate users have navigated back to the page. It may be intentional, if page
      A is a hub for the rest of your content.
    listen:
      Date Range: page_views.flexible_filter_date_range
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 2
    col: 12
    width: 6
    height: 2
  - name: Top Platforms
    title: Top Platforms
    model: snowplow_web_block
    explore: page_views
    type: looker_grid
    fields: [page_views.os_family, page_views.session_count, page_views.user_count]
    sorts: [page_views.session_count desc]
    limit: 10
    total: true
    dynamic_fields:
    - table_calculation: of_sessions
      label: "% of Sessions"
      expression: "${page_views.session_count}/${page_views.session_count:total}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: of_users
      label: "% of Users"
      expression: "${page_views.user_count}/${page_views.user_count:total}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    show_view_names: false
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
      page_views.os_family: Operating System
    series_column_widths:
      page_views.session_count: 142
      page_views.user_count: 117
      of_sessions: 120
      of_users: 106
    series_cell_visualizations:
      page_views.session_count:
        is_active: false
    series_text_format:
      of_sessions:
        align: right
      of_users:
        align: right
    truncate_column_names: false
    subtotals_at_bottom: false
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: A table of operating systems, users, sessions, and percent of sessions
      ordered by users count.
    listen:
      Date Range: page_views.page_view_start_date
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 25
    col: 0
    width: 12
    height: 8
  - name: Traffic Map
    title: Traffic Map
    model: snowplow_web_block
    explore: page_views
    type: looker_map
    fields: [page_views.geo_location, page_views.session_count]
    limit: 5000
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: custom
    map_scale_indicator: metric
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: pixels
    map_marker_proportional_scale_type: log
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map_latitude: 52.5229059402781
    map_longitude: -124.38720703125
    map_zoom: 5
    map_marker_radius_min: 1
    map_marker_radius_max: 12
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: A map, centred on B.C., showing sessions by their geo locations (longitude
      and latitude). Dot size is based on session counts.
    listen:
      Date Range: page_views.page_view_start_date
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 12
    col: 12
    width: 12
    height: 13
  - name: Traffic Summary
    title: Traffic Summary
    model: snowplow_web_block
    explore: page_views
    type: looker_column
    fields: [page_views.summary_date, page_views.user_count, page_views.session_count,
      page_views.row_count]
    filters:
      page_views.in_summary_period: 'Yes'
    sorts: [page_views.summary_date]
    limit: 500
    total: true
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
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: []
    series_colors:
      page_views.page_view_count: "#BABABA"
      page_views.row_count: "#BABABA"
    series_labels:
      page_views.row_count: Page View Count
    label_color: ["#012749"]
    hidden_fields: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: This report summarizes page views, sessions, and users over the date
      range. Use the "Time Period" filter to determine whether this report is summarized
      by day, month, or year. When summarizing by month or year, it will include all
      dates in any month or year that overlaps the date range.
    listen:
      Date Range: page_views.flexible_filter_date_range
      Time Period for Traffic Summary: page_views.summary_granularity
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 4
    col: 0
    width: 12
    height: 8
  - name: Unique Visits this Period and Percent Change Since Last Period
    title: Unique Visits this Period and Percent Change Since Last Period
    model: snowplow_web_block
    explore: page_views
    type: single_value
    fields: [page_views.date_window, page_views.session_count]
    filters:
      page_views.is_in_current_period_or_last_period: 'Yes'
    sorts: [page_views.date_window]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: last_period
      label: last period
      expression: "(${page_views.session_count} / offset(${page_views.session_count},\
        \ 1)) - 1"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    custom_color_enabled: false
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: forestgreen
    single_value_title: Sessions
    comparison_label: from last period
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: The record of a user’s presence and actions performed on a website.
      This may include multiple page views, events, etc. Previously in WebTrends,
      this was referred to as a Visit.
    listen:
      Date Range: page_views.flexible_filter_date_range
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 2
    col: 0
    width: 6
    height: 2
  - name: Page Views per Session this Period and Percent Change Since Last Period
    title: Page Views per Session this Period and Percent Change Since Last Period
    model: snowplow_web_block
    explore: page_views
    type: single_value
    fields: [page_views.date_window, page_views.page_view_count, page_views.session_count]
    filters:
      page_views.is_in_current_period_or_last_period: 'Yes'
    sorts: [page_views.date_window]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: page_views_per_session
      label: Page Views per Session
      expression: "${page_views.page_view_count}/${page_views.session_count}"
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: last_period
      label: last period
      expression: "(${page_views_per_session} - offset(${page_views_per_session},\
        \ 1))/offset(${page_views_per_session}, 1)"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    custom_color_enabled: false
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: forestgreen
    single_value_title: Page Views per Session
    comparison_label: from last period
    hidden_fields: [page_views.page_view_count, page_views.session_count]
    defaults_version: 1
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: The average number of pages that a user has viewed per session.
    listen:
      Date Range: page_views.flexible_filter_date_range
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 2
    col: 18
    width: 6
    height: 2
  - name: Top ISPs
    title: Top ISPs
    model: snowplow_web_block
    explore: page_views
    type: looker_grid
    fields: [page_views.session_count, page_views.user_count, page_views.ip_isp]
    sorts: [page_views.session_count desc]
    limit: 15
    column_limit: 50
    total: true
    dynamic_fields:
    - table_calculation: of_sessions
      label: "% of Sessions"
      expression: "${page_views.session_count}/${page_views.session_count:total}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: of_users
      label: "% of Users"
      expression: "${page_views.user_count}/${page_views.user_count:total}"
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
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      page_views.os_family: Operating System
    series_column_widths:
      page_views.user_count: 89
      page_views.session_count: 111
      of_sessions: 96
      of_users: 82
    series_cell_visualizations:
      page_views.session_count:
        is_active: false
    series_text_format:
      of_sessions:
        align: right
      of_users:
        align: right
    truncate_column_names: false
    subtotals_at_bottom: false
    hidden_fields: []
    y_axes: []
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: A table of Internet Service Providers(ISP), users, sessions, and percent
      of sessions ordered by users count.
    listen:
      Date Range: page_views.page_view_start_date
      City: page_views.geo_city_and_region
      Site: page_views.page_urlhost
      Internal Gov Traffic: page_views.is_government
      ISP: page_views.ip_isp
      Is Mobile: page_views.device_is_mobile
      Title: page_views.page_title
      URL: page_views.page_display_url
      Section: page_views.page_section
      2-letter Country Code: page_views.geo_country
      Sub Section: page_views.page_sub_section
    row: 33
    col: 0
    width: 12
    height: 9
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
    ui_config:
      type: advanced
      display: popover
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.page_view_start_date
  - name: Time Period for Traffic Summary
    title: Time Period for Traffic Summary
    type: field_filter
    default_value: Day
    allow_multiple_values: false
    required: true
    ui_config:
      type: advanced
      display: popover
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.summary_granularity
  - name: City
    title: City
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
      options: []
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: page_views.geo_country
  - name: Site
    title: Site
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
    field: page_views.page_urlhost
  - name: Internal Gov Traffic
    title: Internal Gov Traffic
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
    field: page_views.is_government
  - name: ISP
    title: ISP
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
    field: page_views.ip_isp
  - name: Is Mobile
    title: Is Mobile
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
    field: page_views.device_is_mobile
  - name: Title
    title: Title
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
    field: page_views.page_title
  - name: URL
    title: URL
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
    field: page_views.page_display_url
  - name: Section
    title: Section
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
