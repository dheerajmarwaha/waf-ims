--call __drop_procedure('insert_program');
create or replace procedure insert_program
(
	inout _program_id			int,
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
begin

	insert into program
	(
		program_id, 
		program_code, program_nm, from_date, till_date, is_active, is_frozen, district_or_city_id, location_nm, remarks
	)
	values
	(
		_program_id, 
		_program_code, _program_nm, _from_date, _till_date, _is_active, _is_frozen, _district_or_city_id, _location_nm, _remarks
	);

end;
$p$ language plpgsql security definer;

--HASH:2478215718922019517211952631019314633198155