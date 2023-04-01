--call __drop_function('lkp_owner');
create or replace function lkp_owner
(
	_search_term			text,
	_top_n					int
)
returns table(
	owner_id                                          int,
	owner_nm                                          varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	--if the search term is numeric then compare that to primary key and return
	if(isNumeric(_search_term)) then

		return	query
		select		o.owner_id, o.owner_nm
		from	owner o
		where	o.owner_id = _search_term::int;
		return;

	end if;

	--else return all matching records
	return		query
	select		o.owner_id, o.owner_nm
	from		owner o
	where		(_search_term is null or o.owner_nm ilike _search_term||'%')
	order by	o.owner_id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:12132371399116318067251525023611119424428