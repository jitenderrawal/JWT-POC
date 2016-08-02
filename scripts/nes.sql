CREATE TABLE nes4.master_institution_import (
	institution_id integer,
	institution_name varchar(255),
	institution_address varchar(150),
	institution_city varchar(100),
	institution_state char(2),
	institution_zip varchar(15),
	institution_phone varchar(20),
	institution_opeid varchar(20),
	institution_ipeds_unitid int4,
	institution_web_address varchar(255),
	campus_id integer,
	campus_name varchar(255),
	campus_address varchar(150),
	campus_city varchar(100),
	campus_state char(2),
	campus_zip varchar(15),
	campus_ipeds_unitid int4,
	accreditation_type varchar(20),
	agency_name varchar(255),
	agency_status varchar(30),
	program_name varchar(1000),
	accreditation_status varchar(20),
	accreditation_date_type varchar(15),
	periods varchar(30),
	last_action varchar(30)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.source (
	id serial,
	name varchar(255),
	CONSTRAINT source_pk PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.institution (
	id serial,
	source_id integer,
	source_institution_id integer,
	name varchar(255),
	address varchar(150),
	city varchar(100),
	state char(2),
	zip varchar(15),
	phone varchar(20),
	opeid varchar(20),
	ipeds_unitid integer,
	web_address varchar(255),
	create_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	create_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	audit_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	audit_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	CONSTRAINT institution_pk PRIMARY KEY (id),
	CONSTRAINT source_fk FOREIGN KEY (source_id)
		REFERENCES nes4.source (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT source_institution_id_unq UNIQUE (source_id, source_institution_id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.campus (
	id serial,
	institution_id integer,
	source_id integer,
	source_campus_id integer,
	name varchar(255),
	address varchar(150),
	city varchar(100),
	state char(2),
	zip varchar(15),
	ipeds_unitid integer,
	create_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	create_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	audit_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	audit_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	CONSTRAINT campus_pk PRIMARY KEY (id),
	CONSTRAINT source_fk FOREIGN KEY (source_id)
		REFERENCES nes4.source (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT institution_fk FOREIGN KEY (institution_id)
		REFERENCES nes4.institution (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (OIDS=FALSE);
	
CREATE TABLE nes4.program (
	id serial,
	source_id integer,
	campus_id integer,
	program_name varchar(1000),
	accreditation_type varchar(20),
	agency_name varchar(255),
	agency_status varchar(30),
	accreditation_status varchar(20),
	accreditation_date_type varchar(15),
	periods varchar(30),
	last_action varchar(30),
	create_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	create_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	audit_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	audit_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	CONSTRAINT program_pk PRIMARY KEY (id),
	CONSTRAINT source_fk FOREIGN KEY (source_id)
		REFERENCES nes4.source (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT campus_fk FOREIGN KEY (campus_id)
		REFERENCES nes4.campus (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.education_specificity_type (
	id serial,
	name character varying,
	CONSTRAINT education_specificity_type_pk PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.education_match_type (
	id serial,
	name character varying,
	CONSTRAINT education_match_type_pk PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.education_synonym_expression (
	id serial,
	regular_expression_text character varying,
	institution_id integer,
	campus_id integer,
	program_id integer,
	specificity_type_id integer,
	create_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	create_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	audit_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	audit_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	CONSTRAINT education_synonym_expression_pk PRIMARY KEY (id),
	CONSTRAINT program_fk FOREIGN KEY (program_id)
		REFERENCES nes4.program (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT campus_fk FOREIGN KEY (campus_id)
		REFERENCES nes4.campus (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT institution_fk FOREIGN KEY (institution_id)
		REFERENCES nes4.institution (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT specificity_type_fk FOREIGN KEY (specificity_type_id)
		REFERENCES nes4.education_specificity_type (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (OIDS=FALSE);


CREATE TABLE nes4.education_synonym (
	id serial,
	synonym_text character varying,
	institution_id integer,
	campus_id integer,
	program_id integer,
	specificity_type_id integer,
	matching_type_id integer,
	approved boolean,
	create_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	create_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	audit_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	audit_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	CONSTRAINT education_synonym_pk PRIMARY KEY (id),
	CONSTRAINT program_fk FOREIGN KEY (program_id)
		REFERENCES nes4.program (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT campus_fk FOREIGN KEY (campus_id)
		REFERENCES nes4.campus (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT institution_fk FOREIGN KEY (institution_id)
		REFERENCES nes4.institution (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT specificity_type_fk FOREIGN KEY (specificity_type_id)
		REFERENCES nes4.education_specificity_type (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT matching_type_fk FOREIGN KEY (matching_type_id)
		REFERENCES nes4.education_match_type (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.education_type (
	id serial,
	name character varying,
	CONSTRAINT education_type_pk PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.attorney_education (
	id serial,
	alid integer,
	education_type_id integer,
	education_display_name character varying,
	institution_id integer,
	campus_id integer,
	program_id integer,
	specificity_type_id integer,
	attendance_start_year integer,
	attendance_end_year integer,
	is_law_school boolean,
	display_seq_no integer,
	create_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	create_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	audit_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	audit_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	CONSTRAINT attorney_education_pk PRIMARY KEY (id),
	CONSTRAINT education_type_id_fk FOREIGN KEY (education_type_id)
		REFERENCES nes4.education_type (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,	
	CONSTRAINT program_fk FOREIGN KEY (program_id)
		REFERENCES nes4.program (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT campus_fk FOREIGN KEY (campus_id)
		REFERENCES nes4.campus (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT institution_fk FOREIGN KEY (institution_id)
		REFERENCES nes4.institution (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE)
WITH (OIDS=FALSE);

CREATE TABLE nes4.degree_type (
	id serial,
	name character varying,
	common_abbreviation character varying,
	CONSTRAINT degree_type_pk PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.degree_major (
	id serial,
	name character varying,
	CONSTRAINT degree_major_pk PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.degree_minor (
	id serial,
	name character varying,
	CONSTRAINT degree_minor_pk PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.attorney_degree (
	id serial,
	attorney_education_id integer,
	degree_display_name character varying,
	degree_type_id integer,
	degree_year integer,
	major_id1 integer,
	major_id2 integer,
	major_id3 integer,
	major_id4 integer,
	minor_id1 integer,
	minor_id2 integer,
	minor_id3 integer,
	minor_id4 integer,
	create_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	create_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	audit_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	audit_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	CONSTRAINT attorney_degree_pk PRIMARY KEY (id),
	CONSTRAINT attorney_education_fk FOREIGN KEY (attorney_education_id)
		REFERENCES nes4.attorney_education (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT degree_type_fk FOREIGN KEY (degree_type_id)
		REFERENCES nes4.degree_type (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT major_id1_fk FOREIGN KEY (major_id1)
		REFERENCES nes4.degree_major (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT major_id2_fk FOREIGN KEY (major_id2)
		REFERENCES nes4.degree_major (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT major_id3_fk FOREIGN KEY (major_id3)
		REFERENCES nes4.degree_major (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT major_id4_fk FOREIGN KEY (major_id4)
		REFERENCES nes4.degree_major (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT minor_id1_fk FOREIGN KEY (minor_id1)
		REFERENCES nes4.degree_minor (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT minor_id2_fk FOREIGN KEY (minor_id2)
		REFERENCES nes4.degree_minor (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT minor_id3_fk FOREIGN KEY (minor_id3)
		REFERENCES nes4.degree_minor (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT minor_id4_fk FOREIGN KEY (minor_id4)
		REFERENCES nes4.degree_minor (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.honor_type (
	id serial,
	name character varying,
	CONSTRAINT honor_type_pk PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

CREATE TABLE nes4.attorney_education_honors (
	id serial,
	attorney_education_id integer,
	honor_display character varying,
	honor_type_id integer,
	create_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	create_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	audit_user varchar(32) NOT NULL DEFAULT 'MHnes4EDIT'::character varying,
	audit_date date NOT NULL DEFAULT ('NOW'::text)::timestamp without time zone,
	CONSTRAINT attorney_education_honors_pk PRIMARY KEY (id),
	CONSTRAINT honor_type_fk FOREIGN KEY (honor_type_id)
		REFERENCES nes4.honor_type (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT attorney_education_fk FOREIGN KEY (attorney_education_id)
		REFERENCES nes4.attorney_education (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (OIDS=FALSE);

COPY nes4.master_institution_import FROM '/tmp/Accreditation_2014_12.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);

insert into nes4.source (name) values ('U.S. Department of Education Database of Accredited Postsecondary Institutions and Programs');
insert into nes4.education_specificity_type (id, name) values (0, 'None');
insert into nes4.education_specificity_type (name) values ('Institution');
insert into nes4.education_specificity_type (name) values ('Campus');
insert into nes4.education_specificity_type (name) values ('Program');
insert into nes4.education_match_type (name) values ('Algorithm');
insert into nes4.education_match_type (name) values ('Human');
insert into nes4.education_type (name) values ('Undergraduate');
insert into nes4.education_type (name) values ('Graduate');
insert into nes4.education_type (name) values ('Trade');
insert into nes4.education_type (name) values ('Other');
insert into nes4.degree_type (name, common_abbreviation) values ('Associate of Arts', 'A.A.');
insert into nes4.degree_type (name, common_abbreviation) values ('Associate of Science', 'A.S.');
insert into nes4.degree_type (name, common_abbreviation) values ('Bachelor of Arts', 'B.A.');
insert into nes4.degree_type (name, common_abbreviation) values ('Bachelor of Science', 'B.S.');
insert into nes4.degree_type (name, common_abbreviation) values ('Master of Arts', 'M.A.');
insert into nes4.degree_type (name, common_abbreviation) values ('Master of Business Administration', 'M.B.A.');
insert into nes4.degree_type (name, common_abbreviation) values ('Master of Science', 'M.S.');
insert into nes4.degree_type (name, common_abbreviation) values ('Master of Laws', 'LL.M.');
insert into nes4.degree_type (name, common_abbreviation) values ('Doctor of Jurisprudence', 'J.D.');
insert into nes4.degree_type (name, common_abbreviation) values ('Doctor of Philosophy', 'Ph.D.');
insert into nes4.degree_type (name, common_abbreviation) values ('Doctor of Laws', 'LL.D.');
insert into nes4.degree_type (name, common_abbreviation) values ('Doctor of Medicine', 'M.D.');
insert into nes4.honor_type (name) values ('Latin Honor');
insert into nes4.honor_type (name) values ('Honor Society');
insert into nes4.honor_type (name) values ('Title');
insert into nes4.honor_type (name) values ('Award');
insert into nes4.honor_type (name) values ('Scholarship');

insert into nes4.institution
	(source_id, source_institution_id, name, address, city, 
	 state, zip, phone, opeid, ipeds_unitid, web_address)
select distinct 1,
				institution_id,
				institution_name,
				institution_address,
				institution_city,
				institution_state,
				institution_zip,
				institution_phone,
				institution_opeid,
				institution_ipeds_unitid,
				institution_web_address
from nes4.master_institution_import;

insert into nes4.campus
	(source_id, institution_id, source_campus_id, name,
	 address, city, state, zip, ipeds_unitid)
select distinct 1,
				i.id,
				coalesce(campus_id, -1),
				coalesce(campus_name, institution_name),
				coalesce(campus_address, institution_address),
				coalesce(campus_city, institution_city),
				coalesce(campus_state, institution_state),
				coalesce(campus_zip, institution_zip),
				coalesce(campus_ipeds_unitid, institution_ipeds_unitid)
from nes4.master_institution_import mii,
     nes4.institution i
where mii.institution_id = i.source_institution_id;

insert into nes4.program
	(source_id, campus_id, program_name, accreditation_type,
	 agency_name, agency_status, accreditation_status, 
	 accreditation_date_type, periods, last_action)
select distinct 1,
				c.id,
				coalesce(program_name, 'General Education'),
				accreditation_type,
				agency_name, 
				agency_status, 
				accreditation_status, 
				accreditation_date_type, 
				periods, 
				last_action
from nes4.master_institution_import mii,
     nes4.institution i,
	 nes4.campus c
where mii.institution_id = i.source_institution_id
and   ((mii.campus_id is null and c.source_campus_id = -1) or mii.campus_id = c.source_campus_id)
and   c.institution_id = i.id;
