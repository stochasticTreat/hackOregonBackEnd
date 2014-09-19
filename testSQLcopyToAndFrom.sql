COPY campaign_detail to '/Users/samhiggins2001_worldperks/prog/hack_oregon/dumpsFromPosgres/campaign_detail_dump.csv'
WITH CSV HEADER QUOTE as '"';

copy campaign_detail from '/Users/samhiggins2001_worldperks/prog/hack_oregon/dumpsFromPosgres/campaign_detail_dump.csv'
WITH CSV HEADER QUOTE as '"';


select * from campaign_detail;


create table test_campaign_detail
(candidate_name text, 
race text, 
website text, 
phone text, 
total double precision, 
grassroots double precision,
instate double precision, 
committee_names text, 
filer_id integer);

copy campaign_detail from '/Users/samhiggins2001_worldperks/prog/hack_oregon/dumpsFromPosgres/campaign_detail_dump.csv'
WITH CSV HEADER QUOTE as '"';

select * from test_campaign_detail;