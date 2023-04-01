create	domain	amt				decimal (20, 2);
create	domain	dcml			decimal (20, 6);

create	domain	ttxt			varchar (10);
create	domain	stxt			varchar (50);
create	domain	mtxt			varchar (200);
create	domain	ltxt			varchar (2000);


CREATE TABLE public.audit_logs (
	audit_log_id serial4 NOT NULL,
	user_no int4 NOT NULL,
	operation_dtm timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	object_id varchar(50) NOT NULL,
	object_action bpchar(1) NOT NULL,
	user_role_id varchar(10) NOT NULL,
	application_id varchar(7) NOT NULL,
	screen_id varchar(6) NOT NULL,
	action_id varchar(20) NULL,
	is_consumed bool NOT NULL DEFAULT false,
	CONSTRAINT auditlogs_ck_objectaction CHECK ((object_action = ANY (ARRAY['I'::bpchar, 'U'::bpchar, 'D'::bpchar, 'P'::bpchar, 'A'::bpchar]))),
	CONSTRAINT auditlogs_pk_auditlogid PRIMARY KEY (audit_log_id)
);

CREATE TABLE public.department (
	id int4 NOT NULL,
	dept bpchar(50) NOT NULL,
	emp_id int4 NOT NULL,
	CONSTRAINT department_pkey PRIMARY KEY (id)
);



CREATE TABLE public."program" (
	program_id int4 NOT NULL,
	program_code varchar(5) NOT NULL,
	program_nm varchar(50) NOT NULL,
	from_date date NOT NULL,
	till_date date NOT NULL,
	is_active int4 NOT NULL DEFAULT 0,
	is_frozen int4 NOT NULL DEFAULT 0,
	district_or_city_id int4 NOT NULL,
	location_nm varchar(100) NULL,
	remarks varchar(500) NULL,
	CONSTRAINT program_program_code_key UNIQUE (program_code),
	CONSTRAINT program_program_nm_key UNIQUE (program_nm),
	CONSTRAINT program_pkey PRIMARY KEY (program_id)
);

CREATE TABLE public."owner" (
	owner_id int4 NOT NULL,
	owner_nm varchar(50) NOT NULL,
	contact_number varchar(11) NULL,
	email_id varchar(100) NULL,
	address_line varchar(500) NULL,
	state_id int4 NULL,
	pincode bpchar(6) NULL,
	last_refresh_dtm timestamp NOT NULL DEFAULT now(),
	CONSTRAINT owner_pkey PRIMARY KEY (owner_id)
);


CREATE TABLE public.inventory (
	inventory_id int8 NOT NULL,
	program_id int4 NOT NULL,
	owner_id int4 NOT NULL,
	make varchar(20) NULL,
	serial_no varchar(50) NULL,
	in_date timestamp NULL,
	out_date timestamp NULL,
	is_deparment_item int4 NOT NULL DEFAULT 0,
	total_parts_count int4 NULL,
	remarks varchar(250) NULL,
	CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id),
	CONSTRAINT inventory_program_id_fkey FOREIGN KEY (program_id) REFERENCES public."program"(program_id),
	CONSTRAINT inventory_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public."owner"(owner_id)
);
