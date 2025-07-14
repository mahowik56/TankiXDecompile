using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientControls.Impl
{
	public class CommonControlsSystem : ECSSystem
	{
		public class LocalizedTextNode : Node
		{
			public LocalizedTextComponent localizedText;

			public TextMappingComponent textMapping;
		}

		[OnEventFire]
		public void SetLocalziedText(NodeAddedEvent e, LocalizedTextNode node)
		{
			node.textMapping.Text = node.localizedText.Text;
		}
	}
}
