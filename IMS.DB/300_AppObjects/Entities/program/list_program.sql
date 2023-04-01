--call __drop_function('list_program');
create or replace function list_program
(
	_search_term				text,
	_is_advanced_search			bool,
	_top_n						int,
	_program_id					int,
	_program_code				varchar,
	_program_nm					varchar,
	_from_date					date,
	_till_date					date,
	_is_active					int,
	_is_frozen					int,
	_district_or_city_id		int,
	_location_nm				varchar,
	_remarks					varchar
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

	if (_is_advanced_search) then

		return		query
		select		p.program_id, p.program_nm, p.program_code
		from		program p
		where		((_program_id is null) or (p.program_id  = _program_id))
		and			((_program_code is null) or (p.program_code  ilike _program_code || '%'))
		and			((_program_nm is null) or (p.program_nm  ilike _program_nm || '%'))
		and			((_from_date is null) or (p.from_date  = _from_date))
		and			((_till_date is null) or (p.till_date  = _till_date))
		and			((_is_active is null) or (p.is_active  = _is_active))
		and			((_is_frozen is null) or (p.is_frozen  = _is_frozen))
		and			((_district_or_city_id is null) or (p.district_or_city_id  = _district_or_city_id))
		and			((_location_nm is null) or (p.location_nm  ilike _location_nm || '%'))
		and			((_remarks is null) or (p.remarks  ilike _remarks || '%'))
		order by	p.program_nm
		limit _top_n;

	else

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
		where		(_search_term is null or p.program_code like _search_term||'%')
		or (_search_term is null or p.program_nm like _search_term||'%')
		order by	p.program_id desc
		limit _top_n;

	end if;

end;
$f$ language plpgsql security definer;

--HASH:882461243110518141612915819014418913086113