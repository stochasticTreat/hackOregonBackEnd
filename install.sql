BEGIN;
DROP SCHEMA IF EXISTS http CASCADE;
CREATE SCHEMA http;

CREATE FUNCTION http.get_args2(name1 text, name2 text, name3 text, name4 text, OUT name1 json) AS
  'SELECT row_to_json(row(name1 , name2 ,  name3 , name4));'
LANGUAGE SQL;

CREATE FUNCTION http.get_db_stat(name1 text, name2 text, tabname text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (SELECT * 
    FROM hack_oregon_db_status
    WHERE hack_oregon_db_status IS NOT NULL
    ORDER BY hack_oregon_db_status DESC
    LIMIT 10) qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION http.get_searches(name1 text, name2 text, tabname text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (select access_log.committee_id, date, committee_name 
      from access_log join working_committees 
      on access_log.committee_id = working_committees.committee_id) qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION http.get_search_terms(name1 text, name2 text, tabname text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (select * from search_log) qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION http.get_all_documentation(name1 text, name2 text, commID text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (SELECT *
    FROM documentation) qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION http.get_endpoint_faq(name1 text, name2 text, endpointName text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (SELECT *
    FROM documentation
    WHERE endpoint_name like '%'||endpointName ||'%') qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION http.get_committee_data_by_id(name1 text, name2 text, commID text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN
  
  INSERT INTO access_log (committee_id, date)
  VALUES (commID::integer, CURRENT_TIMESTAMP);

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (SELECT *
    FROM campaign_detail
    WHERE filer_id=commID::integer
    ORDER BY total DESC) qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS http.get_candidate_in_by_state_by_id(name1 text, name2 text, cid text, name4 text);
CREATE FUNCTION http.get_candidate_in_by_state_by_id(name1 text, name2 text, cid text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM
    (SELECT state, value
    FROM candidate_by_state
    where filer_id = cid::integer
    and direction = 'in') qres
  INTO result;

  return result;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS http.get_candidate_out_by_state_by_id(name1 text, name2 text, cid text, name4 text);
CREATE FUNCTION http.get_candidate_out_by_state_by_id(name1 text, name2 text, cid text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM
    (SELECT state, value
    FROM candidate_by_state
    where filer_id = cid::integer
    and direction = 'out') qres
  INTO result;

  return result;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS http.get_competitors_from_name(name1 text, name2 text, cname text, name4 text);
CREATE FUNCTION http.get_competitors_from_name(name1 text, name2 text, cname text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM
    (SELECT * 
  FROM campaign_detail 
  WHERE race IN
    (SELECT race 
    FROM campaign_detail 
    WHERE candidate_name =cname)) qres
  INTO result;

  return result;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS http.get_competitors_from_filer_id(name1 text, name2 text, cname text, name4 text);
CREATE FUNCTION http.get_competitors_from_filer_id(name1 text, name2 text, cname text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM
    (
  SELECT * 
  FROM campaign_detail 
  WHERE race IN
    (SELECT race 
    FROM campaign_detail 
    WHERE filer_id = cname::integer)) qres
  INTO result;

  return result;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS http.get_candidate_in_by_state(name1 text, name2 text, cname text, name4 text);
CREATE FUNCTION http.get_candidate_in_by_state(name1 text, name2 text, cname text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM
    (SELECT state, value
    FROM candidate_by_state
    where candidate_name = cname
    and direction = 'in') qres
  INTO result;

  return result;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS http.get_candidate_out_by_state(name1 text, name2 text, cname text, name4 text);
CREATE FUNCTION http.get_candidate_out_by_state(name1 text, name2 text, cname text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM
    (SELECT state, value
    FROM candidate_by_state
    where candidate_name = cname
    and direction = 'out') qres
  INTO result;

  return result;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION http.get_committee_map(name1 text, name2 text, numRec text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM
    (SELECT candidate_name, committee_names, filer_id
    FROM campaign_detail) qres
  INTO result;

  return result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION http.get_top_committee_data(name1 text, name2 text, numRec text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (SELECT *
    FROM campaign_detail
    ORDER BY total DESC
    LIMIT numRec::int) qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION http.get_committee_data(name1 text, name2 text, commName text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (SELECT *
    FROM campaign_detail
    WHERE candidate_name=commName
    ORDER BY total DESC) qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION http.get_current_transactions(name1 text, name2 text, candidate_id text, name4 text) RETURNS json AS $$
DECLARE
  result json;
BEGIN

  SELECT array_to_json(array_agg(row_to_json(qres, true)), true)
  FROM 
    (SELECT *
    FROM cc_working_transactions
    WHERE filer_id = candidate_id::int
    ORDER BY tran_date DESC) qres
  INTO result;
  
  return result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION http.get(aschema text, afunction text, apath text, auser text) RETURNS json AS $$
DECLARE
  args text;
  result json;
BEGIN
    SELECT array_to_string(array_agg(
        (SELECT quote_literal(a[1]) || coalesce('::' || b[2], '')
         FROM regexp_split_to_array(row, E'::') AS a,
              regexp_split_to_array(row, E'::') AS b)
              ), ',')
    FROM unnest(regexp_split_to_array(apath, E'\/')) AS row INTO args;
    args := format('SELECT * FROM %I.%I(%L, %s) as row;', aschema, 'get_' || afunction, auser, args);
    RAISE NOTICE '%', args;
    EXECUTE args into result;
    RETURN result;
END;
$$ LANGUAGE plpgsql;
COMMIT;