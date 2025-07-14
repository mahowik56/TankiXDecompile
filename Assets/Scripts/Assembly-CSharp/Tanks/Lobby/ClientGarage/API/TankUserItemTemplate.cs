using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientGarage.API
{
	[SerialVersionUID(1438603503434L)]
	public interface TankUserItemTemplate : TankItemTemplate, UpgradableUserItemTemplate, GarageItemTemplate, Template, UserItemTemplate
	{
	}
}
