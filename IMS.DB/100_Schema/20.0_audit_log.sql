CREATE	TABLE	audit_logs
(
	audit_log_id 		SERIAL			NOT NULL	CONSTRAINT	AuditLogs_PK_AuditLogID
														PRIMARY KEY,
	user_no 			INTEGER			NOT NULL,
	operation_dtm 		TIMESTAMP		NOT NULL	CONSTRAINT	AuditLogs_DF_OperationDTM
														DEFAULT CURRENT_TIMESTAMP,
	object_id 			VARCHAR (50) 	NOT	NULL,
	object_action 		CHAR (1) 		NOT NULL	CONSTRAINT	AuditLogs_CK_ObjectAction
														CHECK	(	object_action IN
																		(	'I',	--- Insert
																			'U',	--- Update
																			'D',	--- Delete
																			'P',	--- Print
																			'A'		--- Action
																		)
																),
	user_role_id		VARCHAR (10)	NOT NULL,
	application_id		VARCHAR (7)		NOT NULL,
	screen_id			VARCHAR (6)		NOT NULL,
	action_id			VARCHAR (20)		NULL,
	is_consumed			BOOLEAN			NOT NULL	CONSTRAINT	AuditLogs_DF_IsConsumed
														DEFAULT FALSE
);
