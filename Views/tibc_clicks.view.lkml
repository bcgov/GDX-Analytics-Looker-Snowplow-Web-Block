include: "/Views/clicks.view"

view: tibc_clicks {
  derived_table: {
    sql: SELECT * FROM derived.clicks
          WHERE page_urlhost IN ('www.britishcolumbia.ca','www.britishcolumbia.kr','www.britishcolumbia.jp','www.british-columbia.cn','app.britishcolumbia.ca')
            AND click_date < DATE_TRUNC('day',GETDATE())
          ;;

      distribution_style: all
      datagroup_trigger: datagroup_tibc_ready
    }


    extends: [clicks]

  }
