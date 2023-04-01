using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;
using WAF.Controllers;
using WAF.Lib.Cache;
using System.IO;
using System.Reflection;
using WAF.Controllers.Reporting;
namespace IMS.Server.Controllers{
	public abstract class IMSAbstractReportController<T> : WAFAbstractRDLReportController<T>	{
		public IMSAbstractReportController(RedisService redisService, IConfiguration config, IHttpContextAccessor httpContextAccessor) : base(redisService, config, httpContextAccessor) 		{
		}
		public override bool IsSuperuser => this.CurrentUserRole == "IMS_ADM";
		public IMSDBContext NewDbContext()		{
			return new IMSDBContext(config["DB:server"], int.Parse(config["DB:port"]), config["DB:db"], config["DB:userId"], config["DB:password"], log);
		}
		//[[Directory where the reports files are kept
		DirectoryInfo _reportsFileDirectoryInfo = null;
		public DirectoryInfo ReportsFileDirectoryInfo		{
			get			{
				if (_reportsFileDirectoryInfo == null)				{
					if (IsDevEnv)					{
						_reportsFileDirectoryInfo = new DirectoryInfo(
						Path.Combine((new FileInfo(Assembly.GetExecutingAssembly().Location))//dll file in bin
						.Directory//netcoreapp directory of server project
						.Parent//debug directory of server proejct
						.Parent//bin directory of server project
						.Parent//IMS.Server directory
						.Parent//IMS repo dir
						.FullName, "IMS.Reports"));
					} else
					{
						_reportsFileDirectoryInfo = new DirectoryInfo(Path.Combine((new FileInfo(Assembly.GetExecutingAssembly().Location)).Directory.FullName, "IMS.Reports"));
					}
				}
				return _reportsFileDirectoryInfo;
			}
		}
		//]]
	}
}

//HASH:21517752245253226613285218131961839424351