do $a$ 
begin 
	if(lower(current_database())!='ims')then
		raise exception '**** Current database should be ims ****';
		return;
	end if;
	if(lower(current_schema())!='public')then
		raise exception '**** Current schema should be public ****';
		return;
	end if;
end;
$a$;


--HASH:80893897824820858222182156404846245184