# for use in suggesting dimensions on the site filter, which populates from first_page_urlhost. Rebuild triggered daily.
view: site_cache {
  derived_table: {
    sql:
      SELECT
        sessions.first_page_urlhost  AS "sessions.first_page_urlhost"
      FROM derived.sessions  AS sessions
      LEFT JOIN cmslite.themes  AS cmslite_themes ON sessions.node_id = cmslite_themes.node_id

      WHERE ((sessions.first_page_urlhost <> 'localhost' OR sessions.first_page_urlhost IS NULL)
            AND sessions.first_page_url NOT LIKE '%$/%'
            AND sessions.first_page_url NOT LIKE 'file://%' AND sessions.first_page_url NOT LIKE '-file://%' AND sessions.first_page_url NOT LIKE 'mhtml:file://%') AND (sessions.node_id LIKE '%') AND (sessions.first_page_urlhost LIKE '%') AND (((SPLIT_PART(sessions.first_page_urlpath,'/',2)) LIKE '%')) AND (((COALESCE(cmslite_themes.theme_id,'')) LIKE '%'))
      GROUP BY 1
      ORDER BY 1 ;;
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24)) ;;
    distribution_style: all
  }
  dimension: first_page_urlhost {}
}
