view: form_action {
  derived_table: {
    sql: WITH base AS (
      SELECT wp.id AS page_view_id,
        fa.root_id AS form_event_id,
        events.page_urlhost,
        events.page_url,
        action,
        formid,
        formstage,
        CASE WHEN formid = 'FC005E942B274061A110A2CFC42C1EA2' THEN 'Notice'
              WHEN formid = '34F8F542261449CBA35F220B74ADC393' THEN 'Schedule'
              WHEN formid = 'C88D6641F78A4D5FBC383CC50E641CE6' THEN 'Evidence'
              ELSE 'Other' END AS title,
        CASE WHEN message = '' THEN NULL ELSE message END AS message,
        CONVERT_TIMEZONE('UTC', 'America/Vancouver', fa.root_tstamp) AS timestamp,
        CONVERT_TIMEZONE('UTC', 'America/Vancouver', wp.root_tstamp) AS page_view_timestamp,
        DATEDIFF('second', fa.root_tstamp, wp.root_tstamp) AS time_diff,
        CASE WHEN action = 'submit' AND (message = 'success' OR message = 'submit' OR message IS NULL OR message = '') THEN 'submit success'
              WHEN action = 'submit' AND (message = 'emailed') THEN 'submit emailed'
              WHEN action = 'submit' AND message = 'validation-error' THEN 'submit validation error'
              WHEN action = 'submit' AND (message = 'failure' OR message = 'form-error') THEN 'submit form error'
              WHEN action = 'submission-error' OR message = 'submission-error' THEN 'submit form error'
              ELSE NULL
        END AS result,
        CASE WHEN action = 'submit' THEN 1 ELSE 0 END AS submit_count,
        CASE WHEN action = 'submit' AND (message = 'success' OR message = 'submit' OR message IS NULL OR message = '') THEN 1 ELSE 0 END AS submit_success_count,
        CASE WHEN action = 'submit' AND (message = 'emailed') THEN 1 ELSE 0 END AS submit_emailed_count,
        CASE WHEN action = 'submit' AND message = 'validation-error' THEN 1 ELSE 0 END AS submit_validation_error_count,
        CASE WHEN action = 'submit' AND (message = 'failure' OR message = 'form-error') THEN 1 ELSE 0 END AS submit_form_error_count,
        CASE WHEN action = 'submission-error' THEN 1 ELSE 0 END AS submission_error_count,
        CASE WHEN action = 'clear' THEN 1 ELSE 0 END AS clear_count,
        CASE WHEN action = 'pdf' THEN 1 ELSE 0 END AS pdf_count,
        CASE WHEN action = 'loaded' THEN 1 ELSE 0 END AS loaded_count,
        CASE WHEN action = 'emailed' THEN 1 ELSE 0 END AS emailed_count
        FROM atomic.ca_bc_gov_form_action_1 AS fa
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON fa.root_id = wp.root_id AND fa.root_tstamp = wp.root_tstamp
        JOIN atomic.events ON fa.root_id = events.event_id AND fa.root_tstamp = events.collector_tstamp
                  WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key

      ),
      totals AS (
        SELECT
          page_view_id,
          page_url,
          formid,
          formstage,
          COUNT(form_event_id) AS action_total,
          MIN(timestamp) AS min_timestamp,
          MAX(timestamp) AS max_timestamp,
          MIN(page_view_timestamp) AS min_page_view_timestamp,
          MIN(time_diff) AS first_diff,
          MAX(time_diff) AS last_diff,
          SUM(submit_count) AS submit_total,
          SUM(submit_success_count) AS submit_success_total,
          SUM(submit_validation_error_count) AS submit_validation_error_total,
          SUM(submit_form_error_count) AS submit_form_error_total,
          SUM(submission_error_count) AS submission_error_total,
          SUM(clear_count) AS clear_total,
          SUM(pdf_count) AS pdf_total,
          SUM(loaded_count) AS loaded_total,
          SUM(emailed_count) AS emailed_total
        FROM base
        GROUP BY 1,2,3,4)
      SELECT base.page_view_id, base.form_event_id, base.page_urlhost, base.page_url, base.action, base.formid, base.formstage, base.title, base.message, base.timestamp, base.page_view_timestamp, base.time_diff, base.result, base.submit_count, base.submit_success_count, base.submit_validation_error_count, base.submit_form_error_count, base.submission_error_count, base.clear_count, base.pdf_count, base.loaded_count, base.emailed_count,

        min_page_view_timestamp, min_timestamp, max_timestamp, totals.first_diff, totals.last_diff, totals.action_total, totals.submit_total, totals.submit_success_total, totals.submit_validation_error_total, totals.submit_form_error_total, totals.submission_error_total, totals.clear_total, totals.pdf_total, totals.loaded_total, totals.emailed_total
      FROM base
      JOIN totals ON totals.page_view_id = base.page_view_id AND
                      totals.page_url = base.page_url AND
                      totals.formid = base.formid AND
                      (totals.formstage = base.formstage OR (base.formstage IS NULL AND totals.formstage IS NULL)) -- All other fields in the join can't be NULL
          ;;
    datagroup_trigger:datagroup_25_55
    distribution_style: all
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
  }

  dimension_group: event {
    type: time
    sql: ${TABLE}.timestamp ;;
  }
  dimension: page_view_id {
    type: string
    label: "Page View ID"
    sql: ${TABLE}.page_view_id ;;
  }
  dimension: page_urlhost {
    type: string
    sql: ${TABLE}.page_urlhost ;;
  }
  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url;;
  }
  dimension: form_event_id {
    label: "Form Event ID"
  }
  dimension: action {}
  dimension: result {}
  dimension: message {}
  dimension: title {
    link: {
      label: "Visit Form"
      url: "https://forms2.gov.bc.ca/forms/content?id={{ formid }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: formid {
    label: "Form ID"
    link: {
      label: "Visit Form"
      url: "https://forms2.gov.bc.ca/forms/content?id={{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  dimension: formstage {
    type:  string
    sql:
      CASE
        WHEN ${TABLE}.formstage IS NULL AND ${TABLE}.page_urlhost = 'www.pnpapplication.gov.bc.ca' THEN 'Print Mode'
        ELSE ${TABLE}.formstage END ;;
  }

  dimension: first_diff {
    group_label: "Totals"
  }
  dimension: last_diff {
    group_label: "Totals"
  }
  dimension: action_total {
    group_label: "Totals"
  }
  dimension: submit_total {
    group_label: "Totals"
    }
  dimension: submit_success_total {
    group_label: "Totals"
    }
  dimension: submit_validation_error_total {
    group_label: "Totals"
    }
  dimension: submit_form_error_total {
    group_label: "Totals"
    }
  dimension: submission_error_total {
    group_label: "Totals"
    }
  dimension: clear_total {
    group_label: "Totals"
    }
  dimension: pdf_total {
    group_label: "Totals"
    }
  dimension: loaded_total {
    group_label: "Totals"
    }
  dimension: emailed_total {
    group_label: "Totals"
    }

  dimension: min_timestamp {
    group_label: "Totals"
  }
  dimension: max_timestamp {
    group_label: "Totals"
  }
  dimension: total_time {
    group_label: "Totals"
    sql:  DATEDIFF(seconds, ${min_timestamp}, ${max_timestamp}) ;;
    #value_format: "[h]:mm:ss"
  }

  dimension: min_page_view_timestamp {
    group_label: "Totals"
  }

  # PNP Formstage buckets
  dimension: formstage_bucket {
    description: "Formstages broken out by stage order."
    case: {
      when: {
        sql: ${TABLE}.formstage in ('Registrant','Applicant') ;;
        label: "Registrant/Applicant"
      }
      when: {
        sql: ${TABLE}.formstage in ('Nominee Applicant') ;;
        label: "Nominee Applicant"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Education') ;;
        label: "Education"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Personal Information') ;;
        label: "Personal Information"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Details') ;;
        label: "Details"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Background') ;;
        label: "Background"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Experience') ;;
        label: "Experience"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Work Experience') ;;
        label: "Work Experience"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Net Worth') ;;
        label: "Net Worth"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Personal Net Worth') ;;
        label: "Personal Net Worth"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Adaptability') ;;
        label: "Adaptability"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Family') ;;
        label: "Family"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Job Offer') ;;
        label: "Job Offer"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Language') ;;
        label: "Language"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Business Concept') ;;
        label: "Business Concept"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Business Plan') ;;
        label: "Business Plan"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Business') ;;
        label: "Business"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Personal Investment') ;;
        label: "Personal Investment"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Jobs') ;;
        label: "Jobs"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Attachments') ;;
        label: "Attachments"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Submit') ;;
        label: "Submit"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Request for Review') ;;
        label: "Request for Review"
      }
      when: {
        sql:  ${TABLE}.message = ('Print Mode') ;;
        label: "Print Mode"
      }
      else:"Unknown"
    }
    group_label: "Form Stages"
  }

  dimension: formstage_bucket_sort {
    description: "Use in combination with Form Stage Bucket to enforce sort order. Hide from display."
    case: {
      when: {
        sql: ${TABLE}.formstage in ('Registrant','Applicant') ;;
        label: "1"
      }
      when: {
        sql: ${TABLE}.formstage in ('Nominee Applicant') ;;
        label: "2"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Education') ;;
        label: "3"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Personal Information') ;;
        label: "4"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Details') ;;
        label: "5"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Background') ;;
        label: "6"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Experience') ;;
        label: "7"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Work Experience') ;;
        label: "8"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Net Worth') ;;
        label: "9"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Personal Net Worth') ;;
        label: "10"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Adaptability') ;;
        label: "11"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Family') ;;
        label: "12"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Job Offer') ;;
        label: "13"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Language') ;;
        label: "14"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Business') ;;
        label: "15"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Business Concept') ;;
        label: "16"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Business Plan') ;;
        label: "17"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Personal Investment') ;;
        label: "18"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Jobs') ;;
        label: "19"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Attachments') ;;
        label: "20"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Submit') ;;
        label: "21"
      }
      when: {
        sql:  ${TABLE}.formstage = ('Request for Review') ;;
        label: "22"
      }
      when: {
        sql:  ${TABLE}.message = ('Print Mode') ;;
        label: "23"
      }
      else:"Unknown"
    }
    group_label: "Form Stages"
  }

  measure: formstage_bucket_1 {
    description: "Count of form stage 1."
    type:  sum
    sql:  CASE WHEN  ${TABLE}.formstage in ('Registrant','Applicant') THEN 1
              ELSE 0
              END;;
    label: "Formstage 1"
    group_label: "Form Stages Buckets"
  }

  measure: formstage_bucket_2 {
    description: "Count of form stage 2"
    type:  sum
    sql:  CASE WHEN  ${TABLE}.formstage in ('Education') THEN 1
              ELSE 0
              END;;
    label: "Formstage 2"
    group_label: "Form Stages Buckets"
  }

  measure: formstage_bucket_3 {
    description: "Count of form stage 3"
    type:  sum
    sql:  CASE WHEN  ${TABLE}.formstage in ('Experience') THEN 1
              ELSE 0
              END;;
    label: "Formstage 3"
    group_label: "Form Stages Buckets"
  }
  measure: formstage_bucket_4 {
    description: "Count of form stage 4"
    type:  sum
    sql:  CASE WHEN  ${TABLE}.formstage in ('Work Experience') THEN 1
              ELSE 0
              END;;
    label: "Formstage 4"
    group_label: "Form Stages Buckets"
  }
  measure: formstage_bucket_5 {
    description: "Count of form stage 5"
    type:  sum
    sql:  CASE WHEN  ${TABLE}.formstage in ('Net Worth') THEN 1
              ELSE 0
              END;;
    label: "Formstage 5"
    group_label: "Form Stages Buckets"
  }
  measure: formstage_bucket_6 {
    description: "Count of form stage 6"
    type:  sum
    sql:  CASE WHEN  ${TABLE}.formstage in ('Education') THEN 1
              ELSE 0
              END;;
    label: "Formstage 6"
    group_label: "Form Stages Buckets"
  }


  measure: unique_submit_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN ${TABLE}.action = 'submit' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }

  measure: unique_submit_success_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN ${TABLE}.result = 'submit success' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }
  measure: unique_submit_emailed_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN ${TABLE}.result = 'submit emailed' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }

  measure: unique_submit_validation_error_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN ${TABLE}.result = 'submit validation error' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }

  measure: unique_loaded_count {
    type: count_distinct
    sql_distinct_key: ${TABLE}.page_view_id ;;
    sql: CASE WHEN  ${TABLE}.action = 'loaded' THEN ${TABLE}.page_view_id ELSE NULL END ;;
    group_label: "Unique Counts"
  }

  measure: submit_count {
    type: sum
    sql: ${TABLE}.submit_count ;;
    group_label: "Counts"
  }
  measure: submit_success_count {
    type: sum
    sql: ${TABLE}.submit_success_count ;;
    group_label: "Counts"
  }
  measure: submit_validation_error_count {
    type: sum
    sql: ${TABLE}.submit_validation_error_count ;;
    group_label: "Counts"
  }
  measure: submission_error_count {
    type: sum
    sql: ${TABLE}.submission_error_count ;;
    group_label: "Counts"
  }
  measure: clear_count {
    type: sum
    sql: ${TABLE}.clear_count ;;
    group_label: "Counts"
  }
  measure: pdf_count {
    type: sum
    sql: ${TABLE}.pdf_count ;;
    group_label: "Counts"
  }
  measure: loaded_count {
    type: sum
    sql: ${TABLE}.loaded_count ;;
    group_label: "Counts"
  }
  measure: emailed_count {
    type: sum
    sql: ${TABLE}.emailed_count ;;
    group_label: "Counts"
  }
  measure: average_time {
    type: average_distinct
    sql: ${total_time} ;;
    sql_distinct_key: ${page_view_id} ;;
  }
  measure: row_count {
    type: count
  }
}
