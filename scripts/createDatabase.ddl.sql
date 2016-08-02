-- object: mhadmin | type: ROLE --
DROP DATABASE IF EXISTS mh;

CREATE ROLE mhadmin WITH 
        INHERIT
        LOGIN
        PASSWORD 'mhadmin';
-- ddl-end --

-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: mh | type: DATABASE --
CREATE DATABASE mh
       ENCODING = 'UTF8'
       LC_COLLATE = 'en_US.UTF8'
       LC_CTYPE = 'en_US.UTF8'
       TABLESPACE = pg_default
       OWNER = mhadmin
       TEMPLATE = template0
;
-- -- ddl-end --
