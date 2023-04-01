--drop view view_program cascade;
create or replace view view_program
as
	select		p.program_id, p.program_code, p.program_nm, p.from_date, p.till_date, p.is_active, p.is_frozen, p.district_or_city_id, p.location_nm, 
		p.remarks
	from		program p	;

--HASH:831131295512230922501591130218210208183121