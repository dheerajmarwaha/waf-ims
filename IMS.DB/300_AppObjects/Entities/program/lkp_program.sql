--call __drop_function('lkp_program');
create or replace function lkp_program
(
	_search_term			text,
	_top_n					int
)
returns table(
	program_id                                        int,
	program_nm                                        varchar,
	program_code                                      varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	--if the search term is numeric then compare that to primary key and return
	if(isNumeric(_search_term)) then

		return	query
		select		p.program_id, p.program_nm, p.program_code
		from	program p
		where	p.program_id = _search_term::int;
		return;

	end if;

	--else return all matching records
	return		query
	select		p.program_id, p.program_nm, p.program_code
	from		program p
	where		(_search_term is null or p.program_code ilike _search_term||'%')
	or (_search_term is null or p.program_nm ilike _search_term||'%')
	order by	p.program_id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:215446092351869610020826174195233109103166