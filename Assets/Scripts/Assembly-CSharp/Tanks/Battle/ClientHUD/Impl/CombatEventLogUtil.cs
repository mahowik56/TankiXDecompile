using Tanks.Battle.ClientCore.API;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Battle.ClientHUD.Impl
{
	public static class CombatEventLogUtil
	{
		public static UILog GetUILog(CombatEventLogComponent combatEventLog)
		{
			return combatEventLog.gameObject.GetComponent<UILog>();
		}

		public static string ApplyPlaceholder(string message, string placeholder, int rank, string uid, Color color)
		{
			return message.Replace(placeholder, "{" + rank + ":" + ColorUtility.ToHtmlStringRGB(color) + ":" + uid + "}");
		}

		public static Color GetTeamColor(TeamColor teamColor, CombatEventLogComponent combatEventLog)
		{
			switch (teamColor)
			{
			case TeamColor.BLUE:
				return combatEventLog.BlueTeamColor;
			case TeamColor.RED:
				return combatEventLog.RedTeamColor;
			default:
				return combatEventLog.NeutralColor;
			}
		}
	}
}
