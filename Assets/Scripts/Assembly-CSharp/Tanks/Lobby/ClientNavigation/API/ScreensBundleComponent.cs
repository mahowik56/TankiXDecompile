using System.Collections.Generic;
using Platform.Library.ClientUnityIntegration.API;
using UnityEngine;

namespace Tanks.Lobby.ClientNavigation.API
{
	public class ScreensBundleComponent : BehaviourComponent
	{
		[HideInInspector]
		private ScreenComponent[] screens;

		public IEnumerable<ScreenComponent> Screens
		{
			get
			{
				if (screens == null)
				{
					screens = GetComponentsInChildren<ScreenComponent>(true);
				}
				return screens;
			}
		}

		public Dialogs60Component Dialogs60
		{
			get
			{
				return GetComponentInChildren<Dialogs60Component>(true);
			}
		}

		private void Awake()
		{
			foreach (ScreenComponent screen in Screens)
			{
				if (screen.gameObject.activeSelf)
				{
					Debug.LogError("Screen is Active " + screen.name + ". Disable it in scene!");
					screen.gameObject.SetActive(false);
				}
			}
		}
	}
}
