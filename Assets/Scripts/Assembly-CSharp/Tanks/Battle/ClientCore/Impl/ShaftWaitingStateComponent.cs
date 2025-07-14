using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Battle.ClientCore.Impl
{
	[Shared]
	[SerialVersionUID(6541712051864507498L)]
	public class ShaftWaitingStateComponent : TimeValidateComponent
	{
		public float WaitingTimer { get; set; }

		public ShaftWaitingStateComponent()
		{
			WaitingTimer = 0f;
		}
	}
}
