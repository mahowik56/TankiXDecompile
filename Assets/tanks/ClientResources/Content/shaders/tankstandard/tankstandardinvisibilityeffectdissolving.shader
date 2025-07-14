Shader "Alternativa/TankStandardInvisibilityEffectDissolving" {
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
		Tags { "PerformanceChecks" = "False" "QUEUE" = "AlphaTest+2" "RenderType" = "Opaque" }
		Pass {
			LOD 300
			Tags { "PerformanceChecks" = "False" "QUEUE" = "AlphaTest+2" "RenderType" = "Opaque" }
			ColorMask 0
			ZClip Off
			Offset 0, 2
			Fog {
				Mode 0
			}
			GpuProgramID 339519
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 color : COLOR0;
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.color = saturate(v.color);
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = inp.color;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDBASE" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest+2" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			GpuProgramID 18323
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float2 texcoord6 : TEXCOORD6;
				float3 texcoord8 : TEXCOORD8;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float2 _TracksOffset;
			float4 _Masks_ST;
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _DissolveCoeff;
			float4 _LightColor0;
			float _BumpScale;
			float _Metallic;
			float _OcclusionStrength;
			float _Parallax;
			float _SmoothnessStrength;
			float4 _EmissionColor;
			float _EmissionIntensity;
			float _Alpha;
			float3 _Coloring;
			float _ColoringSmoothness;
			float _ColoringBumpScale;
			float _MetallicColoring;
			float _ColoringMaskThreshold;
			float _ColoringBumpMapDef;
			float _ColoringMapAlphaDef;
			float _TotalWhiteFrostTemperature;
			float _WhiteFrostNormalScale;
			float _FreezeNormalScale;
			float _MaxFreezeIntensity;
			float _FreezeSmoothness;
			float _FreezeMetallic;
			float4 _FreezeEmissionColor;
			float _FreezeEmissionIntensity;
			float4 _AdditiveFreezeEmissionColor;
			float _AdditiveFreezeEmissionIntensity;
			float _TotalBurntColoringTemperature;
			float4 _StrongBurningColor;
			float4 _WeakBurningColor;
			float _BurningColoringMetallic;
			float _BurningMetallic;
			float _BurningEmissionIntensity;
			float _Temperature;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DissolveMap;
			sampler2D _SurfaceMap;
			sampler2D _MainTex;
			sampler2D _ColoringMap;
			sampler2D _FreezingMap;
			sampler2D _Masks;
			sampler2D _BumpMap;
			sampler2D _ColoringBumpMap;
			sampler2D _WhiteFrostNormalMap;
			sampler2D _FreezingNormalMap;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _TracksOffset.y - _TracksOffset.x;
                tmp0.x = v.color.x * tmp0.x + _TracksOffset.x;
                tmp0.yz = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.x = tmp0.x + tmp0.y;
                o.texcoord.y = tmp0.z;
                o.texcoord.zw = v.texcoord.xy * _Masks_ST.xy + _Masks_ST.zw;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                o.texcoord8.xyz = tmp0.xyz;
                tmp0.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp1.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = tmp1.xyz + unity_WorldToObject._m03_m13_m23;
                tmp1.xyz = tmp1.xyz - v.vertex.xyz;
                o.texcoord2.w = dot(v.tangent.xyz, tmp1.xyz);
                tmp0.w = dot(v.normal.xyz, v.normal.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * v.normal.zxy;
                tmp0.w = dot(v.tangent.xyz, v.tangent.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * v.tangent.yzx;
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp2.xyz = tmp2.zxy * tmp3.yzx + -tmp4.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                o.texcoord3.w = dot(tmp2.xyz, tmp1.xyz);
                o.texcoord4.w = dot(v.normal.xyz, tmp1.xyz);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.yzx * tmp1.zxy;
                tmp0.xyz = tmp1.yzx * tmp0.zxy + -tmp2.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
                o.texcoord4.xyz = tmp1.xyz;
                tmp0.x = tmp1.y * tmp1.y;
                tmp0.x = tmp1.x * tmp1.x + -tmp0.x;
                tmp1 = tmp1.yzzx * tmp1.xyzz;
                tmp2.x = dot(unity_SHBr, tmp1);
                tmp2.y = dot(unity_SHBg, tmp1);
                tmp2.z = dot(unity_SHBb, tmp1);
                o.texcoord5.xyz = unity_SHC.xyz * tmp0.xxx + tmp2.xyz;
                o.texcoord5.w = 0.0;
                o.texcoord6.xy = float2(0.0, 0.0);
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                float4 tmp11;
                float4 tmp12;
                float4 tmp13;
                float4 tmp14;
                float4 tmp15;
                tmp0 = tex2D(_DissolveMap, inp.texcoord.xy);
                tmp0.x = tmp0.x - _DissolveCoeff;
                tmp1.x = inp.texcoord2.w;
                tmp1.y = inp.texcoord3.w;
                tmp1.z = inp.texcoord4.w;
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.zw = tmp0.yy * tmp1.xy;
                tmp2 = tex2D(_SurfaceMap, inp.texcoord.xy);
                tmp1.x = tmp2.y * _Parallax;
                tmp1.x = -_Parallax * 0.5 + tmp1.x;
                tmp0.y = tmp1.z * tmp0.y + 0.42;
                tmp3 = tmp0.zwzw / tmp0.yyyy;
                tmp1 = tmp1.xxxx * tmp3 + inp.texcoord;
                tmp3 = tex2D(_MainTex, tmp1.xy);
                tmp0.y = saturate(tmp3.w * _SmoothnessStrength);
                tmp4 = tex2D(_ColoringMap, tmp1.xy);
                tmp5.xyz = tmp4.xyz * _Coloring;
                tmp6 = tex2D(_SurfaceMap, tmp1.xy);
                tmp0.z = _ColoringMaskThreshold < tmp6.w;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp0.w = _ColoringMaskThreshold == -1.0;
                tmp0.z = tmp0.w ? tmp6.w : tmp0.z;
                tmp2.y = _ColoringSmoothness >= 0.0;
                if (tmp2.y) {
                    tmp2.y = _ColoringMapAlphaDef == 2.0;
                    if (tmp2.y) {
                        tmp2.y = saturate(tmp4.w * _ColoringSmoothness);
                    } else {
                        tmp2.y = saturate(_ColoringSmoothness);
                    }
                    tmp2.y = tmp2.y - tmp0.y;
                    tmp0.y = tmp0.z * tmp2.y + tmp0.y;
                }
                tmp2.y = _ColoringMaskThreshold != -1.0;
                tmp4.xyz = _Coloring * tmp4.xyz + -tmp3.xyz;
                tmp4.xyz = tmp0.zzz * tmp4.xyz + tmp3.xyz;
                tmp5.xyz = tmp0.zzz * tmp5.xyz;
                tmp3.w = 1.0 - tmp0.z;
                tmp5.xyz = tmp5.xyz * float3(4.594794, 4.594794, 4.594794) + tmp3.www;
                tmp5.xyz = tmp3.xyz * tmp5.xyz;
                tmp4.xyz = tmp2.yyy ? tmp4.xyz : tmp5.xyz;
                tmp2.y = _MetallicColoring - _Metallic;
                tmp2.y = tmp0.z * tmp2.y + _Metallic;
                tmp3.w = _Temperature < 0.0;
                if (tmp3.w) {
                    tmp5 = tex2D(_FreezingMap, tmp1.xy);
                    tmp4.w = tmp5.w - 1.0;
                    tmp6.y = -tmp4.w * -_TotalWhiteFrostTemperature + _Temperature;
                    tmp4.w = -tmp4.w * -_TotalWhiteFrostTemperature + _TotalWhiteFrostTemperature;
                    tmp4.w = saturate(tmp6.y / tmp4.w);
                    tmp7 = tex2D(_Masks, tmp1.zw);
                    tmp4.w = tmp4.w * tmp7.y;
                    tmp6.yzw = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                    tmp6.yzw = tmp4.www * tmp6.yzw + tmp4.xyz;
                    tmp7.x = _FreezeSmoothness - tmp0.y;
                    tmp7.x = tmp4.w * tmp7.x + tmp0.y;
                    tmp7.y = _FreezeMetallic - tmp2.y;
                    tmp7.y = tmp4.w * tmp7.y + tmp2.y;
                    tmp7.z = _Temperature < _TotalWhiteFrostTemperature;
                    if (tmp7.z) {
                        tmp5.w = min(tmp6.x, tmp5.w);
                        tmp5.w = tmp5.w - 1.0;
                        tmp5.w = saturate(tmp5.w - _Temperature);
                        tmp5.w = tmp5.w * _MaxFreezeIntensity;
                    } else {
                        tmp5.w = 0.0;
                    }
                    tmp5.xyz = tmp5.xyz - tmp6.yzw;
                    tmp4.xyz = tmp5.www * tmp5.xyz + tmp6.yzw;
                    tmp5.x = _FreezeSmoothness - tmp7.x;
                    tmp0.y = tmp5.w * tmp5.x + tmp7.x;
                    tmp5.x = _FreezeMetallic - tmp7.y;
                    tmp2.y = tmp5.w * tmp5.x + tmp7.y;
                    tmp5.xy = float2(0.0, 0.0);
                } else {
                    tmp5.z = _Temperature > 0.0;
                    if (tmp5.z) {
                        tmp6 = tex2D(_Masks, tmp1.xy);
                        tmp5.z = _Temperature - _TotalBurntColoringTemperature;
                        tmp5.z = tmp5.z * tmp6.w;
                        tmp6.x = 1.0 - _TotalBurntColoringTemperature;
                        tmp5.x = saturate(tmp5.z / tmp6.x);
                        tmp6.xyz = _StrongBurningColor.xyz * tmp3.xyz + -tmp3.xyz;
                        tmp6.xyz = tmp5.xxx * tmp6.xyz + tmp3.xyz;
                        tmp7.xyz = tmp3.xyz * _WeakBurningColor.xyz;
                        tmp3.xyz = _StrongBurningColor.xyz * tmp3.xyz + -tmp7.xyz;
                        tmp3.xyz = tmp5.xxx * tmp3.xyz + tmp7.xyz;
                        tmp3.xyz = tmp3.xyz - tmp6.xyz;
                        tmp3.xyz = tmp0.zzz * tmp3.xyz + tmp6.xyz;
                        tmp5.z = _BurningColoringMetallic - _BurningMetallic;
                        tmp5.z = tmp0.z * tmp5.z + _BurningMetallic;
                        tmp6.x = 1.0 - tmp6.w;
                        tmp6.x = _TotalBurntColoringTemperature * tmp6.x + 0.01;
                        tmp5.y = saturate(_Temperature / tmp6.x);
                        tmp3.xyz = tmp3.xyz - tmp4.xyz;
                        tmp4.xyz = tmp5.yyy * tmp3.xyz + tmp4.xyz;
                        tmp3.x = tmp5.z - tmp2.y;
                        tmp2.y = tmp5.x * tmp3.x + tmp2.y;
                    } else {
                        tmp5.xy = float2(0.0, 0.0);
                    }
                    tmp4.w = 0.0;
                    tmp5.w = 0.0;
                }
                tmp3.xyz = tmp4.xyz - float3(0.04, 0.04, 0.04);
                tmp3.xyz = tmp2.yyy * tmp3.xyz + float3(0.04, 0.04, 0.04);
                tmp2.y = -tmp2.y * 0.96 + 0.96;
                tmp4.xyz = tmp2.yyy * tmp4.xyz;
                tmp6 = tex2D(_BumpMap, tmp1.xy);
                tmp6.xy = tmp6.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp6.xy = tmp6.xy * _BumpScale.xx;
                tmp5.z = dot(tmp6.xy, tmp6.xy);
                tmp5.z = min(tmp5.z, 1.0);
                tmp5.z = 1.0 - tmp5.z;
                tmp6.z = sqrt(tmp5.z);
                tmp5.z = _ColoringBumpMapDef > 0.0;
                if (tmp5.z) {
                    tmp7 = tex2D(_ColoringBumpMap, tmp1.xy);
                    tmp7.xy = tmp7.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp7.xy = tmp7.xy * _ColoringBumpScale.xx;
                    tmp5.z = dot(tmp7.xy, tmp7.xy);
                    tmp5.z = min(tmp5.z, 1.0);
                    tmp5.yz = float2(1.0, 1.0) - tmp5.yz;
                    tmp8.z = sqrt(tmp5.z);
                    tmp9.xyz = tmp6.xyz + float3(0.0, 0.0, 1.0);
                    tmp8.xy = -tmp7.xy;
                    tmp5.z = dot(tmp9.xyz, tmp8.xyz);
                    tmp7.xyz = tmp8.xyz * tmp9.zzz;
                    tmp7.xyz = tmp9.xyz * tmp5.zzz + -tmp7.xyz;
                    tmp5.z = dot(tmp7.xyz, tmp7.xyz);
                    tmp5.z = rsqrt(tmp5.z);
                    tmp0.z = tmp0.z * tmp5.y;
                    tmp5.y = saturate(-tmp5.w * 2.0 + 1.0);
                    tmp0.z = tmp0.z * tmp5.y;
                    tmp7.xyz = tmp7.xyz * tmp5.zzz + -tmp6.xyz;
                    tmp6.xyz = tmp0.zzz * tmp7.xyz + tmp6.xyz;
                }
                tmp7 = tex2D(_WhiteFrostNormalMap, tmp1.zw);
                tmp1.zw = tmp7.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.zw = tmp1.zw * _WhiteFrostNormalScale.xx;
                tmp0.z = dot(tmp1.xy, tmp1.xy);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp7.z = sqrt(tmp0.z);
                tmp8.xyz = tmp6.xyz + float3(0.0, 0.0, 1.0);
                tmp7.xy = -tmp1.zw;
                tmp0.z = dot(tmp8.xyz, tmp7.xyz);
                tmp7.xyz = tmp7.xyz * tmp8.zzz;
                tmp7.xyz = tmp8.xyz * tmp0.zzz + -tmp7.xyz;
                tmp0.z = dot(tmp7.xyz, tmp7.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp7.xyz = tmp7.xyz * tmp0.zzz + -tmp6.xyz;
                tmp6.xyz = tmp4.www * tmp7.xyz + tmp6.xyz;
                tmp1 = tex2D(_FreezingNormalMap, tmp1.xy);
                tmp1.xy = tmp1.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy * _FreezeNormalScale.xx;
                tmp0.z = dot(tmp1.xy, tmp1.xy);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp7.z = sqrt(tmp0.z);
                tmp8.xyz = tmp6.xyz + float3(0.0, 0.0, 1.0);
                tmp7.xy = -tmp1.xy;
                tmp0.z = dot(tmp8.xyz, tmp7.xyz);
                tmp1.xyz = tmp7.xyz * tmp8.zzz;
                tmp1.xyz = tmp8.xyz * tmp0.zzz + -tmp1.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp1.xyz * tmp0.zzz + -tmp6.xyz;
                tmp1.xyz = tmp5.www * tmp1.xyz + tmp6.xyz;
                tmp6.xyz = tmp1.yyy * inp.texcoord3.xyz;
                tmp1.xyw = inp.texcoord2.xyz * tmp1.xxx + tmp6.xyz;
                tmp1.xyz = inp.texcoord4.xyz * tmp1.zzz + tmp1.xyw;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp6.xyz = tmp0.zzz * inp.texcoord1.xyz;
                tmp5.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp5.y) {
                    tmp5.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp7.xyz = inp.texcoord8.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp7.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord8.xxx + tmp7.xyz;
                    tmp7.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord8.zzz + tmp7.xyz;
                    tmp7.xyz = tmp7.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp7.xyz = tmp5.zzz ? tmp7.xyz : inp.texcoord8.xyz;
                    tmp7.xyz = tmp7.xyz - unity_ProbeVolumeMin;
                    tmp7.yzw = tmp7.xyz * unity_ProbeVolumeSizeInv;
                    tmp5.z = tmp7.y * 0.25 + 0.75;
                    tmp6.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp7.x = max(tmp5.z, tmp6.w);
                    tmp7 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp7.xzw);
                } else {
                    tmp7 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp5.z = saturate(dot(tmp7, unity_OcclusionMaskSelector));
                tmp6.w = 1.0 - _OcclusionStrength;
                tmp2.x = tmp2.x * _OcclusionStrength + tmp6.w;
                tmp6.w = 1.0 - tmp0.y;
                tmp7.x = dot(tmp6.xyz, tmp1.xyz);
                tmp7.x = tmp7.x + tmp7.x;
                tmp7.xyz = tmp1.xyz * -tmp7.xxx + tmp6.xyz;
                tmp8.xyz = tmp5.zzz * _LightColor0.xyz;
                if (tmp5.y) {
                    tmp5.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp9.xyz = inp.texcoord8.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp9.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord8.xxx + tmp9.xyz;
                    tmp9.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord8.zzz + tmp9.xyz;
                    tmp9.xyz = tmp9.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp9.xyz = tmp5.yyy ? tmp9.xyz : inp.texcoord8.xyz;
                    tmp9.xyz = tmp9.xyz - unity_ProbeVolumeMin;
                    tmp9.yzw = tmp9.xyz * unity_ProbeVolumeSizeInv;
                    tmp5.y = tmp9.y * 0.25;
                    tmp5.z = unity_ProbeVolumeParams.z * 0.5;
                    tmp7.w = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp5.y = max(tmp5.z, tmp5.y);
                    tmp9.x = min(tmp7.w, tmp5.y);
                    tmp10 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp9.xzw);
                    tmp11.xyz = tmp9.xzw + float3(0.25, 0.0, 0.0);
                    tmp11 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp11.xyz);
                    tmp9.xyz = tmp9.xzw + float3(0.5, 0.0, 0.0);
                    tmp9 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp9.xyz);
                    tmp1.w = 1.0;
                    tmp10.x = dot(tmp10, tmp1);
                    tmp10.y = dot(tmp11, tmp1);
                    tmp10.z = dot(tmp9, tmp1);
                } else {
                    tmp1.w = 1.0;
                    tmp10.x = dot(unity_SHAr, tmp1);
                    tmp10.y = dot(unity_SHAg, tmp1);
                    tmp10.z = dot(unity_SHAb, tmp1);
                }
                tmp9.xyz = tmp10.xyz + inp.texcoord5.xyz;
                tmp9.xyz = max(tmp9.xyz, float3(0.0, 0.0, 0.0));
                tmp1.w = unity_SpecCube0_ProbePosition.w > 0.0;
                if (tmp1.w) {
                    tmp1.w = dot(tmp7.xyz, tmp7.xyz);
                    tmp1.w = rsqrt(tmp1.w);
                    tmp10.xyz = tmp1.www * tmp7.xyz;
                    tmp11.xyz = unity_SpecCube0_BoxMax.xyz - inp.texcoord8.xyz;
                    tmp11.xyz = tmp11.xyz / tmp10.xyz;
                    tmp12.xyz = unity_SpecCube0_BoxMin.xyz - inp.texcoord8.xyz;
                    tmp12.xyz = tmp12.xyz / tmp10.xyz;
                    tmp13.xyz = tmp10.xyz > float3(0.0, 0.0, 0.0);
                    tmp11.xyz = tmp13.xyz ? tmp11.xyz : tmp12.xyz;
                    tmp1.w = min(tmp11.y, tmp11.x);
                    tmp1.w = min(tmp11.z, tmp1.w);
                    tmp11.xyz = inp.texcoord8.xyz - unity_SpecCube0_ProbePosition.xyz;
                    tmp10.xyz = tmp10.xyz * tmp1.www + tmp11.xyz;
                } else {
                    tmp10.xyz = tmp7.xyz;
                }
                tmp1.w = -tmp6.w * 0.7 + 1.7;
                tmp1.w = tmp1.w * tmp6.w;
                tmp1.w = tmp1.w * 6.0;
                tmp10 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp10.xyz, tmp1.w));
                tmp5.y = tmp10.w - 1.0;
                tmp5.y = unity_SpecCube0_HDR.w * tmp5.y + 1.0;
                tmp5.y = log(tmp5.y);
                tmp5.y = tmp5.y * unity_SpecCube0_HDR.y;
                tmp5.y = exp(tmp5.y);
                tmp5.y = tmp5.y * unity_SpecCube0_HDR.x;
                tmp11.xyz = tmp10.xyz * tmp5.yyy;
                tmp5.z = unity_SpecCube0_BoxMin.w < 0.99999;
                if (tmp5.z) {
                    tmp5.z = unity_SpecCube1_ProbePosition.w > 0.0;
                    if (tmp5.z) {
                        tmp5.z = dot(tmp7.xyz, tmp7.xyz);
                        tmp5.z = rsqrt(tmp5.z);
                        tmp12.xyz = tmp5.zzz * tmp7.xyz;
                        tmp13.xyz = unity_SpecCube1_BoxMax.xyz - inp.texcoord8.xyz;
                        tmp13.xyz = tmp13.xyz / tmp12.xyz;
                        tmp14.xyz = unity_SpecCube1_BoxMin.xyz - inp.texcoord8.xyz;
                        tmp14.xyz = tmp14.xyz / tmp12.xyz;
                        tmp15.xyz = tmp12.xyz > float3(0.0, 0.0, 0.0);
                        tmp13.xyz = tmp15.xyz ? tmp13.xyz : tmp14.xyz;
                        tmp5.z = min(tmp13.y, tmp13.x);
                        tmp5.z = min(tmp13.z, tmp5.z);
                        tmp13.xyz = inp.texcoord8.xyz - unity_SpecCube1_ProbePosition.xyz;
                        tmp7.xyz = tmp12.xyz * tmp5.zzz + tmp13.xyz;
                    }
                    tmp7 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp7.xyz, tmp1.w));
                    tmp1.w = tmp7.w - 1.0;
                    tmp1.w = unity_SpecCube1_HDR.w * tmp1.w + 1.0;
                    tmp1.w = log(tmp1.w);
                    tmp1.w = tmp1.w * unity_SpecCube1_HDR.y;
                    tmp1.w = exp(tmp1.w);
                    tmp1.w = tmp1.w * unity_SpecCube1_HDR.x;
                    tmp7.xyz = tmp7.xyz * tmp1.www;
                    tmp10.xyz = tmp5.yyy * tmp10.xyz + -tmp7.xyz;
                    tmp11.xyz = unity_SpecCube0_BoxMin.www * tmp10.xyz + tmp7.xyz;
                }
                tmp7.xyz = tmp2.xxx * tmp11.xyz;
                tmp10.xyz = -inp.texcoord1.xyz * tmp0.zzz + _WorldSpaceLightPos0.xyz;
                tmp0.z = dot(tmp10.xyz, tmp10.xyz);
                tmp0.z = max(tmp0.z, 0.001);
                tmp0.z = rsqrt(tmp0.z);
                tmp10.xyz = tmp0.zzz * tmp10.xyz;
                tmp0.z = dot(tmp1.xyz, -tmp6.xyz);
                tmp1.w = saturate(dot(tmp1.xyz, _WorldSpaceLightPos0.xyz));
                tmp1.x = saturate(dot(tmp1.xyz, tmp10.xyz));
                tmp1.y = saturate(dot(_WorldSpaceLightPos0.xyz, tmp10.xyz));
                tmp1.z = tmp1.y * tmp1.y;
                tmp1.z = dot(tmp1.xy, tmp6.xy);
                tmp1.z = tmp1.z - 0.5;
                tmp5.y = 1.0 - tmp1.w;
                tmp5.z = tmp5.y * tmp5.y;
                tmp5.z = tmp5.z * tmp5.z;
                tmp5.y = tmp5.y * tmp5.z;
                tmp5.y = tmp1.z * tmp5.y + 1.0;
                tmp5.z = 1.0 - abs(tmp0.z);
                tmp6.x = tmp5.z * tmp5.z;
                tmp6.x = tmp6.x * tmp6.x;
                tmp5.z = tmp5.z * tmp6.x;
                tmp1.z = tmp1.z * tmp5.z + 1.0;
                tmp1.z = tmp1.z * tmp5.y;
                tmp1.z = tmp1.w * tmp1.z;
                tmp5.y = tmp6.w * tmp6.w;
                tmp6.x = -tmp6.w * tmp6.w + 1.0;
                tmp6.y = abs(tmp0.z) * tmp6.x + tmp5.y;
                tmp6.x = tmp1.w * tmp6.x + tmp5.y;
                tmp0.z = abs(tmp0.z) * tmp6.x;
                tmp0.z = tmp1.w * tmp6.y + tmp0.z;
                tmp0.z = tmp0.z + 0.00001;
                tmp0.z = 0.5 / tmp0.z;
                tmp6.x = tmp5.y * tmp5.y;
                tmp6.y = tmp1.x * tmp6.x + -tmp1.x;
                tmp1.x = tmp6.y * tmp1.x + 1.0;
                tmp6.x = tmp6.x * 0.3183099;
                tmp1.x = tmp1.x * tmp1.x + 0.0000001;
                tmp1.x = tmp6.x / tmp1.x;
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.z = tmp0.z * 3.141593;
                tmp0.z = tmp1.w * tmp0.z;
                tmp0.z = max(tmp0.z, 0.0);
                tmp1.x = tmp5.y * tmp5.y + 1.0;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = tmp1.w != 0.0;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp0.z = tmp0.z * tmp1.w;
                tmp0.y = tmp0.y - tmp2.y;
                tmp0.y = saturate(tmp0.y + 1.0);
                tmp6.xyz = tmp1.zzz * tmp8.xyz;
                tmp6.xyz = tmp9.xyz * tmp2.xxx + tmp6.xyz;
                tmp8.xyz = tmp8.xyz * tmp0.zzz;
                tmp0.z = 1.0 - tmp1.y;
                tmp1.y = tmp0.z * tmp0.z;
                tmp1.y = tmp1.y * tmp1.y;
                tmp0.z = tmp0.z * tmp1.y;
                tmp1.yzw = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp1.yzw = tmp1.yzw * tmp0.zzz + tmp3.xyz;
                tmp1.yzw = tmp1.yzw * tmp8.xyz;
                tmp1.yzw = tmp4.xyz * tmp6.xyz + tmp1.yzw;
                tmp6.xyz = tmp7.xyz * tmp1.xxx;
                tmp7.xyz = tmp0.yyy - tmp3.xyz;
                tmp3.xyz = tmp5.zzz * tmp7.xyz + tmp3.xyz;
                tmp1.xyz = tmp6.xyz * tmp3.xyz + tmp1.yzw;
                tmp0.y = _ColoringMapAlphaDef == 1.0;
                if (tmp0.y) {
                    tmp0.y = tmp2.z * _EmissionIntensity;
                    tmp3.xyz = tmp0.yyy * _EmissionColor.xyz;
                    tmp6 = tex2D(_ColoringMap, inp.texcoord.xy);
                    tmp6.xyz = tmp6.yzw * tmp6.xxx;
                    tmp0.y = _ColoringMaskThreshold < tmp2.w;
                    tmp0.y = tmp0.y ? 1.0 : 0.0;
                    tmp0.y = tmp0.w ? tmp2.w : tmp0.y;
                    tmp2.xyw = tmp6.xyz * _EmissionIntensity.xxx + -tmp3.xyz;
                    tmp0.yzw = tmp0.yyy * tmp2.xyw + tmp3.xyz;
                    tmp0.yzw = tmp0.yzw + tmp1.xyz;
                } else {
                    tmp1.w = tmp2.z * _EmissionIntensity;
                    tmp0.yzw = tmp1.www * _EmissionColor.xyz + tmp1.xyz;
                }
                if (tmp3.w) {
                    tmp1.xyz = _FreezeEmissionColor.xyz * _FreezeEmissionIntensity.xxx;
                    tmp2 = tex2D(_Masks, inp.texcoord.xy);
                    tmp2.yzw = _AdditiveFreezeEmissionIntensity.xxx * _AdditiveFreezeEmissionColor.xyz + -tmp1.xyz;
                    tmp2.xyz = tmp2.xxx * tmp2.yzw + tmp1.xyz;
                    tmp1.xyz = tmp4.www * tmp1.xyz;
                    tmp2.xyz = tmp2.xyz * tmp5.www + -tmp1.xyz;
                    tmp1.xyz = tmp5.www * tmp2.xyz + tmp1.xyz;
                    o.sv_target.xyz = tmp0.yzw + tmp1.xyz;
                } else {
                    tmp1.x = _Temperature > 0.0;
                    tmp1.yzw = tmp4.xyz * _Temperature.xxx;
                    tmp2.xyz = _BurningEmissionIntensity.xxx * _StrongBurningColor.xyz + -tmp1.yzw;
                    tmp1.yzw = tmp5.xxx * tmp2.xyz + tmp1.yzw;
                    tmp1.yzw = tmp0.yzw + tmp1.yzw;
                    o.sv_target.xyz = tmp1.xxx ? tmp1.yzw : tmp0.yzw;
                }
                tmp0.x = saturate(tmp0.x * 25.0);
                o.sv_target.w = tmp0.x * _Alpha;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDADD" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest+2" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend Zero One, Zero One
			ZClip Off
			ZWrite Off
			GpuProgramID 100731
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
				float2 texcoord6 : TEXCOORD6;
				float3 texcoord8 : TEXCOORD8;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float2 _TracksOffset;
			float4 _Masks_ST;
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float _DissolveCoeff;
			float4 _LightColor0;
			float _BumpScale;
			float _Metallic;
			float _Parallax;
			float _SmoothnessStrength;
			float3 _Coloring;
			float _ColoringSmoothness;
			float _ColoringBumpScale;
			float _MetallicColoring;
			float _ColoringMaskThreshold;
			float _ColoringBumpMapDef;
			float _ColoringMapAlphaDef;
			float _TotalWhiteFrostTemperature;
			float _WhiteFrostNormalScale;
			float _FreezeNormalScale;
			float _MaxFreezeIntensity;
			float _FreezeSmoothness;
			float _FreezeMetallic;
			float _TotalBurntColoringTemperature;
			float4 _StrongBurningColor;
			float4 _WeakBurningColor;
			float _BurningColoringMetallic;
			float _BurningMetallic;
			float _Temperature;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DissolveMap;
			sampler2D _SurfaceMap;
			sampler2D _MainTex;
			sampler2D _ColoringMap;
			sampler2D _FreezingMap;
			sampler2D _Masks;
			sampler2D _BumpMap;
			sampler2D _ColoringBumpMap;
			sampler2D _WhiteFrostNormalMap;
			sampler2D _FreezingNormalMap;
			sampler2D _LightTexture0;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _TracksOffset.y - _TracksOffset.x;
                tmp0.x = v.color.x * tmp0.x + _TracksOffset.x;
                tmp0.yz = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.x = tmp0.x + tmp0.y;
                o.texcoord.y = tmp0.z;
                o.texcoord.zw = v.texcoord.xy * _Masks_ST.xy + _Masks_ST.zw;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = -tmp0.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                o.texcoord5.xyz = tmp0.xyz;
                o.texcoord2.w = tmp2.x;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp3.xyz = tmp1.yzx * tmp0.zxy;
                tmp1.xyz = tmp0.yzx * tmp1.zxy + -tmp3.xyz;
                o.texcoord4.xyz = tmp0.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                o.texcoord3.xyz = tmp0.xxx * tmp1.xyz;
                o.texcoord3.w = tmp2.y;
                o.texcoord4.w = tmp2.z;
                o.texcoord6.xy = float2(0.0, 0.0);
                tmp0.x = dot(v.normal.xyz, v.normal.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.zxy;
                tmp0.w = dot(v.tangent.xyz, v.tangent.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * v.tangent.yzx;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.zxy * tmp1.yzx + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp1.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp1.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = tmp1.xyz + unity_WorldToObject._m03_m13_m23;
                tmp1.xyz = tmp1.xyz - v.vertex.xyz;
                o.texcoord8.y = dot(tmp0.xyz, tmp1.xyz);
                o.texcoord8.x = dot(v.tangent.xyz, tmp1.xyz);
                o.texcoord8.z = dot(v.normal.xyz, tmp1.xyz);
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0 = tex2D(_DissolveMap, inp.texcoord.xy);
                tmp0.x = tmp0.x - _DissolveCoeff;
                tmp0.y = dot(inp.texcoord8.xyz, inp.texcoord8.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.zw = tmp0.yy * inp.texcoord8.xy;
                tmp1 = tex2D(_SurfaceMap, inp.texcoord.xy);
                tmp1.x = _Parallax * 0.5;
                tmp1.x = tmp1.y * _Parallax + -tmp1.x;
                tmp0.y = inp.texcoord8.z * tmp0.y + 0.42;
                tmp2 = tmp0.zwzw / tmp0.yyyy;
                tmp1 = tmp1.xxxx * tmp2 + inp.texcoord;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp0.y = saturate(tmp2.w * _SmoothnessStrength);
                tmp3 = tex2D(_ColoringMap, tmp1.xy);
                tmp4.xyz = tmp3.xyz * _Coloring;
                tmp5 = tex2D(_SurfaceMap, tmp1.xy);
                tmp0.z = _ColoringMaskThreshold < tmp5.w;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp0.w = _ColoringMaskThreshold == -1.0;
                tmp0.z = tmp0.w ? tmp5.w : tmp0.z;
                tmp0.w = _ColoringSmoothness >= 0.0;
                if (tmp0.w) {
                    tmp0.w = _ColoringMapAlphaDef == 2.0;
                    if (tmp0.w) {
                        tmp0.w = saturate(tmp3.w * _ColoringSmoothness);
                    } else {
                        tmp0.w = saturate(_ColoringSmoothness);
                    }
                    tmp0.w = tmp0.w - tmp0.y;
                    tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                }
                tmp0.w = _ColoringMaskThreshold != -1.0;
                tmp3.xyz = _Coloring * tmp3.xyz + -tmp2.xyz;
                tmp3.xyz = tmp0.zzz * tmp3.xyz + tmp2.xyz;
                tmp4.xyz = tmp0.zzz * tmp4.xyz;
                tmp2.w = 1.0 - tmp0.z;
                tmp4.xyz = tmp4.xyz * float3(4.594794, 4.594794, 4.594794) + tmp2.www;
                tmp4.xyz = tmp2.xyz * tmp4.xyz;
                tmp3.xyz = tmp0.www ? tmp3.xyz : tmp4.xyz;
                tmp0.w = _MetallicColoring - _Metallic;
                tmp0.w = tmp0.z * tmp0.w + _Metallic;
                tmp2.w = _Temperature < 0.0;
                if (tmp2.w) {
                    tmp4 = tex2D(_FreezingMap, tmp1.xy);
                    tmp2.w = tmp4.w - 1.0;
                    tmp3.w = -tmp2.w * -_TotalWhiteFrostTemperature + _Temperature;
                    tmp2.w = -tmp2.w * -_TotalWhiteFrostTemperature + _TotalWhiteFrostTemperature;
                    tmp2.w = saturate(tmp3.w / tmp2.w);
                    tmp6 = tex2D(_Masks, tmp1.zw);
                    tmp2.w = tmp2.w * tmp6.y;
                    tmp5.yzw = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                    tmp5.yzw = tmp2.www * tmp5.yzw + tmp3.xyz;
                    tmp3.w = _FreezeSmoothness - tmp0.y;
                    tmp3.w = tmp2.w * tmp3.w + tmp0.y;
                    tmp6.x = _FreezeMetallic - tmp0.w;
                    tmp6.x = tmp2.w * tmp6.x + tmp0.w;
                    tmp6.y = _Temperature < _TotalWhiteFrostTemperature;
                    if (tmp6.y) {
                        tmp4.w = min(tmp5.x, tmp4.w);
                        tmp4.w = tmp4.w - 1.0;
                        tmp4.w = saturate(tmp4.w - _Temperature);
                        tmp4.w = tmp4.w * _MaxFreezeIntensity;
                    } else {
                        tmp4.w = 0.0;
                    }
                    tmp4.xyz = tmp4.xyz - tmp5.yzw;
                    tmp3.xyz = tmp4.www * tmp4.xyz + tmp5.yzw;
                    tmp4.x = _FreezeSmoothness - tmp3.w;
                    tmp0.y = tmp4.w * tmp4.x + tmp3.w;
                    tmp3.w = _FreezeMetallic - tmp6.x;
                    tmp0.w = tmp4.w * tmp3.w + tmp6.x;
                    tmp3.w = 0.0;
                } else {
                    tmp4.x = _Temperature > 0.0;
                    if (tmp4.x) {
                        tmp5 = tex2D(_Masks, tmp1.xy);
                        tmp4.x = _Temperature - _TotalBurntColoringTemperature;
                        tmp4.x = tmp4.x * tmp5.w;
                        tmp4.y = 1.0 - _TotalBurntColoringTemperature;
                        tmp4.x = saturate(tmp4.x / tmp4.y);
                        tmp5.xyz = _StrongBurningColor.xyz * tmp2.xyz + -tmp2.xyz;
                        tmp5.xyz = tmp4.xxx * tmp5.xyz + tmp2.xyz;
                        tmp6.xyz = tmp2.xyz * _WeakBurningColor.xyz;
                        tmp2.xyz = _StrongBurningColor.xyz * tmp2.xyz + -tmp6.xyz;
                        tmp2.xyz = tmp4.xxx * tmp2.xyz + tmp6.xyz;
                        tmp2.xyz = tmp2.xyz - tmp5.xyz;
                        tmp2.xyz = tmp0.zzz * tmp2.xyz + tmp5.xyz;
                        tmp4.y = _BurningColoringMetallic - _BurningMetallic;
                        tmp4.y = tmp0.z * tmp4.y + _BurningMetallic;
                        tmp4.z = 1.0 - tmp5.w;
                        tmp4.z = _TotalBurntColoringTemperature * tmp4.z + 0.01;
                        tmp3.w = saturate(_Temperature / tmp4.z);
                        tmp2.xyz = tmp2.xyz - tmp3.xyz;
                        tmp3.xyz = tmp3.www * tmp2.xyz + tmp3.xyz;
                        tmp2.x = tmp4.y - tmp0.w;
                        tmp0.w = tmp4.x * tmp2.x + tmp0.w;
                    } else {
                        tmp3.w = 0.0;
                    }
                    tmp2.w = 0.0;
                    tmp4.w = 0.0;
                }
                tmp2.xyz = tmp3.xyz - float3(0.04, 0.04, 0.04);
                tmp2.xyz = tmp0.www * tmp2.xyz + float3(0.04, 0.04, 0.04);
                tmp0.w = -tmp0.w * 0.96 + 0.96;
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp5 = tex2D(_BumpMap, tmp1.xy);
                tmp4.xy = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp4.xy = tmp4.xy * _BumpScale.xx;
                tmp0.w = dot(tmp4.xy, tmp4.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.yw = float2(1.0, 1.0) - tmp0.yw;
                tmp4.z = sqrt(tmp0.w);
                tmp0.w = _ColoringBumpMapDef > 0.0;
                if (tmp0.w) {
                    tmp5 = tex2D(_ColoringBumpMap, tmp1.xy);
                    tmp5.xy = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp5.xy = tmp5.xy * _ColoringBumpScale.xx;
                    tmp0.w = dot(tmp5.xy, tmp5.xy);
                    tmp0.w = min(tmp0.w, 1.0);
                    tmp0.w = 1.0 - tmp0.w;
                    tmp6.z = sqrt(tmp0.w);
                    tmp7.xyz = tmp4.xyz + float3(0.0, 0.0, 1.0);
                    tmp6.xy = -tmp5.xy;
                    tmp0.w = dot(tmp7.xyz, tmp6.xyz);
                    tmp5.xyz = tmp6.xyz * tmp7.zzz;
                    tmp5.xyz = tmp7.xyz * tmp0.www + -tmp5.xyz;
                    tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                    tmp0.w = rsqrt(tmp0.w);
                    tmp3.w = 1.0 - tmp3.w;
                    tmp0.z = tmp0.z * tmp3.w;
                    tmp3.w = saturate(-tmp4.w * 2.0 + 1.0);
                    tmp0.z = tmp0.z * tmp3.w;
                    tmp5.xyz = tmp5.xyz * tmp0.www + -tmp4.xyz;
                    tmp4.xyz = tmp0.zzz * tmp5.xyz + tmp4.xyz;
                }
                tmp5 = tex2D(_WhiteFrostNormalMap, tmp1.zw);
                tmp0.zw = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = tmp0.zw * _WhiteFrostNormalScale.xx;
                tmp1.z = dot(tmp0.xy, tmp0.xy);
                tmp1.z = min(tmp1.z, 1.0);
                tmp1.z = 1.0 - tmp1.z;
                tmp5.z = sqrt(tmp1.z);
                tmp6.xyz = tmp4.xyz + float3(0.0, 0.0, 1.0);
                tmp5.xy = -tmp0.zw;
                tmp0.z = dot(tmp6.xyz, tmp5.xyz);
                tmp5.xyz = tmp5.xyz * tmp6.zzz;
                tmp5.xyz = tmp6.xyz * tmp0.zzz + -tmp5.xyz;
                tmp0.z = dot(tmp5.xyz, tmp5.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp5.xyz = tmp5.xyz * tmp0.zzz + -tmp4.xyz;
                tmp4.xyz = tmp2.www * tmp5.xyz + tmp4.xyz;
                tmp1 = tex2D(_FreezingNormalMap, tmp1.xy);
                tmp0.zw = tmp1.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = tmp0.zw * _FreezeNormalScale.xx;
                tmp1.x = dot(tmp0.xy, tmp0.xy);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.z = sqrt(tmp1.x);
                tmp5.xyz = tmp4.xyz + float3(0.0, 0.0, 1.0);
                tmp1.xy = -tmp0.zw;
                tmp0.z = dot(tmp5.xyz, tmp1.xyz);
                tmp1.xyz = tmp1.xyz * tmp5.zzz;
                tmp1.xyz = tmp5.xyz * tmp0.zzz + -tmp1.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp1.xyz * tmp0.zzz + -tmp4.xyz;
                tmp1.xyz = tmp4.www * tmp1.xyz + tmp4.xyz;
                tmp4.xyz = tmp1.yyy * inp.texcoord3.xyz;
                tmp1.xyw = inp.texcoord2.xyz * tmp1.xxx + tmp4.xyz;
                tmp1.xyz = inp.texcoord4.xyz * tmp1.zzz + tmp1.xyw;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp4.xyz = tmp0.zzz * inp.texcoord1.xyz;
                tmp5.xyz = inp.texcoord5.yyy * unity_WorldToLight._m01_m11_m21;
                tmp5.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord5.xxx + tmp5.xyz;
                tmp5.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord5.zzz + tmp5.xyz;
                tmp5.xyz = tmp5.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.z = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.z) {
                    tmp0.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp6.xyz = inp.texcoord5.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp6.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord5.xxx + tmp6.xyz;
                    tmp6.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord5.zzz + tmp6.xyz;
                    tmp6.xyz = tmp6.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp6.xyz = tmp0.zzz ? tmp6.xyz : inp.texcoord5.xyz;
                    tmp6.xyz = tmp6.xyz - unity_ProbeVolumeMin;
                    tmp6.yzw = tmp6.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.z = tmp6.y * 0.25 + 0.75;
                    tmp0.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp6.x = max(tmp0.w, tmp0.z);
                    tmp6 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp6.xzw);
                } else {
                    tmp6 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.z = saturate(dot(tmp6, unity_OcclusionMaskSelector));
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp5 = tex2D(_LightTexture0, tmp0.ww);
                tmp0.z = tmp0.z * tmp5.x;
                tmp5.x = inp.texcoord2.w;
                tmp5.y = inp.texcoord3.w;
                tmp5.z = inp.texcoord4.w;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp6.xyz = tmp0.www * tmp5.xyz;
                tmp7.xyz = tmp0.zzz * _LightColor0.xyz;
                tmp5.xyz = tmp5.xyz * tmp0.www + -tmp4.xyz;
                tmp0.z = dot(tmp5.xyz, tmp5.xyz);
                tmp0.z = max(tmp0.z, 0.001);
                tmp0.z = rsqrt(tmp0.z);
                tmp5.xyz = tmp0.zzz * tmp5.xyz;
                tmp0.z = dot(tmp1.xyz, -tmp4.xyz);
                tmp0.w = saturate(dot(tmp1.xyz, tmp6.xyz));
                tmp1.x = saturate(dot(tmp1.xyz, tmp5.xyz));
                tmp1.y = saturate(dot(tmp6.xyz, tmp5.xyz));
                tmp1.z = tmp1.y * tmp1.y;
                tmp1.z = dot(tmp1.xy, tmp0.xy);
                tmp1.z = tmp1.z - 0.5;
                tmp1.w = 1.0 - tmp0.w;
                tmp2.w = tmp1.w * tmp1.w;
                tmp2.w = tmp2.w * tmp2.w;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = tmp1.z * tmp1.w + 1.0;
                tmp2.w = 1.0 - abs(tmp0.z);
                tmp3.w = tmp2.w * tmp2.w;
                tmp3.w = tmp3.w * tmp3.w;
                tmp2.w = tmp2.w * tmp3.w;
                tmp1.z = tmp1.z * tmp2.w + 1.0;
                tmp1.z = tmp1.z * tmp1.w;
                tmp1.z = tmp0.w * tmp1.z;
                tmp1.w = tmp0.y * tmp0.y;
                tmp0.y = -tmp0.y * tmp0.y + 1.0;
                tmp2.w = abs(tmp0.z) * tmp0.y + tmp1.w;
                tmp0.y = tmp0.w * tmp0.y + tmp1.w;
                tmp0.y = tmp0.y * abs(tmp0.z);
                tmp0.y = tmp0.w * tmp2.w + tmp0.y;
                tmp0.y = tmp0.y + 0.00001;
                tmp0.y = 0.5 / tmp0.y;
                tmp0.z = tmp1.w * tmp1.w;
                tmp1.w = tmp1.x * tmp0.z + -tmp1.x;
                tmp1.x = tmp1.w * tmp1.x + 1.0;
                tmp0.z = tmp0.z * 0.3183099;
                tmp1.x = tmp1.x * tmp1.x + 0.0000001;
                tmp0.z = tmp0.z / tmp1.x;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = tmp0.y * 3.141593;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = tmp0.z != 0.0;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp0.y = tmp0.z * tmp0.y;
                tmp1.xzw = tmp1.zzz * tmp7.xyz;
                tmp0.yzw = tmp7.xyz * tmp0.yyy;
                tmp1.y = 1.0 - tmp1.y;
                tmp2.w = tmp1.y * tmp1.y;
                tmp2.w = tmp2.w * tmp2.w;
                tmp1.y = tmp1.y * tmp2.w;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp2.xyz = tmp4.xyz * tmp1.yyy + tmp2.xyz;
                tmp0.yzw = tmp0.yzw * tmp2.xyz;
                tmp1.xyz = tmp3.xyz * tmp1.xzw + tmp0.yzw;
                tmp0.x = saturate(tmp0.x * 25.0);
                tmp1.w = 1.0;
                o.sv_target = tmp0.xxxx * tmp1;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "SHADOWCASTER"
			LOD 300
			Tags { "LIGHTMODE" = "SHADOWCASTER" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest+2" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			ZClip Off
			GpuProgramID 163224
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _DissolveCoeff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler3D _DitherMaskLOD;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp2.xyz = -tmp1.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w * unity_LightShadowBias.z;
                tmp0.xyz = -tmp0.xyz * tmp0.www + tmp1.xyz;
                tmp0.w = unity_LightShadowBias.z != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp2 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp2;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.x = saturate(1.0 - _DissolveCoeff);
                tmp0.z = tmp0.x * 0.9375;
                tmp0.xy = inp.position.xy * float2(0.25, 0.25);
                tmp0 = tex3D(_DitherMaskLOD, tmp0.xyz);
                tmp0.x = tmp0.w - 0.01;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 300
			Tags { "LIGHTMODE" = "META" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest+2" "RenderType" = "Opaque" }
			ZClip Off
			Cull Off
			GpuProgramID 205016
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 texcoord : TEXCOORD0;
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float2 _TracksOffset;
			float4 _Masks_ST;
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _DissolveCoeff;
			float _Metallic;
			float _SmoothnessStrength;
			float4 _EmissionColor;
			float _EmissionIntensity;
			float3 _Coloring;
			float _ColoringSmoothness;
			float _MetallicColoring;
			float _ColoringMaskThreshold;
			float _ColoringMapAlphaDef;
			float _TotalWhiteFrostTemperature;
			float _MaxFreezeIntensity;
			float _FreezeSmoothness;
			float _FreezeMetallic;
			float _TotalBurntColoringTemperature;
			float4 _StrongBurningColor;
			float4 _WeakBurningColor;
			float _BurningColoringMetallic;
			float _BurningMetallic;
			float _Temperature;
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
			// Custom ConstantBuffers for Vertex Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaVertexControl;
			CBUFFER_END
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaFragmentControl;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DissolveMap;
			sampler2D _MainTex;
			sampler2D _ColoringMap;
			sampler2D _SurfaceMap;
			sampler2D _FreezingMap;
			sampler2D _Masks;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _TracksOffset.y - _TracksOffset.x;
                tmp0.x = v.color.x * tmp0.x + _TracksOffset.x;
                tmp0.yz = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.x = tmp0.x + tmp0.y;
                o.texcoord.y = tmp0.z;
                o.texcoord.zw = v.texcoord.xy * _Masks_ST.xy + _Masks_ST.zw;
                tmp0.x = v.vertex.z > 0.0;
                tmp0.z = tmp0.x ? 0.0001 : 0.0;
                tmp0.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp0.xyz = unity_MetaVertexControl.xxx ? tmp0.xyz : v.vertex.xyz;
                tmp0.w = tmp0.z > 0.0;
                tmp1.z = tmp0.w ? 0.0001 : 0.0;
                tmp1.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                tmp0.xyz = unity_MetaVertexControl.yyy ? tmp1.xyz : tmp0.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_DissolveMap, inp.texcoord.xy);
                tmp0.x = tmp0.x - _DissolveCoeff;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.y = saturate(tmp1.w * _SmoothnessStrength);
                tmp2 = tex2D(_ColoringMap, inp.texcoord.xy);
                tmp3.xyz = tmp2.xyz * _Coloring;
                tmp4 = tex2D(_SurfaceMap, inp.texcoord.xy);
                tmp0.z = _ColoringMaskThreshold < tmp4.w;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp0.w = _ColoringMaskThreshold == -1.0;
                tmp0.z = tmp0.w ? tmp4.w : tmp0.z;
                tmp0.w = _ColoringSmoothness >= 0.0;
                if (tmp0.w) {
                    tmp0.w = _ColoringMapAlphaDef == 2.0;
                    if (tmp0.w) {
                        tmp0.w = saturate(tmp2.w * _ColoringSmoothness);
                    } else {
                        tmp0.w = saturate(_ColoringSmoothness);
                    }
                    tmp0.w = tmp0.w - tmp0.y;
                    tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                }
                tmp0.w = _ColoringMaskThreshold != -1.0;
                tmp2.xyz = _Coloring * tmp2.xyz + -tmp1.xyz;
                tmp2.xyz = tmp0.zzz * tmp2.xyz + tmp1.xyz;
                tmp3.xyz = tmp0.zzz * tmp3.xyz;
                tmp1.w = 1.0 - tmp0.z;
                tmp3.xyz = tmp3.xyz * float3(4.594794, 4.594794, 4.594794) + tmp1.www;
                tmp3.xyz = tmp1.xyz * tmp3.xyz;
                tmp2.xyz = tmp0.www ? tmp2.xyz : tmp3.xyz;
                tmp0.w = _MetallicColoring - _Metallic;
                tmp0.w = tmp0.z * tmp0.w + _Metallic;
                tmp1.w = _Temperature < 0.0;
                if (tmp1.w) {
                    tmp3 = tex2D(_FreezingMap, inp.texcoord.xy);
                    tmp1.w = tmp3.w - 1.0;
                    tmp2.w = -tmp1.w * -_TotalWhiteFrostTemperature + _Temperature;
                    tmp1.w = -tmp1.w * -_TotalWhiteFrostTemperature + _TotalWhiteFrostTemperature;
                    tmp1.w = saturate(tmp2.w / tmp1.w);
                    tmp5 = tex2D(_Masks, inp.texcoord.zw);
                    tmp1.w = tmp1.w * tmp5.y;
                    tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                    tmp5.xyz = tmp1.www * tmp5.xyz + tmp2.xyz;
                    tmp2.w = _FreezeSmoothness - tmp0.y;
                    tmp2.w = tmp1.w * tmp2.w + tmp0.y;
                    tmp4.y = _FreezeMetallic - tmp0.w;
                    tmp1.w = tmp1.w * tmp4.y + tmp0.w;
                    tmp4.y = _Temperature < _TotalWhiteFrostTemperature;
                    if (tmp4.y) {
                        tmp3.w = min(tmp4.x, tmp3.w);
                        tmp3.w = tmp3.w - 1.0;
                        tmp3.w = saturate(tmp3.w - _Temperature);
                        tmp3.w = tmp3.w * _MaxFreezeIntensity;
                    } else {
                        tmp3.w = 0.0;
                    }
                    tmp3.xyz = tmp3.xyz - tmp5.xyz;
                    tmp2.xyz = tmp3.www * tmp3.xyz + tmp5.xyz;
                    tmp3.x = _FreezeSmoothness - tmp2.w;
                    tmp0.y = tmp3.w * tmp3.x + tmp2.w;
                    tmp2.w = _FreezeMetallic - tmp1.w;
                    tmp0.w = tmp3.w * tmp2.w + tmp1.w;
                } else {
                    tmp1.w = _Temperature > 0.0;
                    if (tmp1.w) {
                        tmp3 = tex2D(_Masks, inp.texcoord.xy);
                        tmp1.w = _Temperature - _TotalBurntColoringTemperature;
                        tmp1.w = tmp1.w * tmp3.w;
                        tmp2.w = 1.0 - _TotalBurntColoringTemperature;
                        tmp1.w = saturate(tmp1.w / tmp2.w);
                        tmp3.xyz = _StrongBurningColor.xyz * tmp1.xyz + -tmp1.xyz;
                        tmp3.xyz = tmp1.www * tmp3.xyz + tmp1.xyz;
                        tmp4.xyw = tmp1.xyz * _WeakBurningColor.xyz;
                        tmp1.xyz = _StrongBurningColor.xyz * tmp1.xyz + -tmp4.xyw;
                        tmp1.xyz = tmp1.www * tmp1.xyz + tmp4.xyw;
                        tmp1.xyz = tmp1.xyz - tmp3.xyz;
                        tmp1.xyz = tmp0.zzz * tmp1.xyz + tmp3.xyz;
                        tmp2.w = _BurningColoringMetallic - _BurningMetallic;
                        tmp0.z = tmp0.z * tmp2.w + _BurningMetallic;
                        tmp2.w = 1.0 - tmp3.w;
                        tmp2.w = _TotalBurntColoringTemperature * tmp2.w + 0.01;
                        tmp2.w = saturate(_Temperature / tmp2.w);
                        tmp1.xyz = tmp1.xyz - tmp2.xyz;
                        tmp2.xyz = tmp2.www * tmp1.xyz + tmp2.xyz;
                        tmp0.z = tmp0.z - tmp0.w;
                        tmp0.w = tmp1.w * tmp0.z + tmp0.w;
                    }
                }
                tmp1.xyz = tmp2.xyz - float3(0.04, 0.04, 0.04);
                tmp1.xyz = tmp0.www * tmp1.xyz + float3(0.04, 0.04, 0.04);
                tmp0.z = -tmp0.w * 0.96 + 0.96;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = tmp0.y * tmp0.y;
                tmp1.xyz = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5);
                tmp0.yzw = tmp2.xyz * tmp0.zzz + tmp1.xyz;
                tmp1.x = tmp4.z * _EmissionIntensity;
                tmp1.xyz = tmp1.xxx * _EmissionColor.xyz;
                tmp1.w = saturate(unity_OneOverOutputBoost);
                tmp0.yzw = log(tmp0.yzw);
                tmp0.yzw = tmp0.yzw * tmp1.www;
                tmp0.yzw = exp(tmp0.yzw);
                tmp2.xyz = min(tmp0.yzw, unity_MaxOutputValue.xxx);
                tmp2.w = 1.0;
                tmp2 = unity_MetaFragmentControl ? tmp2 : float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = unity_UseLinearSpace != 0.0;
                tmp3.xyz = tmp1.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp3.xyz = tmp1.xyz * tmp3.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp3.xyz = tmp1.xyz * tmp3.xyz;
                tmp0.yzw = tmp0.yyy ? tmp1.xyz : tmp3.xyz;
                tmp0.yzw = tmp0.yzw * float3(0.0103093, 0.0103093, 0.0103093);
                tmp1.x = max(tmp0.z, tmp0.y);
                tmp1.y = max(tmp0.w, 0.02);
                tmp1.x = max(tmp1.y, tmp1.x);
                tmp1.x = tmp1.x * 255.0;
                tmp1.x = ceil(tmp1.x);
                tmp1.w = tmp1.x * 0.0039216;
                tmp1.xyz = tmp0.yzw / tmp1.www;
                tmp1 = unity_MetaFragmentControl ? tmp1 : tmp2;
                tmp0.x = saturate(tmp0.x * 25.0);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
			}
			ENDCG
		}
		GrabPass {
		}
		Pass {
			LOD 300
			Tags { "LIGHTMODE" = "ALWAYS" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest+2" "RenderType" = "Opaque" }
			ZClip Off
			GpuProgramID 271431
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
			float4 _GrabTexture_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BumpMap;
			sampler2D _GrabTexture;
			
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
                tmp0.zw = _GrabTexture_TexelSize.zw * float2(0.0007446, 0.0014793);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = tmp0.xy * float2(0.0000745, 0.0001479);
                tmp0.xy = tmp0.xy * inp.texcoord.ww + inp.texcoord.xy;
                tmp0.xy = tmp0.xy / inp.texcoord.ww;
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target.w = _Alpha;
                return o;
			}
			ENDCG
		}
		UsePass "Alternativa/RepairEffect/REPAIR_EFFECT_PASS"
	}
	Fallback "Alternativa/TankStandardInvisibilityEffect"
	CustomEditor "TankStandardInvisibilityEffectShaderGUI"
}