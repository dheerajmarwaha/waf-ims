--drop view view_inventory cascade;
create or replace view view_inventory
as
	select		i.inventory_id, i.program_id, i.owner_id, i.make, i.serial_no, i.in_date, i.out_date, i.is_deparment_item, i.total_parts_count, 
		i.remarks, 
				p.program_nm as program_id_display,
				o.owner_nm as owner_id_display
	from		inventory i
	join		program p on(i.program_id = p.program_id)
	join		owner o on(i.owner_id = o.owner_id)	;

--HASH:14021168472221021071078241647812514425351