using System;
using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientBattleSelect.Impl
{
	public class BattleSeriesUiComponent : BehaviourComponent
	{
		[Header("Colors")]
		[SerializeField]
		private Color _battleSeriesColor;

		[SerializeField]
		private Color _deserterColor;

		[SerializeField]
		private Color _defaultColor;

		[Header("Texts")]
		[SerializeField]
		private LocalizedField _battlesAmountSingularText;

		[SerializeField]
		private LocalizedField _battlesAmountPlural1Text;

		[SerializeField]
		private LocalizedField _battlesAmountPlural2Text;

		[SerializeField]
		private TextMeshProUGUI _battleSeriesText;

		[SerializeField]
		private LocalizedField _battleSeriesString;

		[SerializeField]
		private LocalizedField _deserterString;

		[Space(10f)]
		[SerializeField]
		private TextMeshProUGUI _additionalExpText;

		[SerializeField]
		private LocalizedField _additionalExpString;

		[SerializeField]
		private TextMeshProUGUI _additionScoresText;

		[SerializeField]
		private LocalizedField _additionScoresString;

		[SerializeField]
		private TextMeshProUGUI _additionalMessageText;

		[SerializeField]
		private LocalizedField _nextBattleNotificationString;

		[SerializeField]
		private LocalizedField _maxSeriesAchiviedString;

		[SerializeField]
		private LocalizedField _deserterAdditionalMessageString;

		[Header("Main Icon")]
		[SerializeField]
		private TextMeshProUGUI _battleSeriesCountText;

		[SerializeField]
		private ImageSkin _battleSeriesImage;

		[SerializeField]
		private string[] _battleImageUids;

		[SerializeField]
		private string _deserterImageUid;

		public int CurrentBattleCount
		{
			set
			{
				if (value > 0)
				{
					_battleSeriesText.color = _battleSeriesColor;
					_battleSeriesText.text = string.Format(_battleSeriesString, value);
					_battleSeriesCountText.color = _battleSeriesColor;
					string text = ArabianToRomanNumConverter.ArabianToRoman(value);
					_battleSeriesCountText.text = text;
				}
				else
				{
					_battleSeriesText.color = _defaultColor;
					_battleSeriesText.text = string.Format(_deserterString, Pluralize(Mathf.Abs(value)));
				}
			}
		}

		public float BattleSeriesPercent
		{
			set
			{
				if (value > 0f)
				{
					bool flag = value >= 1f;
					_battleSeriesCountText.gameObject.SetActive(!flag);
					_additionalMessageText.text = ((!flag) ? _nextBattleNotificationString : _maxSeriesAchiviedString);
					_battleSeriesImage.SpriteUid = ((!flag) ? _battleImageUids[(int)Mathf.Floor((float)(_battleImageUids.Length - 1) * value)] : _battleImageUids[_battleImageUids.Length - 1]);
					_battleSeriesImage.GetComponent<Image>().color = _defaultColor;
				}
				else
				{
					_additionalMessageText.text = _deserterAdditionalMessageString;
					_battleSeriesCountText.gameObject.SetActive(false);
					_battleSeriesImage.SpriteUid = _deserterImageUid;
					_battleSeriesImage.GetComponent<Image>().color = _deserterColor;
				}
			}
		}

		public float ExperienceMultiplier
		{
			set
			{
				if (value > 1f)
				{
					_additionalExpText.gameObject.SetActive(true);
					string text = string.Format("{0:0}", value * 100f - 100f);
					_additionalExpText.text = string.Format(_additionalExpString, "<color=#" + _battleSeriesColor.ToHexString() + ">+" + text + "%</color>");
				}
				else
				{
					_additionalExpText.gameObject.SetActive(false);
				}
			}
		}

		public float ContainerScoreMultiplier
		{
			set
			{
				if (value > 1f)
				{
					_additionScoresText.gameObject.SetActive(true);
					string text = string.Format("{0:0}", value * 100f - 100f);
					_additionScoresText.text = string.Format(_additionScoresString, "<color=#" + _battleSeriesColor.ToHexString() + ">+" + text + "%</color>");
				}
				else
				{
					_additionScoresText.gameObject.SetActive(false);
				}
			}
		}

		private string Pluralize(int amount)
		{
			switch (CasesUtil.GetCase(amount))
			{
			case CaseType.DEFAULT:
				return string.Format(_battlesAmountPlural1Text.Value, amount);
			case CaseType.ONE:
				return string.Format(_battlesAmountSingularText.Value, amount);
			case CaseType.TWO:
				return string.Format(_battlesAmountPlural2Text.Value, amount);
			default:
				throw new Exception("ivnalid case");
			}
		}
	}
}
