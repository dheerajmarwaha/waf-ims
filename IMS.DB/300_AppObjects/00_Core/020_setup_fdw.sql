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