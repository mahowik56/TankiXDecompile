using System.Collections.Generic;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class InputFormatter : BaseInputFormatter
	{
		[SerializeField]
		private List<int> spacePositions = new List<int> { 4, 8, 12 };

		[SerializeField]
		private string spaceChar = " ";

		protected override string FormatAt(char symbol, int charIndex)
		{
			if (!char.IsDigit(symbol))
			{
				return string.Empty;
			}
			if (spacePositions.Contains(charIndex))
			{
				return spaceChar + symbol;
			}
			return symbol.ToString();
		}

		protected override string ClearFormat(string text)
		{
			if (string.IsNullOrEmpty(spaceChar))
			{
				return text;
			}
			return text.Replace(spaceChar, string.Empty);
		}
	}
}
