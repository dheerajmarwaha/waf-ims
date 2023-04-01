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