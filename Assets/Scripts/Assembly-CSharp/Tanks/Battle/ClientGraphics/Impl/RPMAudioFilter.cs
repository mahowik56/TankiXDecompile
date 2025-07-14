using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class RPMAudioFilter : AbstractRPMSoundUpdater
	{
		private float previousEngineRPM;

		private float previousEngineLoad;

		private void OnAudioFilterRead(float[] data, int channels)
		{
			int num = data.Length;
			bool flag = true;
			for (int i = 0; i < num; i++)
			{
				float t = (float)i / (float)num;
				float num2 = Mathf.Lerp(previousEngineRPM, engine.EngineRpm, t);
				float smoothedLoad = Mathf.Lerp(previousEngineLoad, engine.EngineLoad, t);
				if (!engine.IsRPMWithinRange(rpmSoundBehaviour, num2))
				{
					data[i] = 0f;
					flag = (byte)((flag ? 1u : 0u) & 1u) != 0;
				}
				else if (!parentModifier.CheckLoad(smoothedLoad))
				{
					data[i] = 0f;
					flag = false;
				}
				else
				{
					data[i] *= parentModifier.RpmSoundVolume;
					data[i] *= parentModifier.CalculateModifier(num2, smoothedLoad);
					flag = false;
				}
			}
			parentModifier.NeedToStop = flag;
			UpdatePreviousParameters();
		}

		private void UpdatePreviousParameters()
		{
			previousEngineLoad = engine.EngineLoad;
			previousEngineRPM = engine.EngineRpm;
		}

		public override void Play()
		{
			if (!parentModifier.Source.isPlaying)
			{
				UpdatePreviousParameters();
			}
			base.Play();
		}
	}
}
