- dashboard: webcasts_2017
  title: Webcasts 2017
  layout: newspaper
  elements:
  - name: Security Day - June 8, 2017
    title: Security Day - June 8, 2017
    model: snowplow_web_block
    explore: sessions
    type: looker_map
    fields:
    - sessions.geo_city
    - sessions.user_count
    - sessions.page_view_count
    - sessions.device_is_mobile
    - sessions.geo_location
    filters:
      sessions.first_page_url: video.web.gov.bc.ca/mtics/live/securityday.html
      sessions.geo_region_name: British Columbia
    sorts:
    - sessions.user_count desc
    - sessions.device_is_mobile
    limit: 1000
    column_limit: 50
    total: true
    row_total: right
    query_timezone: America/Vancouver
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: positron
    map_position: custom
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: equal_to_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    map: auto
    map_projection: ''
    quantize_colors: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    map_latitude: 48.951366470947725
    map_longitude: -123.95874023437501
    map_zoom: 6
    row: 0
    col: 0
    width: 9
    height: 7
  - name: Agency Excellence Awards - June 16, 2017
    title: Agency Excellence Awards - June 16, 2017
    model: snowplow_web_block
    explore: sessions
    type: looker_map
    fields:
    - sessions.geo_city
    - sessions.user_count
    - sessions.page_view_count
    - sessions.geo_location
    filters:
      sessions.first_page_url: "%video.web.gov.bc.ca/psa/townhall/%,%video.web.gov.bc.ca/psa/townhall/index.html%"
    sorts:
    - sessions.user_count desc
    limit: 1000
    column_limit: 50
    total: true
    row_total: right
    query_timezone: America/Vancouver
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: positron
    map_position: custom
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: equal_to_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    map: auto
    map_projection: ''
    quantize_colors: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    map_latitude: 48.951366470947725
    map_longitude: -123.95874023437501
    map_zoom: 6
    row: 13
    col: 0
    width: 9
    height: 6
  - name: Users - Security Day
    title: Users - Security Day
    model: snowplow_web_block
    explore: users
    type: single_value
    fields:
    - users.user_count
    filters:
      users.first_page_url: video.web.gov.bc.ca/mtics/live/securityday.html
    sorts:
    - users.user_count
    limit: 500
    column_limit: 50
    total: true
    query_timezone: America/Vancouver
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 0
    col: 9
    width: 9
    height: 8
  - name: Users - Agency Excellence Awards
    title: Users - Agency Excellence Awards
    model: snowplow_web_block
    explore: page_views
    type: single_value
    fields:
    - page_views.page_url
    - page_views.user_count
    filters:
      page_views.page_url: "%video.web.gov.bc.ca/psa/townhall/index.html%,%video.web.gov.bc.ca/psa/townhall/%"
    sorts:
    - page_views.user_count desc
    limit: 500
    column_limit: 50
    query_timezone: America/Vancouver
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 14
    col: 9
    width: 9
    height: 5
  - name: Government House - June 12, 2017
    title: Government House - June 12, 2017
    model: snowplow_web_block
    explore: sessions
    type: looker_map
    fields:
    - sessions.geo_city
    - sessions.user_count
    - sessions.page_view_count
    - sessions.device_is_mobile
    - sessions.geo_location
    filters:
      sessions.first_page_url: video.web.gov.bc.ca/mtics/live/gh.html
      sessions.geo_region_name: British Columbia
    sorts:
    - sessions.user_count desc
    - sessions.device_is_mobile
    limit: 1000
    column_limit: 50
    total: true
    row_total: right
    query_timezone: America/Vancouver
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: positron
    map_position: custom
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: equal_to_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    map: auto
    map_projection: ''
    quantize_colors: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    map_latitude: 48.951366470947725
    map_longitude: -123.95874023437501
    map_zoom: 6
    row: 7
    col: 0
    width: 9
    height: 6
  - name: Users - Government House
    title: Users - Government House
    model: snowplow_web_block
    explore: page_views
    type: single_value
    fields:
    - page_views.page_url
    - page_views.user_count
    filters:
      page_views.page_url: "%video.web.gov.bc.ca/mtics/live/gh.html%"
    sorts:
    - page_views.user_count desc
    limit: 500
    column_limit: 50
    query_timezone: America/Vancouver
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 8
    col: 9
    width: 9
    height: 6
  - name: Security Day - November 8, 2017
    title: Security Day - November 8, 2017
    model: snowplow_web_block
    explore: sessions
    type: looker_map
    fields:
    - sessions.geo_country
    - sessions.geo_region
    - sessions.geo_city
    - sessions.user_count
    - sessions.os_name
    pivots:
    - sessions.os_name
    filters:
      sessions.first_page_url: video.web.gov.bc.ca/mtics/live/securityday.html
      sessions.session_start_date: 2017/11/08
    sorts:
    - sessions.os_name 0
    - sessions.user_count desc 8
    limit: 1000
    column_limit: 50
    total: true
    row_total: right
    query_timezone: America/Vancouver
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: positron
    map_position: custom
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: equal_to_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    map: auto
    map_projection: ''
    quantize_colors: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    map_latitude: 48.951366470947725
    map_longitude: -123.95874023437501
    map_zoom: 6
    row: 19
    col: 0
    width: 24
    height: 8
  - name: 2017 STIR Demo Day
    title: 2017 STIR Demo Day
    model: snowplow_web_block
    explore: page_views
    type: table
    fields:
    - page_views.geo_city
    - page_views.page_view_count
    - users.user_count
    filters:
      page_views.page_url: "%video.web.gov.bc.ca/public/townhall/live/stir.html%"
      users.first_session_start_date: 2017/11/24
    sorts:
    - page_views.geo_city desc
    limit: 500
    column_limit: 50
    total: true
    query_timezone: America/Vancouver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    row: 27
    col: 0
    width: 24
    height: 8
