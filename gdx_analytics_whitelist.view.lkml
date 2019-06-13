view: gdx_analytics_whitelist {
  sql_table_name: gdx_analytics.whitelist ;;

  # DIMENSIONS

  # url_host
  # These are the URLs for sites identified by GDX Analytics as valid BCGov owned sites
  dimension: urlhost {
    description: "The URL, if whitelisted."
    type: string
    sql: ${TABLE}.urlhost ;;
  }

  # host_type
  # These are the URLs for sites identified by GDX Analytics as valid BCGov owned sites
  dimension: host_type {
    description: "The type of host, if this URL if whitelisted."
    type: string
    sql: ${TABLE}.host_type ;;
  }

  # FILTERS

  # is_whitelisted
  # When yes this filter will return non- null results from the whitelist, when no it should only return null results (the urlhosts were not whitelisted)
  dimension: is_whitelisted {
    type: yesno
    description: "filter to toggle url hosts as being whitelisted or not"
    sql: ${urlhost} IS NOT NULL ;;
  }
}
