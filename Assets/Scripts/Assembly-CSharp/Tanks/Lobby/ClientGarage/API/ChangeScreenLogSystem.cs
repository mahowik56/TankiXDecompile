using System;
using System.Text.RegularExpressions;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientNavigation.API;

namespace Tanks.Lobby.ClientGarage.API
{
	public class ChangeScreenLogSystem : ECSSystem
	{
		public class SelfUserNode : Node
		{
			public SelfUserComponent selfUser;
		}

		public static string lastScreenName = string.Empty;

		public static DateTime lastScreenEnterDateTime = DateTime.Now;

		[OnEventFire]
		public void SendChangeScreenEvent(ChangeScreenLogEvent e, Node any, [JoinAll] SelfUserNode user)
		{
			string text = SplitCamelCase(e.NextScreen.ToString());
			if (!(lastScreenName == text))
			{
				double duration = 0.0;
				if (!string.IsNullOrEmpty(lastScreenName))
				{
					TimeSpan timeSpan = DateTime.Now.Subtract(lastScreenEnterDateTime);
					duration = Math.Truncate((timeSpan.TotalSeconds + (double)((float)timeSpan.Milliseconds / 1000f)) * 100.0) / 100.0;
				}
				ChangeScreenEvent eventInstance = new ChangeScreenEvent(lastScreenName, text, duration);
				lastScreenName = text;
				lastScreenEnterDateTime = DateTime.Now;
				ScheduleEvent(eventInstance, user);
			}
		}

		private string SplitCamelCase(string str)
		{
			return Regex.Replace(str, "([A-Z])", " $1", RegexOptions.Compiled).Trim();
		}
	}
}
