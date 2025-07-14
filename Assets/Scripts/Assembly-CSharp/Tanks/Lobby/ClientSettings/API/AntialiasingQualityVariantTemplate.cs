using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientSettings.API
{
	[SerialVersionUID(636306335691981785L)]
	public interface AntialiasingQualityVariantTemplate : CarouselItemTemplate, Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		AntialiasingQualityVariantComponent variant();
	}
}
