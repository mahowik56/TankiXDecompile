using Tanks.Lobby.ClientSettings.API;
using UnityEngine;
using UnityEngine.PostProcessing;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class HangarCameraPostProcessingActivator : MonoBehaviour
	{
		public PostProcessingProfile profile;

		private float saturation;

		[SerializeField]
		private MonoBehaviour Bloom;

		[SerializeField]
		private MonoBehaviour Fog;

		[SerializeField]
		private MonoBehaviour TargetBloom;

		public static GameObject ActivePanel;

		public float FocusDistance;

		public Animator blurAnimator;

		private bool lowRenderResolution;

		private int screenWidth;

		private int screenHeight;

		private RenderTexture texture;

		private float renderCoeff = 0.7f;

		private void Start()
		{
			if (GraphicsSettings.INSTANCE != null && GraphicsSettings.INSTANCE.customSettings)
			{
				lowRenderResolution = GraphicsSettings.INSTANCE.CurrentRenderResolutionQuality == 1;
			}
			else
			{
				lowRenderResolution = QualitySettings.GetQualityLevel() == 0;
			}
			if (lowRenderResolution)
			{
				CreateRenderTexture();
			}
		}

		private void OnEnable()
		{
			PostProcessingBehaviour component = GetComponent<PostProcessingBehaviour>();
			if (component.profile == null)
			{
				base.enabled = false;
				return;
			}
			profile = Object.Instantiate(component.profile);
			component.profile = profile;
			DisableAllEffects(profile);
			int qualityLevel = QualitySettings.GetQualityLevel();
			profile.depthOfField.enabled = qualityLevel >= 2;
			Fog.enabled = qualityLevel >= 2;
			profile.colorGrading.enabled = true;
			ColorGradingModel.Settings settings = profile.colorGrading.settings;
			saturation = ((GraphicsSettings.INSTANCE != null) ? GraphicsSettings.INSTANCE.CurrentSaturationLevel : 1f);
			settings.basic.saturation = saturation;
			profile.colorGrading.settings = settings;
			if (GraphicsSettings.INSTANCE != null && GraphicsSettings.INSTANCE.customSettings)
			{
				profile.antialiasing.enabled = GraphicsSettings.INSTANCE.CurrentAntialiasingQuality != 0;
				if (profile.antialiasing.enabled)
				{
					AntialiasingModel.Settings settings2 = profile.antialiasing.settings;
					settings2.method = ((qualityLevel > 3) ? AntialiasingModel.Method.Taa : AntialiasingModel.Method.Fxaa);
					profile.antialiasing.settings = settings2;
				}
				profile.ambientOcclusion.enabled = GraphicsSettings.INSTANCE.currentAmbientOcclusion;
				profile.bloom.enabled = GraphicsSettings.INSTANCE.currentBloom;
				TargetBloom.enabled = GraphicsSettings.INSTANCE.currentBloom;
				profile.chromaticAberration.enabled = GraphicsSettings.INSTANCE.currentChromaticAberration;
				profile.grain.enabled = GraphicsSettings.INSTANCE.currentGrain;
				profile.vignette.enabled = GraphicsSettings.INSTANCE.currentVignette;
			}
			else
			{
				profile.antialiasing.enabled = qualityLevel >= 2;
				if (profile.antialiasing.enabled)
				{
					AntialiasingModel.Settings settings3 = profile.antialiasing.settings;
					settings3.method = ((qualityLevel > 3) ? AntialiasingModel.Method.Taa : AntialiasingModel.Method.Fxaa);
					profile.antialiasing.settings = settings3;
				}
				profile.chromaticAberration.enabled = qualityLevel >= 2;
				profile.bloom.enabled = qualityLevel >= 3;
				TargetBloom.enabled = qualityLevel >= 3;
				profile.grain.enabled = qualityLevel >= 3;
				profile.vignette.enabled = qualityLevel >= 3;
				profile.ambientOcclusion.enabled = qualityLevel >= 4;
			}
		}

		private void Update()
		{
			if (GraphicsSettings.INSTANCE != null && saturation != GraphicsSettings.INSTANCE.CurrentSaturationLevel)
			{
				ColorGradingModel.Settings settings = profile.colorGrading.settings;
				saturation = GraphicsSettings.INSTANCE.CurrentSaturationLevel;
				settings.basic.saturation = saturation;
				profile.colorGrading.settings = settings;
			}
			if (ActivePanel != null && ActivePanel.activeInHierarchy)
			{
				blurAnimator.SetBool("Blur", true);
			}
			else
			{
				blurAnimator.SetBool("Blur", false);
			}
		}

		private void OnPreRender()
		{
			if (lowRenderResolution)
			{
				Camera.main.targetTexture = texture;
				if (screenWidth != Screen.width || screenHeight != Screen.height)
				{
					CreateRenderTexture();
				}
			}
		}

		private void OnPostRender()
		{
			if (lowRenderResolution)
			{
				Camera.main.targetTexture = null;
			}
		}

		private void CreateRenderTexture()
		{
			screenWidth = Screen.width;
			screenHeight = Screen.height;
			texture = new RenderTexture((int)((float)Screen.width * renderCoeff), (int)((float)Screen.height * renderCoeff), 0);
			RenderTexture.active = texture;
			QualitySettings.pixelLightCount = 0;
		}

		private void DisableAllEffects(PostProcessingProfile postProcessingProfile)
		{
			Bloom.enabled = false;
			Fog.enabled = false;
			TargetBloom.enabled = false;
			postProcessingProfile.ambientOcclusion.enabled = false;
			postProcessingProfile.antialiasing.enabled = false;
			postProcessingProfile.bloom.enabled = false;
			postProcessingProfile.chromaticAberration.enabled = false;
			postProcessingProfile.colorGrading.enabled = false;
			postProcessingProfile.debugViews.enabled = false;
			postProcessingProfile.depthOfField.enabled = false;
			postProcessingProfile.dithering.enabled = false;
			postProcessingProfile.eyeAdaptation.enabled = false;
			postProcessingProfile.fog.enabled = false;
			postProcessingProfile.grain.enabled = false;
			postProcessingProfile.motionBlur.enabled = false;
			postProcessingProfile.screenSpaceReflection.enabled = false;
			postProcessingProfile.userLut.enabled = false;
			postProcessingProfile.vignette.enabled = false;
		}
	}
}
