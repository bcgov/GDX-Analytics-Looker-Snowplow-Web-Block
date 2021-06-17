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

}
