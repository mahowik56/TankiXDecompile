Shader "Alternativa/TankStandardInvisibilityEffect" {
	Properties {
		_Alpha ("Alpha", Range(0, 1)) = 1
		_SurfaceMap ("Coloring mask (a), Occlusion (r), Height Map (g), Emission (b)", 2D) = "white" {}
		_Masks ("Burning Mask (a), Freezing emission Mask (r), White frost Mask (g)", 2D) = "white" {}
		_MainTex ("Albedo, Smoothness (a)", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("Normal scale", Float) = 1
		_Metallic ("Metallic", Range(0, 1)) = 0
		_OcclusionStrength ("Occlusion strength", Range(0, 1)) = 1
		_Parallax ("Height scale", Range(0.005, 0.08)) = 0.02
		_SmoothnessStrength ("Smoothness strength", Range(0, 5)) = 1
		_EmissionColor ("Emission color", Color) = (0,0,0,1)
		_EmissionIntensity ("EmissionIntensity", Float) = 1
		_ColoringMap ("Coloring emission mask or smoothness (a), Coloring (rgb)", 2D) = "white" {}
		_Coloring ("Coloring", Color) = (1,1,1,1)
		_MetallicColoring ("Metallic", Range(0, 1)) = 0
		_ColoringSmoothness ("Smoothness", Range(0, 5)) = 0
		_ColoringBumpMap ("Normal Map", 2D) = "bump" {}
		_ColoringBumpScale ("Normal scale", Float) = 1
		_ColoringMaskThreshold ("Coloring mask threshold", Float) = -1
		_ColoringBumpMapDef ("", Float) = -1
		_ColoringMapAlphaDef ("", Float) = -1
		_WhiteFrostNormalMap ("White frost Normal Map", 2D) = "bump" {}
		_WhiteFrostNormalScale ("White frost Normal scale", Float) = 1
		_TotalWhiteFrostTemperature ("Total white frost temperature", Range(-1, 0)) = -0.5
		_FreezingMap ("Freezing Albedo (rgb), Mask (a)", 2D) = "white" {}
		_FreezingNormalMap ("Freezing normal map", 2D) = "bump" {}
		_FreezeNormalScale ("Freeze normal scale", Float) = 1
		_FreezeSmoothness ("Smoothness", Range(0, 1)) = 1
		_FreezeMetallic ("Metallic", Range(0, 1)) = 1
		_FreezeEmissionColor ("Freezing emission", Color) = (1,1,1,1)
		_FreezeEmissionIntensity ("Freezing emission intensity", Float) = 1
		_AdditiveFreezeEmissionColor ("Additive freezing emission ", Color) = (1,1,1,1)
		_AdditiveFreezeEmissionIntensity ("Additive freezing emission intensity", Float) = 1
		_FreezeTransColor ("Freeze transmission color", Color) = (1,1,1,1)
		_MaxFreezeIntensity ("Freeze max intensity", Range(0, 1)) = 1
		_TotalBurntColoringTemperature ("Total burnt coloring temperature", Range(0, 1)) = 0.5
		_StrongBurningColor ("Strong burning", Color) = (0.505,0.00727,0,1)
		_WeakBurningColor ("Weak burning", Color) = (0.174,0.179,0.185,1)
		_BurningColoringMetallic ("Burning coloring metallic", Range(0, 1)) = 0.2
		_BurningMetallic ("Burning metallic", Range(0, 1)) = 0.5
		_BurningEmissionIntensity ("Strong burning emission intensity", Float) = 20
		_Temperature ("Temperature", Range(-1, 1)) = 0
		_RepairFrontCoeff ("Repair Front Coeff", Range(0, 1)) = 0
		_RepairMovementDirection ("Repair Movement Direction", Range(0, 1)) = 1
		_RepairBackCoeff ("Repair back coeff", Range(0, 1)) = 0.78
		_RepairAdditionalLengthExtension ("Repair Length extension", Float) = 10
		_RepairVolume ("Repair volume", Vector) = (1.502808,0.778753,2.34775,0)
		_RepairCenter ("Repair Center", Vector) = (0,-0.02930036,0.60568,0)
		_RepairTex ("Repair Effect Texture", 2D) = "white" {}
		_RepairFadeAlphaRange ("Repair Fade alpha range", Range(0, 1)) = 0.92
		_RepairAlpha ("Repair alpha", Range(0, 1)) = 1
		_RepairRotationAngle ("Repair Rotation Angle", Range(-10, 10)) = 0
		_DissolveMap ("Dissolve map", 2D) = "white" {}
		_DissolveCoeff ("Dissolve coeff", Range(0, 1.05)) = 0
		_DistortionCoeff ("Distortion coeff", Range(0, 1024)) = 0
		[HideInInspector] _Mode ("__mode", Float) = 0
		[HideInInspector] _SrcBlend ("__src", Float) = 1
		[HideInInspector] _DstBlend ("__dst", Float) = 0
		[HideInInspector] _ZWrite ("__zw", Float) = 1
	}
	SubShader {
		LOD 300
		Tags { "PerformanceChecks" = "False" "QUEUE" = "Transparent+501" "RenderType" = "Transparent" }
		GrabPass {
			"_InvisibilityEffectGrabTex"
		}
		Pass {
			LOD 300
			Tags { "LIGHTMODE" = "ALWAYS" "PerformanceChecks" = "False" "QUEUE" = "Transparent+501" "RenderType" = "Transparent" }
			ZClip Off
			GpuProgramID 4833
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 sv_position : SV_Position0;
				float4 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _BumpMap_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _Alpha;
			float _DistortionCoeff;
			float4 _InvisibilityEffectGrabTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BumpMap;
			sampler2D _InvisibilityEffectGrabTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.sv_position = tmp0;
                tmp1.xyz = tmp0.xwy * float3(0.5, 0.5, -0.5);
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp1.yy + tmp1.xz;
                o.texcoord1.xy = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_BumpMap, inp.texcoord1.xy);
                tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * _DistortionCoeff.xx;
                tmp0.zw = _InvisibilityEffectGrabTex_TexelSize.zw * float2(0.0007446, 0.0014793);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = tmp0.xy * float2(0.0000745, 0.0001479);
                tmp0.xy = tmp0.xy * inp.texcoord.ww + inp.texcoord.xy;
                tmp0.xy = tmp0.xy / inp.texcoord.ww;
                tmp0 = tex2D(_InvisibilityEffectGrabTex, tmp0.xy);
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target.w = _Alpha;
                return o;
			}
			ENDCG
		}
		UsePass "Alternativa/RepairEffect/REPAIR_EFFECT_PASS"
	}
}