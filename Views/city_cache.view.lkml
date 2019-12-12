# for use in suggesting dimensions on the geo_city_and_region filter. Rebuild triggered daily.
view: city_cache {
  derived_table: {
    sql:
      SELECT DISTINCT geo_city, geo_country, geo_region_name FROM derived.sessions ORDER BY 1 ;;
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24)) ;;
    distribution_style: all
  }
  dimension: geo_city {}
  dimension: geo_country {}
  dimension: geo_region {}
  dimension: geo_city_and_region {
    type: string
    sql: CASE
       WHEN (${TABLE}.geo_city = '' OR ${TABLE}.geo_city IS NULL) THEN ${TABLE}.geo_country
       WHEN (${TABLE}.geo_country = 'CA' OR ${TABLE}.geo_country = 'US') THEN ${TABLE}.geo_city || ' - ' || ${TABLE}.geo_region_name
       ELSE ${TABLE}.geo_city || ' - ' || ${TABLE}.geo_country
      END;;
  }
}
