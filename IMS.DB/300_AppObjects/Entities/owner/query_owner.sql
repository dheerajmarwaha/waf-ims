--call __drop_function('query_owner');
create or replace function query_owner
(
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
returns setof view_owner
as $f$
begin

	return query
	select		o.*
	from		view_owner o
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

end;
$f$ language plpgsql security definer;

--HASH:1939317017372254219125118112245255243143177