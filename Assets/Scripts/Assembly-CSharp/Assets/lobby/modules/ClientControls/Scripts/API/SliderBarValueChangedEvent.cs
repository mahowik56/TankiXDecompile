using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Assets.lobby.modules.ClientControls.Scripts.API
{
	public class SliderBarValueChangedEvent : Event
	{
		public float Value { get; set; }

		public SliderBarValueChangedEvent()
		{
		}

		public SliderBarValueChangedEvent(float value)
		{
			Value = value;
		}
	}
}
