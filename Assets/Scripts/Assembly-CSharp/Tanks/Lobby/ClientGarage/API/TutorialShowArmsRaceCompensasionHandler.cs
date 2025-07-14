using System;
using Tanks.Lobby.ClientGarage.Impl;

namespace Tanks.Lobby.ClientGarage.API
{
	public class TutorialShowArmsRaceCompensasionHandler : TutorialStepHandler
	{
		public override void RunStep(TutorialData data)
		{
			base.RunStep(data);
			ShowArmsRaceCompensationEvent showArmsRaceCompensationEvent = new ShowArmsRaceCompensationEvent();
			ScheduleEvent(showArmsRaceCompensationEvent, TutorialStepHandler.EngineService.EntityStub);
			if (showArmsRaceCompensationEvent.Dialog != null)
			{
				ConfirmDialogComponent dialog = showArmsRaceCompensationEvent.Dialog;
				dialog.dialogClosed = (Action)Delegate.Combine(dialog.dialogClosed, new Action(DialogClosed));
			}
			else
			{
				StepComplete();
			}
		}

		private void DialogClosed()
		{
			StepComplete();
		}
	}
}
