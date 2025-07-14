using System;
using Tanks.Lobby.ClientGarage.Impl;

namespace Tanks.Lobby.ClientGarage.API
{
	public class TutorialUpgradeModuleCompleteStepHandler : TutorialStepHandler
	{
		public override void RunStep(TutorialData data)
		{
			base.RunStep(data);
			OpenTutorialContainerDialogEvent openTutorialContainerDialogEvent = new OpenTutorialContainerDialogEvent();
			openTutorialContainerDialogEvent.StepId = data.TutorialStep.GetComponent<TutorialStepDataComponent>().StepId;
			openTutorialContainerDialogEvent.ItemId = data.TutorialStep.GetComponent<TutorialSelectItemDataComponent>().itemMarketId;
			OpenTutorialContainerDialogEvent openTutorialContainerDialogEvent2 = openTutorialContainerDialogEvent;
			TutorialStepHandler.EngineService.Engine.ScheduleEvent(openTutorialContainerDialogEvent2, TutorialStepHandler.EngineService.EntityStub);
			openTutorialContainerDialogEvent2.dialog.Message = data.Message;
			TutorialContainerDialog dialog = openTutorialContainerDialogEvent2.dialog;
			dialog.dialogClosed = (Action)Delegate.Combine(dialog.dialogClosed, new Action(Complete));
		}

		private void Complete()
		{
			ShopTabManager.shopTabIndex = 1;
			MainScreenComponent.Instance.HideQuestsIfVisible();
			MainScreenComponent.Instance.ShowShopIfNotVisible();
			StepComplete();
		}
	}
}
