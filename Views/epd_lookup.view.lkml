view: epd_lookup {
  sql_table_name: microservice.epdlookup ;;


  dimension: node_id {}
  dimension: report_branch {}
  dimension: ministry {}
  dimension: division {}
  dimension: branch {}
  dimension: program_area {}
  dimension: program_area_from_smes {
    label: "Program Area from SMEs"
  }

}
