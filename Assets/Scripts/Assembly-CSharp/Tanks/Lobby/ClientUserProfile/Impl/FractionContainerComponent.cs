using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientUserProfile.Impl
{
	public class FractionContainerComponent : BehaviourComponent
	{
		public enum FractionContainerTargets
		{
			PLAYER_FRACTION = 0,
			WINNER_FRACTION = 1
		}

		[SerializeField]
		private ImageSkin _fractionLogo;

		[SerializeField]
		private TextMeshProUGUI _fractionTitle;

		[SerializeField]
		private CanvasGroup _canvasGroup;

		public FractionContainerTargets Target;

		public string FractionLogoUid
		{
			set
			{
				_fractionLogo.SpriteUid = value;
			}
		}

		public string FractionTitle
		{
			set
			{
				_fractionTitle.text = value;
			}
		}

		public Color FractionColor
		{
			set
			{
				_fractionTitle.color = value;
			}
		}

		public bool IsAvailable
		{
			set
			{
				_canvasGroup.alpha = ((!value) ? 0f : 1f);
			}
		}
	}
}
