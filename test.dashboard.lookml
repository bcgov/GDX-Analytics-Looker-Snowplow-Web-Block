- dashboard: test
  title: Test
  layout: newspaper
  elements:
  - title: Page Views Per Page
    name: Page Views Per Page
    model: snowplow_web_block
    explore: page_views
    type: looker_line
    fields:
    - page_views.page_url
    - page_views.device_type
    - page_views.page_view_count
    - page_views.device_is_mobile
    filters:
      page_views.page_view_count: ">200"
      page_views.is_government: 'No'
    sorts:
    - page_views.page_view_count desc
    - page_views.device_is_mobile
    - page_views.device_type
    limit: 500
    column_limit: 50
    query_timezone: America/Vancouver
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
    show_null_points: true
    point_style: circle
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      Browser: page_views.browser
    row: 0
    col: 0
    width: 8
    height: 6
