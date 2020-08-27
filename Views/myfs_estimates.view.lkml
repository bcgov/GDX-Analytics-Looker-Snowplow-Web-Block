view: myfs_estimates {
  derived_table: {
    sql: WITH base AS (
          (SELECT root_tstamp, root_id, button, NULL AS count, estimates, total
            FROM atomic.ca_bc_gov_myfs_estimator_1 AS est1)
          UNION
          (SELECT root_tstamp, root_id, button, count, estimates, total
            FROM atomic.ca_bc_gov_myfs_estimator_2 AS est2)
        ),
        list AS (
          SELECT est.root_tstamp AS date, est.button, est.count, est.estimates,est.total, wp.id,
           ROW_NUMBER() OVER (PARTITION BY wp.id) AS list_ranked
          FROM base AS est
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON est.root_id = wp.root_id AND est.root_tstamp = wp.root_tstamp
          ORDER BY est.root_tstamp ASC, wp.id ASC -- put all estimates in this page view in ascending order
        ),
        list_rev AS (
          SELECT date, id,
            ROW_NUMBER() OVER (PARTITION BY id) AS list_rev_ranked
          FROM list
          ORDER BY list_ranked DESC
        )
        SELECT
          two.date AS start_date,
          three.date AS end_date,
          one.id,
          SUM (CASE WHEN one.button = 'estimate' THEN 1 ELSE 0 END) AS estimate_count,
          SUM (CASE WHEN one.button = 'register' THEN 1 ELSE 0 END) AS register_count,
          two.total AS estimate_total,
          GREATEST(two.count, REGEXP_COUNT(two.estimates, ',') +1)::integer AS number_of_children,
          two.estimates AS estimate_list
        FROM list AS one
        JOIN list AS two on two.list_ranked = 1 AND one.id = two.id -- take the first estimate in this page view
        JOIN list_rev AS three on three.list_rev_ranked = 1 AND one.id = three.id -- take the last estimate in this page view
        GROUP BY 1,2,3,6,7,8
        ORDER BY 1 ASC
        ;;
    distribution_style: all
    persist_for: "2 hours"
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension_group: start_date {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql:  ${TABLE}.start_date ;;
  }
  dimension_group: end_date {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql:  ${TABLE}.end_date ;;
  }

  dimension: estimate_count {}
  dimension: register_count {}

  dimension: register_clicked {
    type: yesno
    sql: CASE WHEN ${register_count} > 0 THEN 1 ELSE 0 END ;;
  }

  dimension: estimate_total {
    group_label: "Values"
  }

  dimension: number_of_children {
    group_label: "Values"
  }

  dimension: estimate_bucket {
    group_label: "Values"
    type: tier
    tiers: [50, 100, 200, 400, 800]
    style: classic # the default value, could be excluded
    sql: ${estimate_total} ;;
  }
  dimension: estimate_list {
    group_label: "Values"
  }

  measure: average_estimate_total {
    type: average
    sql: ${estimate_total} ;;
  }

  measure: count {
    type: count
  }
  measure: registered_count{
    type: sum
    sql: CASE WHEN ${register_count} > 0 THEN 1 ELSE 0 END ;;
  }

  dimension: last_page_title {
      hidden: yes
  }
}
