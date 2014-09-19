create table campaign_detail
(candidate_name text,
race text,
website text,
phone text,
total double precision,
grassroots double precision,
instate double precision,
committee_names text,
filer_id integer);

copy campaign_detail from '/vagrant/campaign_detail_dump.csv'
WITH CSV HEADER QUOTE as '"';
