# for use in suggesting dimensions on the geo_city_and_region filter. Rebuild triggered daily.
view: geo_cache {
  derived_table: {
    sql:
      SELECT geo_city, geo_country, geo_country_name, geo_continent_name, geo_region_name, geo_region
        FROM derived.page_views
        GROUP BY 1,2,3,4,5,6 ;;
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24)) ;;
    distribution_style: all
  }
  dimension: geo_city {
    type: string
    sql: ${TABLE}.geo_city;;
  }
  dimension: geo_country {
    type: string
    sql: ${TABLE}.geo_country;;
    }
  dimension: geo_country_name {
    type: string
    sql: ${TABLE}.geo_country_name;;
    }
  dimension: geo_continent_name {
    type: string
    sql: ${TABLE}.geo_continent_name;;
    }
  dimension: geo_region_name {
    type: string
    sql: ${TABLE}.geo_region_name;;
  }
  dimension: geo_region {
    type: string
    sql: ${TABLE}.geo_region;;
  }
  dimension: geo_city_and_region { # Note: this should be synced up with the record in shared_fields_common.view
    type: string
    sql: CASE
       WHEN (${TABLE}.geo_city = '' OR ${TABLE}.geo_city IS NULL) THEN ${TABLE}.geo_country_name
       WHEN (${TABLE}.geo_country = 'CA' OR ${TABLE}.geo_country = 'US') THEN ${TABLE}.geo_city || ' - ' || ${TABLE}.geo_region_name
       ELSE ${TABLE}.geo_city || ' - ' || ${TABLE}.geo_country_name
      END;;
  }
}
