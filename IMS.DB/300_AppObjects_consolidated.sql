do $IMS$ begin 
--call __drop_all_app_objects();
drop procedure if exists __drop_all_app_objects();


create or replace procedure __drop_all_app_objects()
as $p$
	declare _sql					ltxt;
			_exec_sql				text := '';
begin	
	
	drop table if exists _retain_db_object_prefixes;
	create table _retain_db_object_prefixes
	(
		db_object_prefix 	stxt
	);
	
	if exists (select 1 from information_schema.tables where  table_schema = 'public' and  table_name = 'waf_retain_db_object_prefixes') then
		insert into _retain_db_object_prefixes select db_object_prefix from waf_retain_db_object_prefixes;
	end if;
	
	-- drop all views first
	for _sql in 
		select 		'drop view if exists ' || v.table_schema||'.'||v.table_name || ' cascade;'
		from 		information_schema.views v
		left join	_retain_db_object_prefixes t on true
		where 		v.table_catalog = 'ims' 
		and 		(v.table_schema = 'public' or v.table_schema = 'audit')
		and 		v.table_name not like 'x__%'
		and 		(t.db_object_prefix is null or v.table_name not like t.db_object_prefix || '%')
	loop
		_exec_sql := _exec_sql || _sql;
	end loop;
	raise notice 'sql %', _exec_sql;
	execute _exec_sql;

	--unset the variable
	_exec_sql := '';

	--now drop all functions, aggregates and procedures
	for _sql in 
		select		'drop ' || 
					case p.prokind 
						when 'f' then 'function'
						when 'a' then 'aggregate'
						when 'p' then 'procedure'
					end || 
					' if exists ' ||
					p.proname || 
					'(' || oidvectortypes(proargtypes) || ') cascade;'
		from  		pg_proc p
		join 		pg_namespace ns on (p.pronamespace = ns.oid)
		left join	_retain_db_object_prefixes t on true
		where  		ns.nspname = 'public'  
		and 		p.proname != '__drop_all_app_objects'
		and 		p.proname not like 'postgres%'
		and 		p.proname not like 'uuid%'
		and 		(t.db_object_prefix is null or p.proname not like t.db_object_prefix || '%')
		order by 	proname
	loop
		_exec_sql := _exec_sql || _sql;
	end loop;
	execute _exec_sql;

	drop table if exists _retain_db_object_prefixes;
	
end;
$p$ language plpgsql security definer;



 
 call __drop_all_app_objects(); 
 
do $a$ begin raise notice 'Now executing \00_Core\000_assert_correct_context.sql'; end; $a$;
do $a$ 
begin 
	if(lower(current_database())!='ims')then
		raise exception '**** Current database should be ims ****';
		return;
	end if;
	if(lower(current_schema())!='public')then
		raise exception '**** Current schema should be public ****';
		return;
	end if;
end;
$a$;


--HASH:80893897824820858222182156404846245184
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \00_Core\020_setup_fdw.sql'; end; $a$;
do $a$ 
declare 
	_fdw_schema_names_in_mpb text[] := '{"sysadmin","sync","xcs","cdb"}';--add other schemas here in this list for your project specific requirements
	_exec_dsql  text := '';
	_dsql text;
begin 	
	for _dsql in 
		select 		concat('drop schema if exists ', a.a, ' cascade; create schema if not exists ', a.a,';import foreign schema ', a.a,' from server mpb_fdw_server into ', a.a,';')
		from 		unnest(_fdw_schema_names_in_mpb)a
	loop
		_exec_dsql := _exec_dsql || _dsql;
	end loop;
	raise notice 'sql %', _exec_dsql;
	execute _exec_dsql;	
end;
$a$;





--HASH:991592541733940539164216918561166191
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \00_Core\ConsumeAuditLog.sql'; end; $a$;
drop procedure if exists ConsumeAuditLog;
create or replace procedure ConsumeAuditLog
(
	_audit_log_id           int  
	,_auditedObjectId		text  
)
as $p$
begin
	update audit_logs 
	set is_consumed = true 
	,object_id = _auditedObjectId
	where audit_log_id = _audit_log_id;
end; $p$ language plpgsql security definer;

--HASH:1566514111712411124320623022324226172375844
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \00_Core\drop_all_app_objects.sql'; end; $a$;
--call __drop_all_app_objects();
drop procedure if exists __drop_all_app_objects();


create or replace procedure __drop_all_app_objects()
as $p$
	declare _sql					ltxt;
			_exec_sql				text := '';
