# Version 1.0.0
view: ldb_summary {
  label: "LDB Summary"
  derived_table: {
    sql:  WITH ldb_actions AS (
      SELECT sku,
        DATE(ldb_actions.timestamp) AS action_date,
        SUM(add_to_cellar_count) AS add_to_cellar_count,
        SUM(where_to_buy_count) AS where_to_buy_count
        FROM ${ldb_clicks.SQL_TABLE_NAME} AS ldb_actions
        WHERE {% incrementcondition %} action_date {% endincrementcondition %} -- this matches the table column used by increment_key
        GROUP BY 1,2
    ),
    page_view_summary AS (
         SELECT
          page_display_url,
          page_views.page_section AS section,
          CASE WHEN section = 'product' THEN page_views.page_subsection ELSE NULL END AS sku,
          page_views.page_title,
          DATE(page_views.page_view_start_time) AS date,
          CAST(NULL AS BOOLEAN) AS spider_or_robot,
          COUNT(DISTINCT CASE WHEN page_view_in_session_index = 1 THEN page_view_id ELSE NULL END ) AS landing_page_count,
          COUNT(DISTINCT page_views.page_view_id) AS page_view_count
          FROM derived.page_views
          WHERE page_views.page_urlhost = 'www.bcliquorstores.com' -- AND page_views.page_section = 'product'
            AND page_views.page_view_start_time < '2022-11-01'
            AND {% incrementcondition %} date {% endincrementcondition %} -- this matches the table column used by increment_key
          GROUP BY 1,2,3,4,5,6
        UNION
        SELECT
          page_urlscheme || '://' || page_urlhost || regexp_replace(page_urlpath, 'index.(html|htm|aspx|php|cgi|shtml|shtm)$','') AS page_display_url,
          SPLIT_PART(page_views_v1.page_urlpath,'/',2) AS section,
          CASE WHEN section = 'product' THEN SPLIT_PART(page_views_v1.page_urlpath,'/',3) ELSE NULL END AS sku,
          page_views_v1.page_title,
          DATE(CONVERT_TIMEZONE('UTC', 'America/Vancouver', page_views_v1.start_tstamp)) AS date,
          spider_or_robot,
          COUNT(DISTINCT CASE WHEN page_view_in_session_index = 1 THEN page_view_id ELSE NULL END ) AS landing_page_count,
          COUNT(DISTINCT page_view_id) AS page_view_count
          FROM derived.page_views_v1
          WHERE page_views_v1.page_urlhost = 'www.bcliquorstores.com' --AND SPLIT_PART(page_views_v1.page_urlpath,'/',2) = 'product'
           AND date < DATE_TRUNC('day',GETDATE())
           AND {% incrementcondition %} date {% endincrementcondition %} -- this matches the table column used by increment_key
           AND date >= '2022-11-01'
          GROUP BY 1,2,3,4,5,6
    )
        SELECT
            page_display_url,
            section,
            page_view_summary.sku,
            page_view_summary.date,
            page_title,
            spider_or_robot,
            ldb_sku.product_name,
            ldb_sku.category,
            ldb_sku.sub_category,
            ldb_sku.product_type,
            ldb_sku.region,
            SUM(landing_page_count) AS landing_page_count,
            SUM(page_view_summary.page_view_count) AS page_view_count,
            SUM(add_to_cellar_count) AS add_to_cellar_count,
            SUM(where_to_buy_count) AS where_to_buy_count

            FROM page_view_summary
            LEFT JOIN microservice.ldb_sku AS ldb_sku ON ldb_sku.sku = page_view_summary.sku
            LEFT JOIN ldb_actions ON ldb_actions.sku = page_view_summary.sku AND page_view_summary.date = ldb_actions.action_date

            GROUP BY 1,2,3,4,5,6,7,8,9,10,11 ;;
    #distribution_style: all
    distribution: "date"
    sortkeys: ["date"]
    increment_key: "event_date" # this, linked with increment_offset, says to consider "date" and
        # to reprocess up to 3 daya of results
    increment_offset: 3
    datagroup_trigger: aa_datagroup_cmsl_loaded
  }



  dimension: sku {}


  dimension_group: event {
    sql: ${TABLE}.date ;;
    type: time
    timeframes: [date, day_of_month, day_of_week, week, month, quarter, year]
  }


  dimension: product_name {
    link: {
      label: "Visit Page"
      url: "{{url}}"
      icon_url: "https://www.bcliquorstores.com/themes/custom/bcls_theme/favicon.ico"
    }
  }
  dimension: category {
    drill_fields: [sub_category,region]
  }
  dimension: sub_category {
    drill_fields: [region]
  }
  dimension: product_type {}
  dimension: region {}

  dimension: url {
    sql:'https://www.bcliquorstores.com/product/' || ${sku} ;;
    link: {
      label: "Visit Page"
      url: "{{ value }}"
      icon_url: "https://www.bcliquorstores.com/themes/custom/bcls_theme/favicon.ico"
    }
  }
  dimension: page_title {}
  dimension: spider_or_robot {
    type: yesno
  }
  dimension: page_view_in_session_index {}
  dimension: page_display_url {}
  dimension: section {}
  measure: count {
    type: count
  }
 # dimension: web_analytics_title {}
  measure: add_to_cellar_count {
    type: sum
    sql: ${TABLE}.add_to_cellar_count;;
  }

  measure: where_to_buy_count {
    type: sum
    sql: ${TABLE}.where_to_buy_count;;
  }

  measure: page_view_count {
    type: sum
    sql: ${TABLE}.page_view_count;;
  }

  measure: landing_page_count {
    type: sum
    sql: ${TABLE}.landing_page_count ;;
  }
}
