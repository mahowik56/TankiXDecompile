using System.Text;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientDataStructures.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientUserProfile.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class DetailBonusView : MonoBehaviour
	{
		public ImageSkin[] imageSkins;

		public TextMeshProUGUI text;

		private readonly StringBuilder stringBuilder = new StringBuilder(20);

		public GameObject brokenBack;

		private string mainText;

		[Inject]
		public static GarageItemsRegistry GarageItemsRegistry { get; set; }

		private void Awake()
		{
			mainText = LocalizationUtils.Localize(text.GetComponent<TMPLocalize>().TextUid);
		}

		public void UpdateView(DailyBonusGarageItemReward detailMarketItem)
		{
			DetailItem detailItem = GarageItemsRegistry.GetItem<DetailItem>(detailMarketItem.MarketItemId);
			imageSkins.ForEach(delegate(ImageSkin i)
			{
				i.SpriteUid = detailItem.Preview;
			});
			stringBuilder.Length = 0;
			stringBuilder.Append(mainText);
			stringBuilder.AppendFormat(" {0}/{1}", detailItem.Count + 1, detailItem.RequiredCount);
			text.text = stringBuilder.ToString();
		}

		public void UpdateViewByMarketItem(long marketItem)
		{
			DetailItem detailItem = GarageItemsRegistry.GetItem<DetailItem>(marketItem);
			imageSkins.ForEach(delegate(ImageSkin i)
			{
				i.SpriteUid = detailItem.Preview;
			});
			stringBuilder.Length = 0;
			stringBuilder.Append(mainText);
			stringBuilder.AppendFormat(" {0}/{1}", detailItem.Count + 1, detailItem.RequiredCount);
			text.text = stringBuilder.ToString();
		}
	}
}
