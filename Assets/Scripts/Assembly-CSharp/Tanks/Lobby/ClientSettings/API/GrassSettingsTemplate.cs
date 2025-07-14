using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientSettings.API
{
	[SerialVersionUID(636322850309636241L)]
	public interface GrassSettingsTemplate : CarouselItemTemplate, Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		GrassSettingsComponent variant();
	}
}
