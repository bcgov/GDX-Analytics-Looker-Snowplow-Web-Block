view: epd_lookup {
  sql_table_name: microservice.epdlookup ;;


  dimension: node_id {}
  dimension: report_branch {
    suggest_explore: epd_lookup_cache
    suggest_dimension: epd_lookup_cache.report_branch
  }
  dimension: ministry {
    suggest_explore: epd_lookup_cache
    suggest_dimension: epd_lookup_cache.ministry
  }
  dimension: division {
    suggest_explore: epd_lookup_cache
    suggest_dimension: epd_lookup_cache.division
  }
  dimension: branch {
    suggest_explore: epd_lookup_cache
    suggest_dimension: epd_lookup_cache.branch
  }
  dimension: program_area {
    suggest_explore: epd_lookup_cache
    suggest_dimension: epd_lookup_cache.program_area
  }
  dimension: program_area_from_smes {
    suggest_explore: epd_lookup_cache
    suggest_dimension: epd_lookup_cache.program_area_from_smes
    label: "Program Area from SMEs"
  }

}
