--drop view view_department cascade;
create or replace view view_department
as
	select		d.id, d.dept, d.emp_id
	from		department d	;

--HASH:689515207481551971206540821955524716514