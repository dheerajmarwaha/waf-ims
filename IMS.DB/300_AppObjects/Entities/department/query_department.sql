--call __drop_function('query_department');
create or replace function query_department
(
	_top_n			int,
	_id				int,
	_dept			bpchar,
	_emp_id			int
)
returns setof view_department
as $f$
begin

	return query
	select		d.*
	from		view_department d
	where		((_id is null) or (d.id  = _id))
	and			((_dept is null) or (d.dept  ilike _dept || '%'))
	and			((_emp_id is null) or (d.emp_id  = _emp_id))
	order by	d.id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:951411132552017337012522712911552169699