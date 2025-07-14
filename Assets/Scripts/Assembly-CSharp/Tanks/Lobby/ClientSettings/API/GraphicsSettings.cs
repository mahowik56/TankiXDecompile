using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Tanks.Lobby.ClientSettings.API
{
	public class GraphicsSettings
	{
		private const string WIPE_GRAPHICS_SETTINGS_KEY = "WIPE_GRAPHICS_SETTINGS";

		private const string SATURATION_SHADER_PARAMETER = "_GraphicsSettingsSaturationLevel";

		private const string QUALITY_LEVEL_KEY = "QUALITY_LEVEL_INDEX";

		private const string VEGETATION_LEVEL_KEY = "VEGETATION_LEVEL_INDEX";

		private const string FAR_FOLIAGE_ENABLE_KEY = "FAR_FOLIAGE_ENABLE";

		private const string BILLBOARD_TREES_SHADOWCASTING_KEY = "BILLBOARD_TREES_SHADOWCASTING";

		private const string TREES_SHADOW_RECIEVING = "TREES_SHADOW_RECIEVING";

		private const string GRASS_LEVEL_KEY = "GRASS_LEVEL_INDEX";

		private const string GRASS_FAR_DRAW_DISTANCE_KEY = "GRASS_FAR_DRAW_DISTANCE";

		private const string GRASS_NEAR_DRAW_DISTANCE_KEY = "GRASS_NEAR_DRAW_DISTANCE";

		private const string GRASS_FADE_RANGE_KEY = "GRASS_FADE_RANGE";

		private const string GRASS_DENSITY_MULTIPLIER_KEY = "GRASS_DENSITY_MULTIPLIER";

		private const string GRASS_CASTS_SHADOW_KEY = "GRASS_CASTS_SHADOW";

		private const string SCREEN_RESOLUTION_WIDTH_KEY = "SCREEN_RESOLUTION_WIDTH";

		private const string SCREEN_RESOLUTION_HEIGHT_KEY = "SCREEN_RESOLUTION_HEIGHT";

		private const string SATURATION_LEVEL_KEY = "SATURATION_LEVEL";

		private const string RENDER_RESOLUTION_QUALITY_KEY = "RENDER_RESOLUTION_QUALITY";

		private const string ANTIALIASING_LEVEL_KEY = "ANTIALIASING_LEVEL";

		private const string CARTRIDGE_CASE_AMOUNT_KEY = "CARTRIDGE_CASE_AMOUNT";

		private const string VSYNC_KEY = "VSYNC";

		private const string WINDOW_MODE_KEY = "WINDOW_MODE";

		private const string NO_COMPACT_WINDOW_KEY = "NO_COMPACT_WINDOW";

		private const string ANISOTROPIC_LEVEL_KEY = "ANISOTROPIC_LEVEL";

		private const string SHADOW_LEVEL_KEY = "SHADOW_LEVEL";

		private const string TEXTURE_LEVEL_KEY = "TEXTURE_LEVEL";

		private const string PARTICLE_LEVEL_KEY = "PARTICLE_LEVEL";

		private const string ULTRA_LOW_SETTINGS_FLAG = "ULTRA_LOW_SETTINGS_FLAG";

		private int currentQualityLevel;

		private int currentVegetationLevel;

		private bool currentFarFoliageEnabled;

		private bool currentBillboardTreesShadowCasting;

		private bool currentTreesShadowRecieving;

		private int currentGrassLevel;

		private float currentGrassFarDrawDistance;

		private float currentGrassNearDrawDistance;

		private float currentGrassFadeRange;

		private float currentGrassDensityMultiplier;

		private bool currentGrassCastsShadow;

		private float currentSaturationLevel;

		private int currentRenderResolutionQuality;

		private int currentAntialiasingQuality;

		private int currentAnisotropicQuality;

		private int currentCartridgeCaseAmount;

		private int currentVSyncQuality;

		private int currentShadowQuality;

		private int currentTextureQuality;

		private int currentParticleQuality;

		private Resolution currentResolution;

		private CompactScreenBehaviour compactScreen;

		public bool customSettings;

		public bool currentAmbientOcclusion;

		public bool currentBloom;

		public bool currentChromaticAberration;

		public bool currentGrain;

		public bool currentVignette;

		private int CurrentSettingsVersion = 333;

		public static GraphicsSettings INSTANCE { get; set; }

		public bool WindowedByDefault { get; private set; }

		public bool InitialWindowed { get; private set; }

		public int DefaultQualityLevel
		{
			get
			{
				return DefaultQuality.Level;
			}
		}

		public Quality DefaultQuality { get; private set; }

		public bool UltraEnabled { get; private set; }

		public int CurrentQualityLevel
		{
			get
			{
				return currentQualityLevel;
			}
			private set
			{
				currentQualityLevel = value;
				PlayerPrefs.SetInt("QUALITY_LEVEL_INDEX", currentQualityLevel);
				PlayerPrefs.SetInt("ULTRA_LOW_SETTINGS_FLAG", currentQualityLevel);
			}
		}

		public int DefaultVegetationLevel { get; private set; }

		public int CurrentVegetationLevel
		{
			get
			{
				return currentVegetationLevel;
			}
			private set
			{
				currentVegetationLevel = value;
				PlayerPrefs.SetInt("VEGETATION_LEVEL_INDEX", currentVegetationLevel);
			}
		}

		public bool DefaultFarFoliageEnabled { get; private set; }

		public bool CurrentFarFoliageEnabled
		{
			get
			{
				return currentFarFoliageEnabled;
			}
			private set
			{
				currentFarFoliageEnabled = value;
				PlayerPrefs.SetInt("FAR_FOLIAGE_ENABLE", (!currentFarFoliageEnabled) ? 1 : 0);
			}
		}

		public bool DefaultBillboardTreesShadowCasting { get; private set; }

		public bool CurrentBillboardTreesShadowCasting
		{
			get
			{
				return currentBillboardTreesShadowCasting;
			}
			private set
			{
				currentBillboardTreesShadowCasting = value;
				PlayerPrefs.SetInt("BILLBOARD_TREES_SHADOWCASTING", (!currentBillboardTreesShadowCasting) ? 1 : 0);
			}
		}

		public bool DefaultTreesShadowRecieving { get; private set; }

		public bool CurrentTreesShadowRecieving
		{
			get
			{
				return currentTreesShadowRecieving;
			}
			private set
			{
				currentTreesShadowRecieving = value;
				PlayerPrefs.SetInt("TREES_SHADOW_RECIEVING", (!currentTreesShadowRecieving) ? 1 : 0);
			}
		}

		public int DefaultGrassLevel { get; private set; }

		public int CurrentGrassLevel
		{
			get
			{
				return currentGrassLevel;
			}
			private set
			{
				currentGrassLevel = value;
				PlayerPrefs.SetInt("GRASS_LEVEL_INDEX", currentGrassLevel);
			}
		}

		public float DefaultGrassFarDrawDistance { get; private set; }

		public float CurrentGrassFarDrawDistance
		{
			get
			{
				return currentGrassFarDrawDistance;
			}
			private set
			{
				currentGrassFarDrawDistance = value;
				PlayerPrefs.SetFloat("GRASS_FAR_DRAW_DISTANCE", currentGrassFarDrawDistance);
			}
		}

		public float DefaultGrassNearDrawDistance { get; private set; }

		public float CurrentGrassNearDrawDistance
		{
			get
			{
				return currentGrassNearDrawDistance;
			}
			private set
			{
				currentGrassNearDrawDistance = value;
				PlayerPrefs.SetFloat("GRASS_NEAR_DRAW_DISTANCE", currentGrassNearDrawDistance);
			}
		}

		public float DefaultGrassFadeRange { get; private set; }

		public float CurrentGrassFadeRange
		{
			get
			{
				return currentGrassFadeRange;
			}
			private set
			{
				currentGrassFadeRange = value;
				PlayerPrefs.SetFloat("GRASS_FADE_RANGE", currentGrassFadeRange);
			}
		}

		public float DefaultGrassDensityMultiplier { get; private set; }

		public float CurrentGrassDensityMultiplier
		{
			get
			{
				return currentGrassDensityMultiplier;
			}
			private set
			{
				currentGrassDensityMultiplier = value;
				PlayerPrefs.SetFloat("GRASS_DENSITY_MULTIPLIER", currentGrassDensityMultiplier);
			}
		}

		public bool DefaultGrassCastsShadow { get; private set; }

		public bool CurrentGrassCastsShadow
		{
			get
			{
				return currentGrassCastsShadow;
			}
			private set
			{
				currentGrassCastsShadow = value;
				PlayerPrefs.SetInt("GRASS_CASTS_SHADOW", (!currentGrassCastsShadow) ? 1 : 0);
			}
		}

		public float DefaultSaturationLevel { get; private set; }

		public float CurrentSaturationLevel
		{
			get
			{
				return currentSaturationLevel;
			}
			private set
			{
				currentSaturationLevel = value;
				PlayerPrefs.SetFloat("SATURATION_LEVEL", currentSaturationLevel);
			}
		}

		public int DefaultAnisotropicQuality { get; private set; }

		public int CurrentAnisotropicQuality
		{
			get
			{
				return currentAnisotropicQuality;
			}
			private set
			{
				currentAnisotropicQuality = value;
				PlayerPrefs.SetInt("ANISOTROPIC_LEVEL", currentAnisotropicQuality);
			}
		}

		public int DefaultVSyncQuality { get; private set; }

		public int CurrentVSyncQuality
		{
			get
			{
				return currentVSyncQuality;
			}
			private set
			{
				currentVSyncQuality = value;
				PlayerPrefs.SetInt("VSYNC", currentVSyncQuality);
			}
		}

		public int DefaultShadowQuality { get; private set; }

		public int CurrentShadowQuality
		{
			get
			{
				return currentShadowQuality;
			}
			private set
			{
				currentShadowQuality = value;
				PlayerPrefs.SetInt("SHADOW_LEVEL", currentShadowQuality);
			}
		}

		public int DefaultTextureQuality { get; private set; }

		public int CurrentTextureQuality
		{
			get
			{
				return currentTextureQuality;
			}
			private set
			{
				currentTextureQuality = value;
				PlayerPrefs.SetInt("TEXTURE_LEVEL", currentTextureQuality);
			}
		}

		public int DefaultParticleQuality { get; private set; }

		public int CurrentParticleQuality
		{
			get
			{
				return currentParticleQuality;
			}
			private set
			{
				currentParticleQuality = value;
				PlayerPrefs.SetInt("PARTICLE_LEVEL", currentParticleQuality);
			}
		}

		public int DefaultRenderResolutionQuality { get; private set; }

		public int CurrentRenderResolutionQuality
		{
			get
			{
				return currentRenderResolutionQuality;
			}
			private set
			{
				currentRenderResolutionQuality = value;
				PlayerPrefs.SetInt("RENDER_RESOLUTION_QUALITY", currentRenderResolutionQuality);
			}
		}

		public int DefaultAntialiasingQuality { get; private set; }

		public int CurrentAntialiasingQuality
		{
			get
			{
				return currentAntialiasingQuality;
			}
			private set
			{
				currentAntialiasingQuality = value;
				PlayerPrefs.SetInt("ANTIALIASING_LEVEL", currentAntialiasingQuality);
			}
		}

		public int DefaultCartridgeCaseAmount { get; private set; }

		public int CurrentCartridgeCaseAmount
		{
			get
			{
				return currentCartridgeCaseAmount;
			}
			private set
			{
				currentCartridgeCaseAmount = value;
				PlayerPrefs.SetInt("CARTRIDGE_CASE_AMOUNT", currentCartridgeCaseAmount);
			}
		}

		public List<Resolution> ScreenResolutions { get; private set; }

		public Resolution DefaultResolution { get; private set; }

		public Resolution CurrentResolution
		{
			get
			{
				return currentResolution;
			}
			private set
			{
				currentResolution = value;
				PlayerPrefs.SetInt("SCREEN_RESOLUTION_WIDTH", currentResolution.width);
				PlayerPrefs.SetInt("SCREEN_RESOLUTION_HEIGHT", currentResolution.height);
			}
		}

		public void ApplyQualityLevel(int qualityLevel)
		{
			CurrentQualityLevel = qualityLevel;
		}

		public void ApplyWindowMode(bool windowed)
		{
			Screen.fullScreen = !windowed;
		}

		public void ApplyVegetationLevel(int currentValue, int defaultValue)
		{
			DefaultVegetationLevel = defaultValue;
			ApplyVegetationLevel(currentValue);
		}

		public void ApplyVegetationLevel(int currentValue)
		{
			CurrentVegetationLevel = currentValue;
		}

		public void ApplyFarFoliageEnabled(bool currentValue, bool defaultValue)
		{
			DefaultFarFoliageEnabled = defaultValue;
			ApplyFarFoliageEnabled(currentValue);
		}

		public void ApplyFarFoliageEnabled(bool currentValue)
		{
			CurrentFarFoliageEnabled = true;
		}

		public void ApplyBillboardTreesShadowCasting(bool currentValue, bool defaultValue)
		{
			DefaultBillboardTreesShadowCasting = defaultValue;
			ApplyBillboardTreesShadowCasting(currentValue);
		}

		public void ApplyBillboardTreesShadowCasting(bool currentValue)
		{
			CurrentBillboardTreesShadowCasting = currentValue;
		}

		public void ApplyTreesShadowRecieving(bool currentValue, bool defaultValue)
		{
			DefaultTreesShadowRecieving = defaultValue;
			ApplyTreesShadowRecieving(currentValue);
		}

		public void ApplyTreesShadowRecieving(bool currentValue)
		{
			CurrentTreesShadowRecieving = currentValue;
		}

		public void ApplyGrassLevel(int currentValue, int defaultValue)
		{
			DefaultGrassLevel = defaultValue;
			ApplyGrassLevel(currentValue);
		}

		public void ApplyGrassLevel(int currentValue)
		{
			CurrentGrassLevel = currentValue;
		}

		public void ApplyGrassFarDrawDistance(float currentValue, float defaultValue)
		{
			DefaultGrassFarDrawDistance = defaultValue;
			ApplyGrassFarDrawDistance(currentValue);
		}

		public void ApplyGrassFarDrawDistance(float currentValue)
		{
			CurrentGrassFarDrawDistance = currentValue;
		}

		public void ApplyGrassNearDrawDistance(float currentValue, float defaultValue)
		{
			DefaultGrassNearDrawDistance = defaultValue;
			ApplyGrassNearDrawDistance(currentValue);
		}

		public void ApplyGrassNearDrawDistance(float currentValue)
		{
			CurrentGrassNearDrawDistance = currentValue;
		}

		public void ApplyGrassFadeRange(float currentValue, float defaultValue)
		{
			DefaultGrassFadeRange = defaultValue;
			ApplyGrassFadeRange(currentValue);
		}

		public void ApplyGrassFadeRange(float currentValue)
		{
			CurrentGrassFadeRange = currentValue;
		}

		public void ApplyGrassDensityMultiplier(float currentValue, float defaultValue)
		{
			DefaultGrassDensityMultiplier = defaultValue;
			ApplyGrassDensityMultiplier(currentValue);
		}

		public void ApplyGrassDensityMultiplier(float currentValue)
		{
			CurrentGrassDensityMultiplier = currentValue;
		}

		public void ApplyGrassCastsShadow(bool currentValue, bool defaultValue)
		{
			DefaultGrassCastsShadow = defaultValue;
			ApplyGrassCastsShadow(currentValue);
		}

		public void ApplyGrassCastsShadow(bool currentValue)
		{
			CurrentGrassCastsShadow = currentValue;
		}

		public void ApplySaturationLevel(float currentValue, float defaultValue)
		{
			DefaultSaturationLevel = defaultValue;
			ApplySaturationLevel(currentValue);
		}

		public void ApplySaturationLevel(float currentValue)
		{
			CurrentSaturationLevel = currentValue;
			Shader.SetGlobalFloat("_GraphicsSettingsSaturationLevel", currentSaturationLevel);
		}

		public void ApplyRenderResolutionQuality(int currentValue, int defaultValue)
		{
			DefaultRenderResolutionQuality = defaultValue;
			ApplyRenderResolutionQuality(currentValue);
		}

		public void ApplyRenderResolutionQuality(int currentValue)
		{
			CurrentRenderResolutionQuality = currentValue;
		}

		public void ApplyAntialiasingQuality(int currentValue, int defaultValue)
		{
			DefaultAntialiasingQuality = defaultValue;
			ApplyAntialiasingQuality(currentValue);
		}

		public void ApplyAntialiasingQuality(int currentValue)
		{
			CurrentAntialiasingQuality = currentValue;
		}

		public void ApplyCartridgeCaseAmount(int currentValue, int defaultValue)
		{
			DefaultCartridgeCaseAmount = defaultValue;
			ApplyCartridgeCaseAmount(currentValue);
		}

		public void ApplyCartridgeCaseAmount(int currentValue)
		{
			CurrentCartridgeCaseAmount = currentValue;
		}

		public void ApplyVSyncQuality(int currentValue, int defaultValue)
		{
			DefaultVSyncQuality = defaultValue;
			ApplyVSyncQuality(currentValue);
		}

		public void ApplyVSyncQuality(int currentValue)
		{
			CurrentVSyncQuality = currentValue;
		}

		public void ApplyAnisotropicQuality(int currentValue, int defaultValue)
		{
			DefaultAnisotropicQuality = defaultValue;
			ApplyAnisotropicQuality(currentValue);
		}

		public void ApplyAnisotropicQuality(int currentValue)
		{
			CurrentAnisotropicQuality = currentValue;
		}

		public void ApplyTextureQuality(int currentValue, int defaultValue)
		{
			DefaultTextureQuality = defaultValue;
			ApplyTextureQuality(currentValue);
		}

		public void ApplyTextureQuality(int currentValue)
		{
			CurrentTextureQuality = currentValue;
		}

		public void ApplyParticleQuality(int currentValue, int defaultValue)
		{
			DefaultParticleQuality = defaultValue;
			ApplyParticleQuality(currentValue);
		}

		public void ApplyParticleQuality(int currentValue)
		{
			CurrentParticleQuality = currentValue;
		}

		public void ApplyShadowQuality(int currentValue, int defaultValue)
		{
			DefaultShadowQuality = defaultValue;
			ApplyShadowQuality(currentValue);
		}

		public void ApplyShadowQuality(int currentValue)
		{
			CurrentShadowQuality = currentValue;
		}

		public void ApplyScreenResolution(int width, int height, bool windowed)
		{
			PlayerPrefs.SetInt("SCREEN_RESOLUTION_WIDTH", width);
			PlayerPrefs.SetInt("SCREEN_RESOLUTION_HEIGHT", height);
			Screen.SetResolution(width, height, !windowed);
		}

		public void InitSaturationLevelSettings(float defaultSaturationLevel)
		{
			DefaultSaturationLevel = defaultSaturationLevel;
			if (PlayerPrefs.HasKey("SATURATION_LEVEL"))
			{
				currentSaturationLevel = PlayerPrefs.GetFloat("SATURATION_LEVEL");
			}
			else
			{
				CurrentSaturationLevel = DefaultSaturationLevel;
			}
		}

		public void InitVegetationLevelSettings(int defaultVegetationLevel)
		{
			DefaultVegetationLevel = defaultVegetationLevel;
			if (PlayerPrefs.HasKey("VEGETATION_LEVEL_INDEX"))
			{
				currentVegetationLevel = PlayerPrefs.GetInt("VEGETATION_LEVEL_INDEX");
			}
			else
			{
				CurrentVegetationLevel = DefaultVegetationLevel;
			}
		}

		public void InitFarFoliageEnabled(bool defaultFarFoliageEnabled)
		{
			DefaultFarFoliageEnabled = defaultFarFoliageEnabled;
			if (PlayerPrefs.HasKey("FAR_FOLIAGE_ENABLE"))
			{
				if (PlayerPrefs.GetInt("FAR_FOLIAGE_ENABLE") == 0)
				{
					currentFarFoliageEnabled = false;
				}
				if (PlayerPrefs.GetInt("FAR_FOLIAGE_ENABLE") == 1)
				{
					currentFarFoliageEnabled = true;
				}
			}
			else
			{
				CurrentFarFoliageEnabled = DefaultFarFoliageEnabled;
			}
		}

		public void InitBillboardTreesShadowCasting(bool defaultBillboardTreesShadowCasting)
		{
			DefaultBillboardTreesShadowCasting = defaultBillboardTreesShadowCasting;
			if (PlayerPrefs.HasKey("BILLBOARD_TREES_SHADOWCASTING"))
			{
				if (PlayerPrefs.GetInt("BILLBOARD_TREES_SHADOWCASTING") == 0)
				{
					currentBillboardTreesShadowCasting = false;
				}
				if (PlayerPrefs.GetInt("BILLBOARD_TREES_SHADOWCASTING") == 1)
				{
					currentBillboardTreesShadowCasting = true;
				}
			}
			else
			{
				CurrentBillboardTreesShadowCasting = DefaultBillboardTreesShadowCasting;
			}
		}

		public void InitTreesShadowRecieving(bool defaultTreesShadowRecieving)
		{
			DefaultTreesShadowRecieving = defaultTreesShadowRecieving;
			if (PlayerPrefs.HasKey("TREES_SHADOW_RECIEVING"))
			{
				if (PlayerPrefs.GetInt("TREES_SHADOW_RECIEVING") == 0)
				{
					currentBillboardTreesShadowCasting = false;
				}
				if (PlayerPrefs.GetInt("TREES_SHADOW_RECIEVING") == 1)
				{
					currentBillboardTreesShadowCasting = true;
				}
			}
			else
			{
				CurrentTreesShadowRecieving = DefaultTreesShadowRecieving;
			}
		}

		public void InitGrassLevelSettings(int defaultGrassLevel)
		{
			DefaultGrassLevel = defaultGrassLevel;
			if (PlayerPrefs.HasKey("GRASS_LEVEL_INDEX"))
			{
				currentGrassLevel = PlayerPrefs.GetInt("GRASS_LEVEL_INDEX");
			}
			else
			{
				CurrentGrassLevel = DefaultGrassLevel;
			}
		}

		public void InitGrassFarDrawDistance(float defaultGrassFarDrawDistance)
		{
			DefaultGrassFarDrawDistance = defaultGrassFarDrawDistance;
			if (PlayerPrefs.HasKey("GRASS_FAR_DRAW_DISTANCE"))
			{
				currentGrassFarDrawDistance = PlayerPrefs.GetFloat("GRASS_FAR_DRAW_DISTANCE");
			}
			else
			{
				CurrentGrassFarDrawDistance = DefaultGrassFarDrawDistance;
			}
		}

		public void InitGrassNearDrawDistance(float defaultGrassNearDrawDistance)
		{
			DefaultGrassNearDrawDistance = defaultGrassNearDrawDistance;
			if (PlayerPrefs.HasKey("GRASS_NEAR_DRAW_DISTANCE"))
			{
				currentGrassNearDrawDistance = PlayerPrefs.GetFloat("GRASS_NEAR_DRAW_DISTANCE");
			}
			else
			{
				CurrentGrassNearDrawDistance = DefaultGrassNearDrawDistance;
			}
		}

		public void InitGrassFadeRange(float defaultGrassFadeRange)
		{
			DefaultGrassFadeRange = defaultGrassFadeRange;
			if (PlayerPrefs.HasKey("GRASS_FADE_RANGE"))
			{
				currentGrassFadeRange = PlayerPrefs.GetFloat("GRASS_FADE_RANGE");
			}
			else
			{
				CurrentGrassFadeRange = DefaultGrassFadeRange;
			}
		}

		public void InitGrassDensityMultiplier(float defaultGrassDensityMultiplier)
		{
			DefaultGrassDensityMultiplier = defaultGrassDensityMultiplier;
			if (PlayerPrefs.HasKey("GRASS_DENSITY_MULTIPLIER"))
			{
				currentGrassDensityMultiplier = PlayerPrefs.GetFloat("GRASS_DENSITY_MULTIPLIER");
			}
			else
			{
				CurrentGrassDensityMultiplier = DefaultGrassDensityMultiplier;
			}
		}

		public void InitGrassCastsShadow(bool defaultGrassCastsShadow)
		{
			DefaultGrassCastsShadow = defaultGrassCastsShadow;
			if (PlayerPrefs.HasKey("GRASS_CASTS_SHADOW"))
			{
				if (PlayerPrefs.GetInt("GRASS_CASTS_SHADOW") == 0)
				{
					currentGrassCastsShadow = false;
				}
				if (PlayerPrefs.GetInt("GRASS_CASTS_SHADOW") == 1)
				{
					currentGrassCastsShadow = true;
				}
			}
			else
			{
				CurrentGrassCastsShadow = DefaultGrassCastsShadow;
			}
		}

		public void InitRenderResolutionQualitySettings(int defaultRenderResolutionQuality)
		{
			DefaultRenderResolutionQuality = defaultRenderResolutionQuality;
			if (PlayerPrefs.HasKey("RENDER_RESOLUTION_QUALITY"))
			{
				currentRenderResolutionQuality = PlayerPrefs.GetInt("RENDER_RESOLUTION_QUALITY");
			}
			else
			{
				CurrentRenderResolutionQuality = DefaultRenderResolutionQuality;
			}
		}

		public void InitAntialiasingQualitySettings(int defaultAntialiasingQuality)
		{
			DefaultAntialiasingQuality = defaultAntialiasingQuality;
			if (PlayerPrefs.HasKey("ANTIALIASING_LEVEL"))
			{
				currentAntialiasingQuality = PlayerPrefs.GetInt("ANTIALIASING_LEVEL");
			}
			else
			{
				CurrentAntialiasingQuality = DefaultAntialiasingQuality;
			}
		}

		public void InitAnisotropicQualitySettings(int defaultAnisotropicQuality)
		{
			DefaultAnisotropicQuality = defaultAnisotropicQuality;
			if (PlayerPrefs.HasKey("ANISOTROPIC_LEVEL"))
			{
				currentAnisotropicQuality = PlayerPrefs.GetInt("ANISOTROPIC_LEVEL");
			}
			else
			{
				CurrentAnisotropicQuality = DefaultAnisotropicQuality;
			}
		}

		public void InitTextureQualitySettings(int defaultTextureQuality)
		{
			DefaultTextureQuality = defaultTextureQuality;
			if (PlayerPrefs.HasKey("TEXTURE_LEVEL"))
			{
				currentTextureQuality = PlayerPrefs.GetInt("TEXTURE_LEVEL");
			}
			else
			{
				CurrentTextureQuality = DefaultTextureQuality;
			}
		}

		public void InitParticleQualitySettings(int defaultParticleQuality)
		{
			DefaultParticleQuality = defaultParticleQuality;
			if (PlayerPrefs.HasKey("PARTICLE_LEVEL"))
			{
				currentParticleQuality = PlayerPrefs.GetInt("PARTICLE_LEVEL");
			}
			else
			{
				CurrentParticleQuality = DefaultParticleQuality;
			}
		}

		public void InitShadowQualitySettings(int defaultShadowQuality)
		{
			DefaultShadowQuality = defaultShadowQuality;
			if (PlayerPrefs.HasKey("SHADOW_LEVEL"))
			{
				currentShadowQuality = PlayerPrefs.GetInt("SHADOW_LEVEL");
			}
			else
			{
				CurrentShadowQuality = DefaultShadowQuality;
			}
		}

		public void InitQualitySettings(Quality defaultQuality, bool ultraEnabled)
		{
			DefaultQuality = defaultQuality;
			UltraEnabled = ultraEnabled;
			WipeSettings(CurrentSettingsVersion);
			if (PlayerPrefs.HasKey("QUALITY_LEVEL_INDEX"))
			{
				if (PlayerPrefs.HasKey("ULTRA_LOW_SETTINGS_FLAG"))
				{
					currentQualityLevel = PlayerPrefs.GetInt("QUALITY_LEVEL_INDEX");
				}
				else
				{
					currentQualityLevel++;
				}
			}
			else
			{
				CurrentQualityLevel = DefaultQualityLevel;
			}
			QualitySettings.SetQualityLevel(CurrentQualityLevel, true);
		}

		public void InitCartridgeCaseAmount(int defaultAmount)
		{
			currentCartridgeCaseAmount = defaultAmount;
			if (PlayerPrefs.HasKey("CARTRIDGE_CASE_AMOUNT"))
			{
				currentCartridgeCaseAmount = PlayerPrefs.GetInt("CARTRIDGE_CASE_AMOUNT");
			}
			else
			{
				CurrentCartridgeCaseAmount = DefaultCartridgeCaseAmount;
			}
		}

		public void InitVSyncQualitySettings(int defaultVSyncQuality)
		{
			DefaultVSyncQuality = defaultVSyncQuality;
			if (PlayerPrefs.HasKey("VSYNC"))
			{
				currentVSyncQuality = PlayerPrefs.GetInt("VSYNC");
			}
			else
			{
				CurrentVSyncQuality = DefaultVSyncQuality;
			}
		}

		public void InitScreenResolutionSettings(List<Resolution> avaiableResolutions, Resolution defaultResolution)
		{
			ScreenResolutions = avaiableResolutions;
			DefaultResolution = defaultResolution;
			bool flag = false;
			if (!PlayerPrefs.HasKey("SCREEN_RESOLUTION_WIDTH") || !PlayerPrefs.HasKey("SCREEN_RESOLUTION_HEIGHT"))
			{
				CurrentResolution = DefaultResolution;
			}
			else
			{
				flag = true;
				int width = PlayerPrefs.GetInt("SCREEN_RESOLUTION_WIDTH");
				int height = PlayerPrefs.GetInt("SCREEN_RESOLUTION_HEIGHT");
				currentResolution = default(Resolution);
				currentResolution.width = width;
				currentResolution.height = height;
				CurrentResolution = ScreenResolutions.OrderBy((Resolution r) => Mathf.Abs(r.width - currentResolution.width) + Mathf.Abs(r.height - currentResolution.height)).First();
			}
			bool flag2 = true;
			if (!NeedCompactWindow())
			{
				flag2 = ((!flag) ? (!WindowedByDefault) : DefineScreenMode());
			}
			InitialWindowed = !flag2;
		}

		public void ApplyInitialScreenResolutionData()
		{
			Screen.SetResolution(currentResolution.width, currentResolution.height, !InitialWindowed);
		}

		private bool DefineScreenMode()
		{
			if (PlayerPrefs.HasKey("WINDOW_MODE"))
			{
				bool result = !Convert.ToBoolean(PlayerPrefs.GetInt("WINDOW_MODE"));
				PlayerPrefs.DeleteKey("WINDOW_MODE");
				return result;
			}
			return Screen.fullScreen;
		}

		public void SaveWindowModeOnQuit()
		{
			PlayerPrefs.SetInt("WINDOW_MODE", Convert.ToInt32(InitialWindowed));
		}

		public void InitWindowModeSettings(bool isWindowedByDefault)
		{
			WindowedByDefault = isWindowedByDefault;
		}

		public void EnableCompactScreen(CompactScreenBehaviour compactScreen)
		{
			this.compactScreen = compactScreen;
			compactScreen.InitCompactMode();
		}

		public void DisableCompactScreen()
		{
			if (!(compactScreen == null))
			{
				compactScreen.DisableCompactMode();
				PlayerPrefs.SetInt("NO_COMPACT_WINDOW", 1);
				if (PlayerPrefs.HasKey("WINDOW_MODE"))
				{
					PlayerPrefs.DeleteKey("WINDOW_MODE");
				}
			}
		}

		public bool NeedCompactWindow()
		{
			return !PlayerPrefs.HasKey("NO_COMPACT_WINDOW");
		}

		public void WipeSettings(int version)
		{
			if (PlayerPrefs.GetInt("WIPE_GRAPHICS_SETTINGS") != version)
			{
				PlayerPrefs.DeleteKey("QUALITY_LEVEL_INDEX");
				PlayerPrefs.DeleteKey("TEXTURE_LEVEL");
				PlayerPrefs.DeleteKey("PARTICLE_LEVEL");
				PlayerPrefs.DeleteKey("SHADOW_LEVEL");
				PlayerPrefs.DeleteKey("ANISOTROPIC_LEVEL");
				PlayerPrefs.DeleteKey("ANTIALIASING_LEVEL");
				PlayerPrefs.DeleteKey("VEGETATION_LEVEL_INDEX");
				PlayerPrefs.DeleteKey("FAR_FOLIAGE_ENABLE");
				PlayerPrefs.DeleteKey("BILLBOARD_TREES_SHADOWCASTING");
				PlayerPrefs.DeleteKey("TREES_SHADOW_RECIEVING");
				PlayerPrefs.DeleteKey("GRASS_LEVEL_INDEX");
				PlayerPrefs.DeleteKey("GRASS_FAR_DRAW_DISTANCE");
				PlayerPrefs.DeleteKey("GRASS_NEAR_DRAW_DISTANCE");
				PlayerPrefs.DeleteKey("GRASS_FADE_RANGE");
				PlayerPrefs.DeleteKey("GRASS_DENSITY_MULTIPLIER");
				PlayerPrefs.DeleteKey("GRASS_CASTS_SHADOW");
				PlayerPrefs.DeleteKey("CUSTOM_SETTINGS_MODE");
				PlayerPrefs.DeleteKey("AMBIENT_OCCLUSION_MODE");
				PlayerPrefs.DeleteKey("BLOOM_MODE");
				PlayerPrefs.DeleteKey("CHROMATIC_ABERRATION_MODE");
				PlayerPrefs.DeleteKey("GRAIN_MODE");
				PlayerPrefs.DeleteKey("VIGNETTE_MODE");
				PlayerPrefs.DeleteKey("LOW_RENDER_RESOLUTION_MODE");
				PlayerPrefs.SetInt("WIPE_GRAPHICS_SETTINGS", version);
			}
		}
	}
}
