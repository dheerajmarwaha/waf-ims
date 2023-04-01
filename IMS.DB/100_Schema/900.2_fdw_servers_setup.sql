
--install extension
drop extension if exists postgres_fdw cascade;
create extension if not exists postgres_fdw;




drop server if exists mpb_fdw_server cascade;

create server if not exists mpb_fdw_server
foreign data wrapper postgres_fdw
options(host 'localhost', port '5432', dbname 'mpb', use_remote_estimate 'true', fetch_size '10000');


--drop user mapping for appuser server mpb_fdw_server;
--drop user mapping for reader server mpb_fdw_server;
--drop user mapping for sa server mpb_fdw_server;


--map user
create user mapping if not exists for appuser
server mpb_fdw_server
options(user 'reader', password 'reader');

create user mapping if not exists for reader
server mpb_fdw_server
options(user 'reader', password 'reader');

create user mapping if not exists for sa
server mpb_fdw_server
options(user 'appuser', password 'appuser');

