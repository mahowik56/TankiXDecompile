Shader "Alternativa/Standard" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo", 2D) = "white" {}
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
		_Glossiness ("Smoothness", Range(0, 1)) = 0.5
		_GlossMapScale ("Smoothness Scale", Range(0, 1)) = 1
		[Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		_MetallicGlossMap ("Metallic", 2D) = "white" {}
		[ToggleOff] _SpecularHighlights ("Specular Highlights", Float) = 1
		[ToggleOff] _GlossyReflections ("Glossy Reflections", Float) = 1
		_BumpScale ("Scale", Float) = 1
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_Parallax ("Height Scale", Range(0.005, 0.08)) = 0.02
		_ParallaxMap ("Height Map", 2D) = "black" {}
		_OcclusionStrength ("Strength", Range(0, 1)) = 1
		_OcclusionMap ("Occlusion", 2D) = "white" {}
		_EmissionColor ("Color", Color) = (0,0,0,1)
		_EmissionMap ("Emission", 2D) = "white" {}
		_DetailMask ("Detail Mask", 2D) = "white" {}
		_DetailAlbedoMap ("Detail Albedo x2", 2D) = "grey" {}
		_DetailNormalMapScale ("Scale", Float) = 1
		_DetailNormalMap ("Normal Map", 2D) = "bump" {}
		[Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0
		_SurfaceType ("Surface type", Float) = 0
		_ShadowMapPower ("Shadowmap power", Float) = 0
		[HideInInspector] _Mode ("__mode", Float) = 0
		[HideInInspector] _SrcBlend ("__src", Float) = 1
		[HideInInspector] _DstBlend ("__dst", Float) = 0
		[HideInInspector] _ZWrite ("__zw", Float) = 1
		[HideInInspector] _ZOffset ("__zoffset", Float) = 0
	}
	SubShader {
		LOD 300
		Tags { "PerformanceChecks" = "False" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDBASE" "PerformanceChecks" = "False" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend Zero Zero, Zero Zero
			ZClip Off
			ZWrite Off
			GpuProgramID 18185
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _DetailAlbedoMap_ST;
			float _UVSec;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float _Metallic;
			float _Glossiness;
			float _OcclusionStrength;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _OcclusionMap;
			
			// Keywords: DIRECTIONAL
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _UVSec == 0.0;
                tmp0.xy = tmp0.xx ? v.texcoord.xy : v.texcoord1.xy;
                o.texcoord.zw = tmp0.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.w = 0.0;
                o.texcoord2 = tmp0.wwwx;
                o.texcoord3 = tmp0.wwwy;
                o.texcoord4.w = tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord4.xyz = tmp0.xyz;
                tmp0.w = tmp0.y * tmp0.y;
                tmp0.w = tmp0.x * tmp0.x + -tmp0.w;
                tmp1 = tmp0.yzzx * tmp0.xyzz;
                tmp0.x = dot(unity_SHBr, tmp1);
                tmp0.y = dot(unity_SHBg, tmp1);
                tmp0.z = dot(unity_SHBb, tmp1);
                o.texcoord5.xyz = unity_SHC.xyz * tmp0.www + tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz * _Color.xyz;
                tmp0.xyz = _Color.xyz * tmp0.xyz + float3(-0.04, -0.04, -0.04);
                tmp0.xyz = _Metallic.xxx * tmp0.xyz + float3(0.04, 0.04, 0.04);
                tmp0.w = -_Metallic * 0.96 + 0.96;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * inp.texcoord4.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * inp.texcoord1.xyz;
                tmp3.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp3.w) {
                    tmp4.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.yzw = inp.texcoord3.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.www + tmp4.yzw;
                    tmp4.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.www + tmp4.yzw;
                    tmp4.yzw = tmp4.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.y = inp.texcoord2.w;
                    tmp5.z = inp.texcoord3.w;
                    tmp5.w = inp.texcoord4.w;
                    tmp4.xyz = tmp4.xxx ? tmp4.yzw : tmp5.yzw;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp4.y = tmp4.y * 0.25 + 0.75;
                    tmp5.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp4.y, tmp5.x);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp4.x = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp5 = tex2D(_OcclusionMap, inp.texcoord.xy);
                tmp4.y = 1.0 - _OcclusionStrength;
                tmp4.y = tmp5.y * _OcclusionStrength + tmp4.y;
                tmp4.z = 1.0 - _Glossiness;
                tmp4.w = dot(tmp3.xyz, tmp2.xyz);
                tmp4.w = tmp4.w + tmp4.w;
                tmp5.xyz = tmp2.xyz * -tmp4.www + tmp3.xyz;
                tmp6.xyz = tmp4.xxx * _LightColor0.xyz;
                if (tmp3.w) {
                    tmp3.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp7.xyz = inp.texcoord3.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp7.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.www + tmp7.xyz;
                    tmp7.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.www + tmp7.xyz;
                    tmp7.xyz = tmp7.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp8.y = inp.texcoord2.w;
                    tmp8.z = inp.texcoord3.w;
                    tmp8.w = inp.texcoord4.w;
                    tmp7.xyz = tmp3.www ? tmp7.xyz : tmp8.yzw;
                    tmp7.xyz = tmp7.xyz - unity_ProbeVolumeMin;
                    tmp7.yzw = tmp7.xyz * unity_ProbeVolumeSizeInv;
                    tmp3.w = tmp7.y * 0.25;
                    tmp4.x = unity_ProbeVolumeParams.z * 0.5;
                    tmp4.w = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp3.w = max(tmp3.w, tmp4.x);
                    tmp7.x = min(tmp4.w, tmp3.w);
                    tmp8 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp7.xzw);
                    tmp9.xyz = tmp7.xzw + float3(0.25, 0.0, 0.0);
                    tmp9 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp9.xyz);
                    tmp7.xyz = tmp7.xzw + float3(0.5, 0.0, 0.0);
                    tmp7 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp7.xyz);
                    tmp2.w = 1.0;
                    tmp8.x = dot(tmp8, tmp2);
                    tmp8.y = dot(tmp9, tmp2);
                    tmp8.z = dot(tmp7, tmp2);
                } else {
                    tmp2.w = 1.0;
                    tmp8.x = dot(unity_SHAr, tmp2);
                    tmp8.y = dot(unity_SHAg, tmp2);
                    tmp8.z = dot(unity_SHAb, tmp2);
                }
                tmp7.xyz = tmp8.xyz + inp.texcoord5.xyz;
                tmp7.xyz = max(tmp7.xyz, float3(0.0, 0.0, 0.0));
                tmp2.w = unity_SpecCube0_ProbePosition.w > 0.0;
                if (tmp2.w) {
                    tmp2.w = dot(tmp5.xyz, tmp5.xyz);
                    tmp2.w = rsqrt(tmp2.w);
                    tmp8.xyz = tmp2.www * tmp5.xyz;
                    tmp9.x = inp.texcoord2.w;
                    tmp9.y = inp.texcoord3.w;
                    tmp9.z = inp.texcoord4.w;
                    tmp10.xyz = unity_SpecCube0_BoxMax.xyz - tmp9.xyz;
                    tmp10.xyz = tmp10.xyz / tmp8.xyz;
                    tmp11.xyz = unity_SpecCube0_BoxMin.xyz - tmp9.xyz;
                    tmp11.xyz = tmp11.xyz / tmp8.xyz;
                    tmp12.xyz = tmp8.xyz > float3(0.0, 0.0, 0.0);
                    tmp10.xyz = tmp12.xyz ? tmp10.xyz : tmp11.xyz;
                    tmp2.w = min(tmp10.y, tmp10.x);
                    tmp2.w = min(tmp10.z, tmp2.w);
                    tmp9.xyz = tmp9.xyz - unity_SpecCube0_ProbePosition.xyz;
                    tmp8.xyz = tmp8.xyz * tmp2.www + tmp9.xyz;
                } else {
                    tmp8.xyz = tmp5.xyz;
                }
                tmp2.w = -tmp4.z * 0.7 + 1.7;
                tmp2.w = tmp2.w * tmp4.z;
                tmp2.w = tmp2.w * 6.0;
                tmp8 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp8.xyz, tmp2.w));
                tmp3.w = tmp8.w - 1.0;
                tmp3.w = unity_SpecCube0_HDR.w * tmp3.w + 1.0;
                tmp3.w = log(tmp3.w);
                tmp3.w = tmp3.w * unity_SpecCube0_HDR.y;
                tmp3.w = exp(tmp3.w);
                tmp3.w = tmp3.w * unity_SpecCube0_HDR.x;
                tmp9.xyz = tmp8.xyz * tmp3.www;
                tmp4.x = unity_SpecCube0_BoxMin.w < 0.99999;
                if (tmp4.x) {
                    tmp4.x = unity_SpecCube1_ProbePosition.w > 0.0;
                    if (tmp4.x) {
                        tmp4.x = dot(tmp5.xyz, tmp5.xyz);
                        tmp4.x = rsqrt(tmp4.x);
                        tmp10.xyz = tmp4.xxx * tmp5.xyz;
                        tmp11.x = inp.texcoord2.w;
                        tmp11.y = inp.texcoord3.w;
                        tmp11.z = inp.texcoord4.w;
                        tmp12.xyz = unity_SpecCube1_BoxMax.xyz - tmp11.xyz;
                        tmp12.xyz = tmp12.xyz / tmp10.xyz;
                        tmp13.xyz = unity_SpecCube1_BoxMin.xyz - tmp11.xyz;
                        tmp13.xyz = tmp13.xyz / tmp10.xyz;
                        tmp14.xyz = tmp10.xyz > float3(0.0, 0.0, 0.0);
                        tmp12.xyz = tmp14.xyz ? tmp12.xyz : tmp13.xyz;
                        tmp4.x = min(tmp12.y, tmp12.x);
                        tmp4.x = min(tmp12.z, tmp4.x);
                        tmp11.xyz = tmp11.xyz - unity_SpecCube1_ProbePosition.xyz;
                        tmp5.xyz = tmp10.xyz * tmp4.xxx + tmp11.xyz;
                    }
                    tmp5 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp5.xyz, tmp2.w));
                    tmp2.w = tmp5.w - 1.0;
                    tmp2.w = unity_SpecCube1_HDR.w * tmp2.w + 1.0;
                    tmp2.w = log(tmp2.w);
                    tmp2.w = tmp2.w * unity_SpecCube1_HDR.y;
                    tmp2.w = exp(tmp2.w);
                    tmp2.w = tmp2.w * unity_SpecCube1_HDR.x;
                    tmp5.xyz = tmp5.xyz * tmp2.www;
                    tmp8.xyz = tmp3.www * tmp8.xyz + -tmp5.xyz;
                    tmp9.xyz = unity_SpecCube0_BoxMin.www * tmp8.xyz + tmp5.xyz;
                }
                tmp5.xyz = tmp4.yyy * tmp9.xyz;
                tmp8.xyz = -inp.texcoord1.xyz * tmp1.www + _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp8.xyz, tmp8.xyz);
                tmp1.w = max(tmp1.w, 0.001);
                tmp1.w = rsqrt(tmp1.w);
                tmp8.xyz = tmp1.www * tmp8.xyz;
                tmp1.w = dot(tmp2.xyz, -tmp3.xyz);
                tmp2.w = saturate(dot(tmp2.xyz, _WorldSpaceLightPos0.xyz));
                tmp2.x = saturate(dot(tmp2.xyz, tmp8.xyz));
                tmp2.y = saturate(dot(_WorldSpaceLightPos0.xyz, tmp8.xyz));
                tmp2.z = tmp2.y * tmp2.y;
                tmp2.z = dot(tmp2.xy, tmp4.xy);
                tmp2.z = tmp2.z - 0.5;
                tmp3.x = 1.0 - tmp2.w;
                tmp3.y = tmp3.x * tmp3.x;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.x = tmp3.x * tmp3.y;
                tmp3.x = tmp2.z * tmp3.x + 1.0;
                tmp3.y = 1.0 - abs(tmp1.w);
                tmp3.z = tmp3.y * tmp3.y;
                tmp3.z = tmp3.z * tmp3.z;
                tmp3.y = tmp3.y * tmp3.z;
                tmp2.z = tmp2.z * tmp3.y + 1.0;
                tmp2.z = tmp2.z * tmp3.x;
                tmp2.z = tmp2.w * tmp2.z;
                tmp3.x = tmp4.z * tmp4.z;
                tmp3.z = -tmp4.z * tmp4.z + 1.0;
                tmp3.w = abs(tmp1.w) * tmp3.z + tmp3.x;
                tmp3.z = tmp2.w * tmp3.z + tmp3.x;
                tmp1.w = abs(tmp1.w) * tmp3.z;
                tmp1.w = tmp2.w * tmp3.w + tmp1.w;
                tmp1.w = tmp1.w + 0.00001;
                tmp1.w = 0.5 / tmp1.w;
                tmp3.z = tmp3.x * tmp3.x;
                tmp3.w = tmp2.x * tmp3.z + -tmp2.x;
                tmp2.x = tmp3.w * tmp2.x + 1.0;
                tmp3.z = tmp3.z * 0.3183099;
                tmp2.x = tmp2.x * tmp2.x + 0.0000001;
                tmp2.x = tmp3.z / tmp2.x;
                tmp1.w = tmp1.w * tmp2.x;
                tmp1.w = tmp1.w * 3.141593;
                tmp1.w = tmp2.w * tmp1.w;
                tmp1.w = max(tmp1.w, 0.0);
                tmp2.x = tmp3.x * tmp3.x + 1.0;
                tmp2.x = 1.0 / tmp2.x;
                tmp2.w = dot(tmp0.xyz, tmp0.xyz);
                tmp2.w = tmp2.w != 0.0;
                tmp2.w = tmp2.w ? 1.0 : 0.0;
                tmp1.w = tmp1.w * tmp2.w;
                tmp0.w = _Glossiness - tmp0.w;
                tmp0.w = saturate(tmp0.w + 1.0);
                tmp3.xzw = tmp2.zzz * tmp6.xyz;
                tmp3.xzw = tmp7.xyz * tmp4.yyy + tmp3.xzw;
                tmp4.xyz = tmp6.xyz * tmp1.www;
                tmp1.w = 1.0 - tmp2.y;
                tmp2.y = tmp1.w * tmp1.w;
                tmp2.y = tmp2.y * tmp2.y;
                tmp1.w = tmp1.w * tmp2.y;
                tmp2.yzw = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp2.yzw = tmp2.yzw * tmp1.www + tmp0.xyz;
                tmp2.yzw = tmp2.yzw * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp3.xzw + tmp2.yzw;
                tmp2.xyz = tmp5.xyz * tmp2.xxx;
                tmp3.xzw = tmp0.www - tmp0.xyz;
                tmp0.xyz = tmp3.yyy * tmp3.xzw + tmp0.xyz;
                o.sv_target.xyz = tmp2.xyz * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDADD" "PerformanceChecks" = "False" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend Zero One, Zero One
			ZClip Off
			ZWrite Off
			GpuProgramID 106705
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _DetailAlbedoMap_ST;
			float _UVSec;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float4 _Color;
			float _Metallic;
			float _Glossiness;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _LightTexture0;
			
			// Keywords: POINT
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _UVSec == 0.0;
                tmp0.xy = tmp0.xx ? v.texcoord.xy : v.texcoord1.xy;
                o.texcoord.zw = tmp0.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp1.xyz = -tmp0.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                o.texcoord5.xyz = tmp0.xyz;
                tmp1.w = 0.0;
                o.texcoord2 = tmp1.wwwx;
                o.texcoord3 = tmp1.wwwy;
                o.texcoord4.w = tmp1.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                o.texcoord6.xy = float2(0.0, 0.0);
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz * _Color.xyz;
                tmp0.xyz = _Color.xyz * tmp0.xyz + float3(-0.04, -0.04, -0.04);
                tmp0.xyz = _Metallic.xxx * tmp0.xyz + float3(0.04, 0.04, 0.04);
                tmp0.w = -_Metallic * 0.96 + 0.96;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * inp.texcoord4.xyz;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp4.xyz = inp.texcoord5.yyy * unity_WorldToLight._m01_m11_m21;
                tmp4.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord5.xxx + tmp4.xyz;
                tmp4.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord5.zzz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord5.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord5.xxx + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord5.zzz + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.xyz = tmp0.www ? tmp5.xyz : inp.texcoord5.xyz;
                    tmp5.xyz = tmp5.xyz - unity_ProbeVolumeMin;
                    tmp5.yzw = tmp5.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp5.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp5.x = max(tmp0.w, tmp1.w);
                    tmp5 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp5.xzw);
                } else {
                    tmp5 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp5, unity_OcclusionMaskSelector));
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp4 = tex2D(_LightTexture0, tmp1.ww);
                tmp0.w = tmp0.w * tmp4.x;
                tmp4.x = inp.texcoord2.w;
                tmp4.y = inp.texcoord3.w;
                tmp4.z = inp.texcoord4.w;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp5.xyz = tmp1.www * tmp4.xyz;
                tmp6.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.w = 1.0 - _Glossiness;
                tmp4.xyz = tmp4.xyz * tmp1.www + -tmp3.xyz;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = max(tmp1.w, 0.001);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * tmp4.xyz;
                tmp1.w = dot(tmp2.xyz, -tmp3.xyz);
                tmp2.w = saturate(dot(tmp2.xyz, tmp5.xyz));
                tmp2.x = saturate(dot(tmp2.xyz, tmp4.xyz));
                tmp2.y = saturate(dot(tmp5.xyz, tmp4.xyz));
                tmp2.z = tmp2.y * tmp2.y;
                tmp2.z = dot(tmp2.xy, tmp0.xy);
                tmp2.z = tmp2.z - 0.5;
                tmp3.x = 1.0 - tmp2.w;
                tmp3.y = tmp3.x * tmp3.x;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.x = tmp3.x * tmp3.y;
                tmp3.x = tmp2.z * tmp3.x + 1.0;
                tmp3.y = 1.0 - abs(tmp1.w);
                tmp3.z = tmp3.y * tmp3.y;
                tmp3.z = tmp3.z * tmp3.z;
                tmp3.y = tmp3.y * tmp3.z;
                tmp2.z = tmp2.z * tmp3.y + 1.0;
                tmp2.z = tmp2.z * tmp3.x;
                tmp2.z = tmp2.w * tmp2.z;
                tmp3.x = tmp0.w * tmp0.w;
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp3.y = abs(tmp1.w) * tmp0.w + tmp3.x;
                tmp0.w = tmp2.w * tmp0.w + tmp3.x;
                tmp0.w = tmp0.w * abs(tmp1.w);
                tmp0.w = tmp2.w * tmp3.y + tmp0.w;
                tmp0.w = tmp0.w + 0.00001;
                tmp0.w = 0.5 / tmp0.w;
                tmp1.w = tmp3.x * tmp3.x;
                tmp3.x = tmp2.x * tmp1.w + -tmp2.x;
                tmp2.x = tmp3.x * tmp2.x + 1.0;
                tmp1.w = tmp1.w * 0.3183099;
                tmp2.x = tmp2.x * tmp2.x + 0.0000001;
                tmp1.w = tmp1.w / tmp2.x;
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = tmp0.w * 3.141593;
                tmp0.w = tmp2.w * tmp0.w;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = tmp1.w != 0.0;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w * tmp1.w;
                tmp2.xzw = tmp2.zzz * tmp6.xyz;
                tmp3.xyz = tmp6.xyz * tmp0.www;
                tmp0.w = 1.0 - tmp2.y;
                tmp1.w = tmp0.w * tmp0.w;
                tmp1.w = tmp1.w * tmp1.w;
                tmp0.w = tmp0.w * tmp1.w;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.xyz = tmp4.xyz * tmp0.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp2.xzw + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "SHADOWCASTER"
			LOD 300
			Tags { "LIGHTMODE" = "SHADOWCASTER" "PerformanceChecks" = "False" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			ZClip Off
			GpuProgramID 152844
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH _PARALLAXMAP
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
			// Keywords: SHADOWS_DEPTH _PARALLAXMAP
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 300
			Tags { "LIGHTMODE" = "META" "PerformanceChecks" = "False" "RenderType" = "Opaque" }
			ZClip Off
			Cull Off
			GpuProgramID 227390
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
			float4 _MainTex_ST;
			float4 _DetailAlbedoMap_ST;
			float _UVSec;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _Metallic;
			float _Glossiness;
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
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
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _UVSec == 0.0;
                tmp0.xy = tmp0.xx ? v.texcoord.xy : v.texcoord1.xy;
                o.texcoord.zw = tmp0.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
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
                tmp0.x = 1.0 - _Glossiness;
                tmp0.x = tmp0.x * tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.yzw = _Color.xyz * tmp1.xyz + float3(-0.04, -0.04, -0.04);
                tmp1.xyz = tmp1.xyz * _Color.xyz;
                tmp0.yzw = _Metallic.xxx * tmp0.yzw + float3(0.04, 0.04, 0.04);
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp0.w = -_Metallic * 0.96 + 0.96;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.xyz = log(tmp0.xyz);
                tmp0.w = saturate(unity_OneOverOutputBoost);
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = exp(tmp0.xyz);
                tmp0.xyz = min(tmp0.xyz, unity_MaxOutputValue.xxx);
                tmp0.w = 1.0;
                tmp0 = unity_MetaFragmentControl ? tmp0 : float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target = unity_MetaFragmentControl ? float4(0.0, 0.0, 0.0, 0.0235294) : tmp0;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		LOD 150
		Tags { "PerformanceChecks" = "False" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			LOD 150
			Tags { "LIGHTMODE" = "FORWARDBASE" "PerformanceChecks" = "False" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend Zero Zero, Zero Zero
			ZClip Off
			ZWrite Off
			GpuProgramID 264232
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _DetailAlbedoMap_ST;
			float _UVSec;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float _Metallic;
			float _Glossiness;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _OcclusionMap;
			sampler2D unity_NHxRoughness;
			
			// Keywords: DIRECTIONAL
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
                tmp0.x = _UVSec == 0.0;
                tmp0.xy = tmp0.xx ? v.texcoord.xy : v.texcoord1.xy;
                o.texcoord.zw = tmp0.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp0.w = 0.0;
                o.texcoord2 = tmp0.wwwx;
                o.texcoord3 = tmp0.wwwy;
                o.texcoord4.w = tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord4.xyz = tmp0.xyz;
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz * _Color.xyz;
                tmp0.xyz = _Color.xyz * tmp0.xyz + float3(-0.04, -0.04, -0.04);
                tmp0.xyz = _Metallic.xxx * tmp0.xyz + float3(0.04, 0.04, 0.04);
                tmp0.w = -_Metallic * 0.96 + 0.96;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * inp.texcoord4.xyz;
                tmp1.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.w) {
                    tmp1.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord3.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.www + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.www + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp4.y = inp.texcoord2.w;
                    tmp4.z = inp.texcoord3.w;
                    tmp4.w = inp.texcoord4.w;
                    tmp3.xyz = tmp1.www ? tmp3.xyz : tmp4.yzw;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp1.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp3 = tex2D(_OcclusionMap, inp.texcoord.xy);
                tmp4.xw = float2(1.0, 1.0) - _Glossiness.xx;
                tmp2.w = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp3.xzw = tmp2.xyz * -tmp2.www + inp.texcoord1.xyz;
                tmp5.xyz = tmp1.www * _LightColor0.xyz;
                tmp6.xyz = tmp3.yyy * inp.texcoord5.xyz;
                tmp1.w = -tmp4.x * 0.7 + 1.7;
                tmp1.w = tmp1.w * tmp4.x;
                tmp1.w = tmp1.w * 6.0;
                tmp7 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp3.xzw, tmp1.w));
                tmp1.w = tmp7.w - 1.0;
                tmp1.w = unity_SpecCube0_HDR.w * tmp1.w + 1.0;
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * unity_SpecCube0_HDR.y;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * unity_SpecCube0_HDR.x;
                tmp3.xzw = tmp7.xyz * tmp1.www;
                tmp3.xyz = tmp3.yyy * tmp3.xzw;
                tmp1.w = dot(-inp.texcoord1.xyz, tmp2.xyz);
                tmp2.w = tmp1.w + tmp1.w;
                tmp7.xyz = tmp2.xyz * -tmp2.www + -inp.texcoord1.xyz;
                tmp2.x = saturate(dot(tmp2.xyz, _WorldSpaceLightPos0.xyz));
                tmp1.w = saturate(tmp1.w);
                tmp7.x = dot(tmp7.xyz, _WorldSpaceLightPos0.xyz);
                tmp7.y = 1.0 - tmp1.w;
                tmp7.zw = tmp7.xy * tmp7.xy;
                tmp2.yz = tmp7.xy * tmp7.xw;
                tmp4.yz = tmp7.zy * tmp2.yz;
                tmp0.w = _Glossiness - tmp0.w;
                tmp0.w = saturate(tmp0.w + 1.0);
                tmp7 = tex2D(unity_NHxRoughness, tmp4.yw);
                tmp1.w = tmp7.x * 16.0;
                tmp2.yzw = tmp1.www * tmp0.xyz + tmp1.xyz;
                tmp4.xyw = tmp2.xxx * tmp5.xyz;
                tmp5.xyz = tmp0.www - tmp0.xyz;
                tmp0.xyz = tmp4.zzz * tmp5.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp0.xyz = tmp6.xyz * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp2.yzw * tmp4.xyw + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 150
			Tags { "LIGHTMODE" = "FORWARDADD" "PerformanceChecks" = "False" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend Zero One, Zero One
			ZClip Off
			ZWrite Off
			GpuProgramID 374179
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _DetailAlbedoMap_ST;
			float _UVSec;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float4 _Color;
			float _Metallic;
			float _Glossiness;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _LightTexture0;
			sampler2D unity_NHxRoughness;
			
			// Keywords: POINT
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _UVSec == 0.0;
                tmp0.xy = tmp0.xx ? v.texcoord.xy : v.texcoord1.xy;
                o.texcoord.zw = tmp0.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = -tmp0.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                o.texcoord5.xyz = tmp0.xyz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.w = 0.0;
                o.texcoord2 = tmp0.wwwx;
                o.texcoord3 = tmp0.wwwy;
                o.texcoord4.w = tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                o.texcoord6.xy = float2(0.0, 0.0);
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz * _Color.xyz;
                tmp0.xyz = _Color.xyz * tmp0.xyz + float3(-0.04, -0.04, -0.04);
                tmp0.xyz = _Metallic.xxx * tmp0.xyz + float3(0.04, 0.04, 0.04);
                tmp0.w = -_Metallic * 0.96 + 0.96;
                tmp1.w = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * inp.texcoord4.xyz;
                tmp3.xyz = inp.texcoord5.yyy * unity_WorldToLight._m01_m11_m21;
                tmp3.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord5.xxx + tmp3.xyz;
                tmp3.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord5.zzz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToLight._m03_m13_m23;
                tmp1.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.w) {
                    tmp1.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.xyz = inp.texcoord5.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord5.xxx + tmp4.xyz;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord5.zzz + tmp4.xyz;
                    tmp4.xyz = tmp4.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp4.xyz = tmp1.www ? tmp4.xyz : inp.texcoord5.xyz;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.w = tmp4.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp1.w, tmp2.w);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.w = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3 = tex2D(_LightTexture0, tmp2.ww);
                tmp1.w = tmp1.w * tmp3.x;
                tmp3.xyz = tmp1.www * _LightColor0.xyz;
                tmp1.w = dot(-inp.texcoord1.xyz, tmp2.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp4.xyz = tmp2.xyz * -tmp1.www + -inp.texcoord1.xyz;
                tmp5.x = inp.texcoord2.w;
                tmp5.y = inp.texcoord3.w;
                tmp5.z = inp.texcoord4.w;
                tmp1.w = saturate(dot(tmp2.xyz, tmp5.xyz));
                tmp2.x = dot(tmp4.xyz, tmp5.xyz);
                tmp2.x = tmp2.x * tmp2.x;
                tmp2.x = tmp2.x * tmp2.x;
                tmp2.y = 1.0 - _Glossiness;
                tmp2 = tex2D(unity_NHxRoughness, tmp2.xy);
                tmp2.x = tmp2.x * 16.0;
                tmp0.xyz = tmp0.xyz * tmp2.xxx;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp1.xyz = tmp1.www * tmp3.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "SHADOWCASTER"
			LOD 150
			Tags { "LIGHTMODE" = "SHADOWCASTER" "PerformanceChecks" = "False" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			ZClip Off
			GpuProgramID 394004
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
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
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 150
			Tags { "LIGHTMODE" = "META" "PerformanceChecks" = "False" "RenderType" = "Opaque" }
			ZClip Off
			Cull Off
			GpuProgramID 519492
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
			float4 _MainTex_ST;
			float4 _DetailAlbedoMap_ST;
			float _UVSec;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _Metallic;
			float _Glossiness;
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
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
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _UVSec == 0.0;
                tmp0.xy = tmp0.xx ? v.texcoord.xy : v.texcoord1.xy;
                o.texcoord.zw = tmp0.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
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
                tmp0.x = 1.0 - _Glossiness;
                tmp0.x = tmp0.x * tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.yzw = _Color.xyz * tmp1.xyz + float3(-0.04, -0.04, -0.04);
                tmp1.xyz = tmp1.xyz * _Color.xyz;
                tmp0.yzw = _Metallic.xxx * tmp0.yzw + float3(0.04, 0.04, 0.04);
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp0.w = -_Metallic * 0.96 + 0.96;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.xyz = log(tmp0.xyz);
                tmp0.w = saturate(unity_OneOverOutputBoost);
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = exp(tmp0.xyz);
                tmp0.xyz = min(tmp0.xyz, unity_MaxOutputValue.xxx);
                tmp0.w = 1.0;
                tmp0 = unity_MetaFragmentControl ? tmp0 : float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target = unity_MetaFragmentControl ? float4(0.0, 0.0, 0.0, 0.0235294) : tmp0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "VertexLit"
	CustomEditor "UnityStandardShaderGUI"
}