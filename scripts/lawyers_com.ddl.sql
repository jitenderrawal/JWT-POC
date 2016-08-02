-- PostgreSQL version: 9.4
-- Model Author: Eric Lee

SET check_function_bodies = false;

-- object: ll4 | type: SCHEMA --
-- DROP SCHEMA ll4;
CREATE SCHEMA ll4;
ALTER SCHEMA ll4 OWNER TO mhadmin;
-- ddl-end --

SET search_path TO pg_catalog,public,ll4;
-- ddl-end --

-- object: ll4.organization_1 | type: TABLE --
-- DROP TABLE ll4.organization_1;
CREATE UNLOGGED TABLE ll4.organization_1(
	id integer NOT NULL,
	org_type_id smallint NOT NULL,
	org_name character varying(4000),
	org_size smallint NOT NULL,
	cr_aggr_result_id integer,
	cr_rating_score real,
	cr_last_review_date timestamp,
	cr_ca_avg_score real,
	cr_re_avg_score real,
	cr_qs_avg_score real,
	cr_vm_avg_score real,
	cr_total_client_reviews real,
	cr_total_recommended real,
	cr_aop_list character varying(4000),
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT organization_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_organization | type: INDEX --
-- DROP INDEX ll4.idx_organization;
CREATE UNIQUE INDEX idx_organization ON ll4.organization_1
	USING btree
	(
	  id,
	  org_type_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.organization_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.org_cr_feedback_1 | type: TABLE --
-- DROP TABLE ll4.org_cr_feedback_1;
CREATE UNLOGGED TABLE ll4.org_cr_feedback_1(
	id integer NOT NULL,
	organization_id integer NOT NULL,
	client_type_id smallint NOT NULL,
	client_feedback character varying(4000),
	publish_date timestamp,
	comment character varying(2000),
	display_seq smallint,
	rating_score real,
	recommended_flag character,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT org_cr_feedback_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_org_cr_feedback_1 | type: INDEX --
-- DROP INDEX ll4.idx_org_cr_feedback_1;
CREATE INDEX idx_org_cr_feedback_1 ON ll4.org_cr_feedback_1
	USING btree
	(
	  organization_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.org_cr_feedback_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.location_1 | type: TABLE --
-- DROP TABLE ll4.location_1;
CREATE UNLOGGED TABLE ll4.location_1(
	id integer NOT NULL,
	loc_type_id smallint NOT NULL,
	organization_id integer,
	loc_name character varying(4000),
	profile text,
	postatty character varying(4000),
	legal_insurance character varying(4000),
	free_initial_consult_flag character,
	fixed_hourly_rates_flag character,
	fixed_fee_service_flag character,
	location_id integer,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT location_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_location_1 | type: INDEX --
-- DROP INDEX ll4.idx_location_1;
CREATE INDEX idx_location_1 ON ll4.location_1
	USING btree
	(
	  id,
	  loc_type_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_location_organization_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_location_organization_id_1;
CREATE INDEX idx_location_organization_id_1 ON ll4.location_1
	USING btree
	(
	  organization_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.location_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.address_1 | type: TABLE --
-- DROP TABLE ll4.address_1;
CREATE UNLOGGED TABLE ll4.address_1(
	id integer NOT NULL,
	entity_type_id smallint NOT NULL,
	addr_type_id smallint NOT NULL,
	location_id integer,
	persona_id integer,
	bldg character varying(4000),
	street character varying(4000),
	pobox character varying(4000),
	city_name_override character varying(4000),
	city_id smallint,
	county_id smallint,
	state_id smallint,
	country_id smallint,
	pre_city_postal_code character varying(4000),
	postal_code character varying(4000),
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT address_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_address_location_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_address_location_id_1;
CREATE INDEX idx_address_location_id_1 ON ll4.address_1
	USING btree
	(
	  location_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_address_persona_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_address_persona_id_1;
CREATE INDEX idx_address_persona_id_1 ON ll4.address_1
	USING btree
	(
	  persona_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_address_city_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_address_city_id_1;
CREATE INDEX idx_address_city_id_1 ON ll4.address_1
	USING btree
	(
	  city_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_address_state_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_address_state_id_1;
CREATE INDEX idx_address_state_id_1 ON ll4.address_1
	USING btree
	(
	  state_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_address_county_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_address_county_id_1;
CREATE INDEX idx_address_county_id_1 ON ll4.address_1
	USING btree
	(
	  county_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_address_country_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_address_country_id_1;
CREATE INDEX idx_address_country_id_1 ON ll4.address_1
	USING btree
	(
	  country_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.address_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.country_1 | type: TABLE --
-- DROP TABLE ll4.country_1;
CREATE UNLOGGED TABLE ll4.country_1(
	id smallint NOT NULL,
	country_name character varying(90) NOT NULL,
	country_abbrev_name character varying(6),
	has_states_flag character NOT NULL DEFAULT 'N'::bpchar,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT country_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE ll4.country_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.county_1 | type: TABLE --
-- DROP TABLE ll4.county_1;
CREATE UNLOGGED TABLE ll4.county_1(
	id smallint NOT NULL,
	county_name character varying(90) NOT NULL,
	state_id smallint,
	country_id smallint NOT NULL,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT county_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE ll4.county_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.city_1 | type: TABLE --
-- DROP TABLE ll4.city_1;
CREATE UNLOGGED TABLE ll4.city_1(
	id smallint NOT NULL,
	city_name character varying(128) NOT NULL,
	county_id smallint,
	state_id smallint,
	country_id smallint NOT NULL,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT city_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_city_state_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_city_state_id_1;
CREATE INDEX idx_city_state_id_1 ON ll4.city_1
	USING btree
	(
	  state_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_city_county_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_city_county_id_1;
CREATE INDEX idx_city_county_id_1 ON ll4.city_1
	USING btree
	(
	  county_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_city_country_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_city_country_id_1;
CREATE INDEX idx_city_country_id_1 ON ll4.city_1
	USING btree
	(
	  country_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.city_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.state_1 | type: TABLE --
-- DROP TABLE ll4.state_1;
CREATE UNLOGGED TABLE ll4.state_1(
	id smallint NOT NULL,
	country_id smallint NOT NULL,
	state_abbrev character varying(2) NOT NULL,
	state_name character varying(90) NOT NULL,
	us_possession_flag character NOT NULL DEFAULT 'N'::character varying,
	has_counties_flag character NOT NULL DEFAULT 'N'::character varying,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT state_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_state_state_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_state_state_id_1;
CREATE INDEX idx_state_state_id_1 ON ll4.state_1
	USING btree
	(
	  country_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.state_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.facet_subtype_1 | type: TABLE --
-- DROP TABLE ll4.facet_subtype_1;
CREATE UNLOGGED TABLE ll4.facet_subtype_1(
	id smallint NOT NULL,
	facet_type_id smallint NOT NULL,
	description character varying(4000),
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT facet_subtype_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE ll4.facet_subtype_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.facet_type_1 | type: TABLE --
-- DROP TABLE ll4.facet_type_1;
CREATE UNLOGGED TABLE ll4.facet_type_1(
	id smallint NOT NULL,
	description character varying(4000),
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT facet_type_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE ll4.facet_type_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.media_type_1 | type: TABLE --
-- DROP TABLE ll4.media_type_1;
CREATE UNLOGGED TABLE ll4.media_type_1(
	id smallint NOT NULL,
	description character varying(4000),
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT media_type_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE ll4.media_type_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.facet_1 | type: TABLE --
-- DROP TABLE ll4.facet_1;
CREATE UNLOGGED TABLE ll4.facet_1(
	id integer NOT NULL,
	entity_type_id smallint NOT NULL,
	facet_type_id smallint NOT NULL,
	facet_subtype_id smallint,
	organization_id integer,
	location_id integer,
	individual_id integer,
	persona_id integer,
	caption character varying(4000),
	facet character varying(4000) NOT NULL,
	extension character varying(4000),
	display_seq_no smallint NOT NULL,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT facet_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_facet_organization_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_facet_organization_id_1;
CREATE INDEX idx_facet_organization_id_1 ON ll4.facet_1
	USING btree
	(
	  organization_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_facet_location_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_facet_location_id_1;
CREATE INDEX idx_facet_location_id_1 ON ll4.facet_1
	USING btree
	(
	  location_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_facet_individual_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_facet_individual_id_1;
CREATE INDEX idx_facet_individual_id_1 ON ll4.facet_1
	USING btree
	(
	  individual_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_facet_persona_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_facet_persona_id_1;
CREATE INDEX idx_facet_persona_id_1 ON ll4.facet_1
	USING btree
	(
	  persona_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_facet_entity_type_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_facet_entity_type_id_1;
CREATE INDEX idx_facet_entity_type_id_1 ON ll4.facet_1
	USING btree
	(
	  entity_type_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_facet_facet_type_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_facet_facet_type_id_1;
CREATE INDEX idx_facet_facet_type_id_1 ON ll4.facet_1
	USING btree
	(
	  facet_type_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_facet_facet_subtype_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_facet_facet_subtype_id_1;
CREATE INDEX idx_facet_facet_subtype_id_1 ON ll4.facet_1
	USING btree
	(
	  facet_subtype_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.facet_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.aop_1 | type: TABLE --
-- DROP TABLE ll4.aop_1;
CREATE UNLOGGED TABLE ll4.aop_1(
	id integer NOT NULL,
	entity_type_id smallint NOT NULL,
	organization_id integer,
	location_id integer,
	individual_id integer,
	persona_id integer,
	mh_aop_id smallint,
	percent_of_work real,
	no_of_cases smallint,
	pro_bono_flag character DEFAULT 'N'::bpchar,
	display_aop character varying(4000) NOT NULL,
	display_seq_no smallint NOT NULL,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT aop_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_aop_location_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_aop_location_id_1;
CREATE INDEX idx_aop_location_id_1 ON ll4.aop_1
	USING btree
	(
	  location_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_aop_persona_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_aop_persona_id_1;
CREATE INDEX idx_aop_persona_id_1 ON ll4.aop_1
	USING btree
	(
	  persona_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.aop_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.heading_1 | type: TABLE --
-- DROP TABLE ll4.heading_1;
CREATE UNLOGGED TABLE ll4.heading_1(
	id integer NOT NULL,
	location_id integer NOT NULL,
	subunit_account integer NOT NULL,
	subunit_id integer NOT NULL,
	heading character varying(4000),
	alpha_flag character DEFAULT 'N'::bpchar,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT heading_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_heading_location_id_subunit_account_1 | type: INDEX --
-- DROP INDEX ll4.idx_heading_location_id_subunit_account_1;
CREATE UNIQUE INDEX idx_heading_location_id_subunit_account_1 ON ll4.heading_1
	USING btree
	(
	  location_id,
	  subunit_account
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.heading_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.individual_1 | type: TABLE --
-- DROP TABLE ll4.individual_1;
CREATE UNLOGGED TABLE ll4.individual_1(
	id integer NOT NULL,
	pr_rating_score real,
	pr_last_review_date timestamp,
	pr_aggr_status_id integer,
	cr_aggr_result_id integer,
	cr_total_reviews smallint,
	cr_pct_recommended real,
	cr_rating_score real,
	cr_rating_semantic character varying(30),
	cr_last_review_date timestamp,
	cr_ca_avg_score real,
	cr_re_avg_score real,
	cr_qs_avg_score real,
	cr_vm_avg_score real,
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT individual_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE ll4.individual_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.persona_1 | type: TABLE --
-- DROP TABLE ll4.persona_1;
CREATE UNLOGGED TABLE ll4.persona_1(
	id integer NOT NULL,
	location_id integer,
	heading_id integer,
	individual_id integer,
	first_name character varying(4000),
	middle_name character varying(4000),
	last_name character varying(4000),
	position_desc character varying(4000),
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT persona_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_persona_location_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_persona_location_id_1;
CREATE INDEX idx_persona_location_id_1 ON ll4.persona_1
	USING btree
	(
	  location_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_persona_heading_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_persona_heading_id_1;
CREATE INDEX idx_persona_heading_id_1 ON ll4.persona_1
	USING btree
	(
	  heading_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.persona_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.media_1 | type: TABLE --
-- DROP TABLE ll4.media_1;
CREATE UNLOGGED TABLE ll4.media_1(
	id integer NOT NULL,
	entity_type_id smallint NOT NULL,
	media_type_id smallint NOT NULL,
	organization_id integer,
	location_id integer,
	individual_id integer,
	persona_id integer,
	media_name character varying(128) NOT NULL,
	tagline character varying(256),
	image_path character varying(128),
	external_video_provider character varying(256),
	external_video_id character varying(256),
	external_video_offset character varying(256),
	create_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	create_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	audit_user character varying(32) NOT NULL DEFAULT 'LL4ETL'::character varying,
	audit_date timestamp NOT NULL DEFAULT ('now'::text)::timestamp without time zone,
	CONSTRAINT media_1_pkey PRIMARY KEY (id)

);
-- ddl-end --
-- object: idx_media_organization_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_media_organization_id_1;
CREATE INDEX idx_media_organization_id_1 ON ll4.media_1
	USING btree
	(
	  organization_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_media_location_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_media_location_id_1;
CREATE INDEX idx_media_location_id_1 ON ll4.media_1
	USING btree
	(
	  location_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_media_individual_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_media_individual_id_1;
CREATE INDEX idx_media_individual_id_1 ON ll4.media_1
	USING btree
	(
	  individual_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_media_persona_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_media_persona_id_1;
CREATE INDEX idx_media_persona_id_1 ON ll4.media_1
	USING btree
	(
	  persona_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_media_entity_type_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_media_entity_type_id_1;
CREATE INDEX idx_media_entity_type_id_1 ON ll4.media_1
	USING btree
	(
	  entity_type_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_media_media_type_id_1 | type: INDEX --
-- DROP INDEX ll4.idx_media_media_type_id_1;
CREATE INDEX idx_media_media_type_id_1 ON ll4.media_1
	USING btree
	(
	  media_type_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


ALTER TABLE ll4.media_1 OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.country_v | type: VIEW --
-- DROP VIEW ll4.country_v;
CREATE VIEW ll4.country_v
AS  SELECT country_1.id,
    country_1.country_name,
    country_1.country_abbrev_name,
    country_1.has_states_flag,
    country_1.create_user,
    country_1.create_date,
    country_1.audit_user,
    country_1.audit_date
   FROM ll4.country_1;;
-- ddl-end --

ALTER VIEW ll4.country_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.state_v | type: VIEW --
-- DROP VIEW ll4.state_v;
CREATE VIEW ll4.state_v
AS  SELECT state_1.id,
    state_1.country_id,
    state_1.state_abbrev,
    state_1.state_name,
    state_1.us_possession_flag,
    state_1.has_counties_flag,
    state_1.create_user,
    state_1.create_date,
    state_1.audit_user,
    state_1.audit_date
   FROM ll4.state_1;;
-- ddl-end --

ALTER VIEW ll4.state_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.county_v | type: VIEW --
-- DROP VIEW ll4.county_v;
CREATE VIEW ll4.county_v
AS  SELECT county_1.id,
    county_1.county_name,
    county_1.state_id,
    county_1.country_id,
    county_1.create_user,
    county_1.create_date,
    county_1.audit_user,
    county_1.audit_date
   FROM ll4.county_1;;
-- ddl-end --

ALTER VIEW ll4.county_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.city_v | type: VIEW --
-- DROP VIEW ll4.city_v;
CREATE VIEW ll4.city_v
AS  SELECT city_1.id,
    city_1.city_name,
    city_1.county_id,
    city_1.state_id,
    city_1.country_id,
    city_1.create_user,
    city_1.create_date,
    city_1.audit_user,
    city_1.audit_date
   FROM ll4.city_1;;
-- ddl-end --

ALTER VIEW ll4.city_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.location_v | type: VIEW --
-- DROP VIEW ll4.location_v;
CREATE VIEW ll4.location_v
AS  SELECT organization_1.id,
    organization_1.org_type_id,
    organization_1.org_name,
    organization_1.org_size,
    organization_1.cr_aggr_result_id,
    organization_1.cr_rating_score,
    organization_1.cr_last_review_date,
    organization_1.cr_ca_avg_score,
    organization_1.cr_re_avg_score,
    organization_1.cr_qs_avg_score,
    organization_1.cr_vm_avg_score,
    organization_1.cr_total_client_reviews,
    organization_1.cr_total_recommended,
    organization_1.cr_aop_list,
    organization_1.create_user,
    organization_1.create_date,
    organization_1.audit_user,
    organization_1.audit_date
   FROM ll4.organization_1;;
-- ddl-end --

ALTER VIEW ll4.location_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.address_v | type: VIEW --
-- DROP VIEW ll4.address_v;
CREATE VIEW ll4.address_v
AS  SELECT address_1.id,
    address_1.entity_type_id,
    address_1.addr_type_id,
    address_1.location_id,
    address_1.persona_id,
    address_1.bldg,
    address_1.street,
    address_1.pobox,
    address_1.city_name_override,
    address_1.city_id,
    address_1.county_id,
    address_1.state_id,
    address_1.country_id,
    address_1.pre_city_postal_code,
    address_1.postal_code,
    address_1.create_user,
    address_1.create_date,
    address_1.audit_user,
    address_1.audit_date
   FROM ll4.address_1;;
-- ddl-end --

ALTER VIEW ll4.address_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.facet_type_v | type: VIEW --
-- DROP VIEW ll4.facet_type_v;
CREATE VIEW ll4.facet_type_v
AS  SELECT facet_type_1.id,
    facet_type_1.description,
    facet_type_1.create_user,
    facet_type_1.create_date,
    facet_type_1.audit_user,
    facet_type_1.audit_date
   FROM ll4.facet_type_1;;
-- ddl-end --

ALTER VIEW ll4.facet_type_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.facet_subtype_v | type: VIEW --
-- DROP VIEW ll4.facet_subtype_v;
CREATE VIEW ll4.facet_subtype_v
AS  SELECT facet_subtype_1.id,
    facet_subtype_1.facet_type_id,
    facet_subtype_1.description,
    facet_subtype_1.create_user,
    facet_subtype_1.create_date,
    facet_subtype_1.audit_user,
    facet_subtype_1.audit_date
   FROM ll4.facet_subtype_1;;
-- ddl-end --

ALTER VIEW ll4.facet_subtype_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.facet_v | type: VIEW --
-- DROP VIEW ll4.facet_v;
CREATE VIEW ll4.facet_v
AS  SELECT facet_1.id,
    facet_1.entity_type_id,
    facet_1.facet_type_id,
    facet_1.facet_subtype_id,
    facet_1.organization_id,
    facet_1.location_id,
    facet_1.individual_id,
    facet_1.persona_id,
    facet_1.caption,
    facet_1.facet,
    facet_1.extension,
    facet_1.display_seq_no,
    facet_1.create_user,
    facet_1.create_date,
    facet_1.audit_user,
    facet_1.audit_date
   FROM ll4.facet_1;;
-- ddl-end --

ALTER VIEW ll4.facet_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.aop_v | type: VIEW --
-- DROP VIEW ll4.aop_v;
CREATE VIEW ll4.aop_v
AS  SELECT aop_1.id,
    aop_1.entity_type_id,
    aop_1.organization_id,
    aop_1.location_id,
    aop_1.individual_id,
    aop_1.persona_id,
    aop_1.mh_aop_id,
    aop_1.percent_of_work,
    aop_1.no_of_cases,
    aop_1.pro_bono_flag,
    aop_1.display_aop,
    aop_1.display_seq_no,
    aop_1.create_user,
    aop_1.create_date,
    aop_1.audit_user,
    aop_1.audit_date
   FROM ll4.aop_1;;
-- ddl-end --

ALTER VIEW ll4.aop_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.heading_v | type: VIEW --
-- DROP VIEW ll4.heading_v;
CREATE VIEW ll4.heading_v
AS  SELECT heading_1.id,
    heading_1.location_id,
    heading_1.subunit_account,
    heading_1.subunit_id,
    heading_1.heading,
    heading_1.alpha_flag,
    heading_1.create_user,
    heading_1.create_date,
    heading_1.audit_user,
    heading_1.audit_date
   FROM ll4.heading_1;;
-- ddl-end --

ALTER VIEW ll4.heading_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.individual_v | type: VIEW --
-- DROP VIEW ll4.individual_v;
CREATE VIEW ll4.individual_v
AS  SELECT individual_1.id,
    individual_1.pr_rating_score,
    individual_1.pr_last_review_date,
    individual_1.pr_aggr_status_id,
    individual_1.cr_aggr_result_id,
    individual_1.cr_total_reviews,
    individual_1.cr_pct_recommended,
    individual_1.cr_rating_score,
    individual_1.cr_rating_semantic,
    individual_1.cr_last_review_date,
    individual_1.cr_ca_avg_score,
    individual_1.cr_re_avg_score,
    individual_1.cr_qs_avg_score,
    individual_1.cr_vm_avg_score,
    individual_1.create_user,
    individual_1.create_date,
    individual_1.audit_user,
    individual_1.audit_date
   FROM ll4.individual_1;;
-- ddl-end --

ALTER VIEW ll4.individual_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.persona_v | type: VIEW --
-- DROP VIEW ll4.persona_v;
CREATE VIEW ll4.persona_v
AS  SELECT persona_1.id,
    persona_1.location_id,
    persona_1.heading_id,
    persona_1.individual_id,
    persona_1.first_name,
    persona_1.middle_name,
    persona_1.last_name,
    persona_1.position_desc,
    persona_1.create_user,
    persona_1.create_date,
    persona_1.audit_user,
    persona_1.audit_date
   FROM ll4.persona_1;;
-- ddl-end --

ALTER VIEW ll4.persona_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.media_type_v | type: VIEW --
-- DROP VIEW ll4.media_type_v;
CREATE VIEW ll4.media_type_v
AS  SELECT media_type_1.id,
    media_type_1.description,
    media_type_1.create_user,
    media_type_1.create_date,
    media_type_1.audit_user,
    media_type_1.audit_date
   FROM ll4.media_type_1;;
-- ddl-end --

ALTER VIEW ll4.media_type_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.media_v | type: VIEW --
-- DROP VIEW ll4.media_v;
CREATE VIEW ll4.media_v
AS  SELECT media_1.id,
    media_1.entity_type_id,
    media_1.media_type_id,
    media_1.organization_id,
    media_1.location_id,
    media_1.individual_id,
    media_1.persona_id,
    media_1.media_name,
    media_1.tagline,
    media_1.image_path,
    media_1.external_video_provider,
    media_1.external_video_id,
    media_1.external_video_offset,
    media_1.create_user,
    media_1.create_date,
    media_1.audit_user,
    media_1.audit_date
   FROM ll4.media_1;;
-- ddl-end --

ALTER VIEW ll4.media_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.org_cr_feedback_v | type: VIEW --
-- DROP VIEW ll4.org_cr_feedback_v;
CREATE VIEW ll4.org_cr_feedback_v
AS  SELECT org_cr_feedback_1.id,
    org_cr_feedback_1.organization_id,
    org_cr_feedback_1.client_type_id,
    org_cr_feedback_1.client_feedback,
    org_cr_feedback_1.publish_date,
    org_cr_feedback_1.comment,
    org_cr_feedback_1.display_seq,
    org_cr_feedback_1.rating_score,
    org_cr_feedback_1.recommended_flag,
    org_cr_feedback_1.create_user,
    org_cr_feedback_1.create_date,
    org_cr_feedback_1.audit_user,
    org_cr_feedback_1.audit_date
   FROM ll4.org_cr_feedback_1;;
-- ddl-end --

ALTER VIEW ll4.org_cr_feedback_v OWNER TO mhadmin;
-- ddl-end --

-- object: ll4.organization_v | type: VIEW --
-- DROP VIEW ll4.organization_v;
CREATE VIEW ll4.organization_v
AS  SELECT organization_1.id,
    organization_1.org_type_id,
    organization_1.org_name,
    organization_1.org_size,
    organization_1.cr_aggr_result_id,
    organization_1.cr_rating_score,
    organization_1.cr_last_review_date,
    organization_1.cr_ca_avg_score,
    organization_1.cr_re_avg_score,
    organization_1.cr_qs_avg_score,
    organization_1.cr_vm_avg_score,
    organization_1.cr_total_client_reviews,
    organization_1.cr_total_recommended,
    organization_1.cr_aop_list,
    organization_1.create_user,
    organization_1.create_date,
    organization_1.audit_user,
    organization_1.audit_date
   FROM ll4.organization_1;;
-- ddl-end --

ALTER VIEW ll4.organization_v OWNER TO mhadmin;
-- ddl-end --

-- object: fk_org_cr_feedback_organization_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.org_cr_feedback_1 DROP CONSTRAINT fk_org_cr_feedback_organization_1;
ALTER TABLE ll4.org_cr_feedback_1 ADD CONSTRAINT fk_org_cr_feedback_organization_1 FOREIGN KEY (organization_id)
REFERENCES ll4.organization_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_location_organization_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.location_1 DROP CONSTRAINT fk_location_organization_1;
ALTER TABLE ll4.location_1 ADD CONSTRAINT fk_location_organization_1 FOREIGN KEY (organization_id)
REFERENCES ll4.organization_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_address_location_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.address_1 DROP CONSTRAINT fk_address_location_1;
ALTER TABLE ll4.address_1 ADD CONSTRAINT fk_address_location_1 FOREIGN KEY (location_id)
REFERENCES ll4.location_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_address_city_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.address_1 DROP CONSTRAINT fk_address_city_1;
ALTER TABLE ll4.address_1 ADD CONSTRAINT fk_address_city_1 FOREIGN KEY (city_id)
REFERENCES ll4.city_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_address_county_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.address_1 DROP CONSTRAINT fk_address_county_1;
ALTER TABLE ll4.address_1 ADD CONSTRAINT fk_address_county_1 FOREIGN KEY (county_id)
REFERENCES ll4.county_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_address_state_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.address_1 DROP CONSTRAINT fk_address_state_1;
ALTER TABLE ll4.address_1 ADD CONSTRAINT fk_address_state_1 FOREIGN KEY (state_id)
REFERENCES ll4.state_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_address_country_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.address_1 DROP CONSTRAINT fk_address_country_1;
ALTER TABLE ll4.address_1 ADD CONSTRAINT fk_address_country_1 FOREIGN KEY (state_id)
REFERENCES ll4.country_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_address_persona_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.address_1 DROP CONSTRAINT fk_address_persona_1;
ALTER TABLE ll4.address_1 ADD CONSTRAINT fk_address_persona_1 FOREIGN KEY (persona_id)
REFERENCES ll4.persona_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_county_state_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.county_1 DROP CONSTRAINT fk_county_state_1;
ALTER TABLE ll4.county_1 ADD CONSTRAINT fk_county_state_1 FOREIGN KEY (state_id)
REFERENCES ll4.state_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_county_country_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.county_1 DROP CONSTRAINT fk_county_country_1;
ALTER TABLE ll4.county_1 ADD CONSTRAINT fk_county_country_1 FOREIGN KEY (country_id)
REFERENCES ll4.country_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_city_county_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.city_1 DROP CONSTRAINT fk_city_county_1;
ALTER TABLE ll4.city_1 ADD CONSTRAINT fk_city_county_1 FOREIGN KEY (county_id)
REFERENCES ll4.county_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_city_state_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.city_1 DROP CONSTRAINT fk_city_state_1;
ALTER TABLE ll4.city_1 ADD CONSTRAINT fk_city_state_1 FOREIGN KEY (state_id)
REFERENCES ll4.state_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_city_country_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.city_1 DROP CONSTRAINT fk_city_country_1;
ALTER TABLE ll4.city_1 ADD CONSTRAINT fk_city_country_1 FOREIGN KEY (country_id)
REFERENCES ll4.country_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_state_country_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.state_1 DROP CONSTRAINT fk_state_country_1;
ALTER TABLE ll4.state_1 ADD CONSTRAINT fk_state_country_1 FOREIGN KEY (country_id)
REFERENCES ll4.country_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_facet_type_facet_subtype_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.facet_subtype_1 DROP CONSTRAINT fk_facet_type_facet_subtype_1;
ALTER TABLE ll4.facet_subtype_1 ADD CONSTRAINT fk_facet_type_facet_subtype_1 FOREIGN KEY (facet_type_id)
REFERENCES ll4.facet_type_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_facet_organization_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.facet_1 DROP CONSTRAINT fk_facet_organization_1;
ALTER TABLE ll4.facet_1 ADD CONSTRAINT fk_facet_organization_1 FOREIGN KEY (organization_id)
REFERENCES ll4.organization_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_facet_location_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.facet_1 DROP CONSTRAINT fk_facet_location_1;
ALTER TABLE ll4.facet_1 ADD CONSTRAINT fk_facet_location_1 FOREIGN KEY (location_id)
REFERENCES ll4.location_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_facet_individual_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.facet_1 DROP CONSTRAINT fk_facet_individual_1;
ALTER TABLE ll4.facet_1 ADD CONSTRAINT fk_facet_individual_1 FOREIGN KEY (individual_id)
REFERENCES ll4.individual_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_facet_persona_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.facet_1 DROP CONSTRAINT fk_facet_persona_1;
ALTER TABLE ll4.facet_1 ADD CONSTRAINT fk_facet_persona_1 FOREIGN KEY (persona_id)
REFERENCES ll4.persona_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_facet_facet_type_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.facet_1 DROP CONSTRAINT fk_facet_facet_type_1;
ALTER TABLE ll4.facet_1 ADD CONSTRAINT fk_facet_facet_type_1 FOREIGN KEY (facet_type_id)
REFERENCES ll4.facet_type_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_facet_facet_subtype_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.facet_1 DROP CONSTRAINT fk_facet_facet_subtype_1;
ALTER TABLE ll4.facet_1 ADD CONSTRAINT fk_facet_facet_subtype_1 FOREIGN KEY (facet_subtype_id)
REFERENCES ll4.facet_subtype_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_aop_organization_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.aop_1 DROP CONSTRAINT fk_aop_organization_1;
ALTER TABLE ll4.aop_1 ADD CONSTRAINT fk_aop_organization_1 FOREIGN KEY (organization_id)
REFERENCES ll4.organization_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_aop_location_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.aop_1 DROP CONSTRAINT fk_aop_location_1;
ALTER TABLE ll4.aop_1 ADD CONSTRAINT fk_aop_location_1 FOREIGN KEY (location_id)
REFERENCES ll4.location_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_aop_individual_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.aop_1 DROP CONSTRAINT fk_aop_individual_1;
ALTER TABLE ll4.aop_1 ADD CONSTRAINT fk_aop_individual_1 FOREIGN KEY (individual_id)
REFERENCES ll4.individual_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_aop_persona_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.aop_1 DROP CONSTRAINT fk_aop_persona_1;
ALTER TABLE ll4.aop_1 ADD CONSTRAINT fk_aop_persona_1 FOREIGN KEY (persona_id)
REFERENCES ll4.persona_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_heading_location_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.heading_1 DROP CONSTRAINT fk_heading_location_1;
ALTER TABLE ll4.heading_1 ADD CONSTRAINT fk_heading_location_1 FOREIGN KEY (location_id)
REFERENCES ll4.location_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_persona_heading_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.persona_1 DROP CONSTRAINT fk_persona_heading_1;
ALTER TABLE ll4.persona_1 ADD CONSTRAINT fk_persona_heading_1 FOREIGN KEY (heading_id)
REFERENCES ll4.heading_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_persona_individual_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.persona_1 DROP CONSTRAINT fk_persona_individual_1;
ALTER TABLE ll4.persona_1 ADD CONSTRAINT fk_persona_individual_1 FOREIGN KEY (individual_id)
REFERENCES ll4.individual_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_media_media_type_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.media_1 DROP CONSTRAINT fk_media_media_type_1;
ALTER TABLE ll4.media_1 ADD CONSTRAINT fk_media_media_type_1 FOREIGN KEY (media_type_id)
REFERENCES ll4.media_type_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_media_organization_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.media_1 DROP CONSTRAINT fk_media_organization_1;
ALTER TABLE ll4.media_1 ADD CONSTRAINT fk_media_organization_1 FOREIGN KEY (organization_id)
REFERENCES ll4.organization_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_media_location_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.media_1 DROP CONSTRAINT fk_media_location_1;
ALTER TABLE ll4.media_1 ADD CONSTRAINT fk_media_location_1 FOREIGN KEY (location_id)
REFERENCES ll4.location_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_media_individual_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.media_1 DROP CONSTRAINT fk_media_individual_1;
ALTER TABLE ll4.media_1 ADD CONSTRAINT fk_media_individual_1 FOREIGN KEY (individual_id)
REFERENCES ll4.individual_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_media_persona_1 | type: CONSTRAINT --
-- ALTER TABLE ll4.media_1 DROP CONSTRAINT fk_media_persona_1;
ALTER TABLE ll4.media_1 ADD CONSTRAINT fk_media_persona_1 FOREIGN KEY (persona_id)
REFERENCES ll4.persona_1 (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --


-- object: grant_fa0c51ce9c | type: PERMISSION --
GRANT CONNECT,TEMPORARY
   ON DATABASE mh
   TO PUBLIC;
-- ddl-end --

-- object: grant_49f283da64 | type: PERMISSION --
GRANT CREATE,CONNECT,TEMPORARY
   ON DATABASE mh
   TO mhadmin;
-- ddl-end --

-- object: grant_e07ba55e9e | type: PERMISSION --
GRANT CREATE,USAGE
   ON SCHEMA ll4
   TO mhadmin;
-- ddl-end --


