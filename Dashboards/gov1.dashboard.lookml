- dashboard: bc_gov_analytics_dashboard_1
  title: BC Gov Analytics Dashboard 1
  layout: newspaper
  refresh: 30 minutes
  elements:
  - name: Average Session Duration this Period and Percent Change Since Last Period
    title: Average Session Duration this Period and Percent Change Since Last Period
    model: snowplow_web_block
    explore: sessions
    type: single_value
    fields:
    - sessions.date_window
    - sessions.average_session_length
    fill_fields:
    - sessions.date_window
    filters:
      sessions.is_in_current_period_or_last_period: 'Yes'
    sorts:
    - sessions.date_window
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
    query_timezone: America/Vancouver
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    single_value_title: Avg Session Duration
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Date Range: sessions.flexible_filter_date_range
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 0
    col: 6
    width: 6
    height: 2
  - name: Unique Visits this Period and Percent Change Since Last Period
    title: Unique Visits this Period and Percent Change Since Last Period
    model: snowplow_web_block
    explore: sessions
    type: single_value
    fields:
    - sessions.date_window
    - sessions.user_count
    fill_fields:
    - sessions.date_window
    filters:
      sessions.is_in_current_period_or_last_period: 'Yes'
    sorts:
    - sessions.date_window
    limit: 500
    dynamic_fields:
    - table_calculation: last_period
      label: last period
      expression: "(${sessions.user_count} / offset(${sessions.user_count}, 1)) -\
        \ 1"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    single_value_title: Unique Visits
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Date Range: sessions.flexible_filter_date_range
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 0
    col: 0
    width: 6
    height: 2
  - name: Page Views Comparison
    title: Page Views Comparison
    model: snowplow_web_block
    explore: sessions
    type: looker_line
    fields:
    - sessions.date_window
    - sessions.comparison_date
    - sessions.page_view_count
    pivots:
    - sessions.date_window
    filters:
      sessions.user_count: NOT NULL
      sessions.is_in_current_period_or_last_period: 'Yes'
    sorts:
    - sessions.date_window 0
    - sessions.comparison_date desc
    limit: 500
    query_timezone: America/Vancouver
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_labels:
      current_period - Yes|FIELD|0 - sessions.page_view_count: Current Period
      last_period - Yes|FIELD|1 - sessions.page_view_count: Last Period
    series_types: {}
    limit_displayed_rows: false
    y_axes: []
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
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    listen:
      Date Range: sessions.flexible_filter_date_range
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 2
    col: 12
    width: 12
    height: 7
  - name: Page Views this Period and Percent Change Since Last Period
    title: Page Views this Period and Percent Change Since Last Period
    model: snowplow_web_block
    explore: sessions
    type: single_value
    fields:
    - sessions.date_window
    - sessions.page_view_count
    fill_fields:
    - sessions.date_window
    filters:
      sessions.is_in_current_period_or_last_period: 'Yes'
    sorts:
    - sessions.date_window
    limit: 500
    dynamic_fields:
    - table_calculation: last_period
      label: last period
      expression: "(${sessions.page_view_count} / offset(${sessions.page_view_count},\
        \ 1)) - 1"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    single_value_title: Page Views
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Date Range: sessions.flexible_filter_date_range
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 0
    col: 12
    width: 6
    height: 2
  - name: Bounce Rate this Period and Percent Change Since Last Period
    title: Bounce Rate this Period and Percent Change Since Last Period
    model: snowplow_web_block
    explore: sessions
    type: single_value
    fields:
    - sessions.date_window
    - sessions.bounced_user_count
    - sessions.user_count
    fill_fields:
    - sessions.date_window
    filters:
      sessions.is_in_current_period_or_last_period: 'Yes'
    sorts:
    - sessions.date_window
    limit: 500
    dynamic_fields:
    - table_calculation: bounce_rate
      label: Bounce Rate
      expression: "${sessions.bounced_user_count}/${sessions.user_count}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: last_period
      label: Last Period
      expression: "(${bounce_rate} - offset(${bounce_rate}, 1))"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    single_value_title: Bounce Rate
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    series_types: {}
    hidden_fields:
    - sessions.user_count
    - sessions.bounced_user_count
    y_axes: []
    listen:
      Date Range: sessions.flexible_filter_date_range
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 0
    col: 18
    width: 6
    height: 2
  - name: Traffic Summary
    title: Traffic Summary
    model: snowplow_web_block
    explore: sessions
    type: looker_column
    fields:
    - sessions.summary_date
    - sessions.user_count
    - sessions.session_count
    - sessions.page_view_count
    filters:
      sessions.in_summary_period: 'Yes'
    sorts:
    - sessions.summary_date
    limit: 500
    query_timezone: America/Vancouver
    stacking: ''
    show_value_labels: true
    label_density: 25
    font_size: 70%
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_types: {}
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
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Date Range: sessions.flexible_filter_date_range
      Site: sessions.first_page_urlhost
      Time Period for Traffic Summary: sessions.summary_granularity
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    note_state: collapsed
    note_display: below
    note_text: "This report summarizes page views, sessions, and users over the date\
      \ range. Use the \"Time Period\" filter to determine whether this report is\
      \ summarized by day, month, or year. \n\nWhen summarizing by month or year,\
      \ it will include all dates in any month or year that overlaps the date range."
    row: 2
    col: 0
    width: 12
    height: 8
  - name: Traffic Map
    title: Traffic Map
    model: snowplow_web_block
    explore: sessions
    type: looker_map
    fields:
    - sessions.geo_location
    - sessions.session_count
    sorts:
    - sessions.session_count desc
    limit: 5000
    column_limit: 50
    query_timezone: America/Vancouver
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: custom
    map_latitude: 52.522905940278065
    map_longitude: -124.38720703125001
    map_zoom: 5
    map_scale_indicator: metric
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: pixels
    map_marker_radius_min: 1
    map_marker_radius_max: 12
    map_marker_proportional_scale_type: log
    map_marker_color_mode: fixed
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map: world
    map_projection: ''
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    colors:
    - 'palette: Santa Cruz'
    series_colors: {}
    point_color: "#5245ed"
    hidden_fields: []
    y_axes: []
    listen:
      Date Range: sessions.session_start_date
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 9
    col: 12
    width: 12
    height: 11
  - name: Traffic Channels
    title: Traffic Channels
    model: snowplow_web_block
    explore: sessions
    type: looker_column
    fields:
    - sessions.referrer_medium
    - sessions.session_start_date
    - sessions.session_count
    pivots:
    - sessions.referrer_medium
    fill_fields:
    - sessions.session_start_date
    sorts:
    - sessions.referrer_medium 0
    - sessions.session_start_date
    limit: 1000
    column_limit: 50
    query_timezone: America/Vancouver
    stacking: normal
    colors:
    - "#5245ed"
    - "#ed6168"
    - "#1ea8df"
    - "#353b49"
    - "#49cec1"
    - "#b3a0dd"
    - "#db7f2a"
    - "#706080"
    - "#a2dcf3"
    - "#776fdf"
    - "#e9b404"
    - "#635189"
    show_value_labels: false
    label_density: 25
    font_size: '12'
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_colors: {}
    series_types: {}
    limit_displayed_rows: false
    y_axes: []
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
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: []
    listen:
      Date Range: sessions.session_start_date
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 10
    col: 0
    width: 12
    height: 9
  - name: Top Pages
    title: Top Pages
    model: snowplow_web_block
    explore: page_views
    type: table
    fields:
    - page_views.page_title
    - page_views.page_view_count
    - page_views.page_display_url
    sorts:
    - page_views.page_view_count desc
    limit: 20
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    subtotals_at_bottom: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      page_views.page_display_url: URL
      page_views.page_title: Title
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    series_types: {}
    y_axes: []
    listen:
      Date Range: page_views.page_view_start_date
      Site: page_views.page_urlhost
      City: page_views.geo_city_and_region
      Region: page_views.geo_region_name
      Internal Gov Traffic: page_views.is_government
      Is Mobile: page_views.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: page_views.page_title
      URL: page_views.page_url
    row: 19
    col: 0
    width: 12
    height: 16
  - name: Time of Day and Day of Week Heatmap
    title: Time of Day and Day of Week Heatmap
    model: snowplow_web_block
    explore: sessions
    type: table
    fields:
    - sessions.session_start_hour_of_day
    - sessions.session_count
    - sessions.session_start_day_of_week
    pivots:
    - sessions.session_start_day_of_week
    fill_fields:
    - sessions.session_start_hour_of_day
    - sessions.session_start_day_of_week
    sorts:
    - sessions.session_start_day_of_week 0
    - sessions.session_start_hour_of_day
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: if(${sessions.session_start_hour_of_day} > 12, concat(to_string(${sessions.session_start_hour_of_day}
        - 12), " pm") , concat(to_string(${sessions.session_start_hour_of_day}), "
        am") )
      value_format:
      value_format_name:
      _kind_hint: dimension
      _type_hint: string
    - table_calculation: calculation_2
      label: Calculation 2
      expression: concat(to_string(${sessions.session_start_hour_of_day}),":00")
      value_format:
      value_format_name:
      _kind_hint: dimension
      _type_hint: string
    query_timezone: America/Vancouver
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    subtotals_at_bottom: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      sessions.session_start_hour_of_day: Hour of Day
      sessions.session_start_day_of_week: Day of Week
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting:
    - type: along a scale...
      value:
      background_color:
      font_color:
      palette:
        name: Red to Yellow to Green
        colors:
        - "#F36254"
        - "#FCF758"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - sessions.session_count
      color_application:
        collection_id: legacy
        custom:
          id: c8c9683b-b11a-e625-8b89-cfa1ec613fc5
          label: Custom
          type: continuous
          stops:
          - color: "#F36254"
            offset: 0
          - color: "#FCF758"
            offset: 50
          - color: "#4FBC89"
            offset: 100
        options:
          steps: 5
          reverse: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: true
    hidden_fields:
    - calculation_1
    - calculation_2
    y_axes: []
    listen:
      Date Range: sessions.session_start_date
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 20
    col: 12
    width: 12
    height: 13
  - name: Top Landing Page
    title: Top Landing Page
    model: snowplow_web_block
    explore: page_views
    type: looker_column
    fields:
    - page_views.landing_page_count
    - page_views.page_title
    sorts:
    - page_views.landing_page_count desc
    limit: 10
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
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
    listen:
      Date Range: page_views.page_view_start_date
      Site: page_views.page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: page_views.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: page_views.page_title
      URL: sessions.first_page_url
    row: 33
    col: 12
    width: 12
    height: 9
  - name: Top Referer URL Hosts
    title: Top Referer URL Hosts
    model: snowplow_web_block
    explore: sessions
    type: looker_column
    fields:
    - sessions.session_count
    - sessions.referrer_urlhost
    sorts:
    - sessions.session_count desc
    limit: 20
    column_limit: 50
    dynamic_fields:
    - table_calculation: of_all_referrals
      label: "% of all referrals"
      expression: "${sessions.session_count} / sum(${sessions.session_count})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    hide_legend: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    limit_displayed_rows: false
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: sessions.session_count
        name: Session Count
        axisId: sessions.session_count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label:
      orientation: right
      series:
      - id: of_all_referrals
        name: "% of all referrals"
        axisId: of_all_referrals
      showLabels: true
      showValues: true
      maxValue: 1
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
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
    listen:
      Date Range: sessions.session_start_date
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 35
    col: 0
    width: 12
    height: 9
  - name: Top Browsers
    title: Top Browsers
    model: snowplow_web_block
    explore: sessions
    type: table
    fields:
    - sessions.browser_name
    - sessions.session_count
    - sessions.user_count
    sorts:
    - sessions.session_count desc
    limit: 20
    total: true
    dynamic_fields:
    - table_calculation: of_sessions
      label: "% of Sessions"
      expression: "${sessions.session_count}/${sessions.session_count:total}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: of_visitors
      label: "% of Visitors"
      expression: "${sessions.user_count}/${sessions.user_count:total}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    subtotals_at_bottom: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      sessions.browser_name: Browser
      sessions.session_count: Sessions
      sessions.user_count: Visitors
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields:
    series_types: {}
    listen:
      Date Range: sessions.session_start_date
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 42
    col: 12
    width: 12
    height: 10
  - name: Top Offsite Links
    title: Top Offsite Links
    model: snowplow_web_block
    explore: clicks
    type: table
    fields:
    - clicks.click_count
    - clicks.session_count
    - clicks.target_url_nopar
    filters:
      clicks.click_type: link^_click
      clicks.offsite_click: 'Yes'
    sorts:
    - clicks.click_count desc
    limit: 20
    column_limit: 50
    total: true
    query_timezone: America/Vancouver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      clicks.target_url: Offsite Links
      clicks.click_count: Exits
      clicks.session_count: Sessions
      clicks.target_url_nopar: Offsite Link
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting:
    - type: low to high
      value:
      background_color:
      font_color:
      palette:
        name: Red to Yellow to Green
        colors:
        - "#F36254"
        - "#FCF758"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields:
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields: []
    y_axes: []
    listen:
      Date Range: clicks.click_time_date
      Site: clicks.page_urlhost
      City: clicks.geo_city_and_region
      Region: clicks.geo_region_name
      Internal Gov Traffic: clicks.is_government
      Is Mobile: clicks.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: clicks.page_title
      URL: clicks.page_url
    row: 44
    col: 0
    width: 12
    height: 10
  - name: Top Site Search Terms
    title: Top Site Search Terms
    model: snowplow_web_block
    explore: searches
    type: table
    fields:
    - searches.search_terms
    - searches.search_count
    filters:
      searches.search_terms: "-EMPTY"
    sorts:
    - searches.search_count desc
    limit: 20
    column_limit: 50
    total: true
    dynamic_fields:
    - table_calculation: of_searches
      label: "% of Searches"
      expression: "${searches.search_count}/${searches.search_count:total}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: true
    hide_totals: false
    hide_row_totals: false
    series_labels:
      searches.terms: Search Term
      searches.search_count: Count
      searches.search_terms: Search Term
    table_theme: editable
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '20'
    enable_conditional_formatting: false
    conditional_formatting:
    - type: low to high
      value:
      background_color:
      font_color:
      palette:
        name: Red to Yellow to Green
        colors:
        - "#F36254"
        - "#FCF758"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields:
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields: []
    y_axes: []
    listen:
      Date Range: searches.search_time_date
      Site: searches.page_urlhost
      City: searches.geo_city_and_region
      Region: searches.geo_region_name
      Internal Gov Traffic: searches.is_government
      Is Mobile: searches.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: searches.page_title
      URL: searches.page_url
    row: 52
    col: 12
    width: 12
    height: 10
  - name: Top Downloaded Files
    title: Top Downloaded Files
    model: snowplow_web_block
    explore: clicks
    type: table
    fields:
    - clicks.target_url
    - clicks.download_click_count
    filters:
      clicks.click_type: download
    sorts:
    - clicks.download_click_count desc
    limit: 20
    total: true
    dynamic_fields:
    - table_calculation: of_total_downloads
      label: "% of Total Downloads"
      expression: "${clicks.download_click_count}/${clicks.download_click_count:total}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    subtotals_at_bottom: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      clicks.download_click_count: Downloads
      clicks.target_url: Downloaded File
      clicks.session_count: Sessions
    table_theme: editable
    limit_displayed_rows: false
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    enable_conditional_formatting: false
    conditional_formatting:
    - type: low to high
      value:
      background_color:
      font_color:
      palette:
        name: Red to Yellow to Green
        colors:
        - "#F36254"
        - "#FCF758"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields:
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    hidden_fields:
    y_axes: []
    listen:
      Date Range: clicks.click_time_date
      Site: clicks.page_urlhost
      City: clicks.geo_city_and_region
      Region: clicks.geo_region_name
      Internal Gov Traffic: clicks.is_government
      Is Mobile: clicks.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: clicks.page_title
      URL: clicks.page_url
    row: 54
    col: 0
    width: 12
    height: 7
  - name: Top Platforms
    title: Top Platforms
    model: snowplow_web_block
    explore: sessions
    type: table
    fields:
    - sessions.os_family
    - sessions.session_count
    - sessions.user_count
    sorts:
    - sessions.session_count desc
    limit: 10
    total: true
    dynamic_fields:
    - table_calculation: of_sessions
      label: "% of Sessions"
      expression: "${sessions.session_count}/${sessions.session_count:total}\n  "
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: of_visitors
      label: "% of Visitors"
      expression: "${sessions.user_count}/${sessions.user_count:total}\n  "
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Vancouver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    subtotals_at_bottom: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      sessions.os_family: Operating System
      sessions.session_count: Sessions
      sessions.user_count: Visitors
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields:
    - operating_system
    series_types: {}
    listen:
      Date Range: sessions.session_start_date
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: sessions.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 62
    col: 12
    width: 12
    height: 6
  - name: Marketing Campaigns
    title: Marketing Campaigns
    model: snowplow_web_block
    explore: page_views
    type: looker_column
    fields:
    - page_views.marketing_campaign
    - page_views.session_count
    - page_views.page_view_count
    filters:
      page_views.marketing_campaign: "-EMPTY"
    sorts:
    - page_views.page_view_count desc
    - page_views.marketing_campaign
    limit: 20
    column_limit: 50
    query_timezone: America/Vancouver
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    hide_legend: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_types: {}
    limit_displayed_rows: false
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: page_views.session_count
        name: Session Count
        axisId: page_views.session_count
      - id: page_views.page_view_count
        name: Page View Count
        axisId: page_views.page_view_count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
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
    listen:
      Date Range: sessions.session_start_date
      Site: sessions.first_page_urlhost
      City: sessions.geo_city_and_region
      Region: sessions.geo_region_name
      Internal Gov Traffic: page_views.is_government
      Is Mobile: sessions.device_is_mobile
      Theme: cmslite_themes.theme
      Sub Theme: cmslite_themes.subtheme
      Title: sessions.first_page_title
      URL: sessions.first_page_url
    row: 61
    col: 0
    width: 12
    height: 12
  filters:
  - name: Date Range
    title: Date Range
    type: date_filter
    default_value: 7 days ago for 7 days
    allow_multiple_values: true
    required: true
  - name: Site
    title: Site
    type: field_filter
    default_value: www2.gov.bc.ca
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: sessions
    listens_to_filters: []
    field: sessions.first_page_urlhost
  - name: Time Period for Traffic Summary
    title: Time Period for Traffic Summary
    type: field_filter
    default_value: Day
    allow_multiple_values: true
    required: true
    model: snowplow_web_block
    explore: sessions
    listens_to_filters: []
    field: sessions.summary_granularity
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: sessions
    listens_to_filters: []
    field: sessions.geo_city_and_region
  - name: Region
    title: Region
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: sessions
    listens_to_filters: []
    field: sessions.geo_region_name
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
  - name: Is Mobile
    title: Is Mobile
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: sessions.device_is_mobile
  - name: Theme
    title: Theme
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: cmslite_themes.theme
  - name: Sub Theme
    title: Sub Theme
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: page_views
    listens_to_filters: []
    field: cmslite_themes.subtheme
  - name: Title
    title: Title
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: sessions
    listens_to_filters: []
    field: sessions.first_page_title
  - name: URL
    title: URL
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: snowplow_web_block
    explore: sessions
    listens_to_filters: []
    field: sessions.first_page_url
