--drop view view_owner cascade;
create or replace view view_owner
as
	select		o.owner_id, o.owner_nm, o.contact_number, o.email_id, o.address_line, o.state_id, o.pincode, o.last_refresh_dtm
	from		owner o	;

--HASH:6817167209206121171239877022924715421910698