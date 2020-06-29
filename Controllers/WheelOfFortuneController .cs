using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace wheel.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WheelOfFortuneController : ControllerBase
    {
        private readonly ILogger<WheelOfFortuneController> _logger;
        private readonly List<WheelOfFortune> _wheel;

        public WheelOfFortuneController(ILogger<WheelOfFortuneController> logger)
        {
            _logger = logger;

            using (StreamReader r = new StreamReader("WheelOfFortune.json"))
            {
                string json = r.ReadToEnd();
                _wheel = JsonConvert.DeserializeObject<List<WheelOfFortune>>(json);
            }

        }

        [HttpGet]
        public WinResult Get()
        {
            WheelOfFortune _won = new WheelOfFortune();
            ExtraPoints _wonPoints = new ExtraPoints() 
            { 
                point = 0
            };

            Random random = new Random(DateTime.Now.Millisecond);
            int randomNumber = random.Next(1, 101);

            foreach(WheelOfFortune _fortune in _wheel)
            {
                randomNumber -= _fortune.winPercentage;

                if(randomNumber <= 0)
                {
                    _won = _fortune;
                    break;
                }
            }

            randomNumber = random.Next(1, 101);
            if (_won.canWinpoints)
            {
                List<ExtraPoints> _points = new List<ExtraPoints>();

                using (StreamReader r = new StreamReader("ExtraPoints.json"))
                {
                    string json = r.ReadToEnd();
                    _points = JsonConvert.DeserializeObject<List<ExtraPoints>>(json);
                }

                foreach (ExtraPoints _point in _points)
                {
                    randomNumber -= _point.winPercentage;

                    if (randomNumber <= 0)
                    {
                        _wonPoints = _point;
                        break;
                    }
                }
            }
            return new WinResult() { 
                gift = _won.gift,
                points = _wonPoints.point
            };
        }
    }
}
