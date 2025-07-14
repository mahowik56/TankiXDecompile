using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Tanks.Lobby.ClientGarage.API;

namespace Tanks.Lobby.ClientGarage.Impl
{
	[SerialVersionUID(1504257079301L)]
	public interface TutorialHighlightTankDataTemplate : Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		TutorialStepDataComponent tutorialStepData();

		[AutoAdded]
		[PersistentConfig("", false)]
		TutorialHighlightTankStepDataComponent tutorialHighlightTankStepData();
	}
}
