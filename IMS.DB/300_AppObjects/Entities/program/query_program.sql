--call __drop_function('query_program');
create or replace function query_program
(
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
returns setof view_program
as $f$
begin

	return query
	select		p.*
	from		view_program p
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

end;
$f$ language plpgsql security definer;

--HASH:50746039203352416901172351567212211352