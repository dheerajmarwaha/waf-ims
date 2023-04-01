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
	public class DepartmentController: IMSAbstractApiController<DepartmentViewModel>	{
		public DepartmentController(IConfiguration config, IHttpContextAccessor httpContextAccessor) : base(config, httpContextAccessor)		{
		}

		public override int ScreenId => PackageScreens.department;
		[HttpPost]
		public override List<DepartmentViewModel> GetMultiple([FromBody]DepartmentViewModel model)		{
			if(model==null)			{
				model = new DepartmentViewModel();
			}
			using (var con = NewDbContext())			{
				DataSet dset = con.query_department(MaxRecordCountForListView, model.id, model.dept, model.emp_id);
				return dset.CreateObjects<DepartmentViewModel>();
			}
		}

		[HttpGet]
		public override DepartmentViewModel Get(Int32 id)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.get_department(id);
				DepartmentViewModel obj =  dset.CreateObject<DepartmentViewModel>();
				return obj;			}
		}


		[HttpPost]
		public ActionResult Create([FromBody]DepartmentViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Insert, this.ScreenId);
					int? id = null;
con.insert_department(ref id, model.dept, model.emp_id);
					model.id = id;
					con.CommitTransaction( auditLogId, model.AuditedObjectId);
					return Ok(model.id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		[HttpPost]
		public ActionResult Update([FromBody]DepartmentViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Update, this.ScreenId);
con.update_department(model.id, model.dept, model.emp_id);
					con.CommitTransaction(auditLogId, model.AuditedObjectId);
					return Ok(model.id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		[HttpPost]
		public ActionResult Delete([FromBody]DepartmentViewModel model)		{
			using (var con = NewDbContext())			{
				try				{
					int auditLogId = con.BeginTransaction(this.UserNo, this.PackageId, this.CurrentUserRole, model.AuditedObjectId, WAF.DB.AuditableActions.Delete, this.ScreenId);
con.delete_department(model.id);
					con.CommitTransaction( auditLogId, model.AuditedObjectId);
					return Ok(model.id);
				}
				catch(Exception ex)				{
					con.RollbackTransaction();
					return Notok(ex);
				}
			}
		}

		public override ListingResultSet Listing([FromBody]DepartmentViewModel model)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.list_department(model.SearchString, model.IsAdvancedSearch, this.MaxRecordCountForListView, model.id, model.dept, model.emp_id);
				return dset.ToListingResult(GetListingColumns(false));
			}
		}

		public override ListingResultSet Lookup([FromBody]DepartmentViewModel model)		{
			using (var con = NewDbContext())			{
				DataSet dset = con.lkp_department(model.SearchString, this.MaxRecordCountForLookuptView);
				return dset.ToListingResult(GetListingColumns(true));
			}
		}

		private List<ListingColumn> GetListingColumns(bool isLookupContext)		{
			List<ListingColumn> list = new List<ListingColumn>();
			if(isLookupContext)			{
				list.Add(new ListingColumn { DBColumnName = "id", IsId = true, Title = "ID", PercentWidth = 0 });
				list.Add(new ListingColumn { DBColumnName = "dept", IsDisplay = true, Title = "Dept", PercentWidth = 10 });
			}
			else			{
				list.Add(new ListingColumn { DBColumnName = "id", IsId = true, Title = "ID", PercentWidth = 10 });
				list.Add(new ListingColumn { DBColumnName = "dept", IsDisplay = true, Title = "Dept", PercentWidth = 10 });
			}

			return list;
		}

	}
}

//HASH:1841461447714010240251138621120317425013719