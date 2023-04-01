using Microsoft.AspNetCore.Components;
using WAF.Components;
using WAF.Components.Services;
using WAF.Shared.Models;
using WAF.Components.Utils;
namespace IMS.Client.Pages{
	public abstract class IMSBaseScreenComponent<T> : BaseScreenComponent<T>, IScreen where T : BaseEntity	{
		[Inject] public AuthService AuthService { get; set; }
		public override bool IsSuperuser => this.AuthService?.User?.UserId == "IMS_ADM";
	}
}

//HASH:2712822172179209842481703424551262167786