--drop view audit.view_adt_inventory cascade;
create or replace view audit.view_adt_inventory
as
	select
		i.base_table, i.pk_id, i.audit_log_id,
		sam_all_users.user_id as sam_user_id, sam_all_users.user_no as sam_user_no, sam_all_users.user_nm as sam_user_nm,
		pk_id as inventory_id,
		(i.snapshot->>'program_id')::int as program_id,
		(i.snapshot->>'owner_id')::int as owner_id,
		(i.snapshot->>'make')::varchar as make,
		(i.snapshot->>'serial_no')::varchar as serial_no,
		(i.snapshot->>'in_date')::timestamp as in_date,
		(i.snapshot->>'out_date')::timestamp as out_date,
		(i.snapshot->>'is_deparment_item')::int as is_deparment_item,
		(i.snapshot->>'total_parts_count')::int as total_parts_count,
		(i.snapshot->>'remarks')::varchar as remarks,
		p.program_nm as program_id_display,
		o.owner_nm as owner_id_display
	from		audit.audit_data i
	join		audit_logs on (audit_logs.audit_log_id = i.audit_log_id)
	left join	sysadmin.all_users sam_all_users on (sam_all_users.user_no = audit_logs.user_no)
	join		program p on((i.snapshot->>'program_id')::int = p.program_id)
	join		owner o on((i.snapshot->>'owner_id')::int = o.owner_id)
	where i.base_table = 'inventory';


--HASH:12422464117163133142342071211351562002303975