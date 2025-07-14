using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientNavigation.API;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	public class RegistrationInputValidationSystem : InputValidationSystem
	{
		public class LoginInputFieldNode : BaseInputFieldNode<RegistrationLoginInputComponent>
		{
			public class NormalState : LoginInputFieldNode
			{
				public InputFieldNormalStateComponent inputFieldNormalState;
			}
		}

		public class PasswordInputFieldNode : BaseInputFieldNode<RegistrationPasswordInputComponent>
		{
			public class NormalState : PasswordInputFieldNode
			{
				public InputFieldNormalStateComponent inputFieldNormalState;
			}

			public class ValidState : PasswordInputFieldNode
			{
				public InputFieldValidStateComponent inputFieldValidState;
			}
		}

		public class RepetitionPasswordInputFieldNode : BaseInputFieldNode<RepetitionPasswordInputComponent>
		{
		}

		public class RegistrationScreenLocalizedStringsNode : Node
		{
			public RegistrationScreenLocalizedStringsComponent registrationScreenLocalizedStrings;

			public ScreenGroupComponent screenGroup;
		}

		public class UserAgreementsCheckboxNode : Node
		{
			public UserAgreementsCheckBoxComponent userAgreementsCheckBox;

			public InteractivityPrerequisiteESMComponent interactivityPrerequisiteESM;

			public CheckboxComponent checkbox;

			public void ToAcceptableState()
			{
				interactivityPrerequisiteESM.Esm.ChangeState<InteractivityPrerequisiteStates.AcceptableState>();
			}

			public void ToNotAcceptableState()
			{
				interactivityPrerequisiteESM.Esm.ChangeState<InteractivityPrerequisiteStates.NotAcceptableState>();
			}
		}

		[OnEventFire]
		public void ValidatePassword(InputFieldValueChangedEvent e, PasswordInputFieldNode passwordInputField, [JoinByScreen] SingleNode<PasswordErrorsComponent> strings, [JoinAll] SingleNode<EntranceValidationRulesComponent> rules)
		{
			if (rules.component.IsPasswordSymbolsValid(passwordInputField.Input))
			{
				passwordInputField.ToNormalState();
				return;
			}
			string passwordContainsRestrictedSymbols = strings.component.PasswordContainsRestrictedSymbols;
			passwordInputField.ToInvalidState(passwordContainsRestrictedSymbols);
		}

		[OnEventFire]
		public void ValidatePassword(InputFieldValueChangedEvent e, PasswordInputFieldNode.NormalState passwordInputField, [JoinByScreen] LoginInputFieldNode loginInputField, [JoinByScreen] SingleNode<PasswordErrorsComponent> strings, [JoinAll] SingleNode<EntranceValidationRulesComponent> rules)
		{
			if (passwordInputField.Input == loginInputField.Input)
			{
				passwordInputField.ToInvalidState(strings.component.PasswordEqualsLogin);
			}
		}

		[OnEventFire]
		public void ValidatePassword(InputPausedEvent e, PasswordInputFieldNode.NormalState passwordInputField, [JoinByScreen] SingleNode<PasswordErrorsComponent> strings, [JoinAll] SingleNode<EntranceValidationRulesComponent> rules)
		{
			ChangePasswordInputFieldState(passwordInputField, strings.component, rules.component);
		}

		[OnEventFire]
		public void ValidatePassword(InputFieldValueChangedEvent e, LoginInputFieldNode loginInputField, [JoinByScreen] PasswordInputFieldNode passwordInput, [JoinByScreen] SingleNode<PasswordErrorsComponent> strings, [JoinAll] SingleNode<EntranceValidationRulesComponent> rules)
		{
			if (passwordInput.Input == loginInputField.Input && !string.IsNullOrEmpty(loginInputField.Input))
			{
				passwordInput.ToInvalidState(strings.component.PasswordEqualsLogin);
			}
			else if (!string.IsNullOrEmpty(passwordInput.Input))
			{
				ChangePasswordInputFieldState(passwordInput, strings.component, rules.component);
			}
		}

		private void ChangePasswordInputFieldState(BaseInputFieldNode<RegistrationPasswordInputComponent> passwordInputField, PasswordErrorsComponent strings, EntranceValidationRulesComponent rules)
		{
			string input = passwordInputField.Input;
			if (string.IsNullOrEmpty(input))
			{
				passwordInputField.ToNormalState();
			}
			else if (rules.IsPasswordTooShort(input))
			{
				passwordInputField.ToInvalidState(strings.PasswordIsTooShort);
			}
			else if (rules.IsPasswordTooLong(input))
			{
				passwordInputField.ToInvalidState(strings.PasswordIsTooLong);
			}
			else
			{
				passwordInputField.ToValidState();
			}
		}

		[OnEventFire]
		public void SetNormalStateWhenRepetitionPasswordInputChanged(InputFieldValueChangedEvent e, RepetitionPasswordInputFieldNode repetitionPasswordInputField)
		{
			repetitionPasswordInputField.ToNormalState();
		}

		[OnEventFire]
		public void SetNormalStateWhenPasswordInputChanged(InputFieldValueChangedEvent e, PasswordInputFieldNode passwordInputField, [JoinByScreen] RepetitionPasswordInputFieldNode repetitionPasswordInputField)
		{
			repetitionPasswordInputField.ToNormalState();
		}

		[OnEventFire]
		public void CheckRepetitionWhenPasswordInputValid(NodeAddedEvent e, PasswordInputFieldNode.ValidState passwordInputField, [JoinByScreen] RepetitionPasswordInputFieldNode repetitionPasswordInputField, [JoinByScreen] SingleNode<PasswordErrorsComponent> strings)
		{
			CheckRepetitionPassword(repetitionPasswordInputField, passwordInputField, strings.component);
		}

		[OnEventFire]
		public void ValidateRepetitionPassword(InputPausedEvent e, RepetitionPasswordInputFieldNode repetitionPasswordInputField, [JoinByScreen] PasswordInputFieldNode.ValidState passwordInputField, [JoinByScreen] SingleNode<PasswordErrorsComponent> strings)
		{
			CheckRepetitionPassword(repetitionPasswordInputField, passwordInputField, strings.component);
		}

		private void CheckRepetitionPassword(BaseInputFieldNode<RepetitionPasswordInputComponent> repetitionPasswordInputField, PasswordInputFieldNode passwordInputField, PasswordErrorsComponent strings)
		{
			if (string.IsNullOrEmpty(repetitionPasswordInputField.Input))
			{
				repetitionPasswordInputField.ToNormalState();
			}
			else if (repetitionPasswordInputField.Input != passwordInputField.Input)
			{
				repetitionPasswordInputField.ToInvalidState(strings.PasswordsDoNotMatch);
			}
			else
			{
				repetitionPasswordInputField.ToValidState();
			}
		}

		[OnEventFire]
		public void SetCheckboxAcceptableState(CheckedCheckboxEvent e, UserAgreementsCheckboxNode agreementsCheckbox)
		{
			agreementsCheckbox.ToAcceptableState();
		}

		[OnEventFire]
		public void SetCheckboxNotAcceptableState(UncheckedCheckboxEvent e, UserAgreementsCheckboxNode agreementsCheckbox)
		{
			agreementsCheckbox.ToNotAcceptableState();
		}
	}
}
