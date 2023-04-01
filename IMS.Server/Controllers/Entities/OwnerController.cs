using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;
using IMS.Shared.Models;
using IMS.Shared.Models.Entities;
using WAF.Shared.Models;
using WAF.Shared.Extensions;
using System.Data;
using Newtonsoft.Json;
namespace IMS.Server.Controllers.Entities{
	public class OwnerController: IMSAbstractApiController<OwnerViewModel>	{
		public OwnerController(IConfiguration config, IHttpContextAccessor httpContextAccessor) : base(config, httpContextAccessor)		{
		}

		public override int ScreenId => PackageScreens.owner;
		[HttpPost]
		public override List<OwnerViewModel> GetMultiple([FromBody]OwnerViewModel model)		{
			if(model==null)			{
				model = new OwnerViewModel();
			}
			using (var con = NewDbContext())			{
				DataSet dset = con.query_owner(MaxRecordCountForListView, model.owner_id, model.owner_nm, model.contact_number, model.email_id, model.address_line, model.state_id, model.pincode, model.last_refresh_dtm);
				return dset.CreateObjects<OwnerViewModel>();
			}
		}

		[HttpGet]
		public override OwnerViewModel Get(Int32 id)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.get_owner(id);
				OwnerViewModel obj =  dset.CreateObject<OwnerViewModel>();
				return obj;			}
		}


		[HttpPost]
		public ActionResult Create([FromBody]OwnerViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Insert, this.ScreenId);
					int? owner_id = null;
con.insert_owner(ref owner_id, model.owner_nm, model.contact_number, model.email_id, model.address_line, model.state_id, model.pincode, model.last_refresh_dtm);
					model.owner_id = owner_id;
					con.CommitTransaction( auditLogId, model.AuditedObjectId);
					return Ok(model.owner_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		[HttpPost]
		public ActionResult Update([FromBody]OwnerViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Update, this.ScreenId);
con.update_owner(model.owner_id, model.owner_nm, model.contact_number, model.email_id, model.address_line, model.state_id, model.pincode, model.last_refresh_dtm);
					con.CommitTransaction(auditLogId, model.AuditedObjectId);
					return Ok(model.owner_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		[HttpPost]
		public ActionResult Delete([FromBody]OwnerViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Delete, this.ScreenId);
con.delete_owner(model.owner_id);
					con.CommitTransaction( auditLogId, model.AuditedObjectId);
					return Ok(model.owner_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		public override ListingResultSet Listing([FromBody]OwnerViewModel model)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.list_owner(model.SearchString, model.IsAdvancedSearch, this.MaxRecordCountForListView, model.owner_id, model.owner_nm, model.contact_number, model.email_id, model.address_line, model.state_id, model.pincode, model.last_refresh_dtm);
				return dset.ToListingResult(GetListingColumns(false));
			}
		}

		public override ListingResultSet Lookup([FromBody]OwnerViewModel model)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.lkp_owner(model.SearchString, this.MaxRecordCountForLookuptView);
				return dset.ToListingResult(GetListingColumns(true));
			}
		}

		private List<ListingColumn> GetListingColumns(bool isLookupContext)		{
			List<ListingColumn> list = new List<ListingColumn>();
			if(isLookupContext)			{
				list.Add(new ListingColumn { DBColumnName = "owner_id", IsId = true, Title = "Owner", PercentWidth = 0 });
				list.Add(new ListingColumn { DBColumnName = "owner_nm", IsDisplay = true, Title = "Owner Name", PercentWidth = 10 });
			}
			else			{
				list.Add(new ListingColumn { DBColumnName = "owner_id", IsId = true, Title = "Owner", PercentWidth = 10 });
				list.Add(new ListingColumn { DBColumnName = "owner_nm", IsDisplay = true, Title = "Owner Name", PercentWidth = 10 });
			}

			return list;
		}

	}
}

//HASH:23822317319125488126217222241278697141243161