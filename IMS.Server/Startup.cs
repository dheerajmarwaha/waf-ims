using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json.Serialization;
using WAF.Lib.Cache;
using WAF.Shared.JSON;
using WAF.Utils;



namespace IMS.Server {
    public class Startup {
        public static IConfiguration Configuration;//so that we can refer this config object from static methods of other classes
        public Startup(IConfiguration _configuration) {
            Startup.Configuration = _configuration;            
        }   
        
        public void ConfigureServices(IServiceCollection services) {
            services.AddSingleton(typeof(RedisService), new RedisService());

            IMvcBuilder mvcbuilder = services.AddControllersWithViews();
            mvcbuilder.AddNewtonsoftJson(options =>
            {
                options.SerializerSettings.ContractResolver = new DefaultContractResolver();
                options.SerializerSettings.NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore;
                //options.SerializerSettings.Converters.Add(new DecimalJsonConverter());
            });

            //[[WAF ADDED THIS CODE
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();            
            //<<auth related code           
            services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(options => {
                options.Cookie.Name = ".dccauth";
                options.LoginPath = new PathString("/Auth/RedirectToLogin");
                options.DataProtectionProvider = DataProtectionProvider.Create(ServerUtils.WAFDataProtectionProviderDirInfo);
            });
            //>>
            //]]            
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IConfiguration configuration, RedisService redisService) {
            redisService.Init(configuration["PACKAGE:PACKAGE_ID"], configuration["REDIS:SERVER"]);
            
            //[[WAF ADDED THIS CODE            
            //<<This is required if our app is behind a reverse proxy, which will be the case almost all the times
            app.UseForwardedHeaders(new ForwardedHeadersOptions {
                ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
            });
            string pathBase = ServerUtils.GetAppBasePathFromSysadmin(configuration).ToLower();
            if (!env.IsDevelopment()) {
                app.UsePathBase(pathBase);
            }
            ServerUtils.ModifyIndexHtmlForBaseHref(env.ContentRootPath,  pathBase);                        
            ServerUtils.ConfigureLogger(configuration);
            //]]

            //app.UseResponseCompression();
            
            if (env.IsDevelopment()) {
                app.UseDeveloperExceptionPage();
                app.UseWebAssemblyDebugging();
            }

            app.UseAuthentication();

            app.UseBlazorFrameworkFiles();
            app.UseStaticFiles();
            
          
            app.UseRouting();
            app.UseAuthorization();
            app.UseEndpoints(endpoints => {
                endpoints.MapControllerRoute("default", "{controller}/{action}/{id?}");
                endpoints.MapFallbackToFile("index.html");
            });


            ServerUtils.Config = configuration;
        }
       
    }
}

//HASH:1669618248225138212161837125564107668163