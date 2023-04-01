--call __drop_function('lkp_inventory');
create or replace function lkp_inventory
(
	_search_term			text,
	_top_n					int
)
returns table(
	inventory_id                                      bigint,
	make                                              varchar
)
as $f$
begin

	--trim the search term
	_search_term := ltrim(rtrim(_search_term));

	--if the search term is numeric then compare that to primary key and return
	if(isNumeric(_search_term)) then

		return	query
		select		i.inventory_id, i.make
		from	inventory i
		where	i.inventory_id = _search_term::bigint;
		return;

	end if;

	--else return all matching records
	return		query
	select		i.inventory_id, i.make
	from		inventory i
	order by	i.inventory_id desc
	limit _top_n;

end;
$f$ language plpgsql security definer;

--HASH:648413325248230104305224325113013376661