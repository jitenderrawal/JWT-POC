DROP SCHEMA IF EXISTS lc CASCADE;
DROP ROLE IF EXISTS lc;
CREATE SCHEMA lc;
ALTER SCHEMA lc OWNER to lawyers_com;
GRANT USAGE ON SCHEMA lc to lawyers_com;
create role lc;

SET search_path TO lc, public;

CREATE TABLE lc.branch
(
  branch_id serial NOT NULL,
  branch_name character varying NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT branch_pk PRIMARY KEY (branch_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.branch OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.branch TO lawyers_com;
GRANT ALL ON TABLE lc.branch TO lc;

CREATE TABLE lc.firm_type 
(
  firm_type_id serial NOT NULL,
  firm_type_name character varying NOT NULL,
  firm_type_description character varying,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT firm_type_pk PRIMARY KEY (firm_type_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.firm_type OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.firm_type TO lawyers_com;
GRANT ALL ON TABLE lc.firm_type TO lc;

CREATE TABLE lc.language
(
  language_id serial NOT NULL,
  language character varying NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT language_pk PRIMARY KEY (language_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.language OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.language TO lawyers_com;
GRANT ALL ON TABLE lc.language TO lc;

CREATE TABLE lc.listing_product_type
(
  listing_product_type_id serial NOT NULL,
  listing_product_type_name character varying NOT NULL,
  listing_product_type_description character varying,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT listing_product_type_pk PRIMARY KEY (listing_product_type_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.listing_product_type OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.listing_product_type TO lawyers_com;
GRANT ALL ON TABLE lc.listing_product_type TO lc;

create table lc.membership 
(
	membership_id serial NOT NULL,
	membership_name character varying,
	membership_description character varying,
    date_created timestamp with time zone default now(),
    create_user character varying,
    date_updated timestamp with time zone default now(),
    update_user character varying,
    CONSTRAINT membership_pk PRIMARY KEY (membership_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.membership OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.membership TO lc;
GRANT ALL ON TABLE lc.membership TO lawyers_com;

create table lc.practice_area
(
	practice_area_id serial NOT NULL,
	practice_area_name character varying NOT NULL,
	practice_area_description character varying,
	date_created timestamp with time zone default now(),
    create_user character varying,
    date_updated timestamp with time zone default now(),
    update_user character varying,
    CONSTRAINT practice_area_pk PRIMARY KEY (practice_area_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.practice_area OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.practice_area TO public;
GRANT ALL ON TABLE lc.practice_area TO lawyers_com;


CREATE TABLE lc.firm
(
  firm_id serial NOT NULL,
  branch_id integer NOT NULL,
  org_id integer,
  firm_name character varying,
  firm_type_id integer,
  latitude double precision,
  longitude double precision,
  county character varying,
  street character varying,
  city character varying,
  state character varying,
  postal_code character varying,
  image_url character varying,
  photo_width integer,
  photo_height integer,
  firm_tag_line character varying,
  firm_call_tracking character varying,
  cfn_phone_no character varying,
  call_tracking_indicator character(1),
  custom_url character varying,
  firm_website_url character varying,
  firm_website_flag character(1),
  email_indicator character(1),
  firm_connect character varying,
  firm_has_rating character(1),
  has_client_rating character(1),
  total_client_reviews integer,
  client_review_rating double precision,
  peer_review_rating double precision,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT firm_pk PRIMARY KEY (firm_id, branch_id),
  CONSTRAINT branch_id_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT firm_type_fk FOREIGN KEY (firm_type_id)
      REFERENCES lc.firm_type (firm_type_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.firm OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.firm TO public;
GRANT ALL ON TABLE lc.firm TO lawyers_com;

CREATE OR REPLACE FUNCTION lc.insert_firm_history()
  RETURNS trigger AS
$BODY$
    BEGIN
	insert into lc.firm_history
	(
		firm_id,
		branch_id,
		version_id,
		org_id,
		firm_name,
		firm_type_id,
		latitude,
		longitude,
		county,
		street,
		city,
		state,
		postal_code,
		image_url,
		photo_width,
		photo_height,
		firm_tag_line,
		firm_call_tracking,
		cfn_phone_no,
		call_tracking_indicator,
		custom_url,
		firm_website_url,
		firm_website_flag,
		email_indicator,
		firm_connect,
		firm_has_rating,
		has_client_rating,
		total_client_reviews,
		client_review_rating,
		peer_review_rating,
		date_created,
	    create_user,
    	date_updated,
	    update_user
    )
	values
	(
		NEW.firm_id,
		NEW.branch_id,
		1,
		NEW.org_id,
		NEW.firm_name,
		NEW.firm_type_id,
		NEW.latitude,
		NEW.longitude,
		NEW.county,
		NEW.street,
		NEW.city,
		NEW.state,
		NEW.postal_code,
		NEW.image_url,
		NEW.photo_width,
		NEW.photo_height,
		NEW.firm_tag_line,
		NEW.firm_call_tracking,
		NEW.cfn_phone_no,
		NEW.call_tracking_indicator,
		NEW.custom_url,
		NEW.firm_website_url,
		NEW.firm_website_flag,
		NEW.email_indicator,
		NEW.firm_connect,
		NEW.firm_has_rating,
		NEW.has_client_rating,
		NEW.total_client_reviews,
		NEW.client_review_rating,
		NEW.peer_review_rating,
		NEW.date_created,
		NEW.create_user,
    	NEW.date_updated,
	    NEW.update_user
    );
	RETURN null;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lc.insert_firm_history() OWNER TO lawyers_com;
GRANT ALL ON FUNCTION lc.insert_firm_history() TO lawyers_com;
GRANT ALL ON FUNCTION lc.insert_firm_history() TO lc;

CREATE TRIGGER insert_firm_history_trigger AFTER INSERT
   ON lc.firm FOR EACH ROW
   EXECUTE PROCEDURE lc.insert_firm_history();

  
CREATE OR REPLACE FUNCTION lc.update_firm_history()
  RETURNS trigger AS
$BODY$
    BEGIN
	insert into lc.firm_history
	(
		firm_id,
		branch_id,
		version_id,
		org_id,
		firm_name,
		firm_type_id,
		latitude,
		longitude,
		county,
		street,
		city,
		state,
		postal_code,
		image_url,
		photo_width,
		photo_height,
		firm_tag_line,
		firm_call_tracking,
		cfn_phone_no,
		call_tracking_indicator,
		custom_url,
		firm_website_url,
		firm_website_flag,
		email_indicator,
		firm_connect,
		firm_has_rating,
		has_client_rating,
		total_client_reviews,
		client_review_rating,
		peer_review_rating,
		date_created,
	    create_user,
    	date_updated,
	    update_user	
	)
	select 
		NEW.firm_id,
		NEW.branch_id,
		max(version_id)+1,
		NEW.org_id,
		NEW.firm_name,
		NEW.firm_type_id,
		NEW.latitude,
		NEW.longitude,
		NEW.county,
		NEW.street,
		NEW.city,
		NEW.state,
		NEW.postal_code,
		NEW.image_url,
		NEW.photo_width,
		NEW.photo_height,
		NEW.firm_tag_line,
		NEW.firm_call_tracking,
		NEW.cfn_phone_no,
		NEW.call_tracking_indicator,
		NEW.custom_url,
		NEW.firm_website_url,
		NEW.firm_website_flag,
		NEW.email_indicator,
		NEW.firm_connect,
		NEW.firm_has_rating,
		NEW.has_client_rating,
		NEW.total_client_reviews,
		NEW.client_review_rating,
		NEW.peer_review_rating,
		NEW.date_created,
		NEW.create_user,
    	NEW.date_updated,
	    NEW.update_user	
	from lc.firm_history
	where firm_id = NEW.firm_id
	and   branch_id = NEW.branch_id;
	RETURN null;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lc.update_firm_history() OWNER TO lawyers_com;
GRANT ALL ON FUNCTION lc.update_firm_history() TO lawyers_com;
GRANT ALL ON FUNCTION lc.update_firm_history() TO lc;
CREATE TRIGGER firm_history_update_trigger AFTER UPDATE
   ON lc.firm FOR EACH ROW
   EXECUTE PROCEDURE lc.update_firm_history();


CREATE OR REPLACE FUNCTION lc.delete_firm_history()
  RETURNS trigger AS
$BODY$
    BEGIN
	insert into lc.firm_history
	(
		firm_id,
		branch_id,
		version_id,
		org_id,
		firm_name,
		firm_type_id,
		latitude,
		longitude,
		county,
		street,
		city,
		state,
		postal_code,
		image_url,
		photo_width,
		photo_height,
		firm_tag_line,
		firm_call_tracking,
		cfn_phone_no,
		call_tracking_indicator,
		custom_url,
		firm_website_url,
		firm_website_flag,
		email_indicator,
		firm_connect,
		firm_has_rating,
		has_client_rating,
		total_client_reviews,
		client_review_rating,
		peer_review_rating,
		date_created,
	    create_user,
    	date_updated,
	    update_user	
	)
	select 
		OLD.firm_id,
		OLD.branch_id,
		max(version_id)+1,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		NOW(),
		OLD.create_user,
    	NOW(),
	    OLD.update_user	
	from lc.firm_history
	where firm_id = OLD.firm_id
	and   branch_id = OLD.branch_id;
	RETURN null;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lc.delete_firm_history() OWNER TO lawyers_com;
GRANT ALL ON FUNCTION lc.delete_firm_history() TO lawyers_com;
GRANT ALL ON FUNCTION lc.delete_firm_history() TO lc;
CREATE TRIGGER firm_history_delete_trigger AFTER DELETE
   ON lc.firm FOR EACH ROW
   EXECUTE PROCEDURE lc.delete_firm_history();

CREATE TABLE lc.firm_history
(
  firm_id integer NOT NULL,
  branch_id integer NOT NULL,
  version_id integer NOT NULL,
  org_id integer,
  firm_name character varying,
  firm_type_id integer,
  latitude double precision,
  longitude double precision,
  county character varying,
  street character varying,
  city character varying,
  state character varying,
  postal_code character varying,
  image_url character varying,
  photo_width integer,
  photo_height integer,
  firm_tag_line character varying,
  firm_call_tracking character varying,
  cfn_phone_no character varying,
  call_tracking_indicator character(1),
  custom_url character varying,
  firm_website_url character varying,
  firm_website_flag character(1),
  email_indicator character(1),
  firm_connect character varying,
  firm_has_rating character(1),
  has_client_rating character(1),
  total_client_reviews integer,
  client_review_rating double precision,
  peer_review_rating double precision,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT firm_history_pk PRIMARY KEY (firm_id, branch_id, version_id),
  CONSTRAINT branch_id_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT firm_type_fk FOREIGN KEY (firm_type_id)
      REFERENCES lc.firm_type (firm_type_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.firm_history OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.firm_history TO lawyers_com;
GRANT ALL ON TABLE lc.firm_history TO lc;


CREATE TABLE lc.firm_practice_area
(
  firm_id integer NOT NULL,
  branch_id integer NOT NULL,
  practice_area_id integer NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT firm_practice_area_pk PRIMARY KEY (firm_id, branch_id, practice_area_id),
  CONSTRAINT branch_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT firm_fk FOREIGN KEY (firm_id, branch_id)
      REFERENCES lc.firm (firm_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT practice_area_fk FOREIGN KEY (practice_area_id)
      REFERENCES lc.practice_area (practice_area_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.firm_practice_area OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.firm_practice_area TO lawyers_com;
GRANT ALL ON TABLE lc.firm_practice_area TO lc;

CREATE TABLE lc.firm_practice_area_history
(
  firm_id integer NOT NULL,
  branch_id integer NOT NULL,
  version_id integer NOT NULL,
  practice_area_id integer NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT firm_practice_area_history_pk PRIMARY KEY (firm_id, branch_id, version_id, practice_area_id),
  CONSTRAINT branch_history_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT firm_history_fk FOREIGN KEY (firm_id, branch_id)
      REFERENCES lc.firm (firm_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT practice_area_history_fk FOREIGN KEY (practice_area_id)
      REFERENCES lc.practice_area (practice_area_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.firm_practice_area_history OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.firm_practice_area_history TO lawyers_com;
GRANT ALL ON TABLE lc.firm_practice_area_history TO lc;

CREATE TABLE lc.firm_language
(
  firm_id integer NOT NULL,
  branch_id integer NOT NULL,
  language_id integer NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT firm_language_pk PRIMARY KEY (firm_id, branch_id, language_id),
  CONSTRAINT branch_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT firm_fk FOREIGN KEY (firm_id, branch_id)
      REFERENCES lc.firm (firm_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT language_fk FOREIGN KEY (language_id)
      REFERENCES lc.language (language_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.firm_language OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.firm_language TO lawyers_com;
GRANT ALL ON TABLE lc.firm_language TO lc;

CREATE TABLE lc.firm_language_history
(
  firm_id integer NOT NULL,
  branch_id integer NOT NULL,
  version_id integer NOT NULL,
  language_id integer NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT firm_language_history_pk PRIMARY KEY (firm_id, branch_id, version_id, language_id),
  CONSTRAINT branch_history_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT firm_history_fk FOREIGN KEY (firm_id, branch_id)
      REFERENCES lc.firm (firm_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT language_fk FOREIGN KEY (language_id)
      REFERENCES lc.language (language_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.firm_language_history OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.firm_language_history TO lawyers_com;
GRANT ALL ON TABLE lc.firm_language_history TO lc;

create table lc.listing_product 
(
	listing_product_id serial NOT NULL,
	branch_id integer NOT NULL,
	firm_id integer,
	attorney_id integer,
	listing_product_type_id integer NOT NULL,
	practice_area_id integer NOT NULL,
    date_created timestamp with time zone default now(),
    create_user character varying,
    date_updated timestamp with time zone default now(),
    update_user character varying,
    CONSTRAINT listing_product_pk PRIMARY KEY (listing_product_id, branch_id),
    CONSTRAINT branch_id_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT listing_product_type_fk FOREIGN KEY (listing_product_type_id)
      REFERENCES lc.listing_product_type (listing_product_type_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT practice_area_fk FOREIGN KEY (practice_area_id)
      REFERENCES lc.practice_area (practice_area_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.listing_product OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.listing_product TO lawyers_com;
GRANT ALL ON TABLE lc.listing_product TO lc;

create table lc.listing_product_history
(
	listing_product_id serial NOT NULL,
	firm_id integer NOT NULL,
	branch_id integer NOT NULL,
	version_id integer NOT NULL,
	listing_product_type_id integer NOT NULL,
	practice_area_id integer NOT NULL,
    date_created timestamp with time zone default now(),
    create_user character varying,
    date_updated timestamp with time zone default now(),
    update_user character varying,
    CONSTRAINT listing_product_history_pk PRIMARY KEY (listing_product_id, branch_id),
    CONSTRAINT branch_id_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT firm_id_fk FOREIGN KEY (firm_id, branch_id)
      REFERENCES lc.firm (firm_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT listing_product_type_fk FOREIGN KEY (listing_product_type_id)
      REFERENCES lc.listing_product_type (listing_product_type_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT practice_area_fk FOREIGN KEY (practice_area_id)
      REFERENCES lc.practice_area (practice_area_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.listing_product_history OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.listing_product_history TO lawyers_com;
GRANT ALL ON TABLE lc.listing_product_history TO lc;


CREATE OR REPLACE FUNCTION lc.insert_listing_product_history()
  RETURNS trigger AS
$BODY$
    BEGIN
	insert into lc.listing_product_history
	(listing_product_id, version_id, branch_id, firm_id, 
	   listing_product_type_id, practice_area_id, date_created, 
	   create_user, date_updated, update_user
    )
	values
	(NEW.listing_product_id, 1, NEW.branch_id, NEW.firm_listing_id, 
	   NEW.listing_product_type_id, NEW.practice_area_id, NEW.date_created, 
	   NEW.create_user, NEW.date_updated, NEW.update_user
    );
	RETURN null;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lc.insert_listing_product_history() OWNER TO lawyers_com;
GRANT ALL ON FUNCTION lc.insert_listing_product_history() TO lawyers_com;
GRANT ALL ON FUNCTION lc.insert_listing_product_history() TO lc;
CREATE TRIGGER listing_product_history_insert_trigger AFTER INSERT
   ON lc.listing_product FOR EACH ROW
   EXECUTE PROCEDURE lc.insert_listing_product_history();

  
CREATE OR REPLACE FUNCTION lc.update_listing_product_history()
  RETURNS trigger AS
$BODY$
    BEGIN
	insert into lc.listing_product_history
	(listing_product_id, version_id, branch_id, firm_id, 
	   listing_product_type_id, practice_area_id, date_created, 
	   create_user, date_updated, update_user)
	select NEW.listing_product_id, max(version_id) + 1, NEW.branch_id, NEW.firm_id, 
	   NEW.listing_product_type_id, NEW.practice_area_id, NEW.date_created, 
	   NEW.create_user, NEW.date_updated, NEW.update_user
	from listing_product_history
	where listing_product_id = NEW.external_id
	and   branch_id = NEW.branch_id;
	RETURN null;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lc.update_listing_product_history() OWNER TO lawyers_com;
GRANT ALL ON FUNCTION lc.update_listing_product_history() TO lawyers_com;
GRANT ALL ON FUNCTION lc.update_listing_product_history() TO lc;
CREATE TRIGGER listing_product_history_update_trigger AFTER UPDATE
   ON lc.listing_product FOR EACH ROW
   EXECUTE PROCEDURE lc.update_listing_product_history();


CREATE OR REPLACE FUNCTION lc.delete_listing_product_history()
  RETURNS trigger AS
$BODY$
    BEGIN
	insert into lc.listing_product_history
	(listing_product_id, version_id, branch_id, firm_id, 
	   listing_product_type_id, practice_area_id, date_created, 
	   create_user, date_updated, update_user)
	select OLD.listing_product_id, max(version_id) + 1, OLD.branch_id, OLD.firm_id, 
	   -1, -1, NOW(), 
	   OLD.create_user, NOW(), OLD.update_user
	from listing_product_history
	where listing_product_id = OLD.external_id
	and   branch_id = OLD.branch_id;
	RETURN null;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lc.delete_listing_product_history() OWNER TO lawyers_com;
GRANT ALL ON FUNCTION lc.delete_listing_product_history() TO lawyers_com;
GRANT ALL ON FUNCTION lc.delete_listing_product_history() TO lc;
CREATE TRIGGER listing_product_history_delete_trigger AFTER UPDATE
   ON lc.listing_product FOR EACH ROW
   EXECUTE PROCEDURE lc.delete_listing_product_history();


CREATE TABLE lc.attorney
(
  attorney_id serial NOT NULL,
  branch_id integer NOT NULL,
  isln integer NOT NULL,
  org_id integer,
  first_name character varying,
  last_name character varying,
  display_name character varying,
  position_name character varying,
  affiliated_firm_id integer,
  affiliated_firm_name character varying,
  latitude double precision,
  longitude double precision,
  county character varying,
  street character varying,
  city character varying,
  state character varying,
  postal_code character varying,
  image_url character varying,
  photo_width integer,
  photo_height integer,
  atty_tag_line character varying,
  atty_call_tracking character varying,
  cfn_phone_no character varying,
  call_tracking_indicator character(1),
  custom_url character varying,
  atty_email character varying,
  atty_has_rating character(1),
  has_client_rating character(1),
  total_client_reviews integer,
  client_review_rating double precision,
  peer_review_rating double precision,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT attorney_pk PRIMARY KEY (attorney_id, branch_id),
  CONSTRAINT branch_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT firm_fk FOREIGN KEY (affiliated_firm_id, branch_id)
      REFERENCES lc.firm (firm_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.attorney OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.attorney TO lawyers_com;
GRANT ALL ON TABLE lc.attorney TO lc;

CREATE TABLE lc.attorney_history
(
  attorney_id serial NOT NULL,
  branch_id integer NOT NULL,
  version_id integer NOT NULL,
  isln integer NOT NULL,
  org_id integer,
  first_name character varying,
  last_name character varying,
  display_name character varying,
  position_name character varying,
  affiliated_firm_id integer,
  affiliated_firm_name character varying,
  latitude double precision,
  longitude double precision,
  county character varying,
  street character varying,
  city character varying,
  state character varying,
  postal_code character varying,
  image_url character varying,
  photo_width integer,
  photo_height integer,
  atty_tag_line character varying,
  atty_call_tracking character varying,
  cfn_phone_no character varying,
  call_tracking_indicator character(1),
  custom_url character varying,
  atty_email character varying,
  atty_has_rating character(1),
  has_client_rating character(1),
  total_client_reviews integer,
  client_review_rating double precision,
  peer_review_rating double precision,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT attorney_history_pk PRIMARY KEY (attorney_id, branch_id, version_id),
  CONSTRAINT branch_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.attorney OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.attorney TO lawyers_com;
GRANT ALL ON TABLE lc.attorney TO lc;
    
create table lc.attorney_membership 
(
	attorney_id INTEGER,
	branch_id INTEGER,
	membership_id INTEGER,
    date_created timestamp with time zone default now(),
    create_user character varying,
    date_updated timestamp with time zone default now(),
    update_user character varying,
    CONSTRAINT attorney_membership_pk PRIMARY KEY (attorney_id, branch_id),
    CONSTRAINT branch_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT membership_fk FOREIGN KEY (membership_id)
      REFERENCES lc.membership (membership_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.attorney_membership OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_membership TO lc;
GRANT ALL ON TABLE lc.attorney_membership TO lawyers_com;	


CREATE TABLE lc.attorney_practice_area
(
  attorney_id integer NOT NULL,
  branch_id integer NOT NULL,
  practice_area_id integer NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT attorney_practice_area_pk PRIMARY KEY (attorney_id, branch_id, practice_area_id),
  CONSTRAINT branch_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT attorney_fk FOREIGN KEY (attorney_id, branch_id)
      REFERENCES lc.attorney (attorney_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT practice_area_fk FOREIGN KEY (practice_area_id)
      REFERENCES lc.practice_area (practice_area_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.attorney_practice_area OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_practice_area TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_practice_area TO lc;

CREATE TABLE lc.attorney_practice_area_history
(
  attorney_id integer NOT NULL,
  branch_id integer NOT NULL,
  version_id integer NOT NULL,
  practice_area_id integer NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT attorney_practice_area_history_pk PRIMARY KEY (attorney_id, branch_id, version_id, practice_area_id),
  CONSTRAINT branch_history_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT attorney_history_fk FOREIGN KEY (attorney_id, branch_id)
      REFERENCES lc.attorney (attorney_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT practice_area_history_fk FOREIGN KEY (practice_area_id)
      REFERENCES lc.practice_area (practice_area_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.attorney_practice_area_history OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_practice_area_history TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_practice_area_history TO lc;

CREATE TABLE lc.attorney_language
(
  attorney_id integer NOT NULL,
  branch_id integer NOT NULL,
  language_id integer NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT attorney_language_pk PRIMARY KEY (attorney_id, branch_id, language_id),
  CONSTRAINT branch_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT attorney_fk FOREIGN KEY (attorney_id, branch_id)
      REFERENCES lc.attorney (attorney_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT language_fk FOREIGN KEY (language_id)
      REFERENCES lc.language (language_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.attorney_language OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_language TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_language TO lc;

CREATE TABLE lc.attorney_language_history
(
  attorney_id integer NOT NULL,
  branch_id integer NOT NULL,
  version_id integer NOT NULL,
  language_id integer NOT NULL,
  date_created timestamp with time zone default now(),
  create_user character varying,
  date_updated timestamp with time zone default now(),
  update_user character varying,
  CONSTRAINT attorney_language_history_pk PRIMARY KEY (attorney_id, branch_id, version_id, language_id),
  CONSTRAINT branch_history_fk FOREIGN KEY (branch_id)
      REFERENCES lc.branch (branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT attorney_history_fk FOREIGN KEY (attorney_id, branch_id)
      REFERENCES lc.attorney (attorney_id, branch_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT language_fk FOREIGN KEY (language_id)
      REFERENCES lc.language (language_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE)
WITH (
  OIDS=FALSE
);
ALTER TABLE lc.attorney_language_history OWNER TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_language_history TO lawyers_com;
GRANT ALL ON TABLE lc.attorney_language_history TO lc;