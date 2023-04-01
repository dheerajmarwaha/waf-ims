using System;
using System.Net.Http;
using System.Threading.Tasks;
using IMS.Client.Shared;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using Microsoft.Extensions.DependencyInjection;

namespace IMS.Client {
    public class Program {
        public static async Task Main(string[] args) { 
            var builder = WebAssemblyHostBuilder.CreateDefault(args);
            builder.RootComponents.Add<App>("app");
            var services= builder.Services;
            

            services.AddSingleton(sp => new HttpClient { BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) });

            //ADD   WAF SPECIFIC SERVICES
            WAF.Components.Services.ServiceUtils.AddWAFServices(services);

            
            await builder.Build().RunAsync();

        }


    }
}

//HASH:18821723022923255551922011221985122318226