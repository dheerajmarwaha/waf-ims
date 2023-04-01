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