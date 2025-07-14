using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.ClientLauncher.Impl
{
	[SerialVersionUID(1444730989962L)]
	public interface LauncherDownloadScreenTemplate : Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		LauncherDownloadScreenTextComponent launcherDownloadScreenText();
	}
}
