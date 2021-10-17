view: language_cohorts_users {
  label: "Language Cohorts (users)"
  derived_table: {
    sql: SELECT * FROM gdx_analytics.language_cohorts_users ;;
  }
  dimension: domain_userid {}

   dimension: English { type: yesno }
  dimension_group: English_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: English_first { type: yesno }
  dimension: Punjabi { type: yesno }
  dimension_group: Punjabi_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Punjabi_first { type: yesno }
  dimension: French { type: yesno }
  dimension_group: French_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: French_first { type: yesno }
  dimension: Traditional_Chinese { type: yesno }
  dimension_group: Traditional_Chinese_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Traditional_Chinese_first { type: yesno }
  dimension: Simplified_Chinese { type: yesno }
  dimension_group: Simplified_Chinese_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Simplified_Chinese_first { type: yesno }
  dimension: Farsi { type: yesno }
  dimension_group: Farsi_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Farsi_first { type: yesno }
  dimension: Korean { type: yesno }
  dimension_group: Korean_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Korean_first { type: yesno }
  dimension: Japanese { type: yesno }
  dimension_group: Japanese_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Japanese_first { type: yesno }
  dimension: Tagalog { type: yesno }
  dimension_group: Tagalog_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Tagalog_first { type: yesno }
  dimension: Hindi { type: yesno }
  dimension_group: Hindi_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Hindi_first { type: yesno }
  dimension: Arabic { type: yesno }
  dimension_group: Arabic_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Arabic_first { type: yesno }
  dimension: Spanish { type: yesno }
  dimension_group: Spanish_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Spanish_first { type: yesno }
  dimension: Vietnamese { type: yesno }
  dimension_group: Vietnamese_start {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
  }
  dimension: Vietnamese_first { type: yesno }

  dimension: any_translation {
    sql:  Arabic OR Farsi OR French OR Hindi OR Japanese OR Korean OR Punjabi OR Simplified_Chinese OR Spanish OR Tagalog OR Traditional_Chinese OR Vietnamese ;;
    type: yesno
  }
  dimension: any_translation_first {
    sql:  Arabic_first OR Farsi_first OR French_first OR Hindi_first OR Japanese_first OR Korean_first OR Punjabi_first OR Simplified_Chinese_first OR Spanish_first OR Tagalog_first OR Traditional_Chinese_first OR Vietnamese_first ;;
    type: yesno
  }

}
