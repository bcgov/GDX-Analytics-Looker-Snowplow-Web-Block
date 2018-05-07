view: cfms_poc {
  derived_table: {
    sql: WITH step1 AS(
      SELECT
        event_name,
        derived_tstamp AS event_time,
        DATEDIFF(seconds, LAG(derived_tstamp) OVER (PARTITION BY client_id ORDER BY event_time), derived_tstamp) AS wait_time,
        client_id,
        office_id,
        agent_id,
        program_id,
        channel,
        inaccurate_time
      FROM atomic.events AS ev
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_agent_2 AS a
          ON ev.event_id = a.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_citizen_2 AS c
          ON ev.event_id = c.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_office_1 AS o
          ON ev.event_id = o.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_addcitizen_1 AS ac
          ON ev.event_id = ac.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_additionalservice_1 AS ad
          ON ev.event_id = ad.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_addtoqueue_1 AS aq
          ON ev.event_id = aq.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_beginservice_1 AS bs
          ON ev.event_id = bs.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_chooseservice_2 AS cs
          ON ev.event_id = cs.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_customerleft_1 AS cl
          ON ev.event_id = cl.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_finish_1 AS fi
          ON ev.event_id = fi.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_hold_1 AS ho
          ON ev.event_id = ho.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_invitecitizen_1 AS ic
          ON ev.event_id = ic.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_invitefromhold_1 AS ih
          ON ev.event_id = ih.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_invitefromlist_1 AS il
          ON ev.event_id = il.root_id
      LEFT JOIN atomic.ca_bc_gov_cfmspoc_returntoqueue_1 AS rq
          ON ev.event_id = rq.root_id
      WHERE name_tracker = 'CFMS_poc' AND client_id IS NOT NULL
      ),
  welcome_table AS(
    SELECT
        event_name,
        event_time,
        wait_time,
        inaccurate_time,
        client_id,
        office_id,
        agent_id,
        program_id,
        channel,
        event_time welcome_time
      FROM step1
      WHERE event_name in ('addcitizen')
      ORDER BY event_time
      ),
    stand_table AS(
      SELECT
        event_name,
        event_time,
        wait_time,
        inaccurate_time,
        client_id,
        office_id,
        agent_id,
        program_id,
        channel,
        event_time stand_time
      FROM step1
      WHERE event_name in ('addtoqueue','beginservice')
      ORDER BY event_time
      ),
    invite_table AS(
      SELECT
        event_name,
        event_time,
        wait_time,
        inaccurate_time,
        client_id,
        office_id,
        agent_id,
        program_id,
        channel,
        event_time invite_time
      FROM step1
      WHERE event_name in ('beginservice','invitecitizen')
      ORDER BY event_time
      ),
    start_table AS(
      SELECT
        event_name,
        event_time,
        wait_time,
        inaccurate_time,
        client_id,
        office_id,
        agent_id,
        program_id,
        channel,
        event_time start_time
      FROM step1
      WHERE event_name in ('beginservice')
      ORDER BY event_time
      ),
    finish_table AS(
      SELECT
        event_name,
        event_time,
        wait_time,
        inaccurate_time,
        client_id,
        office_id,
        agent_id,
        program_id,
        channel,
        event_time finish_time
      FROM step1
      WHERE event_name in ('finish','customerleft')
      ORDER BY event_time
      ),
    chooseservice_table AS(
      SELECT
        event_name,
        event_time,
        wait_time,
        inaccurate_time,
        client_id,
        office_id,
        agent_id,
        program_id,
        channel,
        event_time chooseservice_time
      FROM step1
      WHERE event_name in ('chooseservice')
      ORDER BY event_time
      ),
    combined AS (
      SELECT
      welcome_table.client_id,
      welcome_table.office_id,
      welcome_table.agent_id,
      chooseservice_table.program_id,
      static.service_info.name AS program_name,
      chooseservice_table.channel,
      finish_table.inaccurate_time,
      welcome_time, stand_time, invite_time, start_time, finish_time
      FROM welcome_table
      LEFT JOIN stand_table ON welcome_table.client_id = stand_table.client_id
      LEFT JOIN invite_table ON welcome_table.client_id = invite_table.client_id
      LEFT JOIN start_table ON welcome_table.client_id = start_table.client_id
      LEFT JOIN finish_table ON welcome_table.client_id = finish_table.client_id
      LEFT JOIN chooseservice_table ON welcome_table.client_id = chooseservice_table.client_id
      JOIN static.service_info ON static.service_info.id = chooseservice_table.program_id
    )
    SELECT * FROM (
      SELECT *, ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY welcome_time) AS client_id_ranked
      FROM combined
      ORDER BY client_id, welcome_time
    ) AS ranked
    WHERE ranked.client_id_ranked = 1
    ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: welcome_time {
    type: date_time
    sql: ${TABLE}.welcome_time ;;
  }

  dimension: stand_time {
    type: date_time
    sql: ${TABLE}.stand_time ;;
  }

  dimension: invite_time {
    type: date_time
    sql: ${TABLE}.invite_time ;;
  }

  dimension: start_time {
    type: date_time
    sql: ${TABLE}.start_time ;;
  }

  dimension: finish_time {
    type: date_time
    sql: ${TABLE}.finish_time ;;
  }

  dimension: client_id {
    type: number
    sql: ${TABLE}.client_id ;;
  }

  dimension: office_id {
    type: number
    sql: ${TABLE}.office_id ;;
  }

  dimension: agent_id {
    type: number
    sql: ${TABLE}.agent_id ;;
  }

  dimension: program_id {
    type: number
    sql: ${TABLE}.program_id ;;
  }

  dimension: program_name {
    type: number
    sql: ${TABLE}.program_name ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: inaccurate_time {
    type: yesno
    sql: ${TABLE}.inaccurate_time ;;
  }


  set: detail {
    fields: [
      client_id,
      office_id,
      agent_id,
      program_id,
      channel,
      inaccurate_time,
      welcome_time,
      stand_time,
      invite_time,
      start_time,
      finish_time
    ]
  }
}
