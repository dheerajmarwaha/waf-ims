--drop view audit.view_adt_program cascade;
create or replace view audit.view_adt_program
as
	select
		p.base_table, p.pk_id, p.audit_log_id,
		sam_all_users.user_id as sam_user_id, sam_all_users.user_no as sam_user_no, sam_all_users.user_nm as sam_user_nm,
		pk_id as program_id,
		(p.snapshot->>'program_code')::varchar as program_code,
		(p.snapshot->>'program_nm')::varchar as program_nm,
		(p.snapshot->>'from_date')::date as from_date,
		(p.snapshot->>'till_date')::date as till_date,
		(p.snapshot->>'is_active')::int as is_active,
		(p.snapshot->>'is_frozen')::int as is_frozen,
		(p.snapshot->>'district_or_city_id')::int as district_or_city_id,
		(p.snapshot->>'location_nm')::varchar as location_nm,
		(p.snapshot->>'remarks')::varchar as remarks
	from		audit.audit_data p
	join		audit_logs on (audit_logs.audit_log_id = p.audit_log_id)
	left join	sysadmin.all_users sam_all_users on (sam_all_users.user_no = audit_logs.user_no)
	where p.base_table = 'program';


--HASH:156296319910114220314911412183233198117183181