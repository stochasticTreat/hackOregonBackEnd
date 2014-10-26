create table import_dates
	(id numeric, 
	scrape_date date);

insert into import_dates
	(select committee_id, '2014-3-1'::date
	from raw_committees);
	
insert into import_dates
	(select id, '2010-1-1'::date
	from raw_committees_scraped);