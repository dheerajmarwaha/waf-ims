begin tran
set nocount on
use SysAdmin
set xact_abort on

declare @package_id varchar(3) ='IMS'

alter table saved_searches drop constraint SavedSearches_FK_PackageId_ScreenId;
declare @storeCurrentUsersForApp table(
    user_id user_id
    , application_id application_id
    , user_role_id user_role_id
)

insert into @storeCurrentUsersForApp
    select user_id, application_id, user_role_id from application_users where application_id in (select application_id from applications where package_id = @package_id)

declare @storeCurrentUserPrivileges table(
	  user_id user_id
	, user_role_id user_role_id
	, application_id application_id
	, effective_from_dt datetime
	, effective_till_dt datetime
    , does_override_two_factor_auth bit
)

insert into @storeCurrentUserPrivileges
	select user_id, user_role_id, application_id, effective_from_dt, effective_till_dt, does_override_two_factor_auth from user_privileges where application_id in (select application_id from applications where package_id = @package_id)

declare @storeObjects_applications_precedences table(
	  object_type			object_type
	, application_id		application_id
	, user_role_id			user_role_id
	, precedence_sq			tinyint
	, does_change_owner		bit
)

insert into @storeObjects_applications_precedences 
	select object_type, application_id, user_role_id, precedence_sq, does_change_owner  from objects_applications_precedences where application_id in (select application_id from applications where package_id = @package_id)


declare @storePermissible_applications table (
	  object_type					object_type
	, application_id				application_id
	, user_role_id					user_role_id
	, permitted_application_id		application_id
	, permitted_user_role_id		user_role_id
	, does_change_owner				bit
)

insert into @storePermissible_applications
	select object_type, application_id, user_role_id, permitted_application_id, permitted_user_role_id, does_change_owner 
	from permissible_applications 
	where ( application_id in (select application_id from applications where package_id = @package_id))
			OR 
		  (permitted_application_id in (select application_id from applications where package_id = @package_id))

declare @storeAdditional_user_roles table (
	base_user_role_id	user_role_id,
	application_id	application_id,
	added_user_role_id user_role_id
)

insert into @storeAdditional_user_roles
	select base_user_role_id, application_id, added_user_role_id 
	from additional_user_roles 
	where  added_user_role_id in (select user_role_id from package_user_roles where package_id=@package_id)

declare @current_requires_two_factor_auth bit 
select @current_requires_two_factor_auth = requires_two_factor_auth from applications where application_id  = 'IMS_APP'


-- Create Dummy Package, app and Role. then put that into current table for users of this app
-----------------------------------------------------------------------------------------------
declare @dummy_package_id varchar(3) = 'xxx'
declare @dummy_app_id varchar(7) = 'xxx_APP'
declare @dummy_user_role_id varchar(7) = 'xxx_ADM'

if not exists (select top 1 1 from packages where package_id = @dummy_package_id)
begin 
	EXEC insPackage @package_id=@dummy_package_id
		,@package_nm=@dummy_package_id
		,@version_no='1.0'
		,@version_dt='12 May 2015'
		,@server_distribution_root='/xxx'
		,@client_default_root=''
        ,@framework='xxx'
    exec insPackageDatabase @dummy_package_id,@dummy_package_id,'.',null,null
end

if not exists (select top 1 1 from applications where application_id = @dummy_app_id)
begin
exec insApplication 
    @application_id=@dummy_app_id
    ,@application_nm=@dummy_package_id
    ,@package_id=@dummy_package_id
    ,@database_nm=@dummy_package_id
    ,@implementation_dt='12 May 2015'
    ,@error_log_level='ERROR'
    ,@log_file_size_in_mb=1
    ,@report_title=null
    ,@report_footer=null
    ,@path_1=null
    ,@path_2=null
    ,@path_3=null
    ,@argument_1=null
    ,@argument_2=null
    ,@argument_3=null
    ,@argument_4=null
    ,@argument_5=null
    ,@requires_two_factor_auth=0
end 
  
if exists (select top 1 1 from package_user_roles where package_id = @dummy_package_id and user_role_id = @dummy_user_role_id)
begin 
   exec DropRole @dummy_package_id, @dummy_user_role_id
end
exec CreateRole
    @p_package_id = @dummy_package_id
    ,@p_user_role_id = @dummy_user_role_id
    ,@p_user_role_nm = 'xxx Admin'
    ,@p_executable_nm = '.'
    ,@p_create_login='No'

update application_users set application_id = @dummy_app_id, user_role_id = @dummy_user_role_id where application_id in (select application_id from applications where package_id = @package_id)

