using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.AccessControl;
using System.Threading.Tasks;
using CommandLine;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace dummy_host {
    public class Program {
        public static void Main (string[] args) {
            CreateHostBuilder (args).Build ().Run ();
        }

        public static IHostBuilder CreateHostBuilder (string[] args) {
            IHostBuilder builder = null;
            Parser.Default.ParseArguments<Options> (args)
                .WithParsed<Options> (o => {
                    System.IO.Directory.SetCurrentDirectory (o.ContentRoot);

                    builder = Host.CreateDefaultBuilder (args)

                        .ConfigureWebHostDefaults (webBuilder => {
                            webBuilder.UseStartup<Startup> ();
                            webBuilder.UseKestrel ();
                        });
                });
            return builder;
        }
    }
    public class Options {
        [Option ('c', "contentRoot", Required = true, HelpText = "Set content root.")]
        public string ContentRoot { get; set; }

    }
}