--call __drop_procedure('update_department');
create or replace procedure update_department
(
	_id				int,
	_dept			bpchar,
	_emp_id			int
)
as $p$
declare v_current_ts timestamp = current_timestamp;
begin

	update	department
	set
		dept		=	_dept,
		emp_id		=	_emp_id

	where
		id = _id	;

end;
$p$ language plpgsql security definer;

--HASH:6977132145744719924421622131192220147181106