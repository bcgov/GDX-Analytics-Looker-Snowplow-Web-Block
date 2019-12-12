# for use in suggesting dimensions on the site filter, which populates from first_page_urlhost. Rebuild triggered daily.
view: site_cache {
  derived_table: {
    sql:
      SELECT
        LOWER(page_views.page_urlhost)  AS "page_urlhost",
        CASE WHEN LOWER(page_views.page_urlhost) IN ('cannabis.gov.bc.ca','cleanbc.gov.bc.ca','adopt.gov.bc.ca','fosternow.gov.bc.ca','buybc.gov.bc.ca','www.stopoverdose.gov.bc.ca','www.bcbudget.gov.bc.ca','upgrade.gov.bc.ca','budget.gov.bc.ca','bcwildfire.ca','erase.gov.bc.ca','childcare.gov.bc.ca') THEN '1' ELSE '0' END AS page_campaign_urlhost
      FROM derived.page_views  AS page_views
      LEFT JOIN cmslite.themes  AS cmslite_themes ON page_views.node_id = cmslite_themes.node_id

      WHERE (((LOWER(page_views.page_urlhost)) <> 'localhost' OR (LOWER(page_views.page_urlhost)) IS NULL)
            AND page_views.page_url NOT LIKE '%$/%'
            AND page_views.page_url NOT LIKE 'file://%' AND page_views.page_url NOT LIKE '-file://%' AND page_views.page_url NOT LIKE 'mhtml:file://%') AND (page_views.br_family LIKE '%') AND (page_views.node_id LIKE '%') AND (((LOWER(page_views.page_urlhost)) LIKE '%')) AND (((COALESCE(cmslite_themes.theme_id,'')) LIKE '%')) AND (((SPLIT_PART(page_views.page_urlpath,'/',2)) LIKE '%'))
      GROUP BY 1, 2
      ORDER BY 1 ;;
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24)) ;;
    distribution_style: all
  }
  dimension: page_urlhost {
    type: string
  }
  dimension: page_campaign_urlhost {
    type:  string
  }
}
