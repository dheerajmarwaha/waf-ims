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