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