begin	
	
	drop table if exists _retain_db_object_prefixes;
	create table _retain_db_object_prefixes
	(
		db_object_prefix 	stxt
	);
	
	if exists (select 1 from information_schema.tables where  table_schema = 'public' and  table_name = 'waf_retain_db_object_prefixes') then
		insert into _retain_db_object_prefixes select db_object_prefix from waf_retain_db_object_prefixes;
	end if;
	
	-- drop all views first
	for _sql in 
		select 		'drop view if exists ' || v.table_schema||'.'||v.table_name || ' cascade;'
		from 		information_schema.views v
		left join	_retain_db_object_prefixes t on true
		where 		v.table_catalog = 'ims' 
		and 		(v.table_schema = 'public' or v.table_schema = 'audit')
		and 		v.table_name not like 'x__%'
		and 		(t.db_object_prefix is null or v.table_name not like t.db_object_prefix || '%')
	loop
		_exec_sql := _exec_sql || _sql;
	end loop;
	raise notice 'sql %', _exec_sql;
	execute _exec_sql;

	--unset the variable
	_exec_sql := '';

	--now drop all functions, aggregates and procedures
	for _sql in 
		select		'drop ' || 
					case p.prokind 
						when 'f' then 'function'
						when 'a' then 'aggregate'
						when 'p' then 'procedure'
					end || 
					' if exists ' ||
					p.proname || 
					'(' || oidvectortypes(proargtypes) || ') cascade;'
		from  		pg_proc p
		join 		pg_namespace ns on (p.pronamespace = ns.oid)
		left join	_retain_db_object_prefixes t on true
		where  		ns.nspname = 'public'  
		and 		p.proname != '__drop_all_app_objects'
		and 		p.proname not like 'postgres%'
		and 		p.proname not like 'uuid%'
		and 		(t.db_object_prefix is null or p.proname not like t.db_object_prefix || '%')
		order by 	proname
	loop
		_exec_sql := _exec_sql || _sql;
	end loop;
	execute _exec_sql;

	drop table if exists _retain_db_object_prefixes;
	
end;
$p$ language plpgsql security definer;




--HASH:16666111874112185211441012341711349780201
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \00_Core\drop_procedure_and_drop_function.sql'; end; $a$;
create or replace procedure public.__drop_function(function_name text) 
as $p$
declare
   _sql text;
   obj_count int;
begin
   select count(*)::int
        , 'drop function ' || string_agg(oid::regprocedure::text, '; drop function ')
   from   pg_proc
   where  proname = function_name
   and    pg_function_is_visible(oid)
   into   obj_count, _sql;  -- only returned if trailing drops succeed
   if obj_count > 0 then    -- only if function(s) found
     	execute _sql;
    	raise notice 'Dropped all overloads of function %', function_name;
   else
    	raise notice 'No visible function found with name %', function_name;
   end if;
end;
$p$ language plpgsql ;


---------------------

create or replace procedure public.__drop_procedure(procedure_name text) 
as $p$
declare
   _sql text;
   obj_count int;
begin
   select count(*)::int
        , 'drop procedure ' || string_agg(oid::regprocedure::text, '; drop procedure ')
   from   pg_proc
   where  proname = procedure_name
   and    pg_function_is_visible(oid)
   into   obj_count, _sql;  -- only returned if trailing drops succeed
   if obj_count > 0 then    -- only if function(s) found
     execute _sql;
    raise notice 'Dropped all overloads of procedure %', procedure_name;
   else
    raise notice 'No visible procedure found with name %', procedure_name;
   end if;
end;
$p$ language plpgsql;

--HASH:5751122292191561051102199463141146165189
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \00_Core\InsertAuditLog.sql'; end; $a$;
drop procedure if exists InsertAuditLog;
create or replace procedure InsertAuditLog
(
	inout _audit_log_id		int,
	_user_no				int,	
	_object_id				text,
	_object_action			char(1),
	_user_role_id			text,
	_application_id			text,
	_screen_id				text,
	_action_id				text
)
as $p$
begin
	insert into audit_logs
	(
		user_no, operation_dtm, object_id, object_action, user_role_id, application_id, screen_id, is_consumed, action_id
	)
	values
	(
		_user_no, current_timestamp, _object_id, _object_action, _user_role_id, _application_id, _screen_id, false, _action_id
	)returning audit_log_id into _audit_log_id;
	
end; $p$ language plpgsql  security definer;

--HASH:19612559225824613711621209125122863206139
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \00_Core\isNumeric.sql'; end; $a$;
create or replace function isNumeric(_str text)
returns boolean
as $f$
begin
	return _str ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$';	
end
$f$ language plpgsql   security definer;

--HASH:921882342232171792201911815810578630223239
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \01_Views\01_Generated\Entities\view_department.sql'; end; $a$;
--drop view view_department cascade;
create or replace view view_department
as
	select		d.id, d.dept, d.emp_id
	from		department d	;

--HASH:689515207481551971206540821955524716514
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \01_Views\01_Generated\Entities\view_owner.sql'; end; $a$;
--drop view view_owner cascade;
create or replace view view_owner
as
	select		o.owner_id, o.owner_nm, o.contact_number, o.email_id, o.address_line, o.state_id, o.pincode, o.last_refresh_dtm
	from		owner o	;

--HASH:6817167209206121171239877022924715421910698
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \01_Views\01_Generated\Entities\view_program.sql'; end; $a$;
--drop view view_program cascade;
create or replace view view_program
as
	select		p.program_id, p.program_code, p.program_nm, p.from_date, p.till_date, p.is_active, p.is_frozen, p.district_or_city_id, p.location_nm, 
		p.remarks
	from		program p	;

--HASH:831131295512230922501591130218210208183121
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \01_Views\01_Generated\Inv\view_inventory.sql'; end; $a$;
--drop view view_inventory cascade;
create or replace view view_inventory
as
	select		i.inventory_id, i.program_id, i.owner_id, i.make, i.serial_no, i.in_date, i.out_date, i.is_deparment_item, i.total_parts_count, 
		i.remarks, 
				p.program_nm as program_id_display,
				o.owner_nm as owner_id_display
	from		inventory i
	join		program p on(i.program_id = p.program_id)
	join		owner o on(i.owner_id = o.owner_id)	;

