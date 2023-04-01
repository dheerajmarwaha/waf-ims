--call __drop_function('get_program');
create or replace function get_program
(
	_program_id			int4
)
returns setof view_program
as $f$
begin

	return		query
	select		v.* 
	from		view_program v
	where		program_id = _program_id
	order by	program_id	;

end;
$f$ language plpgsql security definer;

--HASH:242571742372411071784423214212411844155109144