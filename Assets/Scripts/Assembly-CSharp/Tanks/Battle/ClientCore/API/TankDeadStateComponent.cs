using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Platform.Library.ClientUnityIntegration.API;

namespace Tanks.Battle.ClientCore.API
{
	[Shared]
	[SerialVersionUID(-2656312914607478436L)]
	public class TankDeadStateComponent : Component
	{
		private Date endDate;

		public Date EndDate
		{
			get
			{
				return endDate;
			}
			set
			{
				endDate = value;
			}
		}
	}
}
