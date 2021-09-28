# ================================================================================
# NOTE: Changes here and in cmslite_metadata.themes should be replicated in https://analytics.gov.bc.ca/projects/google_api/files/cmslite_themes.view.lkml
# ================================================================================

include: "//cmslite_metadata/Views/themes.view"

view: cmslite_themes {
  extends: [themes]

  # Hide unneeded dimensions from base view
  dimension: parent_node_id {hidden: yes}
  dimension: parent_title {hidden:yes}
  dimension: hr_url {hidden: yes}


  dimension: asset_folder {
    description: "Dev version of asset folders for FOI work"
    type: string
    sql: CASE
       WHEN ${parent_node_id} = '5CAE76ADAE994DC8B60212BA6DF22ED0' THEN 'Open Government'
       WHEN ${parent_node_id} = '7C24ACD5C5E54395877764D1D6278D12' THEN 'Open Information'
       WHEN ${parent_node_id} = '0AC4388189F44A4C962D526F80940BE3' THEN 'Alternative Service Delivery Contracts'
       WHEN ${parent_node_id} = '298AD3F178704B8F84020CE3F44217E8' THEN 'Archive'
       WHEN ${parent_node_id} = '455436B6ED734A9FA3987A12492E0AA2' THEN 'Calendars'
       WHEN ${parent_node_id} = '1AA5208799524175BB2248D63154F74C' THEN 'Directly_Awarded_Contracts'
       WHEN ${parent_node_id} = 'E005949023DE4ED28729F906352F9593' THEN 'Jan_2018_calendars'
       WHEN ${parent_node_id} = 'CA5A6D0BE40C4E0DBD28B9F852FD8C1D' THEN 'pattern library'
       ELSE NULL
       END ;;
  }

}
