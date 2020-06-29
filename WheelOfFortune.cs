using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace wheel
{
    public class WheelOfFortune
    {
        public string gift { set; get; }
        public int winPercentage { set; get; }
        public bool canWinpoints { set; get; }
    }
    public class ExtraPoints
    {
        public int point { set; get; }
        public int winPercentage { set; get; }
    }
}
