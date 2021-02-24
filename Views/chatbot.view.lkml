view: chatbot {
  derived_table: {
    sql: with chatbot_combined AS ( -- link together V1 and V2, filling in NULL for the newly added fields that aren't in V1
          SELECT schema_vendor, schema_name, schema_format, schema_version, root_id, root_tstamp, ref_root, ref_tree, ref_parent, action, agent, text, NULL AS frontend_id, NULL AS intent_confidence, NULL AS "sentiment.magnitude",   NULL AS "sentiment.score", NULL AS session_id FROM atomic.ca_bc_gov_chatbot_chatbot_1
          UNION
          SELECT schema_vendor, schema_name, schema_format, schema_version, root_id, root_tstamp, ref_root, ref_tree, ref_parent, action, agent, text, frontend_id, intent_confidence, "sentiment.magnitude",  "sentiment.score", session_id FROM atomic.ca_bc_gov_chatbot_chatbot_2
        )
        SELECT wp.id,
          cb.root_id AS chat_event_id,
          action,
          agent,
          text,
          frontend_id,
          intent_confidence,
          "sentiment.magnitude" AS sentiment_magnitude,
          "sentiment.score" AS sentiment_score,
          session_id,
          CONVERT_TIMEZONE('UTC', 'America/Vancouver', cb.root_tstamp) AS timestamp,
          CASE WHEN action = 'ask_question' THEN 1 ELSE 0 END AS question_count,
          CASE WHEN action = 'get_answer' THEN 1 ELSE 0 END AS answer_count,
          CASE WHEN action = 'open' THEN 1 ELSE 0 END AS open_count,
          CASE WHEN action = 'hello' THEN 1 ELSE 0 END AS hello_count,
          CASE WHEN action = 'close' THEN 1 ELSE 0 END AS close_count,
          CASE WHEN action = 'link_click' THEN 1 ELSE 0 END AS link_click_count,
          CASE WHEN action = 'get_answer' THEN SPLIT_PART(text,'^',1) ELSE NULL END AS intent,
          CASE WHEN action = 'get_answer' THEN text ELSE NULL END AS intent_raw,
          CASE
                WHEN action = 'get_answer' AND SPLIT_PART(text,'^',2) <> '' THEN SPLIT_PART(text,'^',2)
                WHEN action = 'get_answer' THEN '1'
                ELSE NULL END AS intent_version, -- if there is something after "^" in an intent, it is the version. Otherwise, it is assumed to be version 1

          CASE WHEN timestamp < '2020-10-06 20:37:00' AND action = 'get_answer' THEN SPLIT_PART(SPLIT_PART(text, '-',1),'^',1)
               WHEN timestamp >= '2020-10-06 20:37:00' AND action = 'get_answer' THEN SPLIT_PART(SPLIT_PART(SPLIT_PART(text, '_',2),'|',1),'^',1)
          ELSE NULL END AS intent_category,
          CASE WHEN timestamp >= '2020-10-06 20:37:00' AND action = 'get_answer' THEN SPLIT_PART(SPLIT_PART(text, '_',1),'^',1)
            ELSE NULL END AS agency
          --CASE WHEN timestamp >= '2020-10-06 20:37:00' AND action = 'get_answer' THEN SPLIT_PART(SPLIT_PART(SPLIT_PART(text, '_',2),'|',2),'^',1)
          --  ELSE NULL END AS intent_subcategory,
          --CASE WHEN timestamp >= '2020-10-06 20:37:00' AND action = 'get_answer' THEN SPLIT_PART(SPLIT_PART(text, '_',3),'^',1)
          --  ELSE NULL END AS sample_question,
          --CASE WHEN action <> 'link_click' THEN NULL
          --  WHEN hr_url IS NOT NULL AND SPLIT_PART(text, '#',2) = '' THEN hr_url
          --  WHEN hr_url IS NOT NULL AND SPLIT_PART(text, '#',2) <> '' THEN hr_url || '#' || SPLIT_PART(text, '#',2)
          --  ELSE text END AS link_click_url
          FROM chatbot_combined AS cb
          JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON cb.root_id = wp.root_id AND cb.root_tstamp = wp.root_tstamp
          --LEFT JOIN cmslite.themes ON action = 'link_click' AND text LIKE 'https://www2.gov.bc.ca/gov/content?id=%' AND themes.node_id = SPLIT_PART(SPLIT_PART(SPLIT_PART(text, 'https://www2.gov.bc.ca/gov/content?id=', 2), '?',1 ), '#',1)
          ;;

      distribution_style: all
      persist_for: "8 hours"
    }

    dimension_group: event {
      type: time
      sql: ${TABLE}.timestamp ;;
    }
    dimension: id {
      type: string
      label: "Page View ID"
      sql: ${TABLE}.id ;;
    }
    dimension: chat_event_id {
      type: string
      sql: ${TABLE}.chat_event_id ;;
    }
    dimension: action {
      type: string
      sql: ${TABLE}.action ;;
    }
    dimension: link_click_url {
      type: string
      sql: ${TABLE}.link_click_url ;;
      drill_fields: [page_views.chatbot_page_display_url]
      link: {
        label: "Visit Page"
        url: "{{ value }}"
        icon_url: "https://looker.com/favicon.ico"
      }
    }
    dimension: intent {
      drill_fields: [page_views.chatbot_page_display_url,intent_version]
      group_label: "Intents"
    }
    dimension: intent_raw {
      drill_fields: [page_views.chatbot_page_display_url,intent_version]
      group_label: "Intents"
    }
    dimension: intent_version {
      drill_fields: [page_views.chatbot_page_display_url]
      group_label: "Intents"
    }
    dimension: intent_category {
    #  drill_fields: [intent, intent_subcategory, page_views.chatbot_page_display_url]
      group_label: "Intents"
    }

    dimension: intent_agency {
      drill_fields: [intent_category, intent, page_views.chatbot_page_display_url]
      sql: ${TABLE}.agency ;;
      group_label: "Intents"
    }
    dimension: frontend_id {}
    dimension: intent_confidence {}
    dimension: sentiment_magnitude {
      group_label: "Sentiment"
    }
    dimension: sentiment_score {
      group_label: "Sentiment"
    }

    dimension: chat_session_id {
      sql: ${TABLE}.session_id ;;
    }

    dimension: text {
      type: string
      sql: ${TABLE}.text ;;
    }
    dimension: agent {
      type: string
      sql: ${TABLE}.agent ;;
    }

    measure: question_count {
      type: sum
      sql: ${TABLE}.question_count ;;
    }
    measure: hello_count {
      type: sum
      sql: ${TABLE}.hello_count ;;
    }
    measure: answer_count {
      type: sum
      sql: ${TABLE}.answer_count ;;
    }
    measure:open_count {
      type: sum
      sql: ${TABLE}.open_count ;;
    }
    measure: close_count {
      type: sum
      sql: ${TABLE}.close_count ;;
    }
    measure: link_click_count {
      type: sum
      sql: ${TABLE}.link_click_count ;;
    }
    measure: chatbot_event_count {
      type: count
    }
    measure: extra_answer_count {
      type: sum
      sql: ${TABLE}.answer_count - ${TABLE}.question_count ;;
    }

  }
