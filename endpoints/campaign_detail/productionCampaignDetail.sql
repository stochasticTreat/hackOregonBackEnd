/*Make working_candidate_committees table*/

DROP TABLE IF EXISTS working_candidate_committees;
CREATE TABLE working_candidate_committees AS
(SELECT * 
FROM ( SELECT  committee_id, committee_name, candidate_last_name, candidate_first_name, committee_type, 
		candidate_office as office_district, candidate_office_group, filing_date, candidate_work_phone,
		"organization_filing Date", active_election, measure 
	FROM raw_committees
	WHERE committee_type='CC') AS sub1
LEFT OUTER JOIN working_candidate_filings
ON sub1.candidate_last_name = last_name
AND sub1.candidate_first_name= first_name);

/*select * from working_candidate_committees where committee_type='CC';*/

/*Join with cc_grass_roots_in_state*/
DROP TABLE IF EXISTS campaign_detail;
CREATE TABLE campaign_detail AS
	(SELECT candidate_first_name ||' '||candidate_last_name as candidate_name, 
		candidate_office_group ||' '|| office_district as race, 
		web_address as website,
		candidate_work_phone as phone,
		total_money as total,
		percent_grassroots as grassroots,
		percent_instate as instate
	FROM 
		(SELECT filer_id, total_money, percent_grassroots, percent_instate
		FROM cc_grass_roots_in_state) as sub1
	JOIN working_candidate_committees
	ON committee_id = sub1.filer_id);
/*
select * from campaign_detail;
select * from cc_grass_roots_in_state;
select * from raw_committees;
*/
/*Find what is going on per race*/