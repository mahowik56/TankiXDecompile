using Platform.Kernel.ECS.ClientEntitySystem.API;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientControls.API
{
	public class ImageCropComponent : UIBehaviour, Platform.Kernel.ECS.ClientEntitySystem.API.Component
	{
		[SerializeField]
		private Image image;

		protected override void OnRectTransformDimensionsChange()
		{
			if (!(image == null) && !(image.overrideSprite == null))
			{
				Rect rect = image.overrideSprite.rect;
				float num = rect.width / rect.height;
				RectTransform rectTransform = (RectTransform)base.transform;
				RectTransform rectTransform2 = (RectTransform)image.transform;
				float num2 = rectTransform.rect.width / rectTransform.rect.height;
				rectTransform2.sizeDelta = ((!(num2 < num)) ? new Vector2(rectTransform.rect.width, rectTransform.rect.width / num) : new Vector2(num * rectTransform.rect.height, rectTransform.rect.height));
			}
		}
	}
}
