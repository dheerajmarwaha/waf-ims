--call __drop_function('lkp_department');
create or replace function lkp_department
(
	_search_term			text,
	_top_n					int
)
returns table(
	id                                                int,
	dept                                              bpchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

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

end;
$f$ language plpgsql security definer;

--HASH:227711024712113820615716312616811620575159