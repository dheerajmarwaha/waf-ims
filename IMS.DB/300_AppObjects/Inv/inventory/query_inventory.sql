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