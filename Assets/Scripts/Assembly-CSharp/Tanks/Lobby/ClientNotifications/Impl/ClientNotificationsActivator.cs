using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientGarage.Impl;
using Tanks.Lobby.ClientNotifications.API;
using Tanks.Lobby.ClientUserProfile.Impl;

namespace Tanks.Lobby.ClientNotifications.Impl
{
	public class ClientNotificationsActivator : UnityAwareActivator<AutoCompleting>, ECSActivator, Activator
	{
		[Inject]
		public static TemplateRegistry TemplateRegistry { get; set; }

		public void RegisterSystemsAndTemplates()
		{
			TemplateRegistry.Register<IgnoreBattleScreenNotificationTemplate>();
			TemplateRegistry.Register<LockScreenNotificationTemplate>();
			TemplateRegistry.Register<UIDChangedNotificationTemplate>();
			TemplateRegistry.Register<IgnoreBattleResultScreenNotificationTemplate>();
			TemplateRegistry.Register<UserRankRewardNotificationTemplate>();
			TemplateRegistry.Register<NewItemNotificationTemplate>();
			TemplateRegistry.Register<NewItemClientNotificationTemplate>();
			TemplateRegistry.Register<LeagueFirstEntranceRewardPersistentNotificationTemplate>();
			TemplateRegistry.Register<LeagueSeasonEndRewardPersistentNotificationTemplate>();
			TemplateRegistry.Register<EnergyCompensationPersistentNotificationTemplate>();
			TemplateRegistry.Register<EventContainerPersistentNotificationTemplate>();
			TemplateRegistry.Register<ReleaseGiftsPersistentNotificationTemplate>();
			TemplateRegistry.Register<EulaPersistentNotificationTemplate>();
			TemplateRegistry.Register<LoginRewardNotificationTemplate>();
			TemplateRegistry.Register<PrivacyPolicyPersistentNotificationTemplate>();
			TemplateRegistry.Register<FractionsCompetitionStartNotificationTemplate>();
			TemplateRegistry.Register<FractionsCompetitionRewardNotificationTemplate>();
			ECSBehaviour.EngineService.RegisterSystem(new UIDChangedNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new UserRankRewardNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new IgnoreBattleScreenNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new LockScreenNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new CancelNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new IgnoreBattleResultsScreenNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new NewItemNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new NotificationsOnBattleResultsScreenSystem());
			ECSBehaviour.EngineService.RegisterSystem(new LeagueFirstEntranceRewardNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new LeagueSeasonEndRewardNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new EnergyCompensationNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new EulaNotificationSystem());
			ECSBehaviour.EngineService.RegisterSystem(new EventContainerScreenSystem());
			ECSBehaviour.EngineService.RegisterSystem(new PrivacyPolicyNotificationSystem());
		}
	}
}
