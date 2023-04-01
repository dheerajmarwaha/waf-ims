--call __drop_function('list_department');
create or replace function list_department
(
	_search_term				text,
	_is_advanced_search			bool,
	_top_n						int,
	_id							int,
	_dept						bpchar,
	_emp_id						int
)
returns table(
	id                                                int,
	dept                                              bpchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	if (_is_advanced_search) then

		return		query
		select		d.id, d.dept
		from		department d
		where		((_id is null) or (d.id  = _id))
		and			((_dept is null) or (d.dept  ilike _dept || '%'))
		and			((_emp_id is null) or (d.emp_id  = _emp_id))
		order by	d.id desc
		limit _top_n;

	else

		--if the search term is numeric then compare that to primary key and return
		if(isNumeric(_search_term)) then

			return	query
			select		d.id, d.dept
			from	department d
			where	d.id = _search_term::int;
			return;

		end if;

		--else return all matching records
		return		query
		select		d.id, d.dept
		from		department d
		order by	d.id desc
		limit _top_n;

	end if;

end;
$f$ language plpgsql security definer;

--HASH:4955165153481314228232182161996143246