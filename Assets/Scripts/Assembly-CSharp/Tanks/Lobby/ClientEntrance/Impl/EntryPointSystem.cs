using System;
using System.IO;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.System.Data.Exchange.ClientNetwork.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientNavigation.API;
using Tanks.Lobby.ClientNavigation.Impl;
using UnityEngine;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	public class EntryPointSystem : ECSSystem
	{
		public class SecuredClientSessionNode : Node
		{
			public ClientSessionComponent clientSession;

			public SessionSecurityPublicComponent sessionSecurityPublic;

			public WebIdComponent webId;
		}

		public class SessionAwaitingTokenNode : Node
		{
			public ClientSessionComponent clientSession;

			public AutoLoginTokenAwaitingComponent autoLoginTokenAwaiting;
		}

		public const string AUTO_AUTHENTICATION_TOKEN = "TOToken";

		public const string AUTO_AUTHENTICATION_LOGIN = "TOLogin";

		public const string STEAM_AUTHENTICATION_KEY = "SteamAuthentication";

		[OnEventFire]
		public void SendWebId(NodeAddedEvent e, SingleNode<ClientSessionComponent> node)
		{
			string text;
			try
			{
				text = File.ReadAllText(Application.dataPath + "/USER_ID");
				long num = Convert.ToInt64(text);
			}
			catch (Exception)
			{
				text = string.Empty;
			}
			ScheduleEvent(new ClientLaunchEvent(text), node);
		}

		[OnEventFire]
		public void CheckAutoLogin(NodeAddedEvent e, SecuredClientSessionNode clientSession, SingleNode<ScreensRegistryComponent> screenRegistry, SingleNode<EntranceValidationRulesComponent> validationRules)
		{
			string text = PlayerPrefs.GetString("TOLogin");
			string text2 = PlayerPrefs.GetString("TOToken");
			if (!clientSession.Entity.HasComponent<InviteComponent>() && !string.IsNullOrEmpty(text2) && !string.IsNullOrEmpty(text))
			{
				AutoLoginUserEvent autoLoginUserEvent = new AutoLoginUserEvent();
				autoLoginUserEvent.Uid = text;
				autoLoginUserEvent.EncryptedToken = PasswordSecurityUtils.RSAEncrypt(clientSession.sessionSecurityPublic.PublicKey, Convert.FromBase64String(text2));
				autoLoginUserEvent.HardwareFingerprint = HardwareFingerprintUtils.HardwareFingerprint;
				AutoLoginUserEvent eventInstance = autoLoginUserEvent;
				ScheduleEvent(eventInstance, clientSession);
			}
			else if (IsSteamUserLogin())
			{
				ScheduleEvent<ShowFirstScreenEvent<EntranceScreenComponent>>(screenRegistry);
				ScheduleEvent<RequestSteamAuthenticationEvent>(clientSession);
			}
			else
			{
				string savedLogin = SaveLoginSystem.GetSavedLogin();
				if (!string.IsNullOrEmpty(savedLogin) || !string.IsNullOrEmpty(clientSession.webId.WebIdUid))
				{
					ScheduleEvent<ShowFirstScreenEvent<EntranceScreenComponent>>(screenRegistry);
				}
				else
				{
					ScheduleEvent<ShowFirstScreenEvent<RegistrationScreenComponent>>(screenRegistry);
				}
			}
		}

		private bool IsSteamUserLogin()
		{
			bool flag = PlayerPrefs.GetInt("SteamAuthentication", 0) == 1;
			return SteamManager.Initialized && !flag;
		}

		[OnEventFire]
		public void ContinueWithLogin(AutoLoginFailedEvent e, Node any, [JoinAll] SingleNode<TopPanelComponent> topPanel)
		{
			ClearAutoLoginToken();
			ScheduleEvent<ShowFirstScreenEvent<EntranceScreenComponent>>(topPanel);
		}

		[Mandatory]
		[OnEventFire]
		public void SaveToken(SaveAutoLoginTokenEvent e, Node user, SessionAwaitingTokenNode clientSession)
		{
			string value = DecryptToken(clientSession.autoLoginTokenAwaiting.PasswordDigest, e.Token);
			PlayerPrefs.SetString("TOLogin", e.Uid);
			PlayerPrefs.SetString("TOToken", value);
			clientSession.Entity.RemoveComponent<AutoLoginTokenAwaitingComponent>();
		}

		private void ClearAutoLoginToken()
		{
			PlayerPrefs.DeleteKey("TOToken");
			PlayerPrefs.DeleteKey("TOLogin");
		}

		private string DecryptToken(byte[] passwordDigest, byte[] encryptedToken)
		{
			byte[] array = new byte[encryptedToken.Length];
			for (int i = 0; i < encryptedToken.Length; i++)
			{
				array[i] = (byte)(encryptedToken[i] ^ passwordDigest[i % passwordDigest.Length]);
			}
			return Convert.ToBase64String(array);
		}
	}
}
