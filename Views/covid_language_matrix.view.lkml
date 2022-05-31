# Version: 1.1.0
view: covid_language_matrix {
  derived_table: {
    sql:  SELECT title, english AS english_url, 'English' AS language, english AS translated_url FROM cmslite.covid_language_matrix WHERE english <> ''
          UNION
        SELECT title, english AS english_url, 'Punjabi' AS language, punjabi AS translated_url FROM cmslite.covid_language_matrix WHERE punjabi <> ''
          UNION
        SELECT title, english AS english_url, 'French' AS language, french AS translated_url FROM cmslite.covid_language_matrix WHERE french <> ''
          UNION
        SELECT title, english AS english_url, 'Spanish' AS language, spanish AS translated_url FROM cmslite.covid_language_matrix WHERE spanish <> ''
          UNION
        SELECT title, english AS english_url, 'Traditional Chinese' AS language, tc AS translated_url FROM cmslite.covid_language_matrix WHERE tc <> ''
          UNION
        SELECT title, english AS english_url, 'Simplified Chinese' AS language, sc AS translated_url FROM cmslite.covid_language_matrix WHERE sc <> ''
          UNION
        SELECT title, english AS english_url, 'Farsi' AS language, farsi AS translated_url FROM cmslite.covid_language_matrix WHERE farsi <> ''
          UNION
        SELECT title, english AS english_url, 'Tagalog' AS language, tagalog AS translated_url FROM cmslite.covid_language_matrix WHERE tagalog <> ''
          UNION
        SELECT title, english AS english_url, 'Korean' AS language, korean AS translated_url FROM cmslite.covid_language_matrix WHERE korean <> ''
          UNION
        SELECT title, english AS english_url, 'Arabic' AS language, arabic AS translated_url FROM cmslite.covid_language_matrix WHERE arabic <> ''
          UNION
        SELECT title, english AS english_url, 'Vietnamese' AS language, vietnamese AS translated_url FROM cmslite.covid_language_matrix WHERE vietnamese <> ''
          UNION
        SELECT title, english AS english_url, 'Japanese' AS language, japanese AS translated_url FROM cmslite.covid_language_matrix WHERE japanese <> ''
          UNION
        SELECT title, english AS english_url, 'Hindi' AS language, hindi AS translated_url FROM cmslite.covid_language_matrix WHERE hindi <> ''
          UNION
        SELECT title, english AS english_url, 'Russian' AS language, russian AS translated_url FROM cmslite.covid_language_matrix WHERE russian <> ''
          UNION
        SELECT title, english AS english_url, 'Ukrainian' AS language, ukrainian AS translated_url FROM cmslite.covid_language_matrix WHERE ukrainian <> '';;

      persist_for: "24 hours"
      distribution_style: all
  }
  label: "COVID Language Matrix"

  dimension: title {
    sql: ${TABLE}.title ;;
    drill_fields: [translated_url,language]
    link: {
      label: "Visit English Page"
      url: "{{ covid_language_matrix.english_url }}"
      icon_url: "https://looker.com/favicon.ico"
    }

  }
  dimension: english_url {
    sql:  ${TABLE}.english_url ;;
    link: {
      label: "Visit English Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }
  dimension: language {
    drill_fields: [translated_url]
  }
  dimension: translated_url {
    link: {
      label: "Visit English Page"
      url: "{{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
    link: {
      label: "Visit Translated Page"
      url: "{{ covid_language_matrix.english_url }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }
}
