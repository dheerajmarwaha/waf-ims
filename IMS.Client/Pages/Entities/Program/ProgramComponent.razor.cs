using System;
using System.Threading.Tasks;
using WAF.Components.Extensions;
using WAF.Components.Screen;
using WAF.Components.Utils;
using WAF.Shared.Models;
using System.Collections.Generic;
using WAF.Shared.Extensions;
using WAF.Components.Services;
using WAF.Components.ListView;
using System.Text.Json;
using WAF.Shared.Extensions;

using IMS.Shared.Models;
using IMS.Shared.Models.Entities;

namespace IMS.Client.Pages.Entities.Program{
	public partial class ProgramComponent : IMSBaseScreenComponent<ProgramViewModel>	{

		public override int ScreenId => PackageScreens.program;
		public override string ScreenName => "Program";

		public override void FocusDefaultElement() 		{
			base.FocusDefaultElement();//Override this if you want to focus on different controls at runtime.
		}


		protected override void OnInitialized()		{
			base.OnInitialized();
			this.UIMode = this.DefaultUIMode == UIModes.None ? UIModes.List : this.DefaultUIMode;
			this.OnModelReset += () => ProgramComponent_OnModelReset();
		}

		protected override async Task OnInitializedAsync()		{
			if (this.DefaultUIMode == UIModes.Reference && !this.PopupModeEntityId.IsNullOrEmpty()) 			{
				await LoadBrowseViewAsync(this.PopupModeEntityId);
			}
		}

		private void ProgramComponent_OnModelReset()		{
		}
		public override bool IsThereUnsavedDataInNewModelState => this.Model.program_code.HasValue() || this.Model.program_nm.HasValue() || this.Model.from_date.HasValue || this.Model.till_date.HasValue || this.Model.is_active.HasValue || this.Model.is_frozen.HasValue || this.Model.district_or_city_id.HasValue || this.Model.location_nm.HasValue() || this.Model.remarks.HasValue();

		public override void Validate()		{
			//put your custom validation here as shown in example below
			//This method will get invoked when user clicks on the save button in toolbar (or presses associated shortcut key)

			//if(some logical condition here){
			//this.ValidationService.Invalidate(new WAF.Components.Services.ValidationMessage { Message = "My custom validation message" });
			//}
		}

		public async override Task<ProgramViewModel> GetAsync(string id) 		{
			return await this.Http.WAFGetJsonAsync<ProgramViewModel>("Program/Get?id=" + id);
		}

		public override string DebugJson => System.Text.Json.JsonSerializer.Serialize(this.Model);

		public void LoadPresavedQuery(string savedQueryJson)		{
			this.ResetQueryModel(JsonSerializer.Deserialize<ProgramViewModel>(savedQueryJson));
		}
		internal Task<ListingResultSet> Listing(string searchString, bool isAdvanceSearch)		{
			var criteria = new ProgramViewModel() { SearchString = searchString };
			criteria.IsAdvancedSearch = isAdvanceSearch;
			if (isAdvanceSearch)			{
				 criteria = this.QueryModel;
			}
			return this.Http.WAFPostJsonAsync<ListingResultSet>("Program/Listing", criteria);
		}
		public async override Task LoadBrowseViewAsync(string id)		{
			var modelFromServer = await this.GetAsync(id);
			this.ResetModel(modelFromServer);
		}

		private async Task<WAFWebAPIResponseMessage> SaveAsync(string webApiRelativeUrl)		{
			try			{
				//Save header & details together by saving header
				WAFWebAPIResponseMessage msg = await this.Http.WAFPostJsonAsync<WAFWebAPIResponseMessage>(webApiRelativeUrl, this.Model);
				await this.ListingComponent.ReloadOrAddCurrentRecordAsync(msg.Id);

				if(this.IsInsertMode)				{
					await this.ExecutePostInsertSaveBehaviorAsync(msg.Id);
				}
				else				{
					await this.LoadBrowseViewAsync(this.Model.Id);
				}
				this.MessageService.Success("Successfully Saved");
				return msg;
			}
			catch(Exception ex)			{
				this.MessageService.Error(ex.Message);
				return null;
			}
		}

		public async override Task<WAFWebAPIResponseMessage> CreateAsync()		{
			return await SaveAsync("Program/Create");
		}

		public async override Task<WAFWebAPIResponseMessage> UpdateAsync()		{
			return await SaveAsync("Program/Update");
		}
		public override async Task<WAFWebAPIResponseMessage> DeleteAsync()		{
			if (this.Model == null || this.Model.Id == null)			{
				MessageService.Warning("Nothing to delete");
				return null;
			}
			try			{
				var response = await this.Http.WAFPostJsonAsync<WAFWebAPIResponseMessage>($"Program/Delete", this.Model);
				this.ListingComponent.RemoveCurrentRecord(this.Model.Id);
				this.SwitchToListMode();
				this.ResetModel(null);
				this.StateHasChanged();
				this.MessageService.Success("Sucessfully Deleted");
				return response;
			}
			catch(Exception ex)			{
				MessageService.Error(ex.Message);
				return null;
			}
		}
	}
}


//HASH:231781402231558151201111522171524915416970