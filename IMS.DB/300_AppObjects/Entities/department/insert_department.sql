--call __drop_procedure('insert_department');
create or replace procedure insert_department
(
	inout _id		int,
	_dept			bpchar,
	_emp_id			int
)
as $p$
begin

	insert into department
	(
		id, 
		dept, emp_id
	)
	values
	(
		_id, 
		_dept, _emp_id
	);

end;
$p$ language plpgsql security definer;

--HASH:1042384710940672551371325411212219518083205