delete user_privileges where application_id in (select application_id from applications where package_id = @package_id)
delete objects_applications_precedences where application_id in (select application_id from applications where package_id = @package_id)
delete permissible_applications where ( application_id in (select application_id from applications where package_id = @package_id))
										OR 
									  (permitted_application_id in (select application_id from applications where package_id = @package_id))


-----------------------------------------------------------------------------------------------
delete from standard_messages where package_id = @package_id

delete x from generic_users x
join generic_user_groups y on(x.generic_user_group_id = y.generic_user_group_id
                          and y.package_id = @package_id)
									   
delete from generic_user_groups where package_id = @package_id

update package_user_roles set default_user_role_menu_id = null  
where default_user_role_menu_id in
(
    select m.user_role_menu_id from user_role_menus m
    join user_role_menu_groups g on (m.user_role_menu_group_id=g.user_role_menu_group_id)
    join package_user_roles pur on (pur.user_role_id=g.user_role_id)
    where pur.package_id=@package_id
)

delete from user_privileges	where user_role_id in (select user_role_id from package_user_roles where package_id = @package_id)
delete from user_role_granted_actions where package_id = @package_id
delete from user_role_privileges where package_id = @package_id

delete from package_screen_actions where package_id = @package_id
delete from package_screens where package_id = @package_id

delete urm from user_role_menus urm 
join user_role_menu_groups urmg on (urmg.user_role_menu_group_id = urm.user_role_menu_group_id)
where urmg.user_role_id in (select user_role_id from package_user_roles where package_id = @package_id)

delete from user_role_menu_groups  where user_role_id in (select user_role_id from package_user_roles where package_id = @package_id) 

delete from additional_user_roles where base_user_role_id in (select user_role_id from package_user_roles where package_id=@package_id)
delete from additional_user_roles where  added_user_role_id in (select user_role_id from package_user_roles where package_id=@package_id)

delete from application_users where application_id in (select application_id from applications where package_id = @package_id)

delete from application_screen_audits where application_id in (select application_id from applications where package_id=@package_id)

declare @version_dt date
declare @implementation_dt date

if exists (select top 1 1 from applications where package_id = @package_id)
	begin
		select @version_dt = version_dt from packages where package_id = @package_id
		select @implementation_dt = implementation_dt from applications where package_id = @package_id
	end
else
	begin
		set @version_dt = getdate()
		set @implementation_dt = getdate()
	end

delete from applications where package_id = @package_id
delete from package_databases where package_id = @package_id
	
declare @existing_server_distribution_root varchar(200)
select @existing_server_distribution_root = server_distribution_root from packages where package_id=@package_id
delete from package_user_roles where package_id = @package_id
delete from packages where package_id = @package_id

EXEC insPackage @package_id='IMS'
    ,@package_nm='IMS'
    ,@version_no='1.0'
    ,@version_dt=@version_dt
    ,@server_distribution_root='/apps/IMS'
    ,@client_default_root=''
    ,@framework='waf'
update packages set  server_distribution_root = coalesce(@existing_server_distribution_root, server_distribution_root) where package_id = @package_id
exec insPackageDatabase 'IMS','ims','.',null,null

exec insApplication 
    @application_id='IMS_APP'
    ,@application_nm='IMS'
    ,@package_id='IMS'
    ,@database_nm='ims'
    ,@implementation_dt=@implementation_dt
    ,@error_log_level='ERROR'
    ,@log_file_size_in_mb=1
    ,@report_title=null
    ,@report_footer=null
    ,@path_1=null
    ,@path_2=null
    ,@path_3=null
    ,@argument_1=null
    ,@argument_2=null
    ,@argument_3=null
    ,@argument_4=null
    ,@argument_5=null
    ,@requires_two_factor_auth=@current_requires_two_factor_auth
    
update applications set display_order = 1, style_nm='green' where application_id='IMS_APP'

if exists (select top 1 1 from package_user_roles where package_id = 'IMS' and user_role_id = 'IMS_Admin')
begin 
   exec DropRole 'IMS', 'IMS_Admin'
end
exec CreateRole
    @p_package_id = 'IMS'
    ,@p_user_role_id = 'IMS_Admin'
    ,@p_user_role_nm = 'Administrator'
    ,@p_executable_nm = '.'
    ,@p_create_login='No'

if exists (select top 1 1 from package_user_roles where package_id = 'IMS' and user_role_id = 'IMS_User')
begin 
   exec DropRole 'IMS', 'IMS_User'
end
exec CreateRole
    @p_package_id = 'IMS'
    ,@p_user_role_id = 'IMS_User'
    ,@p_user_role_nm = 'Front User'
    ,@p_executable_nm = '.'
    ,@p_create_login='No'

if exists (select top 1 1 from package_user_roles where package_id = 'IMS' and user_role_id = 'IMS_Mobile')
begin 
   exec DropRole 'IMS', 'IMS_Mobile'
