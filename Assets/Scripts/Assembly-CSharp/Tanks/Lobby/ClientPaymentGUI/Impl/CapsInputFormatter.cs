using System.Text.RegularExpressions;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class CapsInputFormatter : BaseInputFormatter
	{
		private static Regex allowedSymbols = new Regex("[A-Za-z ]");

		protected override string FormatAt(char symbol, int charIndex)
		{
			string text = symbol.ToString();
			if (!allowedSymbols.IsMatch(text))
			{
				return string.Empty;
			}
			return text.ToUpper();
		}

		protected override string ClearFormat(string text)
		{
			return text;
		}
	}
}
