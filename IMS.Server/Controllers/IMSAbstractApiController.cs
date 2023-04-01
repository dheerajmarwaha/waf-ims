using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;
using WAF.Controllers;
namespace IMS.Server.Controllers{
	public abstract class IMSAbstractApiController<T> : WAFBaseController<T>	{
		public IMSAbstractApiController(IConfiguration config, IHttpContextAccessor httpContextAccessor) : base(config, httpContextAccessor) 		{
		}
		public override bool IsSuperuser => this.CurrentUserRole == "IMS_ADM";
		public IMSDBContext NewDbContext()		{
			return new IMSDBContext(config["DB:server"], int.Parse(config["DB:port"]), config["DB:db"], config["DB:userId"], config["DB:password"], log);
		}
	}
}

//HASH:178107204253067399237237159206218711222