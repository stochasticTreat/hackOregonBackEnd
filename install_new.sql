BEGIN;
DROP SCHEMA IF EXISTS http CASCADE;
CREATE SCHEMA http;

CREATE FUNCTION http.get_args2(name1 text, name2 text, name3 text, name4 text, OUT name1 json) AS
  'SELECT row_to_json(row(name1 , name2 ,  name3 , name4));'
LANGUAGE SQL;


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