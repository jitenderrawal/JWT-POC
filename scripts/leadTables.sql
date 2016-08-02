CREATE TABLE ll4_1.property
(
  name character varying,
  value character varying,
  CONSTRAINT pk_property PRIMARY KEY (name)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ll4_1.property
  OWNER TO mhowner;
GRANT ALL ON ll4_1.property
  TO mhadmin;
  

CREATE TABLE ll4_1.lead_distribution_log
(
  id serial,
  organization_id integer,
  last_lead_delivered timestamp,
  total_lead_count integer, 
  nolo_lead_count integer,
  CONSTRAINT pk_lead_distribution_log PRIMARY KEY (organization_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ll4_1.lead_distribution_log
  OWNER TO mhowner;
GRANT ALL ON ll4_1.lead_distribution_log
  TO mhadmin;  

