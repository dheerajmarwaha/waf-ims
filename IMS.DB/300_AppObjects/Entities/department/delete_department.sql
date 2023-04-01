--call __drop_procedure('delete_department');
create or replace procedure delete_department
(
	_id				int
)
as $p$
begin

	--delete below line if you are sure that this delete functionality is required
	raise exception 'Not sure if delete functionality is confirmed on this object';
	delete	from	department
	where
			id = _id	;

end;
$p$ language plpgsql security definer;

--HASH:11023522721011062102235510322263036209235