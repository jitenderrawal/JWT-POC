create table page_compare.test (
	id 		serial not null,
	title 		character varying not null,
	url_pattern	character varying,
	page_tests_json	text,
	created_at timestamp,
	updated_at timestamp,
	CONSTRAINT test_id_pkey PRIMARY KEY (id)
);

create table page_compare.test_url (
	id		serial not null,
	test_id		int not null,
	url		character varying,
	created_at timestamp,
	updated_at timestamp,
	constraint test_url_pkey primary key(id),
	CONSTRAINT fk_test_url_test FOREIGN KEY (test_id)
        REFERENCES page_compare.test (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE
);

create table page_compare.test_run (
	id 		serial not null,
	test_id 		int not null,
	created_at timestamp,
	updated_at timestamp,
	CONSTRAINT test__run_pkey PRIMARY KEY (id)
);


create table page_compare.test_run_url_test (
	id		serial not null,
	run_id		int not null,
	test_id		int not null,
	url_id		int not null,
	successful_tests int not null,
	failed_tests int not null,
	created_at timestamp,
	updated_at timestamp,
	constraint test_run_url_test_pkey primary key(id),
	CONSTRAINT fk_test_run_url_test FOREIGN KEY (test_id)
        REFERENCES page_compare.test (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT fk_test_run_url_test_url FOREIGN KEY (url_id)
        REFERENCES page_compare.test_url (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT fk_test_run_url_test_run FOREIGN KEY (run_id)
        REFERENCES page_compare.test_run (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE INDEX test_url_test_run_id_idx
   ON page_compare.test_run_url_test (run_id ASC NULLS LAST);

create table page_compare.test_run_url_test_failure (
	id		serial not null,
	run_id		int not null,
	test_id		int not null,
	url_id		int not null,
	test_run_url_id		int not null,
	test_name		character varying,
	expected_value	text,
	actual_value	text,
	created_at timestamp,
	updated_at timestamp,
	constraint test_run_url_failure_pkey primary key(id),
	CONSTRAINT fk_page_test_failure_page FOREIGN KEY (test_id)
        REFERENCES page_compare.test (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE,
        CONSTRAINT fk_page_test_failure_page_url FOREIGN KEY (url_id)
        REFERENCES page_compare.test_url (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE,
        CONSTRAINT fk_page_test_failure_page_test FOREIGN KEY (test_id)
        REFERENCES page_compare.test (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE INDEX test_run_url_failure_run_url_id_idx
   ON page_compare.test_run_url_test_failure (run_id ASC NULLS LAST, url_id desc nulls last);

CREATE INDEX test_run_url_failure_test_name_idx
   ON page_compare.test_run_url_test_failure (test_name asc nulls last);


