using System.Collections.Generic;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class SelectedItemUI : MonoBehaviour
	{
		[SerializeField]
		private TextMeshProUGUI itemName;

		[SerializeField]
		private TextMeshProUGUI feature;

		[SerializeField]
		private MainVisualPropertyUI[] props;

		[SerializeField]
		private AnimatedNumber mastery;

		[SerializeField]
		private TextMeshProUGUI currentSkin;

		[SerializeField]
		private UpgradeStars upgradeStars;

		[SerializeField]
		private LocalizedField currentSkinLocalizedField;

		public TankPartItem TankPartItem { get; set; }

		public void SetStars(float coef)
		{
			upgradeStars.SetPower(coef);
		}

		public void Set(TankPartItem item, string skinName, int level)
		{
			TankPartItem = item;
			this.SendEvent<ListItemSelectedEvent>(item.UserItem);
			itemName.text = item.Name;
			mastery.Value = level;
			feature.text = item.Feature;
			currentSkin.text = currentSkinLocalizedField.Value + ": " + skinName;
			List<MainVisualProperty> mainProperties = item.MainProperties;
			for (int i = 0; i < mainProperties.Count; i++)
			{
				props[i].gameObject.SetActive(true);
				props[i].Set(mainProperties[i].Name, mainProperties[i].NormalizedValue);
			}
			for (int j = mainProperties.Count; j < props.Length; j++)
			{
				props[j].gameObject.SetActive(false);
			}
		}

		public void DisableMasteryElement()
		{
			mastery.gameObject.SetActive(false);
		}

		public void EnableMasteryElement()
		{
			mastery.gameObject.SetActive(true);
		}
	}
}
