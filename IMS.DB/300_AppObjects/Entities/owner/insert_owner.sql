--call __drop_procedure('insert_owner');
create or replace procedure insert_owner
(
	inout _owner_id				int,
	_owner_nm					varchar,
	_contact_number				varchar,
	_email_id					varchar,
	_address_line				varchar,
	_state_id					int,
	_pincode					bpchar,
	_last_refresh_dtm			timestamp
)
as $p$
begin

	insert into owner
	(
		owner_id, 
		owner_nm, contact_number, email_id, address_line, state_id, pincode, last_refresh_dtm
	)
	values
	(
		_owner_id, 
		_owner_nm, _contact_number, _email_id, _address_line, _state_id, _pincode, _last_refresh_dtm
	);

end;
$p$ language plpgsql security definer;

--HASH:3418521894571642074313114222653905510027