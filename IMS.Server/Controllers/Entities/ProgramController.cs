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
	public class ProgramController: IMSAbstractApiController<ProgramViewModel>	{
		public ProgramController(IConfiguration config, IHttpContextAccessor httpContextAccessor) : base(config, httpContextAccessor)		{
		}

		public override int ScreenId => PackageScreens.program;
		[HttpPost]
		public override List<ProgramViewModel> GetMultiple([FromBody]ProgramViewModel model)		{
			if(model==null)			{
				model = new ProgramViewModel();
			}
			using (var con = NewDbContext())			{
				DataSet dset = con.query_program(MaxRecordCountForListView, model.program_id, model.program_code, model.program_nm, model.from_date, model.till_date, model.is_active, model.is_frozen, model.district_or_city_id, model.location_nm, model.remarks);
				return dset.CreateObjects<ProgramViewModel>();
			}
		}

		[HttpGet]
		public override ProgramViewModel Get(Int32 id)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.get_program(id);
				ProgramViewModel obj =  dset.CreateObject<ProgramViewModel>();
				return obj;			}
		}


		[HttpPost]
		public ActionResult Create([FromBody]ProgramViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Insert, this.ScreenId);
					int? program_id = null;
con.insert_program(ref program_id, model.program_code, model.program_nm, model.from_date, model.till_date, model.is_active, model.is_frozen, model.district_or_city_id, model.location_nm, model.remarks);
					model.program_id = program_id;
					con.CommitTransaction( auditLogId, model.AuditedObjectId);
					return Ok(model.program_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		[HttpPost]
		public ActionResult Update([FromBody]ProgramViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Update, this.ScreenId);
con.update_program(model.program_id, model.program_code, model.program_nm, model.from_date, model.till_date, model.is_active, model.is_frozen, model.district_or_city_id, model.location_nm, model.remarks);
					con.CommitTransaction(auditLogId, model.AuditedObjectId);
					return Ok(model.program_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		[HttpPost]
		public ActionResult Delete([FromBody]ProgramViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Delete, this.ScreenId);
con.delete_program(model.program_id);
					con.CommitTransaction( auditLogId, model.AuditedObjectId);
					return Ok(model.program_id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		public override ListingResultSet Listing([FromBody]ProgramViewModel model)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.list_program(model.SearchString, model.IsAdvancedSearch, this.MaxRecordCountForListView, model.program_id, model.program_code, model.program_nm, model.from_date, model.till_date, model.is_active, model.is_frozen, model.district_or_city_id, model.location_nm, model.remarks);
				return dset.ToListingResult(GetListingColumns(false));
			}
		}

		public override ListingResultSet Lookup([FromBody]ProgramViewModel model)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.lkp_program(model.SearchString, this.MaxRecordCountForLookuptView);
				return dset.ToListingResult(GetListingColumns(true));
			}
		}

		private List<ListingColumn> GetListingColumns(bool isLookupContext)		{
			List<ListingColumn> list = new List<ListingColumn>();
			if(isLookupContext)			{
				list.Add(new ListingColumn { DBColumnName = "program_id", IsId = true, Title = "Program", PercentWidth = 0 });
				list.Add(new ListingColumn { DBColumnName = "program_nm", IsDisplay = true, Title = "Program Name", PercentWidth = 10 });
			}
			else			{
				list.Add(new ListingColumn { DBColumnName = "program_id", IsId = true, Title = "Program", PercentWidth = 10 });
				list.Add(new ListingColumn { DBColumnName = "program_nm", IsDisplay = true, Title = "Program Name", PercentWidth = 10 });
			}

			return list;
		}

	}
}

//HASH:1694925015475182582525223488898168104255