using Platform.Library.ClientUnityIntegration.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class AmbientZoneSoundEffectMarkerComponent : BehaviourComponent
	{
		[SerializeField]
		private AmbientZoneSoundEffect ambientZoneSoundEffect;

		public AmbientZoneSoundEffect AmbientZoneSoundEffect
		{
			get
			{
				return ambientZoneSoundEffect;
			}
		}
	}
}
