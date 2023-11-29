connection: "snowflake_snowplow"

include: "/SnowflakeViews/*.view.lkml"


# Set the week start day to Sunday. Default is Monday
week_start_day: sunday


explore: page_views_snowflake {
  persist_for: "10 minutes"
  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  #sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
  #    AND ${page_url} NOT LIKE '%$/%'
  #    AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%' ;;

  # adding this access filter to be used by the CMS Lite embed code generator
  #    to allow for page-level dashboards
  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }
  access_filter: {
    field: app_id
    user_attribute: app_id
  }

  # sql_always_where: ${page_url} NOT LIKE '%video.web.%' ;; -- Causing problems with video.gov analytics
  join: sessions_snowflake {
    type: left_outer
    sql_on: ${sessions_snowflake.session_id} = ${page_views_snowflake.session_id};;
    relationship: many_to_many
  }

  join: users_snowflake {
    sql_on: ${page_views_snowflake.domain_userid} = ${users_snowflake.domain_userid} ;;
    relationship: many_to_one
  }
}

explore: sessions_snowflake {
  persist_for: "10 minutes"

  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  # Note that we are using first_page here instead of page, as there is no "page" for sessions
  #sql_always_where: (${first_page_urlhost} <> 'localhost' OR ${first_page_urlhost} IS NULL)
  #    AND ${first_page_url} NOT LIKE '%$/%'
  #    AND ${first_page_url} NOT LIKE 'file://%' AND ${first_page_url} NOT LIKE '-file://%' AND ${first_page_url} NOT LIKE 'mhtml:file://%';;

  join: users_snowflake {
    sql_on: ${sessions_snowflake.domain_userid} = ${users_snowflake.domain_userid} ;;
    relationship: many_to_one
  }

  access_filter: {
    field: first_page_urlhost
    user_attribute: urlhost
  }
}

explore: users_snowflake {
  persist_for: "10 minutes"


  # sql_always_where: ${first_page_url} NOT LIKE '%video.web.%' ;; -- Causing problems with Dan's video analytics
}

explore: clicks_snowflake {
  persist_for: "10 minutes"

  # exclude when people are viewing files on locally downloaded or hosted copies of webpages
  #sql_always_where: (${page_urlhost} <> 'localhost' OR ${page_urlhost} IS NULL)
  #    AND ${page_url} NOT LIKE '%$/%'
  #    AND ${page_url} NOT LIKE 'file://%' AND ${page_url} NOT LIKE '-file://%' AND ${page_url} NOT LIKE 'mhtml:file://%' ;;

  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }
}
