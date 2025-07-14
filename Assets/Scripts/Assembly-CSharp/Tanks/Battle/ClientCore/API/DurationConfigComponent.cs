using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Battle.ClientCore.API
{
	[Shared]
	[SerialVersionUID(482294559116673084L)]
	public class DurationConfigComponent : Component
	{
		public long Duration { get; set; }
	}
}
