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

namespace IMS.Client.Pages.Entities.Owner{
	public partial class OwnerComponent : IMSBaseScreenComponent<OwnerViewModel>	{

		public override int ScreenId => PackageScreens.owner;
		public override string ScreenName => "Owner";

		public override void FocusDefaultElement() 		{
			base.FocusDefaultElement();//Override this if you want to focus on different controls at runtime.
		}


		protected override void OnInitialized()		{
			base.OnInitialized();
			this.UIMode = this.DefaultUIMode == UIModes.None ? UIModes.List : this.DefaultUIMode;
			this.OnModelReset += () => OwnerComponent_OnModelReset();
		}

		protected override async Task OnInitializedAsync()		{
			if (this.DefaultUIMode == UIModes.Reference && !this.PopupModeEntityId.IsNullOrEmpty()) 			{
				await LoadBrowseViewAsync(this.PopupModeEntityId);
			}
		}

		private void OwnerComponent_OnModelReset()		{
		}
		public override bool IsThereUnsavedDataInNewModelState => this.Model.owner_nm.HasValue() || this.Model.contact_number.HasValue() || this.Model.email_id.HasValue() || this.Model.address_line.HasValue() || this.Model.state_id.HasValue || this.Model.pincode.HasValue() || this.Model.last_refresh_dtm.HasValue;

		public override void Validate()		{
			//put your custom validation here as shown in example below
			//This method will get invoked when user clicks on the save button in toolbar (or presses associated shortcut key)

			//if(some logical condition here){
			//this.ValidationService.Invalidate(new WAF.Components.Services.ValidationMessage { Message = "My custom validation message" });
			//}
		}

		public async override Task<OwnerViewModel> GetAsync(string id) 		{
			return await this.Http.WAFGetJsonAsync<OwnerViewModel>("Owner/Get?id=" + id);
		}

		public override string DebugJson => System.Text.Json.JsonSerializer.Serialize(this.Model);

		public void LoadPresavedQuery(string savedQueryJson)		{
			this.ResetQueryModel(JsonSerializer.Deserialize<OwnerViewModel>(savedQueryJson));
		}
		internal Task<ListingResultSet> Listing(string searchString, bool isAdvanceSearch)		{
			var criteria = new OwnerViewModel() { SearchString = searchString };
			criteria.IsAdvancedSearch = isAdvanceSearch;
			if (isAdvanceSearch)			{
				 criteria = this.QueryModel;
			}
			return this.Http.WAFPostJsonAsync<ListingResultSet>("Owner/Listing", criteria);
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
			return await SaveAsync("Owner/Create");
		}

		public async override Task<WAFWebAPIResponseMessage> UpdateAsync()		{
			return await SaveAsync("Owner/Update");
		}
		public override async Task<WAFWebAPIResponseMessage> DeleteAsync()		{
			if (this.Model == null || this.Model.Id == null)			{
				MessageService.Warning("Nothing to delete");
				return null;
			}
			try			{
				var response = await this.Http.WAFPostJsonAsync<WAFWebAPIResponseMessage>($"Owner/Delete", this.Model);
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


//HASH:3561941541116120914245166201161573316825