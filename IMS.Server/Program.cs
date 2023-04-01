using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace IMS.Server {
    public class Program {

        public static void Main(string[] args) {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder => {
                    webBuilder.UseUrls("http://*:5434");
                    webBuilder.UseStartup<Startup>();
                });
        
    }
}

//HASH:21110484681872232262217831101191202185438