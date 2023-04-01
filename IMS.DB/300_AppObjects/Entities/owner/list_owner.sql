--call __drop_function('list_owner');
create or replace function list_owner
(
	_search_term				text,
	_is_advanced_search			bool,
	_top_n						int,
	_owner_id					int,
	_owner_nm					varchar,
	_contact_number				varchar,
	_email_id					varchar,
	_address_line				varchar,
	_state_id					int,
	_pincode					bpchar,
	_last_refresh_dtm			timestamp
)
returns table(
	owner_id                                          int,
	owner_nm                                          varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	if (_is_advanced_search) then

		return		query
		select		o.owner_id, o.owner_nm
		from		owner o
		where		((_owner_id is null) or (o.owner_id  = _owner_id))
		and			((_owner_nm is null) or (o.owner_nm  ilike _owner_nm || '%'))
		and			((_contact_number is null) or (o.contact_number  ilike _contact_number || '%'))
		and			((_email_id is null) or (o.email_id  ilike _email_id || '%'))
		and			((_address_line is null) or (o.address_line  ilike _address_line || '%'))
		and			((_state_id is null) or (o.state_id  = _state_id))
		and			((_pincode is null) or (o.pincode  ilike _pincode || '%'))
		and			((_last_refresh_dtm is null) or (o.last_refresh_dtm  = _last_refresh_dtm))
		order by	o.owner_nm
		limit _top_n;

	else

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
		where		(_search_term is null or o.owner_nm like _search_term||'%')
		order by	o.owner_id desc
		limit _top_n;

	end if;

end;
$f$ language plpgsql security definer;

--HASH:68187237163414910714016016611421141934173