using TMPro;
using Tanks.Lobby.ClientNavigation.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientSettings.Impl
{
	public class SelectLocaleScreenTextComponent : LocalizedScreenComponent
	{
		[SerializeField]
		private TextMeshProUGUI hint;

		[SerializeField]
		private Text currentLanguage;

		public string Hint
		{
			set
			{
				hint.text = value;
			}
		}

		public string CurrentLanguage
		{
			set
			{
				currentLanguage.text = value;
			}
		}
	}
}
