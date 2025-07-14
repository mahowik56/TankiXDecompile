using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientNavigation.API;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	public abstract class InputValidationSystem : ECSSystem
	{
		public class BaseInputFieldNode<TMarker> : Node where TMarker : Component
		{
			public InputFieldComponent inputField;

			public ESMComponent esm;

			public ScreenGroupComponent screenGroup;

			public InteractivityPrerequisiteESMComponent interactivityPrerequisiteESM;

			public TMarker marker;

			public string Input
			{
				get
				{
					return inputField.Input;
				}
			}

			public void ToValidState()
			{
				ToState<InteractivityPrerequisiteStates.AcceptableState, InputFieldStates.ValidState>();
			}

			public void ToAwaitState()
			{
				ToState<InteractivityPrerequisiteStates.NotAcceptableState, InputFieldStates.AwaitState>();
			}

			public void ToNormalState()
			{
				ToState<InteractivityPrerequisiteStates.NotAcceptableState, InputFieldStates.NormalState>();
			}

			public void ToInvalidState(string errorMessage)
			{
				ToState<InteractivityPrerequisiteStates.NotAcceptableState, InputFieldStates.InvalidState>();
				inputField.ErrorMessage = errorMessage;
			}

			private void ToState<TPrerequisiteState, TInputFieldState>() where TPrerequisiteState : Node where TInputFieldState : Node
			{
				if ((inputField.InputField != null && inputField.InputField.IsInteractable()) || (inputField.TMPInputField != null && inputField.TMPInputField.IsInteractable()))
				{
					interactivityPrerequisiteESM.Esm.ChangeState<TPrerequisiteState>();
					esm.Esm.ChangeState<TInputFieldState>();
				}
			}
		}
	}
}
