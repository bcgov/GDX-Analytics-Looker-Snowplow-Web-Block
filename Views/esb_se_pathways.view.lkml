view: esb_se_pathways {

  sql_table_name: esb.se_pathways ;;

  dimension: id {
    description: "The ID number of the pathway."
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: type {
    description: "Pathway type."
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: pathway {
    description: "The name of the pathway."
    type: string
    sql: ${TABLE}.pathway ;;
  }

  dimension: order {
    description: "The order of the page inside the path."
    type: string
    sql: ${TABLE}.order ;;
  }

  dimension: title {
    description: "The title of the page."
    type: string
    sql: ${TABLE}.title ;;
  }

}
