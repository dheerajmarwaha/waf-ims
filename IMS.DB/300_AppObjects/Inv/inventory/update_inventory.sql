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