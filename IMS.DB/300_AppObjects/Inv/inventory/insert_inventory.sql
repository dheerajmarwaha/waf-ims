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