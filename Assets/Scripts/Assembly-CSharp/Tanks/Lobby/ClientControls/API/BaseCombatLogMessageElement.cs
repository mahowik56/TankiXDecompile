using UnityEngine;

namespace Tanks.Lobby.ClientControls.API
{
	public abstract class BaseCombatLogMessageElement : MonoBehaviour
	{
		[SerializeField]
		protected RectTransform rectTransform;

		public RectTransform RectTransform
		{
			get
			{
				return rectTransform;
			}
		}
	}
}
