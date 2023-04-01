--drop view audit.view_adt_owner cascade;
create or replace view audit.view_adt_owner
as
	select
		o.base_table, o.pk_id, o.audit_log_id,
		sam_all_users.user_id as sam_user_id, sam_all_users.user_no as sam_user_no, sam_all_users.user_nm as sam_user_nm,
		pk_id as owner_id,
		(o.snapshot->>'owner_nm')::varchar as owner_nm,
		(o.snapshot->>'contact_number')::varchar as contact_number,
		(o.snapshot->>'email_id')::varchar as email_id,
		(o.snapshot->>'address_line')::varchar as address_line,
		(o.snapshot->>'state_id')::int as state_id,
		(o.snapshot->>'pincode')::bpchar as pincode,
		(o.snapshot->>'last_refresh_dtm')::timestamp as last_refresh_dtm
	from		audit.audit_data o
	join		audit_logs on (audit_logs.audit_log_id = o.audit_log_id)
	left join	sysadmin.all_users sam_all_users on (sam_all_users.user_no = audit_logs.user_no)
	where o.base_table = 'owner';


--HASH:1051616212896140802091277921976205856189