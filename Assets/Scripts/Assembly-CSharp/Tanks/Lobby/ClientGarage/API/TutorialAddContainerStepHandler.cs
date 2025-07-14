using Tanks.Lobby.ClientGarage.Impl;

namespace Tanks.Lobby.ClientGarage.API
{
	public class TutorialAddContainerStepHandler : TutorialStepHandler
	{
		public override void RunStep(TutorialData data)
		{
			base.RunStep(data);
			base.gameObject.SetActive(true);
		}

		public void Success(long stepId)
		{
			tutorialData.ContinueOnClick = true;
			TutorialCanvas.Instance.SetupActivePopup(tutorialData);
			base.gameObject.SetActive(true);
		}

		public void Fail(long stepId)
		{
			tutorialData.ContinueOnClick = true;
			TutorialCanvas.Instance.SetupActivePopup(tutorialData);
			base.gameObject.SetActive(true);
		}
	}
}
