drop procedure if exists InsertAuditLog;
create or replace procedure InsertAuditLog
(
	inout _audit_log_id		int,
	_user_no				int,	
	_object_id				text,
	_object_action			char(1),
	_user_role_id			text,
	_application_id			text,
	_screen_id				text,
	_action_id				text
)
as $p$
begin
	insert into audit_logs
	(
		user_no, operation_dtm, object_id, object_action, user_role_id, application_id, screen_id, is_consumed, action_id
	)
	values
	(
		_user_no, current_timestamp, _object_id, _object_action, _user_role_id, _application_id, _screen_id, false, _action_id
	)returning audit_log_id into _audit_log_id;
	
end; $p$ language plpgsql  security definer;

--HASH:19612559225824613711621209125122863206139