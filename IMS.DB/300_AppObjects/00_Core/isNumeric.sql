create or replace function isNumeric(_str text)
returns boolean
as $f$
begin
	return _str ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$';	
end
$f$ language plpgsql   security definer;

--HASH:921882342232171792201911815810578630223239