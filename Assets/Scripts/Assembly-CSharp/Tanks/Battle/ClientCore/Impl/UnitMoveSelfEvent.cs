using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Battle.ClientCore.Impl
{
	[SerialVersionUID(1486036000129L)]
	[Shared]
	public class UnitMoveSelfEvent : UnitMoveEvent
	{
		public UnitMoveSelfEvent()
		{
		}

		public UnitMoveSelfEvent(Movement move)
			: base(move)
		{
		}
	}
}
