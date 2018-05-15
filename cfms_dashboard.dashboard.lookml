- dashboard: cfms
  title: CFMS
  layout: newspaper
  elements:
  - title: Offices by Date
    name: Offices by Date
    model: cfms_poc
    explore: cfms_poc
    type: looker_line
    fields:
    - cfms_poc.office_name
    - cfms_poc.date
    - cfms_poc.count
    pivots:
    - cfms_poc.office_name
    fill_fields:
    - cfms_poc.date
    filters:
      cfms_poc.office_name: "-NULL"
    sorts:
    - cfms_poc.count desc 0
    - cfms_poc.date
    - cfms_poc.office_name
    limit: 500
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
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    listen:
      Office Name: cfms_poc.office_name
      Program Name: cfms_poc.program_name
    row: 9
    col: 0
    width: 12
    height: 5
  - title: Programs by Date
    name: Programs by Date
    model: cfms_poc
    explore: cfms_poc
    type: looker_column
    fields:
    - cfms_poc.program_name
    - cfms_poc.count
    - cfms_poc.date
    pivots:
    - cfms_poc.program_name
    fill_fields:
    - cfms_poc.date
    filters:
      cfms_poc.program_name: "-NULL"
    sorts:
    - cfms_poc.date
    - cfms_poc.program_name 0
    limit: 500
    stacking: normal
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
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    series_types: {}
    listen:
      Office Name: cfms_poc.office_name
      Program Name: cfms_poc.program_name
    row: 0
    col: 12
    width: 12
    height: 9
  - title: Programs by Office
    name: Programs by Office
    model: cfms_poc
    explore: cfms_poc
    type: looker_column
    fields:
    - cfms_poc.office_name
    - cfms_poc.program_name
    - cfms_poc.count
    pivots:
    - cfms_poc.program_name
    sorts:
    - cfms_poc.count desc 0
    - cfms_poc.program_name
    limit: 500
    stacking: normal
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
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
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
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    hide_legend: false
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    series_types: {}
    listen:
      Office Name: cfms_poc.office_name
      Program Name: cfms_poc.program_name
    row: 0
    col: 0
    width: 12
    height: 9
  - title: Times by Office
    name: Times by Office
    model: cfms_poc
    explore: cfms_poc
    type: table
    fields:
    - cfms_poc.office_name
    - cfms_poc.count
    - cfms_poc.reception_time_average
    - cfms_poc.waiting_time_average
    - cfms_poc.prep_time_average
    sorts:
    - cfms_poc.waiting_time_average desc
    limit: 500
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
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
    listen:
      Office Name: cfms_poc.office_name
      Program Name: cfms_poc.program_name
    row: 9
    col: 12
    width: 12
    height: 5
  filters:
  - name: Office Name
    title: Office Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: cfms_poc
    explore: cfms_poc
    listens_to_filters: []
    field: cfms_poc.office_name
  - name: Program Name
    title: Program Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: cfms_poc
    explore: cfms_poc
    listens_to_filters: []
    field: cfms_poc.program_name