end
exec CreateRole
    @p_package_id = 'IMS'
    ,@p_user_role_id = 'IMS_Mobile'
    ,@p_user_role_nm = 'Mobile User'
    ,@p_executable_nm = '.'
    ,@p_create_login='No'

exec waf_insert_menu_groups_and_menus '[{"menus":[{"permittedUserRoleIds":["IMS_Admin"],"isDivider":false,"display":"Department","shortcutKey":null,"screenNo":1},{"permittedUserRoleIds":["IMS_Admin"],"isDivider":false,"display":"Owner","shortcutKey":null,"screenNo":4},{"permittedUserRoleIds":["IMS_Admin"],"isDivider":false,"display":"Program","shortcutKey":null,"screenNo":5}],"display":"Entities","shortcutKey":null,"lstMenuGroups":null,"id":"Entities"},{"menus":[{"permittedUserRoleIds":["IMS_Admin"],"isDivider":false,"display":"Inventory","shortcutKey":null,"screenNo":3}],"display":"inv","shortcutKey":null,"lstMenuGroups":null,"id":"inv"}]'
exec insPackageScreen 'IMS', '1', 'Department', 'Yes', 'Yes', 'Yes', 'Yes', 'No ', 'No ', 'No ', 'No '
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_Admin', '1', 'IMS', 'Yes', 'Yes', 'Yes', 'Yes', 'No ')
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_User', '1', 'IMS', 'No ', 'No ', 'No ', 'No ', 'No ')
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_Mobile', '1', 'IMS', 'No ', 'No ', 'No ', 'No ', 'No ')

exec insPackageScreen 'IMS', '4', 'Owner', 'Yes', 'Yes', 'Yes', 'Yes', 'No ', 'No ', 'No ', 'No '
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_Admin', '4', 'IMS', 'Yes', 'Yes', 'Yes', 'Yes', 'No ')
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_User', '4', 'IMS', 'No ', 'No ', 'No ', 'No ', 'No ')
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_Mobile', '4', 'IMS', 'No ', 'No ', 'No ', 'No ', 'No ')

exec insPackageScreen 'IMS', '5', 'Program', 'Yes', 'Yes', 'Yes', 'Yes', 'No ', 'No ', 'No ', 'No '
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_Admin', '5', 'IMS', 'Yes', 'Yes', 'Yes', 'Yes', 'No ')
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_User', '5', 'IMS', 'No ', 'No ', 'No ', 'No ', 'No ')
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_Mobile', '5', 'IMS', 'No ', 'No ', 'No ', 'No ', 'No ')

exec insPackageScreen 'IMS', '3', 'Inventory', 'Yes', 'Yes', 'Yes', 'Yes', 'No ', 'No ', 'No ', 'No '
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_Admin', '3', 'IMS', 'Yes', 'Yes', 'Yes', 'Yes', 'No ')
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_User', '3', 'IMS', 'No ', 'No ', 'No ', 'No ', 'No ')
insert into user_role_privileges (user_role_id, screen_id, package_id, is_select_granted, is_insert_granted, is_update_granted, is_delete_granted, is_print_granted)  values ('IMS_Mobile', '3', 'IMS', 'No ', 'No ', 'No ', 'No ', 'No ')

-------------------------------------------------
------Restore the rights of the users if they were there earlier 

update application_users 
set application_id = temp.application_id, user_role_id = temp.user_role_id
	from application_users au
		join @storeCurrentUsersForApp temp on (temp.user_id = au.user_id)
	where au.application_id = @dummy_app_id


insert into user_privileges 
	select * from @storeCurrentUserPrivileges  where user_role_id in (select user_role_id from package_user_roles where package_id='IMS')

insert into objects_applications_precedences
	select * from @storeObjects_applications_precedences

insert into permissible_applications
	select * from @storePermissible_applications

insert into additional_user_roles (base_user_role_id, application_id, added_user_role_id)
	select * from @storeAdditional_user_roles

-------------------------------------------------

-------------------------------------------------
------Remove the dummy user role, app and package we made
delete from user_privileges	where user_role_id = @dummy_user_role_id
delete from user_privileges	where application_id = @dummy_app_id
delete from application_users where user_role_id = @dummy_user_role_id
delete from package_user_roles where user_role_id = @dummy_user_role_id

delete from applications where application_id = @dummy_app_id
delete from package_databases where package_id = @dummy_package_id
	
delete from packages where package_id = @dummy_package_id
---------------------------------------------

alter table saved_searches add constraint SavedSearches_FK_PackageId_ScreenId foreign key(package_id, screen_id) references package_screens;
commit

--HASH:2315820721210231102116422061421652471944387