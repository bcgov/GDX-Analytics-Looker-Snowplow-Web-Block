- dashboard: gdx_kpis
  title: GDX KPIs
  layout: newspaper
  embed_style:
    background_color: "#f6f8fa"
    show_title: true
    title_color: "#3a4245"
    show_filters_bar: true
    tile_text_color: "#3a4245"
    text_tile_text_color: ''
  elements:
  - name: Number of users
    title: Number of users
    model: snowplow_web_block
    explore: sessions
    type: single_value
    fields:
    - sessions.session_start_window
    - sessions.user_count
    sorts:
    - sessions.session_start_window
    dynamic_fields:
    - table_calculation: change
      label: Change since last period
      expression: offset(${sessions.user_count}, 0) - offset(${sessions.user_count},
        1)
      __FILE: snowplow_web_block/web.dashboard.lookml
      __LINE_NUM: 44
    show_comparison: true
    comparison_type: change
    comparison_label: compared to last period
    show_comparison_label: true
    listen:
      City: sessions.geo_city
    row: 0
    col: 0
    width: 6
    height: 4
  - name: Number of new users
    title: Number of new users
    model: snowplow_web_block
    explore: sessions
    type: single_value
    fields:
    - sessions.session_start_window
    - sessions.new_user_count
    sorts:
    - sessions.session_start_window
    dynamic_fields:
    - table_calculation: change
      label: Change since last period
      expression: offset(${sessions.new_user_count}, 0) - offset(${sessions.new_user_count},
        1)
      __FILE: snowplow_web_block/web.dashboard.lookml
      __LINE_NUM: 61
    show_comparison: true
    comparison_type: change
    comparison_label: compared to last period
    show_comparison_label: true
    listen:
      City: sessions.geo_city
    row: 0
    col: 6
    width: 6
    height: 4
  - name: Number of engaged new users
    title: Number of engaged new users
    model: snowplow_web_block
    explore: sessions
    type: single_value
    fields:
    - sessions.session_start_window
    - sessions.new_user_count
    filters:
      sessions.user_engaged: 'Yes'
    sorts:
    - sessions.session_start_window
    dynamic_fields:
    - table_calculation: change
      label: Change since last period
      expression: offset(${sessions.new_user_count}, 0) - offset(${sessions.new_user_count},
        1)
      __FILE: snowplow_web_block/web.dashboard.lookml
      __LINE_NUM: 78
    show_comparison: true
    comparison_type: change
    comparison_label: compared to last period
    show_comparison_label: true
    listen:
      City: sessions.geo_city
    row: 0
    col: 12
    width: 6
    height: 4
  - name: Referer breakdown
    title: Referer breakdown
    model: snowplow_web_block
    explore: sessions
    type: looker_donut_multiples
    fields:
    - sessions.first_or_returning_session
    - sessions.referer_medium
    - sessions.row_count
    pivots:
    - sessions.referer_medium
    filters:
      sessions.session_start_time: 28 days
    sorts:
    - sessions.first_or_returning_session
    - sessions.referer_medium
    column_limit: 50
    query_timezone: America/Vancouver
    show_value_labels: true
    font_size: 12
    stacking: ''
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    colors:
    - 'palette: Santa Cruz'
    series_colors: {}
    listen:
      City: sessions.geo_city
    row: 4
    col: 0
    width: 12
    height: 9
  - name: Sessions per referer medium
    title: Sessions per referer medium
    model: snowplow_web_block
    explore: sessions
    type: looker_area
    fields:
    - sessions.referer_medium
    - sessions.session_start_date
    - sessions.session_count
    pivots:
    - sessions.referer_medium
    filters:
      sessions.session_start_date: 28 days
    sorts:
    - sessions.referer_medium
    - sessions.session_start_date desc
    column_limit: 50
    query_timezone: America/Vancouver
    stacking: ''
    x_axis_label: Date
    y_axis_labels:
    - Sessions
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
    show_null_points: true
    point_style: none
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    colors:
    - 'palette: Santa Cruz'
    series_colors: {}
    listen:
      City: sessions.geo_city
    row: 13
    col: 0
    width: 12
    height: 9
  - name: Page performance per browser
    title: Page performance per browser
    model: snowplow_web_block
    explore: page_views
    type: looker_bar
    fields:
    - page_views.browser_name
    - page_views.average_request_time
    - page_views.average_response_time
    - page_views.average_onload_time
    - page_views.average_time_to_dom_interactive
    - page_views.average_time_to_dom_complete
    filters:
      page_views.page_view_count: ">10"
    sorts:
    - page_views.browser_name
    column_limit: 50
    query_timezone: America/Vancouver
    stacking: normal
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
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hide_legend: true
    series_types: {}
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
    - "#635189"
    series_colors:
      page_views.average_time_to_dom_interactive: "#b3a0dd"
      page_views.average_response_time: "#353b49"
    listen:
      City: sessions.geo_city
    row: 12
    col: 12
    width: 12
    height: 10
  - name: Hourly page views per device
    title: Hourly page views per device
    model: snowplow_web_block
    explore: page_views
    type: looker_column
    fields:
    - page_views.page_view_start_local_hour_of_day
    - page_views.device_type
    - page_views.page_view_count
    pivots:
    - page_views.device_type
    filters:
      page_views.device_type: "-Game console,-Unknown"
      page_views.page_view_start_local_hour_of_day: NOT NULL
      sessions.session_start_time: 28 days
    sorts:
    - page_views.page_view_start_local_hour_of_day
    - page_views.device_type
    limit: 500
    column_limit: 50
    query_timezone: America/Vancouver
    stacking: normal
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
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    colors:
    - 'palette: Santa Cruz'
    series_colors: {}
    listen:
      City: page_views.geo_city
    row: 22
    col: 0
    width: 24
    height: 9
  - name: Sessions by Geographic Location
    title: Sessions by Geographic Location
    model: snowplow_web_block
    explore: sessions
    type: looker_map
    fields:
    - sessions.geo_location
    - sessions.user_count
    filters:
      sessions.geo_location: inside box from 85.0511287798066, -540 to -85.05112877980659,
        180
      sessions.session_start_time: 28 days
    sorts:
    - sessions.user_count desc
    limit: 1000
    column_limit: 50
    query_timezone: America/Vancouver
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: positron
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
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
    map_zoom: 2
    series_types: {}
    colors:
    - 'palette: Santa Cruz'
    series_colors: {}
    point_color: "#5245ed"
    listen:
      City: sessions.geo_city
    row: 4
    col: 12
    width: 12
    height: 8
  filters:
  - name: City
    title: City
    type: field_filter
    default_value: ''
    model: snowplow_web_block
    explore: sessions
    field: sessions.geo_city
    listens_to_filters: []
    allow_multiple_values: true
    required: false
