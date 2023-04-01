--call __drop_procedure('delete_inventory');
create or replace procedure delete_inventory
(
	_inventory_id				bigint
)
as $p$
begin

	--delete below line if you are sure that this delete functionality is required
	raise exception 'Not sure if delete functionality is confirmed on this object';
	delete	from	inventory
	where
			inventory_id = _inventory_id	;

end;
$p$ language plpgsql security definer;

--HASH:962237931283381186160143166521182002842