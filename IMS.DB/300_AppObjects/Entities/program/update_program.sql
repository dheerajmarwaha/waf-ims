--call __drop_procedure('update_program');
create or replace procedure update_program
(
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
as $p$
declare v_current_ts timestamp = current_timestamp;
begin

	update	program
	set
		program_code			=	_program_code,
		program_nm				=	_program_nm,
		from_date				=	_from_date,
		till_date				=	_till_date,
		is_active				=	_is_active,
		is_frozen				=	_is_frozen,
		district_or_city_id		=	_district_or_city_id,
		location_nm				=	_location_nm,
		remarks					=	_remarks

	where
		program_id = _program_id	;

end;
$p$ language plpgsql security definer;

--HASH:28132191956419919276521902116415029241