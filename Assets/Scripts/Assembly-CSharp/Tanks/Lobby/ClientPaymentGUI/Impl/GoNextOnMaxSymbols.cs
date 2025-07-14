using TMPro;
using UnityEngine;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	[RequireComponent(typeof(TMP_InputField))]
	public class GoNextOnMaxSymbols : MonoBehaviour
	{
		private void Awake()
		{
			GetComponent<TMP_InputField>().onValueChanged.AddListener(ValueChanged);
		}

		private void ValueChanged(string val)
		{
			TMP_InputField component = GetComponent<TMP_InputField>();
			if (component.text.Length == component.characterLimit)
			{
				component.navigation.selectOnDown.Select();
			}
		}
	}
}
