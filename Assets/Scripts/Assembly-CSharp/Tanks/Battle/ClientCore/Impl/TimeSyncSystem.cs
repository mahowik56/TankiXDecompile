using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration.API;
using Platform.System.Data.Exchange.ClientNetwork.API;
using Tanks.Battle.ClientCore.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class TimeSyncSystem : ECSSystem
	{
		public class SessionNode : Node
		{
			public ClientSessionComponent clientSession;

			public ClientTimeComponent clientTime;
		}

		[Inject]
		public static UnityTime UnityTime { get; set; }

		[Inject]
		public static TimeService TimeService { get; set; }

		[OnEventFire]
		public void AddComponent(NodeAddedEvent e, SingleNode<ClientSessionComponent> session)
		{
			session.Entity.AddComponent<ClientTimeComponent>();
		}

		[OnEventFire]
		public void Ping(PingEvent e, SessionNode session)
		{
			float realtimeSinceStartup = UnityTime.realtimeSinceStartup;
			base.Log.InfoFormat("Ping e={0} pongCommandClientRealTime={1}", e, realtimeSinceStartup);
			PongEvent pongEvent = new PongEvent();
			pongEvent.PongCommandClientRealTime = realtimeSinceStartup;
			pongEvent.CommandId = e.CommandId;
			ScheduleEvent(pongEvent, session);
			session.clientTime.PingServerTime = e.ServerTime;
			session.clientTime.PingClientRealTime = realtimeSinceStartup;
		}

		[OnEventFire]
		public void PingResult(PingResultEvent e, SessionNode session)
		{
			float realtimeSinceStartup = UnityTime.realtimeSinceStartup;
			float pingClientRealTime = session.clientTime.PingClientRealTime;
			long num = e.ServerTime - (long)((pingClientRealTime + realtimeSinceStartup) * 1000f / 2f);
			base.Log.InfoFormat("PingResult newDiffToServer={0} e={1}", num, e);
			TimeService.DiffToServer = num;
		}
	}
}
