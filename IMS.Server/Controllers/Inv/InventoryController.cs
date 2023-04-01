using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;
using IMS.Shared.Models;
using IMS.Shared.Models.Inv;
using WAF.Shared.Models;
using WAF.Shared.Extensions;
using System.Data;
using Newtonsoft.Json;
namespace IMS.Server.Controllers.Inv{
	public class InventoryController: IMSAbstractApiController<InventoryViewModel>	{
		public InventoryController(IConfiguration config, IHttpContextAccessor httpContextAccessor) : base(config, httpContextAccessor)		{
		}

		public override int ScreenId => PackageScreens.inventory;
		[HttpPost]
		public override List<InventoryViewModel> GetMultiple([FromBody]InventoryViewModel model)		{
			if(model==null)			{
				model = new InventoryViewModel();
			}
			using (var con = NewDbContext())			{
				DataSet dset = con.query_inventory(MaxRecordCountForListView, model.inventory_id, model.program_id_lookup.AsInt(),model.owner_id_lookup.AsInt(),model.make, model.serial_no, model.in_date, model.out_date, model.is_deparment_item, model.total_parts_count, model.remarks);
				return dset.CreateObjects<InventoryViewModel>();
			}
		}

		[HttpGet]
		public override InventoryViewModel Get(Int64 id)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.get_inventory(id);
				InventoryViewModel obj =  dset.CreateObject<InventoryViewModel>();
				return obj;			}
		}


		[HttpPost]
		public ActionResult Create([FromBody]InventoryViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Insert, this.ScreenId);
					long? inventory_id = null;
con.insert_inventory(ref inventory_id, model.program_id_lookup.AsInt(),model.owner_id_lookup.AsInt(),model.make, model.serial_no, model.in_date, model.out_date, model.is_deparment_item, model.total_parts_count, model.remarks);
					model.inventory_id = inventory_id;
					con.CommitTransaction( auditLogId, model.AuditedObjectId);
					return Ok(model.inventory_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		[HttpPost]
		public ActionResult Update([FromBody]InventoryViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Update, this.ScreenId);
con.update_inventory(model.inventory_id, model.program_id_lookup.AsInt(),model.owner_id_lookup.AsInt(),model.make, model.serial_no, model.in_date, model.out_date, model.is_deparment_item, model.total_parts_count, model.remarks);
					con.CommitTransaction(auditLogId, model.AuditedObjectId);
					return Ok(model.inventory_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		[HttpPost]
		public ActionResult Delete([FromBody]InventoryViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Delete, this.ScreenId);
con.delete_inventory(model.inventory_id);
					con.CommitTransaction( auditLogId, model.AuditedObjectId);
					return Ok(model.inventory_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		public override ListingResultSet Listing([FromBody]InventoryViewModel model)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.list_inventory(model.SearchString, model.IsAdvancedSearch, this.MaxRecordCountForListView, model.inventory_id, model.program_id_lookup.AsInt(),model.owner_id_lookup.AsInt(),model.make, model.serial_no, model.in_date, model.out_date, model.is_deparment_item, model.total_parts_count, model.remarks);
				return dset.ToListingResult(GetListingColumns(false));
			}
		}

		public override ListingResultSet Lookup([FromBody]InventoryViewModel model)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.lkp_inventory(model.SearchString, this.MaxRecordCountForLookuptView);
				return dset.ToListingResult(GetListingColumns(true));
			}
		}

		private List<ListingColumn> GetListingColumns(bool isLookupContext)		{
			List<ListingColumn> list = new List<ListingColumn>();
			if(isLookupContext)			{
				list.Add(new ListingColumn { DBColumnName = "inventory_id", IsId = true, Title = "Inventory", PercentWidth = 0 });
				list.Add(new ListingColumn { DBColumnName = "make", IsDisplay = true, Title = "Make", PercentWidth = 10 });
			}
			else			{
				list.Add(new ListingColumn { DBColumnName = "inventory_id", IsId = true, Title = "Inventory", PercentWidth = 10 });
				list.Add(new ListingColumn { DBColumnName = "make", IsDisplay = true, Title = "Make", PercentWidth = 10 });
			}

			return list;
		}

	}
}

//HASH:8321111511792524916023770192122129176142