--HASH:14021168472221021071078241647812514425351
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \99_audit\audit_triggers.sql'; end; $a$;
--No audit_log_id column found for table department

--No audit_log_id column found for table owner

--No audit_log_id column found for table program

--No audit_log_id column found for table inventory

--HASH:20997178240235661162721537207212634
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \99_audit\view_adt_department.sql'; end; $a$;
--drop view audit.view_adt_department cascade;
create or replace view audit.view_adt_department
as
	select
		d.base_table, d.pk_id, d.audit_log_id,
		sam_all_users.user_id as sam_user_id, sam_all_users.user_no as sam_user_no, sam_all_users.user_nm as sam_user_nm,
		pk_id as id,
		(d.snapshot->>'dept')::bpchar as dept,
		(d.snapshot->>'emp_id')::int as emp_id
	from		audit.audit_data d
	join		audit_logs on (audit_logs.audit_log_id = d.audit_log_id)
	left join	sysadmin.all_users sam_all_users on (sam_all_users.user_no = audit_logs.user_no)
	where d.base_table = 'department';


--HASH:1881310511315712186226167620128142150241236
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \99_audit\view_adt_inventory.sql'; end; $a$;
--drop view audit.view_adt_inventory cascade;
create or replace view audit.view_adt_inventory
as
	select
		i.base_table, i.pk_id, i.audit_log_id,
		sam_all_users.user_id as sam_user_id, sam_all_users.user_no as sam_user_no, sam_all_users.user_nm as sam_user_nm,
		pk_id as inventory_id,
		(i.snapshot->>'program_id')::int as program_id,
		(i.snapshot->>'owner_id')::int as owner_id,
		(i.snapshot->>'make')::varchar as make,
		(i.snapshot->>'serial_no')::varchar as serial_no,
		(i.snapshot->>'in_date')::timestamp as in_date,
		(i.snapshot->>'out_date')::timestamp as out_date,
		(i.snapshot->>'is_deparment_item')::int as is_deparment_item,
		(i.snapshot->>'total_parts_count')::int as total_parts_count,
		(i.snapshot->>'remarks')::varchar as remarks,
		p.program_nm as program_id_display,
		o.owner_nm as owner_id_display
	from		audit.audit_data i
	join		audit_logs on (audit_logs.audit_log_id = i.audit_log_id)
	left join	sysadmin.all_users sam_all_users on (sam_all_users.user_no = audit_logs.user_no)
	join		program p on((i.snapshot->>'program_id')::int = p.program_id)
	join		owner o on((i.snapshot->>'owner_id')::int = o.owner_id)
	where i.base_table = 'inventory';


--HASH:12422464117163133142342071211351562002303975
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \99_audit\view_adt_owner.sql'; end; $a$;
--drop view audit.view_adt_owner cascade;
create or replace view audit.view_adt_owner
as
	select
		o.base_table, o.pk_id, o.audit_log_id,
		sam_all_users.user_id as sam_user_id, sam_all_users.user_no as sam_user_no, sam_all_users.user_nm as sam_user_nm,
		pk_id as owner_id,
		(o.snapshot->>'owner_nm')::varchar as owner_nm,
		(o.snapshot->>'contact_number')::varchar as contact_number,
		(o.snapshot->>'email_id')::varchar as email_id,
		(o.snapshot->>'address_line')::varchar as address_line,
		(o.snapshot->>'state_id')::int as state_id,
		(o.snapshot->>'pincode')::bpchar as pincode,
		(o.snapshot->>'last_refresh_dtm')::timestamp as last_refresh_dtm
	from		audit.audit_data o
	join		audit_logs on (audit_logs.audit_log_id = o.audit_log_id)
	left join	sysadmin.all_users sam_all_users on (sam_all_users.user_no = audit_logs.user_no)
	where o.base_table = 'owner';


--HASH:1051616212896140802091277921976205856189
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \99_audit\view_adt_program.sql'; end; $a$;
--drop view audit.view_adt_program cascade;
create or replace view audit.view_adt_program
as
	select
		p.base_table, p.pk_id, p.audit_log_id,
		sam_all_users.user_id as sam_user_id, sam_all_users.user_no as sam_user_no, sam_all_users.user_nm as sam_user_nm,
		pk_id as program_id,
		(p.snapshot->>'program_code')::varchar as program_code,
		(p.snapshot->>'program_nm')::varchar as program_nm,
		(p.snapshot->>'from_date')::date as from_date,
		(p.snapshot->>'till_date')::date as till_date,
		(p.snapshot->>'is_active')::int as is_active,
		(p.snapshot->>'is_frozen')::int as is_frozen,
		(p.snapshot->>'district_or_city_id')::int as district_or_city_id,
		(p.snapshot->>'location_nm')::varchar as location_nm,
		(p.snapshot->>'remarks')::varchar as remarks
	from		audit.audit_data p
	join		audit_logs on (audit_logs.audit_log_id = p.audit_log_id)
	left join	sysadmin.all_users sam_all_users on (sam_all_users.user_no = audit_logs.user_no)
	where p.base_table = 'program';


--HASH:156296319910114220314911412183233198117183181
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\department\delete_department.sql'; end; $a$;
--call __drop_procedure('delete_department');
create or replace procedure delete_department
(
	_id				int
)
as $p$
begin

	--delete below line if you are sure that this delete functionality is required
	raise exception 'Not sure if delete functionality is confirmed on this object';
	delete	from	department
	where
			id = _id	;

