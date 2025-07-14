using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientControls.Impl
{
	public class TextToUppercase : MonoBehaviour
	{
		private Text inputField;

		private TextMeshProUGUI tmpText;

		private void Start()
		{
			inputField = GetComponent<Text>();
			tmpText = GetComponent<TextMeshProUGUI>();
			ToUpperCase();
		}

		public void ToUpperCase()
		{
			if (inputField != null)
			{
				inputField.text = inputField.text.ToUpper();
			}
			else
			{
				tmpText.text = tmpText.text.ToUpper();
			}
		}
	}
}
