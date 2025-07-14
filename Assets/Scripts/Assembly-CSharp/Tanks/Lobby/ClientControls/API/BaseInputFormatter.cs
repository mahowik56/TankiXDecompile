using System.Text;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientControls.API
{
	[RequireComponent(typeof(InputField))]
	public abstract class BaseInputFormatter : MonoBehaviour
	{
		protected InputField input;

		private bool formating;

		private void Awake()
		{
			input = GetComponent<InputField>();
			input.onValueChanged.AddListener(Format);
		}

		protected abstract string FormatAt(char symbol, int charIndex);

		protected abstract string ClearFormat(string text);

		private void Format(string text)
		{
			if (!formating)
			{
				formating = true;
				StringBuilder stringBuilder = new StringBuilder();
				text = ClearFormat(text);
				int num = 0;
				for (int i = 0; i < text.Length; i++)
				{
					string text2 = FormatAt(text[i], i);
					stringBuilder.Append(text2);
					num += text2.Length - 1;
				}
				input.text = stringBuilder.ToString();
				input.caretPosition += num;
				formating = false;
			}
		}
	}
}
