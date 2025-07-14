using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class PaymentSpecialIconMinimalRankComponent : LocalizedControl, Component
	{
		private string minimalRank;

		public string MinimalRank
		{
			get
			{
				return minimalRank;
			}
			set
			{
				minimalRank = value;
			}
		}
	}
}
