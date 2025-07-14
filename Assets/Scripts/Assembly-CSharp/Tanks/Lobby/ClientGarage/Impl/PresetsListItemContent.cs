using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class PresetsListItemContent : MonoBehaviour, ListItemContent
	{
		[SerializeField]
		private new TextMeshProUGUI name;

		[SerializeField]
		private TextMeshProUGUI level;

		public void SetDataProvider(object dataProvider)
		{
			PresetItem presetItem = (PresetItem)dataProvider;
			name.text = presetItem.Name;
			level.text = presetItem.hullName + " <sprite name=\"" + presetItem.hullId + "\"> " + presetItem.turretName + "<sprite name=\"" + presetItem.weaponId + "\"> ";
		}

		public void Select()
		{
		}
	}
}
