connection: "redshift"

include: "cfms_poc.view"

# Set the week start day to Sunday. Default is Monday
week_start_day: sunday

# persist_with: cfms_block_default_datagroup

label: "CFMS"


explore: cfms_poc {}
