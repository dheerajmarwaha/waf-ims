drop procedure if exists ConsumeAuditLog;
create or replace procedure ConsumeAuditLog
(
	_audit_log_id           int  
	,_auditedObjectId		text  
)
as $p$
begin
	update audit_logs 
	set is_consumed = true 
	,object_id = _auditedObjectId
	where audit_log_id = _audit_log_id;
end; $p$ language plpgsql security definer;

--HASH:1566514111712411124320623022324226172375844