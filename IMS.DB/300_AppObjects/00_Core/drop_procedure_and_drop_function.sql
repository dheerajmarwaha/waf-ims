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