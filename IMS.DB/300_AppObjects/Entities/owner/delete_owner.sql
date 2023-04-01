--call __drop_procedure('delete_owner');
create or replace procedure delete_owner
(
	_owner_id					int
)
as $p$
begin

	--delete below line if you are sure that this delete functionality is required
	raise exception 'Not sure if delete functionality is confirmed on this object';
	delete	from	owner
	where
			owner_id = _owner_id	;

end;
$p$ language plpgsql security definer;

--HASH:76016621211812412463222415119323414081242