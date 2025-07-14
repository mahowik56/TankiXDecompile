using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientBattleSelect.Impl
{
	[Shared]
	[SerialVersionUID(1463648611538L)]
	public class SetScoreTablePositionEvent : Event
	{
		public int Position { get; set; }

		public SetScoreTablePositionEvent()
		{
		}

		public SetScoreTablePositionEvent(int position)
		{
			Position = position;
		}
	}
}
