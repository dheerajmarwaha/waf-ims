create schema if not exists audit;


create table audit.audit_data(
	base_table						varchar(200),
	pk_id							bigint,	
	audit_log_id					bigint,
	snapshot						jsonb
);
create index	AuditData_IDX_BaseTable_PKId_AuditLogId
on	audit.audit_data (base_table, pk_id, audit_log_id);


drop function if exists audit.adt_fn_audit_data cascade;

create function audit.adt_fn_audit_data()
	returns	trigger
as	$trg$
declare		
	_dsql		text;
begin
	select format('insert into audit.audit_data(base_table, pk_id, audit_log_id, snapshot)
					select ''%s'', d.%s, d.audit_log_id, to_jsonb(d)
					from deleted d;',
					TG_TABLE_NAME::regclass::text, TG_ARGV[0]::text	
	) into _dsql;
	
	execute _dsql;

	return null;
end
$trg$ language plpgsql	security definer;
