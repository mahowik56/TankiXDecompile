using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.ECS.ClientEntitySystem.Impl;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration.API;
using UnityEngine;

namespace Platform.Library.ClientUnityIntegration.Impl
{
	public class EngineBehaviour : MonoBehaviour
	{
		private static ApplicationFocusEvent applicationFocusEvent = new ApplicationFocusEvent();

		private static ViewportResizeEvent viewportResizeEvent = new ViewportResizeEvent();

		[Inject]
		public static EngineServiceInternal EngineServiceInternal { get; set; }

		private void Update()
		{
			UpdateEvent instance = UpdateEvent.Instance;
			float deltaTime = Time.deltaTime;
			TimeUpdateEvent.Instance.DeltaTime = deltaTime;
			deltaTime = deltaTime;
			EarlyUpdateEvent.Instance.DeltaTime = deltaTime;
			instance.DeltaTime = deltaTime;
			Flow flow = EngineServiceInternal.GetFlow();
			flow.TryInvoke(TimeUpdateEvent.Instance, typeof(TimeUpdateFireHandler));
			flow.TryInvoke(TimeUpdateEvent.Instance, typeof(TimeUpdateCompleteHandler));
			flow.TryInvoke(EarlyUpdateEvent.Instance, typeof(EarlyUpdateFireHandler));
			flow.TryInvoke(EarlyUpdateEvent.Instance, typeof(EarlyUpdateCompleteHandler));
			flow.TryInvoke(UpdateEvent.Instance, typeof(UpdateEventFireHandler));
			flow.TryInvoke(UpdateEvent.Instance, typeof(UpdateEventCompleteHandler));
			EngineServiceInternal.GetFlow();
			EngineServiceInternal.DelayedEventManager.Update(Time.time);
		}

		private void FixedUpdate()
		{
			FixedUpdateEvent.Instance.DeltaTime = Time.fixedDeltaTime;
			Flow flow = EngineServiceInternal.GetFlow();
			flow.TryInvoke(FixedUpdateEvent.Instance, typeof(FixedUpdateEventFireHandler));
			flow.TryInvoke(FixedUpdateEvent.Instance, typeof(FixedUpdateEventCompleteHandler));
		}

		private void OnApplicationFocus(bool isFocused)
		{
			applicationFocusEvent.IsFocused = isFocused;
			EngineEventSender.SendEventIntoEngine(EngineServiceInternal, applicationFocusEvent);
		}

		private void OnRectTransformDimensionsChange()
		{
			EngineEventSender.SendEventIntoEngine(EngineServiceInternal, viewportResizeEvent);
		}
	}
}
