include: "/Views/page_views.view"

view: tibc_page_views {
  derived_table: {
    sql: SELECT * FROM derived.page_views
          WHERE page_urlhost IN ('www.britishcolumbia.ca','www.britishcolumbia.kr','www.britishcolumbia.jp','www.british-columbia.cn','app.britishcolumbia.ca')
            AND page_view_start_date < DATE_TRUNC('day',GETDATE())
          ;;

      distribution_style: all
      datagroup_trigger: datagroup_tibc_ready
    }

  extends: [page_views]

  dimension: tibc_section {
    description: "The identifier for a section of the TIBC website."
    type: string
    label: "TIBC Section"
    drill_fields: [page_display_url]
    sql: CASE
            WHEN ${TABLE}.page_section = '' THEN 'International'
            WHEN ${TABLE}.page_section IN ('for-bc-businesses','export','Export') THEN 'Export'
            WHEN ${TABLE}.page_section IN ('buy','Buy','buy-from-bc') THEN 'Buy'
            WHEN ${TABLE}.page_section IN ('invest-capital-in-bc','invest','invest-kr','Invest') THEN 'Invest'
            WHEN ${TABLE}.page_section IN ('expand-to-bc') THEN 'Expand'
            WHEN ${TABLE}.page_section IN ('news-stories') THEN 'News & Stories'
            WHEN ${TABLE}.page_section IN ('global','Global','event','about-trade-and-invest-bc') THEN 'Global'
            WHEN ${TABLE}.page_section IN ('industries') THEN 'Sectors'
            WHEN ${TABLE}.page_section IN ('china') THEN 'China'
            WHEN ${TABLE}.page_section IN ('japan') THEN 'Japan'
            WHEN ${TABLE}.page_section IN ('korea') THEN 'Korea'
            WHEN ${TABLE}.page_section IN ('why-british-columbia-canada','about-british-columbia-canada') THEN 'Discovery'
            ELSE 'Other' END ;;
    group_label: "TIBC"
    order_by_field: tibc_section_sort
  }

  dimension: tibc_section_sort {
    label: "TIBC Section Sort"
    type: string
    hidden: yes
    description: "The identifier for a section of the TIBC website."
    sql: CASE
            WHEN ${TABLE}.page_section = '' THEN 'International'
            WHEN ${TABLE}.page_section IN ('for-bc-businesses','export','Export') THEN 'Export'
            WHEN ${TABLE}.page_section IN ('buy','Buy','buy-from-bc') THEN 'Buy'
            WHEN ${TABLE}.page_section IN ('invest-capital-in-bc','invest','invest-kr','Invest') THEN 'Invest'
            WHEN ${TABLE}.page_section IN ('expand-to-bc') THEN 'Expand'
            WHEN ${TABLE}.page_section IN ('news-stories') THEN 'News & Stories'
            WHEN ${TABLE}.page_section IN ('global','Global','event','about-trade-and-invest-bc') THEN 'Global'
            WHEN ${TABLE}.page_section IN ('industries') THEN 'Sectors'
            WHEN ${TABLE}.page_section IN ('why-british-columbia-canada','about-british-columbia-canada') THEN 'Discovery'
            ELSE 'ZZZZZOther' END ;;
    group_label: "TIBC"
  }

  dimension: comparison_date_sort {
    group_label: "Flexible Filter"
    hidden: yes
    required_fields: [date_window]
    description: "Comparison Date offsets measures from the last period to appear in the range of the current period,
    allowing a pairwise comparison between these periods when used with Date Window."
    type: date
    sql:
       CASE
         WHEN ${filter_start_raw} >= ${date_start}
             AND ${filter_start_raw} < ${date_end}
            THEN ${filter_start_date}
         WHEN ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, ${date_start})
             AND ${filter_start_raw} < ${date_start}
            THEN DATEADD(DAY,${period_difference},(${filter_start_date}))
         ELSE
           NULL
       END ;;
  }


  dimension: section_date_window {
    group_label: "TIBC"
    label: "Section"
    sql: CASE
            WHEN {% parameter comparison_period %} != 'No Comparison' AND ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, ${date_start})
                  AND ${filter_start_raw} <  DATEADD(DAY, -${period_difference}, ${date_end}) THEN ' '
            WHEN ${TABLE}.page_section = '' THEN 'Home'
            WHEN ${TABLE}.page_section IN ('invest','invest-kr','Invest') THEN 'Invest'
            WHEN ${TABLE}.page_section IN ('buy','Buy') THEN 'Buy'
            WHEN ${TABLE}.page_section IN ('global','Global') THEN 'Global'
            WHEN ${TABLE}.page_section IN ('export','Export') THEN 'Export'
            ELSE 'Other' END ;;
    order_by_field: section_date_window_sort
  }

  dimension: section_date_window_sort {
    group_label: "TIBC"
    label: "Section Sort"
    sql: CASE WHEN {% parameter comparison_period %} = 'No Comparison' THEN ${tibc_section_sort}
            WHEN ${filter_start_raw} >= ${date_start} AND ${filter_start_raw} < ${date_end} THEN ${tibc_section_sort} || '00'
            WHEN ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, ${date_start})
                  AND ${filter_start_raw} <  DATEADD(DAY, -${period_difference}, ${date_end}) THEN ${tibc_section_sort} || '11'
            ELSE 'Unknown' END ;;
    description: "Pivot on Date Window to compare measures between the current and last periods, use with Comparison Date"
    hidden: yes
  }


  dimension: date_window {
    group_label: "Flexible Filter"
    label: "{% if comparison_period._parameter_value == \"'No Comparison'\" %}  {% else %} Date Window {% endif %}"
    sql: CASE WHEN {% parameter comparison_period %} = 'No Comparison' THEN ' '
            WHEN ${filter_start_raw} >= ${date_start} AND ${filter_start_raw} < ${date_end} THEN 'Current Period'
            WHEN ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, ${date_start})
                  AND ${filter_start_raw} <  DATEADD(DAY, -${period_difference}, ${date_end}) THEN 'Last Period'
            ELSE 'Unknown' END ;;
    description: "Pivot on Date Window to compare measures between the current and last periods, use with Comparison Date"
  }
  dimension: date_window_2 {
    group_label: "Flexible Filter"
    label: "{% if comparison_period._parameter_value == \"'No Comparison'\" %}  {% else %} Date Window 2 {% endif %}"
    sql: CASE -- WHEN {% parameter comparison_period %} = 'No Comparison' THEN ' '
            WHEN ${filter_start_raw} >= ${date_start} AND ${filter_start_raw} < ${date_end} THEN
            TO_CHAR(${date_start} ,'YYYY-MM-DD') || ' - ' || TO_CHAR(DATEADD(DAY, -1, ${date_end}),'YYYY-MM-DD')
            WHEN ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, ${date_start})
                  AND ${filter_start_raw} <  DATEADD(DAY, -${period_difference}, ${date_end}) THEN
                  TO_CHAR(DATEADD(DAY, -${period_difference},${date_start}) ,'YYYY-MM-DD') || ' - ' || TO_CHAR(DATEADD(DAY, -1 -${period_difference}, ${date_end}),'YYYY-MM-DD')
            ELSE 'Unknown' END ;;
    description: "Pivot on Date Window to compare measures between the current and last periods, use with Comparison Date. This version shows the date range as the label."
  }


  dimension: comparison_date {
    label: "{% if comparison_period._parameter_value == \"'No Comparison'\" %} Date {% else %} Comparison Date {% endif %}"
    drill_fields: [youtube_embed_video.title,youtube_embed_video.video_id,youtube_embed_video.video_display_source]
    group_label: "Flexible Filter"
    type: string
    sql:
      CASE WHEN {% parameter comparison_period %} = 'No Comparison' THEN TO_CHAR(${filter_start_date},'YYYY-MM-DD')
          WHEN ${filter_start_raw} >= ${date_start} AND ${filter_start_raw} < ${date_end}
            THEN TO_CHAR(${filter_start_date},'YYYY-MM-DD') || ' / ' || TO_CHAR(DATEADD(DAY,-${period_difference},(${filter_start_date})),'YYYY-MM-DD')
          WHEN ${filter_start_raw} >= DATEADD(DAY, -${period_difference}, ${date_start})
             AND ${filter_start_raw} < ${date_start}
            THEN TO_CHAR(DATEADD(DAY,${period_difference},(${filter_start_date})),'YYYY-MM-DD') || ' / ' || TO_CHAR(${filter_start_date},'YYYY-MM-DD')
          ELSE NULL
       END ;;
    order_by_field: comparison_date_sort
  }

}
