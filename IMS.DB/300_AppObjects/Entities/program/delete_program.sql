--call __drop_procedure('delete_program');
create or replace procedure delete_program
(
	_program_id					int
)
as $p$
begin

	--delete below line if you are sure that this delete functionality is required
	raise exception 'Not sure if delete functionality is confirmed on this object';
	delete	from	program
	where
			program_id = _program_id	;

end;
$p$ language plpgsql security definer;

--HASH:25521220490239225235411461141921722544183125