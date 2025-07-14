using System;
using System.Collections.Generic;
using System.Linq;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class BattlePingComponent : Component
	{
		private long summ;

		private long count;

		private HashSet<int> values = new HashSet<int>();

		public ScheduleManager PeriodicEventManager { get; set; }

		public float LastPingTime { get; set; }

		public void add(int ping)
		{
			summ += ping;
			count++;
			values.Add(ping);
		}

		public int getAveragePing()
		{
			return (int)((count > 0) ? (summ / count) : 0);
		}

		public int getMediana()
		{
			int[] array = values.ToArray();
			Array.Sort(array);
			if (array.Length > 0)
			{
				return array[array.Length / 2];
			}
			return 0;
		}
	}
}