end;
$p$ language plpgsql security definer;

--HASH:11023522721011062102235510322263036209235
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\department\get_department.sql'; end; $a$;
--call __drop_function('get_department');
create or replace function get_department
(
	_id			int4
)
returns setof view_department
as $f$
begin

	return		query
	select		v.* 
	from		view_department v
	where		id = _id
	order by	id	;

end;
$f$ language plpgsql security definer;

--HASH:641761121431071410652741252176623626168
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\department\insert_department.sql'; end; $a$;
--call __drop_procedure('insert_department');
create or replace procedure insert_department
(
	inout _id		int,
	_dept			bpchar,
	_emp_id			int
)
as $p$
begin

	insert into department
	(
		id, 
		dept, emp_id
	)
	values
	(
		_id, 
		_dept, _emp_id
	);

end;
$p$ language plpgsql security definer;

--HASH:1042384710940672551371325411212219518083205
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\department\list_department.sql'; end; $a$;
--call __drop_function('list_department');
create or replace function list_department
(
	_search_term				text,
	_is_advanced_search			bool,
	_top_n						int,
	_id							int,
	_dept						bpchar,
	_emp_id						int
)
returns table(
	id                                                int,
	dept                                              bpchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	if (_is_advanced_search) then

		return		query
		select		d.id, d.dept
		from		department d
		where		((_id is null) or (d.id  = _id))
		and			((_dept is null) or (d.dept  ilike _dept || '%'))
		and			((_emp_id is null) or (d.emp_id  = _emp_id))
		order by	d.id desc
		limit _top_n;

	else

		--if the search term is numeric then compare that to primary key and return
		if(isNumeric(_search_term)) then

			return	query
			select		d.id, d.dept
			from	department d
			where	d.id = _search_term::int;
			return;

		end if;

		--else return all matching records
		return		query
		select		d.id, d.dept
		from		department d
		order by	d.id desc
		limit _top_n;

	end if;

end;
$f$ language plpgsql security definer;

--HASH:4955165153481314228232182161996143246
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\department\lkp_department.sql'; end; $a$;
--call __drop_function('lkp_department');
create or replace function lkp_department
(
	_search_term			text,
	_top_n					int
)
returns table(
	id                                                int,
	dept                                              bpchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	--if the search term is numeric then compare that to primary key and return
	if(isNumeric(_search_term)) then

		return	query
		select		d.id, d.dept
		from	department d
		where	d.id = _search_term::int;
		return;

	end if;

	--else return all matching records
	return		query
	select		d.id, d.dept
	from		department d
	order by	d.id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:227711024712113820615716312616811620575159
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\department\query_department.sql'; end; $a$;
--call __drop_function('query_department');
create or replace function query_department
(
	_top_n			int,
	_id				int,
	_dept			bpchar,
	_emp_id			int
)
returns setof view_department
as $f$
begin

	return query
	select		d.*
	from		view_department d
	where		((_id is null) or (d.id  = _id))
	and			((_dept is null) or (d.dept  ilike _dept || '%'))
	and			((_emp_id is null) or (d.emp_id  = _emp_id))
	order by	d.id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:951411132552017337012522712911552169699
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\department\update_department.sql'; end; $a$;
--call __drop_procedure('update_department');
create or replace procedure update_department
(
	_id				int,
	_dept			bpchar,
	_emp_id			int
)
as $p$
declare v_current_ts timestamp = current_timestamp;
begin

	update	department
	set
		dept		=	_dept,
		emp_id		=	_emp_id

	where
		id = _id	;

end;
$p$ language plpgsql security definer;

--HASH:6977132145744719924421622131192220147181106
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\owner\delete_owner.sql'; end; $a$;
--call __drop_procedure('delete_owner');
create or replace procedure delete_owner
(
	_owner_id					int
)
as $p$
begin

	--delete below line if you are sure that this delete functionality is required
	raise exception 'Not sure if delete functionality is confirmed on this object';
	delete	from	owner
	where
			owner_id = _owner_id	;

end;
$p$ language plpgsql security definer;

--HASH:76016621211812412463222415119323414081242
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\owner\get_owner.sql'; end; $a$;
--call __drop_function('get_owner');
create or replace function get_owner
(
	_owner_id			int4
)
returns setof view_owner
as $f$
begin

	return		query
	select		v.* 
	from		view_owner v
	where		owner_id = _owner_id
	order by	owner_id	;

end;
$f$ language plpgsql security definer;

--HASH:55208162122702182461836617123053124206243
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\owner\insert_owner.sql'; end; $a$;
--call __drop_procedure('insert_owner');
create or replace procedure insert_owner
(
	inout _owner_id				int,
	_owner_nm					varchar,
	_contact_number				varchar,
	_email_id					varchar,
	_address_line				varchar,
	_state_id					int,
	_pincode					bpchar,
	_last_refresh_dtm			timestamp
)
as $p$
begin

	insert into owner
	(
		owner_id, 
		owner_nm, contact_number, email_id, address_line, state_id, pincode, last_refresh_dtm
	)
	values
	(
		_owner_id, 
		_owner_nm, _contact_number, _email_id, _address_line, _state_id, _pincode, _last_refresh_dtm
	);

end;
$p$ language plpgsql security definer;

--HASH:3418521894571642074313114222653905510027
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\owner\list_owner.sql'; end; $a$;
--call __drop_function('list_owner');
create or replace function list_owner
(
	_search_term				text,
	_is_advanced_search			bool,
	_top_n						int,
	_owner_id					int,
	_owner_nm					varchar,
	_contact_number				varchar,
	_email_id					varchar,
	_address_line				varchar,
	_state_id					int,
	_pincode					bpchar,
	_last_refresh_dtm			timestamp
)
returns table(
	owner_id                                          int,
	owner_nm                                          varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	if (_is_advanced_search) then

		return		query
		select		o.owner_id, o.owner_nm
		from		owner o
		where		((_owner_id is null) or (o.owner_id  = _owner_id))
		and			((_owner_nm is null) or (o.owner_nm  ilike _owner_nm || '%'))
		and			((_contact_number is null) or (o.contact_number  ilike _contact_number || '%'))
		and			((_email_id is null) or (o.email_id  ilike _email_id || '%'))
		and			((_address_line is null) or (o.address_line  ilike _address_line || '%'))
		and			((_state_id is null) or (o.state_id  = _state_id))
		and			((_pincode is null) or (o.pincode  ilike _pincode || '%'))
		and			((_last_refresh_dtm is null) or (o.last_refresh_dtm  = _last_refresh_dtm))
		order by	o.owner_nm
		limit _top_n;

	else

		--if the search term is numeric then compare that to primary key and return
		if(isNumeric(_search_term)) then

			return	query
			select		o.owner_id, o.owner_nm
			from	owner o
			where	o.owner_id = _search_term::int;
			return;

		end if;

		--else return all matching records
		return		query
		select		o.owner_id, o.owner_nm
		from		owner o
		where		(_search_term is null or o.owner_nm like _search_term||'%')
		order by	o.owner_id desc
		limit _top_n;

	end if;

end;
$f$ language plpgsql security definer;

--HASH:68187237163414910714016016611421141934173
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\owner\lkp_owner.sql'; end; $a$;
--call __drop_function('lkp_owner');
create or replace function lkp_owner
(
	_search_term			text,
	_top_n					int
)
returns table(
	owner_id                                          int,
	owner_nm                                          varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	--if the search term is numeric then compare that to primary key and return
	if(isNumeric(_search_term)) then

		return	query
		select		o.owner_id, o.owner_nm
		from	owner o
		where	o.owner_id = _search_term::int;
		return;

	end if;

	--else return all matching records
	return		query
	select		o.owner_id, o.owner_nm
	from		owner o
	where		(_search_term is null or o.owner_nm ilike _search_term||'%')
	order by	o.owner_id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:12132371399116318067251525023611119424428
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\owner\query_owner.sql'; end; $a$;
--call __drop_function('query_owner');
create or replace function query_owner
(
	_top_n						int,
	_owner_id					int,
	_owner_nm					varchar,
	_contact_number				varchar,
	_email_id					varchar,
	_address_line				varchar,
	_state_id					int,
	_pincode					bpchar,
	_last_refresh_dtm			timestamp
)
returns setof view_owner
as $f$
begin

	return query
	select		o.*
	from		view_owner o
	where		((_owner_id is null) or (o.owner_id  = _owner_id))
	and			((_owner_nm is null) or (o.owner_nm  ilike _owner_nm || '%'))
	and			((_contact_number is null) or (o.contact_number  ilike _contact_number || '%'))
	and			((_email_id is null) or (o.email_id  ilike _email_id || '%'))
	and			((_address_line is null) or (o.address_line  ilike _address_line || '%'))
	and			((_state_id is null) or (o.state_id  = _state_id))
	and			((_pincode is null) or (o.pincode  ilike _pincode || '%'))
	and			((_last_refresh_dtm is null) or (o.last_refresh_dtm  = _last_refresh_dtm))
	order by	o.owner_nm
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:1939317017372254219125118112245255243143177
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\owner\update_owner.sql'; end; $a$;
--call __drop_procedure('update_owner');
create or replace procedure update_owner
(
	_owner_id					int,
	_owner_nm					varchar,
	_contact_number				varchar,
	_email_id					varchar,
	_address_line				varchar,
	_state_id					int,
	_pincode					bpchar,
	_last_refresh_dtm			timestamp
)
as $p$
declare v_current_ts timestamp = current_timestamp;
begin

	update	owner
	set
		owner_nm				=	_owner_nm,
		contact_number			=	_contact_number,
		email_id				=	_email_id,
		address_line			=	_address_line,
		state_id				=	_state_id,
		pincode					=	_pincode,
		last_refresh_dtm		=	_last_refresh_dtm

	where
		owner_id = _owner_id	;

end;
$p$ language plpgsql security definer;

--HASH:981222129428154161107752051961323719957
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\program\delete_program.sql'; end; $a$;
--call __drop_procedure('delete_program');
create or replace procedure delete_program
(
	_program_id					int
)
as $p$
begin

	--delete below line if you are sure that this delete functionality is required
	raise exception 'Not sure if delete functionality is confirmed on this object';
	delete	from	program
	where
			program_id = _program_id	;

end;
$p$ language plpgsql security definer;

--HASH:25521220490239225235411461141921722544183125
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\program\get_program.sql'; end; $a$;
--call __drop_function('get_program');
create or replace function get_program
(
	_program_id			int4
)
returns setof view_program
as $f$
begin

	return		query
	select		v.* 
	from		view_program v
	where		program_id = _program_id
	order by	program_id	;

end;
$f$ language plpgsql security definer;

--HASH:242571742372411071784423214212411844155109144
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\program\insert_program.sql'; end; $a$;
--call __drop_procedure('insert_program');
create or replace procedure insert_program
(
	inout _program_id			int,
	_program_code				varchar,
	_program_nm					varchar,
	_from_date					date,
	_till_date					date,
	_is_active					int,
	_is_frozen					int,
	_district_or_city_id		int,
	_location_nm				varchar,
	_remarks					varchar
)
as $p$
begin

	insert into program
	(
		program_id, 
		program_code, program_nm, from_date, till_date, is_active, is_frozen, district_or_city_id, location_nm, remarks
	)
	values
	(
		_program_id, 
		_program_code, _program_nm, _from_date, _till_date, _is_active, _is_frozen, _district_or_city_id, _location_nm, _remarks
	);

end;
$p$ language plpgsql security definer;

--HASH:2478215718922019517211952631019314633198155
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\program\list_program.sql'; end; $a$;
--call __drop_function('list_program');
create or replace function list_program
(
	_search_term				text,
	_is_advanced_search			bool,
	_top_n						int,
	_program_id					int,
	_program_code				varchar,
	_program_nm					varchar,
	_from_date					date,
	_till_date					date,
	_is_active					int,
	_is_frozen					int,
	_district_or_city_id		int,
	_location_nm				varchar,
	_remarks					varchar
)
returns table(
	program_id                                        int,
	program_nm                                        varchar,
	program_code                                      varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	if (_is_advanced_search) then

		return		query
		select		p.program_id, p.program_nm, p.program_code
		from		program p
		where		((_program_id is null) or (p.program_id  = _program_id))
		and			((_program_code is null) or (p.program_code  ilike _program_code || '%'))
		and			((_program_nm is null) or (p.program_nm  ilike _program_nm || '%'))
		and			((_from_date is null) or (p.from_date  = _from_date))
		and			((_till_date is null) or (p.till_date  = _till_date))
		and			((_is_active is null) or (p.is_active  = _is_active))
		and			((_is_frozen is null) or (p.is_frozen  = _is_frozen))
		and			((_district_or_city_id is null) or (p.district_or_city_id  = _district_or_city_id))
		and			((_location_nm is null) or (p.location_nm  ilike _location_nm || '%'))
		and			((_remarks is null) or (p.remarks  ilike _remarks || '%'))
		order by	p.program_nm
		limit _top_n;

	else

		--if the search term is numeric then compare that to primary key and return
		if(isNumeric(_search_term)) then

			return	query
			select		p.program_id, p.program_nm, p.program_code
			from	program p
			where	p.program_id = _search_term::int;
			return;

		end if;

		--else return all matching records
		return		query
		select		p.program_id, p.program_nm, p.program_code
		from		program p
		where		(_search_term is null or p.program_code like _search_term||'%')
		or (_search_term is null or p.program_nm like _search_term||'%')
		order by	p.program_id desc
		limit _top_n;

	end if;

end;
$f$ language plpgsql security definer;

--HASH:882461243110518141612915819014418913086113
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\program\lkp_program.sql'; end; $a$;
--call __drop_function('lkp_program');
create or replace function lkp_program
(
	_search_term			text,
	_top_n					int
)
returns table(
	program_id                                        int,
	program_nm                                        varchar,
	program_code                                      varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	--if the search term is numeric then compare that to primary key and return
	if(isNumeric(_search_term)) then

		return	query
		select		p.program_id, p.program_nm, p.program_code
		from	program p
		where	p.program_id = _search_term::int;
		return;

	end if;

	--else return all matching records
	return		query
	select		p.program_id, p.program_nm, p.program_code
	from		program p
	where		(_search_term is null or p.program_code ilike _search_term||'%')
	or (_search_term is null or p.program_nm ilike _search_term||'%')
	order by	p.program_id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:215446092351869610020826174195233109103166
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\program\query_program.sql'; end; $a$;
--call __drop_function('query_program');
create or replace function query_program
(
	_top_n						int,
	_program_id					int,
	_program_code				varchar,
	_program_nm					varchar,
	_from_date					date,
	_till_date					date,
	_is_active					int,
	_is_frozen					int,
	_district_or_city_id		int,
	_location_nm				varchar,
	_remarks					varchar
)
returns setof view_program
as $f$
begin

	return query
	select		p.*
	from		view_program p
	where		((_program_id is null) or (p.program_id  = _program_id))
	and			((_program_code is null) or (p.program_code  ilike _program_code || '%'))
	and			((_program_nm is null) or (p.program_nm  ilike _program_nm || '%'))
	and			((_from_date is null) or (p.from_date  = _from_date))
	and			((_till_date is null) or (p.till_date  = _till_date))
	and			((_is_active is null) or (p.is_active  = _is_active))
	and			((_is_frozen is null) or (p.is_frozen  = _is_frozen))
	and			((_district_or_city_id is null) or (p.district_or_city_id  = _district_or_city_id))
	and			((_location_nm is null) or (p.location_nm  ilike _location_nm || '%'))
	and			((_remarks is null) or (p.remarks  ilike _remarks || '%'))
	order by	p.program_nm
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:50746039203352416901172351567212211352
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Entities\program\update_program.sql'; end; $a$;
--call __drop_procedure('update_program');
create or replace procedure update_program
(
	_program_id					int,
	_program_code				varchar,
	_program_nm					varchar,
	_from_date					date,
	_till_date					date,
	_is_active					int,
	_is_frozen					int,
	_district_or_city_id		int,
	_location_nm				varchar,
	_remarks					varchar
)
as $p$
declare v_current_ts timestamp = current_timestamp;
begin

	update	program
	set
		program_code			=	_program_code,
		program_nm				=	_program_nm,
		from_date				=	_from_date,
		till_date				=	_till_date,
		is_active				=	_is_active,
		is_frozen				=	_is_frozen,
		district_or_city_id		=	_district_or_city_id,
		location_nm				=	_location_nm,
		remarks					=	_remarks

	where
		program_id = _program_id	;

end;
$p$ language plpgsql security definer;

--HASH:28132191956419919276521902116415029241
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Inv\inventory\delete_inventory.sql'; end; $a$;
--call __drop_procedure('delete_inventory');
create or replace procedure delete_inventory
(
	_inventory_id				bigint
)
as $p$
begin

	--delete below line if you are sure that this delete functionality is required
	raise exception 'Not sure if delete functionality is confirmed on this object';
	delete	from	inventory
	where
			inventory_id = _inventory_id	;

end;
$p$ language plpgsql security definer;

--HASH:962237931283381186160143166521182002842
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Inv\inventory\get_inventory.sql'; end; $a$;
--call __drop_function('get_inventory');
create or replace function get_inventory
(
	_inventory_id			int8
)
returns setof view_inventory
as $f$
begin

	return		query
	select		v.* 
	from		view_inventory v
	where		inventory_id = _inventory_id
	order by	inventory_id	;

end;
$f$ language plpgsql security definer;

--HASH:505418801031384814459416321418324119119
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Inv\inventory\insert_inventory.sql'; end; $a$;
--call __drop_procedure('insert_inventory');
create or replace procedure insert_inventory
(
	inout _inventory_id			bigint,
	_program_id					int,
	_owner_id					int,
	_make						varchar,
	_serial_no					varchar,
	_in_date					timestamp,
	_out_date					timestamp,
	_is_deparment_item			int,
	_total_parts_count			int,
	_remarks					varchar
)
as $p$
begin

	insert into inventory
	(
		inventory_id, 
		program_id, owner_id, make, serial_no, in_date, out_date, is_deparment_item, total_parts_count, remarks
	)
	values
	(
		_inventory_id, 
		_program_id, _owner_id, _make, _serial_no, _in_date, _out_date, _is_deparment_item, _total_parts_count, _remarks
	);

end;
$p$ language plpgsql security definer;

--HASH:247120139175414018203620525029161141205168
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Inv\inventory\list_inventory.sql'; end; $a$;
--call __drop_function('list_inventory');
create or replace function list_inventory
(
	_search_term				text,
	_is_advanced_search			bool,
	_top_n						int,
	_inventory_id				bigint,
	_program_id					int,
	_owner_id					int,
	_make						varchar,
	_serial_no					varchar,
	_in_date					timestamp,
	_out_date					timestamp,
	_is_deparment_item			int,
	_total_parts_count			int,
	_remarks					varchar
)
returns table(
	inventory_id                                      bigint,
	make                                              varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	if (_is_advanced_search) then

		return		query
		select		i.inventory_id, i.make
		from		inventory i
		where		((_inventory_id is null) or (i.inventory_id  = _inventory_id))
		and			((_owner_id is null) or (i.owner_id  = _owner_id))
		and			((_make is null) or (i.make  ilike _make || '%'))
		and			((_serial_no is null) or (i.serial_no  ilike _serial_no || '%'))
		and			((_in_date is null) or (i.in_date  = _in_date))
		and			((_out_date is null) or (i.out_date  = _out_date))
		and			((_is_deparment_item is null) or (i.is_deparment_item  = _is_deparment_item))
		and			((_total_parts_count is null) or (i.total_parts_count  = _total_parts_count))
		and			((_remarks is null) or (i.remarks  ilike _remarks || '%'))
		and			((_program_id is null) or (i.program_id  = _program_id))
		order by	i.inventory_id desc
		limit _top_n;

	else

		--if the search term is numeric then compare that to primary key and return
		if(isNumeric(_search_term)) then

			return	query
			select		i.inventory_id, i.make
			from	inventory i
			where	i.inventory_id = _search_term::bigint;
			return;

		end if;

		--else return all matching records
		return		query
		select		i.inventory_id, i.make
		from		inventory i
		order by	i.inventory_id desc
		limit _top_n;

	end if;

end;
$f$ language plpgsql security definer;

--HASH:1591801718011715025172422434110115145190140
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Inv\inventory\lkp_inventory.sql'; end; $a$;
--call __drop_function('lkp_inventory');
create or replace function lkp_inventory
(
	_search_term			text,
	_top_n					int
)
returns table(
	inventory_id                                      bigint,
	make                                              varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	--if the search term is numeric then compare that to primary key and return
	if(isNumeric(_search_term)) then

		return	query
		select		i.inventory_id, i.make
		from	inventory i
		where	i.inventory_id = _search_term::bigint;
		return;

	end if;

	--else return all matching records
	return		query
	select		i.inventory_id, i.make
	from		inventory i
	order by	i.inventory_id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:648413325248230104305224325113013376661
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Inv\inventory\query_inventory.sql'; end; $a$;
--call __drop_function('query_inventory');
create or replace function query_inventory
(
	_top_n						int,
	_inventory_id				bigint,
	_program_id					int,
	_owner_id					int,
	_make						varchar,
	_serial_no					varchar,
	_in_date					timestamp,
	_out_date					timestamp,
	_is_deparment_item			int,
	_total_parts_count			int,
	_remarks					varchar
)
returns setof view_inventory
as $f$
begin

	return query
	select		i.*
	from		view_inventory i
	where		((_inventory_id is null) or (i.inventory_id  = _inventory_id))
	and			((_owner_id is null) or (i.owner_id  = _owner_id))
	and			((_make is null) or (i.make  ilike _make || '%'))
	and			((_serial_no is null) or (i.serial_no  ilike _serial_no || '%'))
	and			((_in_date is null) or (i.in_date  = _in_date))
	and			((_out_date is null) or (i.out_date  = _out_date))
	and			((_is_deparment_item is null) or (i.is_deparment_item  = _is_deparment_item))
	and			((_total_parts_count is null) or (i.total_parts_count  = _total_parts_count))
	and			((_remarks is null) or (i.remarks  ilike _remarks || '%'))
	and			((_program_id is null) or (i.program_id  = _program_id))
	order by	i.inventory_id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:194571281631352001134679157482411481741219
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \Inv\inventory\update_inventory.sql'; end; $a$;
--call __drop_procedure('update_inventory');
create or replace procedure update_inventory
(
	_inventory_id				bigint,
	_program_id					int,
	_owner_id					int,
	_make						varchar,
	_serial_no					varchar,
	_in_date					timestamp,
	_out_date					timestamp,
	_is_deparment_item			int,
	_total_parts_count			int,
	_remarks					varchar
)
as $p$
declare v_current_ts timestamp = current_timestamp;
begin

	update	inventory
	set
		program_id				=	_program_id,
		owner_id				=	_owner_id,
		make					=	_make,
		serial_no				=	_serial_no,
		in_date					=	_in_date,
		out_date				=	_out_date,
		is_deparment_item		=	_is_deparment_item,
		total_parts_count		=	_total_parts_count,
		remarks					=	_remarks

	where
		inventory_id = _inventory_id	;

end;
$p$ language plpgsql security definer;

--HASH:2442031717274828211917619616791771294260
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

do $a$ begin raise notice 'Now executing \zz_permissions\grant_permissions.sql'; end; $a$;
call __drop_procedure('_grant_usage_on_all_schemas');
create or replace procedure _grant_usage_on_all_schemas(_user_id text)
as $p$
	declare _dsql					ltxt;
			_exec_dsql				text := '';
begin		
	for _dsql in 
		select 		'grant usage on schema '|| v.schema_name ||' to '|| _user_id||';'
		from 		information_schema.schemata v		
	loop
		_exec_dsql := _exec_dsql || _dsql;
	end loop;
	raise notice 'sql %', _exec_dsql;
	execute _exec_dsql;	
end;
$p$ language plpgsql security definer;
--------------------------------------------------------------


call __drop_procedure('_grant_select_on_all_schemas');
create or replace procedure _grant_select_on_all_schemas(_user_id text)
as $p$
	declare _dsql					ltxt;
			_exec_dsql				text := '';
begin		
	for _dsql in 
		select 		'grant select on all tables in schema '|| v.schema_name ||' to '|| _user_id||';'||
                    'grant select on all sequences in schema '|| v.schema_name ||' to '|| _user_id||';'
		from 		information_schema.schemata v		
	loop
		_exec_dsql := _exec_dsql || _dsql;
	end loop;
	raise notice 'sql %', _exec_dsql;
	execute _exec_dsql;	
end;
$p$ language plpgsql security definer;
--------------------------------------------------------------

call __drop_procedure('_grant_exec_on_all_schemas');
create or replace procedure _grant_exec_on_all_schemas(_user_id text)
as $p$
	declare _dsql					ltxt;
			_exec_dsql				text := '';
begin		
	for _dsql in 
		select 		'grant execute on all functions in schema '|| v.schema_name ||' to '|| _user_id||';'||
					'grant execute on all procedures in schema '|| v.schema_name ||' to '|| _user_id||';'
		from 		information_schema.schemata v		
	loop
		_exec_dsql := _exec_dsql || _dsql;
	end loop;
	raise notice 'sql %', _exec_dsql;
	execute _exec_dsql;	
end;
$p$ language plpgsql security definer;

--------------------------------------------------------------

revoke all on schema public from public;
call _grant_usage_on_all_schemas('appuser');
call _grant_usage_on_all_schemas('reader');
call _grant_usage_on_all_schemas('debuguser');

call _grant_select_on_all_schemas('appuser');
call _grant_select_on_all_schemas('reader');
call _grant_select_on_all_schemas('debuguser');

call _grant_exec_on_all_schemas('appuser');
call _grant_exec_on_all_schemas('debuguser');

--HASH:180766521616422195137551821621501351574399
do $a$ begin raise notice 'Done'; end; $a$;
do $a$ begin raise notice '=================================================================='; end; $a$;

end $IMS$;
--HASH:138165312091671412341174159118235961789935