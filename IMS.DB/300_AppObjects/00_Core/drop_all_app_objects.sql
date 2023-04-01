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