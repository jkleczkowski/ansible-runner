using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace dummy_host.Controllers {
    [ApiController]
    [Route ("[controller]")]
    public class DummyController : ControllerBase {

        private readonly ILogger<DummyController> _logger;

        public DummyController (ILogger<DummyController> logger) {
            _logger = logger;
        }

        [HttpGet ("[action]")]
        public IActionResult Index () {
            return Content ("This is only dummy host for container liveness");
        }

        [HttpGet]
        public IEnumerable<int> Get () {
            var rng = new Random ();
            return Enumerable.Range (1, 5)
                .ToArray ();
        }
    }
}