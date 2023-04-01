--call __drop_procedure('update_owner');
create or replace procedure update_owner
(
	_owner_id					int,
	_owner_nm					varchar,
	_contact_number				varchar,
	_email_id					varchar,
	_address_line				varchar,
	_state_id					int,
	_pincode					bpchar,
	_last_refresh_dtm			timestamp
)
as $p$
declare v_current_ts timestamp = current_timestamp;
begin

	update	owner
	set
		owner_nm				=	_owner_nm,
		contact_number			=	_contact_number,
		email_id				=	_email_id,
		address_line			=	_address_line,
		state_id				=	_state_id,
		pincode					=	_pincode,
		last_refresh_dtm		=	_last_refresh_dtm

	where
		owner_id = _owner_id	;

end;
$p$ language plpgsql security definer;

--HASH:981222129428154161107752051961323719957