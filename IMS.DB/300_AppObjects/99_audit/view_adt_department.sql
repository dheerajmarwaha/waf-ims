--drop view audit.view_adt_department cascade;
create or replace view audit.view_adt_department
as
	select
		d.base_table, d.pk_id, d.audit_log_id,
		sam_all_users.user_id as sam_user_id, sam_all_users.user_no as sam_user_no, sam_all_users.user_nm as sam_user_nm,
		pk_id as id,
		(d.snapshot->>'dept')::bpchar as dept,
		(d.snapshot->>'emp_id')::int as emp_id
	from		audit.audit_data d
	join		audit_logs on (audit_logs.audit_log_id = d.audit_log_id)
	left join	sysadmin.all_users sam_all_users on (sam_all_users.user_no = audit_logs.user_no)
	where d.base_table = 'department';


--HASH:1881310511315712186226167620128142150241236