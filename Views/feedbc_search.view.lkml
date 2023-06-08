view: feedbc_search {
  label: "FeedBC Search"
  derived_table: {
    sql: WITH base_table AS (
      (
        SELECT
          'product search' AS search_type,
          root_tstamp,
          root_id,
          query,
          count,
          "filters.availability",
          "filters.certifications",
          "filters.delivery_options",
          "filters.dietary",
          "filters.food_safety_certifications",
          "filters.producer_operations",
          "filters.region",
          NULL AS "filters.producer_market_channels"
        FROM atomic.ca_bc_gov_feedbc_product_search_1
      )
      UNION
      (
        SELECT
          'buyers search' AS search_type,
          root_tstamp,
          root_id,
          query,
          count,
          NULL AS "filters.availability",
          NULL AS "filters.certifications",
          NULL AS "filters.delivery_options",
          NULL AS "filters.dietary",
          NULL AS "filters.food_safety_certifications",
          NULL AS "filters.producer_operations",
          NULL AS "filters.region",
          "filters.producer_market_channels"
        FROM atomic.ca_bc_gov_feedbc_find_buyers_1
      )
      UNION
      (
        SELECT
          'producer search' AS search_type,
          root_tstamp,
          root_id,
          query,
          count,
          NULL AS "filters.availability",
          NULL AS "filters.certifications",
          NULL AS "filters.delivery_options",
          NULL AS "filters.dietary",
          NULL AS "filters.food_safety_certifications",
          "filters.region",
          "filters.producer_operations",
          NULL AS "filters.producer_market_channels"
        FROM atomic.ca_bc_gov_feedbc_producer_search_1
      )
    )
    SELECT wp.id AS page_view_id,
          page_urlhost,
          domain_sessionid AS session_id,
          search_type,
          count AS results_count,
          query,
          "filters.availability" AS availability,
          "filters.certifications" AS certifications,
          "filters.delivery_options" AS delivery_options,
          "filters.dietary" AS dietary,
          "filters.food_safety_certifications" AS food_safety_certifications,
          "filters.producer_operations" AS producer_operations,
          "filters.region" AS region,
          "filters.producer_market_channels" AS producer_market_channels,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', base_table.root_tstamp) AS timestamp,
          CASE WHEN search_type = 'product search' THEN 1 ELSE 0 END AS product_search_count,
          CASE WHEN search_type = 'buyers search' THEN 1 ELSE 0 END AS buyers_search_count,
          CASE WHEN search_type = 'producer search' THEN 1 ELSE 0 END AS producer_search_count,
          CASE WHEN query IS NOT NULL THEN 1 ELSE 0 END AS query_count,
          CASE WHEN "filters.availability" IS NOT NULL THEN 1 ELSE 0 END AS availability_count,
          CASE WHEN "filters.certifications" IS NOT NULL THEN 1 ELSE 0 END AS certifications_count,
          CASE WHEN "filters.delivery_options" IS NOT NULL THEN 1 ELSE 0 END AS delivery_options_count,
          CASE WHEN "filters.dietary" IS NOT NULL THEN 1 ELSE 0 END AS dietary_count,
          CASE WHEN "filters.food_safety_certifications" IS NOT NULL THEN 1 ELSE 0 END AS food_safety_certifications_count,
          CASE WHEN "filters.producer_operations" IS NOT NULL THEN 1 ELSE 0 END AS producer_operations_count,
          CASE WHEN "filters.region" IS NOT NULL THEN 1 ELSE 0 END AS region_count,
          CASE WHEN "filters.producer_market_channels" IS NOT NULL THEN 1 ELSE 0 END AS producer_market_channels_count
        FROM base_table
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp
              ON base_table.root_id = wp.root_id AND base_table.root_tstamp = wp.root_tstamp
          LEFT JOIN atomic.events ON base_table.root_id = events.event_id AND base_table.root_tstamp = events.collector_tstamp
          ;;
    distribution_style: all
    persist_for: "1 hours"
  }
  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
  }

  dimension: page_urlhost {}
  dimension_group: event {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: search_type {}
  dimension: query {}
  dimension: availability {
    group_label: "Filters"
  }
  dimension: certifications {
    group_label: "Filters"
    }
  dimension: delivery_options {
    group_label: "Filters"
    }
  dimension: dietary {
    group_label: "Filters"
    }
  dimension: food_safety_certifications {
    group_label: "Filters"
    }
  dimension: producer_operations {
    group_label: "Filters"
    }
  dimension: region {
    group_label: "Filters"
    }
  dimension: producer_market_channels {
    group_label: "Filters"
    }

  measure: query_count {
    type: sum
    sql: ${TABLE}.query_count;;
  }
  measure: availability_count {
    type: sum
    group_label: "Filter Counts"
    sql: ${TABLE}.availability_count;;
  }
  measure: certifications_count {
    type: sum
    group_label: "Filter Counts"
    sql: ${TABLE}.certifications_count;;
  }
  measure: delivery_options_count {
    type: sum
    group_label: "Filter Counts"
    sql: ${TABLE}.delivery_options_count;;
  }
  measure: dietary_count {
    type: sum
    group_label: "Filter Counts"
    sql: ${TABLE}.dietary_count;;
  }
  measure: food_safety_certifications_count {
    type: sum
    group_label: "Filter Counts"
    sql: ${TABLE}.food_safety_certifications_count;;
  }
  measure: producer_operations_count {
    type: sum
    group_label: "Filter Counts"
    sql: ${TABLE}.producer_operations_count;;
  }
  measure: region_count {
    type: sum
    group_label: "Filter Counts"
    sql: ${TABLE}.region_count;;
  }
  measure: producer_market_channels_count {
    type: sum
    group_label: "Filter Counts"
    sql:  ${TABLE}.producer_market_channels_count ;;
  }
  measure: product_search_count {
    type: sum
    group_label: "Search Type Counts"
    sql:  ${TABLE}.product_search_count ;;
  }
  measure: buyers_search_count {
    type: sum
    group_label: "Search Type Counts"
    sql:  ${TABLE}.buyers_search_count ;;
  }
  measure: producer_search_count {
    type: sum
    group_label: "Search Type Counts"
    sql:  ${TABLE}.producer_search_count ;;
  }
  measure: row_count {
    type: count
  }
  measure: session_count {
    description: "Count of the outcome over distinct Browser Session IDs"
    type: count_distinct
    sql_distinct_key: ${TABLE}.session_id ;;
    sql: ${TABLE}.session_id  ;;
  }

}
