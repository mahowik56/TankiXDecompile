Shader "Alternativa/LayersStandard" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		[NoScaleOffset] _Masks ("Layer Masks", 2D) = "white" {}
		_MainTex1 ("Albedo Layer 1", 2D) = "white" {}
		_MainTex2 ("Albedo Layer 2", 2D) = "white" {}
		_MainTex3 ("Albedo Layer 3", 2D) = "white" {}
		_SmoothnessStrength1 ("Smoothness Layer 1", Range(0, 1)) = 0.5
		_SmoothnessStrength2 ("Smoothness Layer 2", Range(0, 1)) = 0.5
		_SmoothnessStrength3 ("Smoothness Layer 3", Range(0, 1)) = 0.5
		[Gamma] _Metallic1 ("Metallic Layer 1", Range(0, 1)) = 0
		[Gamma] _Metallic2 ("Metallic Layer 2", Range(0, 1)) = 0
		[Gamma] _Metallic3 ("Metallic Layer 3", Range(0, 1)) = 0
		[ToggleOff] _SpecularHighlights ("Specular Highlights", Float) = 1
		[ToggleOff] _GlossyReflections ("Glossy Reflections", Float) = 1
		_BumpScale1 ("Scale1", Float) = 1
		_BumpScale2 ("Scale2", Float) = 1
		_BumpScale3 ("Scale3", Float) = 1
		_BumpMap1 ("Normal Map Layer 1", 2D) = "bump" {}
		_BumpMap2 ("Normal Map Layer 2", 2D) = "bump" {}
		_BumpMap3 ("Normal Map Layer 3", 2D) = "bump" {}
		[NoScaleOffset] _ParallaxMap1 ("Height Map(B)", 2D) = "white" {}
		[NoScaleOffset] _ParallaxMap2 ("Height Map(B)", 2D) = "white" {}
		[NoScaleOffset] _ParallaxMap3 ("Height Map(B)", 2D) = "white" {}
		_Parallax1 ("Height Scale 1", Range(0.005, 0.08)) = 0.02
		_Parallax2 ("Height Scale 2", Range(0.005, 0.08)) = 0.02
		_Parallax3 ("Height Scale 3", Range(0.005, 0.08)) = 0.02
		_OcclusionStrength1 ("Occlusion Strength 1", Range(0, 1)) = 1
		_OcclusionStrength2 ("Occlusion Strength 2", Range(0, 1)) = 1
		_OcclusionStrength3 ("Occlusion Strength 3", Range(0, 1)) = 1
		_Layer2 ("", Float) = 0
		_Layer3 ("", Float) = 0
		_ParallaxMapDef_1 ("", Float) = 0
		_ParallaxMapDef_2 ("", Float) = 0
		_ParallaxMapDef_3 ("", Float) = 0
		[Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0
		[HideInInspector] _Mode ("__mode", Float) = 0
		[HideInInspector] _SrcBlend ("__src", Float) = 1
		[HideInInspector] _DstBlend ("__dst", Float) = 0
		[HideInInspector] _ZWrite ("__zw", Float) = 1
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
			GpuProgramID 34375
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord10 : TEXCOORD10;
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
			float4 _MainTex1_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float _BumpScale1;
			float _BumpScale2;
			float _BumpScale3;
			float _Metallic1;
			float _Metallic2;
			float _Metallic3;
			float _SmoothnessStrength1;
			float _SmoothnessStrength2;
			float _SmoothnessStrength3;
			float _OcclusionStrength1;
			float _OcclusionStrength2;
			float _OcclusionStrength3;
			float _Parallax1;
			float _Parallax2;
			float _Parallax3;
			float _Layer2;
			float _Layer3;
			float _ParallaxMapDef_1;
			float _ParallaxMapDef_2;
			float _ParallaxMapDef_3;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _ParallaxMap1;
			sampler2D _ParallaxMap2;
			sampler2D _ParallaxMap3;
			sampler2D _MainTex1;
			sampler2D _MainTex2;
			sampler2D _MainTex3;
			sampler2D _Masks;
			sampler2D _BumpMap1;
			sampler2D _BumpMap2;
			sampler2D _BumpMap3;
			
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
                o.texcoord.zw = v.texcoord.xy * _MainTex1_ST.xy + _MainTex1_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord10.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord10.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
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
                tmp0 = tex2D(_ParallaxMap1, inp.texcoord.zw);
                tmp1 = float4(_Layer2.x, _Layer3.x, _ParallaxMapDef_1.x, _ParallaxMapDef_2.x) != float4(0.0, 0.0, 0.0, 0.0);
                if (tmp1.x) {
                    tmp2 = tex2D(_ParallaxMap2, inp.texcoord10.xy);
                } else {
                    tmp2.x = 0.0;
                }
                if (tmp1.y) {
                    tmp3 = tex2D(_ParallaxMap3, inp.texcoord10.zw);
                } else {
                    tmp3.x = 0.0;
                }
                tmp4.x = inp.texcoord2.w;
                tmp4.y = inp.texcoord3.w;
                tmp4.z = inp.texcoord4.w;
                tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.yw = tmp0.xx * tmp4.xy;
                tmp2.yzw = float3(_Parallax1.x, _Parallax2.x, _Parallax3.x) * float3(0.5, 0.5, 0.5);
                tmp0.z = tmp0.z * _Parallax1 + -tmp2.y;
                tmp0.x = tmp4.z * tmp0.x + 0.42;
                tmp0.xy = tmp0.yw / tmp0.xx;
                tmp0.zw = tmp0.zz * tmp0.xy + inp.texcoord.zw;
                tmp0.zw = tmp1.zz ? tmp0.zw : inp.texcoord.zw;
                tmp1.z = tmp1.w ? tmp1.x : 0.0;
                tmp1.w = tmp2.x * _Parallax2 + -tmp2.z;
                tmp2.xy = tmp1.ww * tmp0.xy + inp.texcoord10.xy;
                tmp1.zw = tmp1.zz ? tmp2.xy : inp.texcoord10.xy;
                tmp2.x = _ParallaxMapDef_3 != 0.0;
                tmp2.x = tmp1.y ? tmp2.x : 0.0;
                tmp2.y = tmp3.x * _Parallax3 + -tmp2.w;
                tmp0.xy = tmp2.yy * tmp0.xy + inp.texcoord10.zw;
                tmp0.xy = tmp2.xx ? tmp0.xy : inp.texcoord10.zw;
                tmp2 = tex2D(_ParallaxMap1, tmp0.zw);
                if (tmp1.x) {
                    tmp3 = tex2D(_ParallaxMap2, tmp1.zw);
                } else {
                    tmp3.xz = float2(0.0, 0.0);
                }
                if (tmp1.y) {
                    tmp4 = tex2D(_ParallaxMap3, tmp0.xy);
                } else {
                    tmp4.xz = float2(0.0, 0.0);
                }
                tmp5 = tex2D(_MainTex1, tmp0.zw);
                if (tmp1.x) {
                    tmp6 = tex2D(_MainTex2, tmp1.zw);
                }
                if (tmp1.y) {
                    tmp7 = tex2D(_MainTex3, tmp0.xy);
                }
                tmp8 = tex2D(_Masks, inp.texcoord.xy);
                tmp2.xw = tmp8.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.yw = tmp2.zz - tmp2.xw;
                tmp2.x = tmp2.x + tmp3.z;
                tmp2.x = tmp2.x - tmp3.y;
                tmp2.x = tmp2.x + 0.3125;
                tmp2.x = saturate(tmp2.x * 1.6);
                tmp2.z = tmp2.w + tmp4.z;
                tmp2.z = tmp2.z - tmp3.w;
                tmp2.z = tmp2.z + 0.3125;
                tmp2.z = saturate(tmp2.z * 1.6);
                tmp2.xz = tmp1.xy ? tmp2.xz : tmp8.xy;
                tmp2.w = tmp5.w * _SmoothnessStrength1;
                if (tmp1.x) {
                    tmp3.y = _Metallic2 - _Metallic1;
                    tmp3.y = tmp2.x * tmp3.y + _Metallic1;
                    tmp8 = tex2D(_MainTex2, tmp1.zw);
                    tmp3.z = tmp8.w * _SmoothnessStrength2 + -tmp2.w;
                    tmp2.w = tmp2.x * tmp3.z + tmp2.w;
                } else {
                    tmp3.y = _Metallic1;
                }
                if (tmp1.y) {
                    tmp3.z = _Metallic3 - tmp3.y;
                    tmp3.y = tmp2.z * tmp3.z + tmp3.y;
                    tmp8 = tex2D(_MainTex3, tmp0.xy);
                    tmp3.z = tmp8.w * _SmoothnessStrength3 + -tmp2.w;
                    tmp2.w = tmp2.z * tmp3.z + tmp2.w;
                }
                tmp4.yzw = tmp6.xyz - tmp5.xyz;
                tmp4.yzw = tmp2.xxx * tmp4.yzw + tmp5.xyz;
                tmp4.yzw = tmp1.xxx ? tmp4.yzw : tmp5.xyz;
                tmp5.xyz = tmp7.xyz - tmp4.yzw;
                tmp5.xyz = tmp2.zzz * tmp5.xyz + tmp4.yzw;
                tmp4.yzw = tmp1.yyy ? tmp5.xyz : tmp4.yzw;
                tmp5.xyz = tmp4.yzw * _Color.xyz;
                tmp4.yzw = tmp4.yzw * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp4.yzw = tmp3.yyy * tmp4.yzw + float3(0.04, 0.04, 0.04);
                tmp3.y = -tmp3.y * 0.96 + 0.96;
                tmp5.xyz = tmp3.yyy * tmp5.xyz;
                tmp6 = tex2D(_BumpMap1, tmp0.zw);
                tmp0.zw = tmp6.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp6.xy = tmp0.zw * _BumpScale1.xx;
                tmp0.z = dot(tmp6.xy, tmp6.xy);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp6.z = sqrt(tmp0.z);
                if (tmp1.x) {
                    tmp7 = tex2D(_BumpMap2, tmp1.zw);
                    tmp0.zw = tmp7.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp7.xy = tmp0.zw * _BumpScale2.xx;
                    tmp0.z = dot(tmp7.xy, tmp7.xy);
                    tmp0.z = min(tmp0.z, 1.0);
                    tmp0.z = 1.0 - tmp0.z;
                    tmp7.z = sqrt(tmp0.z);
                    tmp7.xyz = tmp7.xyz - tmp6.xyz;
                    tmp7.xyz = tmp2.xxx * tmp7.xyz + tmp6.xyz;
                    tmp0.z = dot(tmp7.xyz, tmp7.xyz);
                    tmp0.z = rsqrt(tmp0.z);
                    tmp6.xyz = tmp0.zzz * tmp7.xyz;
                }
                if (tmp1.y) {
                    tmp0 = tex2D(_BumpMap3, tmp0.xy);
                    tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp0.xy = tmp0.xy * _BumpScale3.xx;
                    tmp0.w = dot(tmp0.xy, tmp0.xy);
                    tmp0.w = min(tmp0.w, 1.0);
                    tmp0.w = 1.0 - tmp0.w;
                    tmp0.z = sqrt(tmp0.w);
                    tmp0.xyz = tmp0.xyz - tmp6.xyz;
                    tmp0.xyz = tmp2.zzz * tmp0.xyz + tmp6.xyz;
                    tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                    tmp0.w = rsqrt(tmp0.w);
                    tmp6.xyz = tmp0.www * tmp0.xyz;
                }
                tmp0.xyz = tmp6.yyy * inp.texcoord3.xyz;
                tmp0.xyz = inp.texcoord2.xyz * tmp6.xxx + tmp0.xyz;
                tmp0.xyz = inp.texcoord4.xyz * tmp6.zzz + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp6.xyz = tmp1.zzz * inp.texcoord1.xyz;
                tmp1.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.w) {
                    tmp3.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp7.xyz = inp.texcoord8.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp7.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord8.xxx + tmp7.xyz;
                    tmp7.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord8.zzz + tmp7.xyz;
                    tmp7.xyz = tmp7.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp7.xyz = tmp3.zzz ? tmp7.xyz : inp.texcoord8.xyz;
                    tmp7.xyz = tmp7.xyz - unity_ProbeVolumeMin;
                    tmp7.yzw = tmp7.xyz * unity_ProbeVolumeSizeInv;
                    tmp3.z = tmp7.y * 0.25 + 0.75;
                    tmp3.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp7.x = max(tmp3.w, tmp3.z);
                    tmp7 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp7.xzw);
                } else {
                    tmp7 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp3.z = saturate(dot(tmp7, unity_OcclusionMaskSelector));
                tmp7.xyz = -float3(_OcclusionStrength1.x, _OcclusionStrength2.x, _OcclusionStrength3.x) + float3(1.0, 1.0, 1.0);
                tmp2.y = tmp2.y * _OcclusionStrength1 + tmp7.x;
                tmp3.x = tmp3.x * _OcclusionStrength2 + tmp7.y;
                tmp3.x = tmp3.x - tmp2.y;
                tmp2.x = tmp2.x * tmp3.x + tmp2.y;
                tmp1.x = tmp1.x ? tmp2.x : tmp2.y;
                tmp2.x = tmp4.x * _OcclusionStrength3 + tmp7.z;
                tmp2.x = tmp2.x - tmp1.x;
                tmp2.x = tmp2.z * tmp2.x + tmp1.x;
                tmp1.x = tmp1.y ? tmp2.x : tmp1.x;
                tmp1.y = 1.0 - tmp2.w;
                tmp2.x = dot(tmp6.xyz, tmp0.xyz);
                tmp2.x = tmp2.x + tmp2.x;
                tmp2.xyz = tmp0.xyz * -tmp2.xxx + tmp6.xyz;
                tmp3.xzw = tmp3.zzz * _LightColor0.xyz;
                if (tmp1.w) {
                    tmp1.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp7.xyz = inp.texcoord8.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp7.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord8.xxx + tmp7.xyz;
                    tmp7.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord8.zzz + tmp7.xyz;
                    tmp7.xyz = tmp7.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp7.xyz = tmp1.www ? tmp7.xyz : inp.texcoord8.xyz;
                    tmp7.xyz = tmp7.xyz - unity_ProbeVolumeMin;
                    tmp7.yzw = tmp7.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.w = tmp7.y * 0.25;
                    tmp4.x = unity_ProbeVolumeParams.z * 0.5;
                    tmp5.w = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp1.w = max(tmp1.w, tmp4.x);
                    tmp7.x = min(tmp5.w, tmp1.w);
                    tmp8 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp7.xzw);
                    tmp9.xyz = tmp7.xzw + float3(0.25, 0.0, 0.0);
                    tmp9 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp9.xyz);
                    tmp7.xyz = tmp7.xzw + float3(0.5, 0.0, 0.0);
                    tmp7 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp7.xyz);
                    tmp0.w = 1.0;
                    tmp8.x = dot(tmp8, tmp0);
                    tmp8.y = dot(tmp9, tmp0);
                    tmp8.z = dot(tmp7, tmp0);
                } else {
                    tmp0.w = 1.0;
                    tmp8.x = dot(unity_SHAr, tmp0);
                    tmp8.y = dot(unity_SHAg, tmp0);
                    tmp8.z = dot(unity_SHAb, tmp0);
                }
                tmp7.xyz = tmp8.xyz + inp.texcoord5.xyz;
                tmp7.xyz = max(tmp7.xyz, float3(0.0, 0.0, 0.0));
                tmp0.w = unity_SpecCube0_ProbePosition.w > 0.0;
                if (tmp0.w) {
                    tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                    tmp0.w = rsqrt(tmp0.w);
                    tmp8.xyz = tmp0.www * tmp2.xyz;
                    tmp9.xyz = unity_SpecCube0_BoxMax.xyz - inp.texcoord8.xyz;
                    tmp9.xyz = tmp9.xyz / tmp8.xyz;
                    tmp10.xyz = unity_SpecCube0_BoxMin.xyz - inp.texcoord8.xyz;
                    tmp10.xyz = tmp10.xyz / tmp8.xyz;
                    tmp11.xyz = tmp8.xyz > float3(0.0, 0.0, 0.0);
                    tmp9.xyz = tmp11.xyz ? tmp9.xyz : tmp10.xyz;
                    tmp0.w = min(tmp9.y, tmp9.x);
                    tmp0.w = min(tmp9.z, tmp0.w);
                    tmp9.xyz = inp.texcoord8.xyz - unity_SpecCube0_ProbePosition.xyz;
                    tmp8.xyz = tmp8.xyz * tmp0.www + tmp9.xyz;
                } else {
                    tmp8.xyz = tmp2.xyz;
                }
                tmp0.w = -tmp1.y * 0.7 + 1.7;
                tmp0.w = tmp0.w * tmp1.y;
                tmp0.w = tmp0.w * 6.0;
                tmp8 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp8.xyz, tmp0.w));
                tmp1.w = tmp8.w - 1.0;
                tmp1.w = unity_SpecCube0_HDR.w * tmp1.w + 1.0;
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * unity_SpecCube0_HDR.y;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * unity_SpecCube0_HDR.x;
                tmp9.xyz = tmp8.xyz * tmp1.www;
                tmp4.x = unity_SpecCube0_BoxMin.w < 0.99999;
                if (tmp4.x) {
                    tmp4.x = unity_SpecCube1_ProbePosition.w > 0.0;
                    if (tmp4.x) {
                        tmp4.x = dot(tmp2.xyz, tmp2.xyz);
                        tmp4.x = rsqrt(tmp4.x);
                        tmp10.xyz = tmp2.xyz * tmp4.xxx;
                        tmp11.xyz = unity_SpecCube1_BoxMax.xyz - inp.texcoord8.xyz;
                        tmp11.xyz = tmp11.xyz / tmp10.xyz;
                        tmp12.xyz = unity_SpecCube1_BoxMin.xyz - inp.texcoord8.xyz;
                        tmp12.xyz = tmp12.xyz / tmp10.xyz;
                        tmp13.xyz = tmp10.xyz > float3(0.0, 0.0, 0.0);
                        tmp11.xyz = tmp13.xyz ? tmp11.xyz : tmp12.xyz;
                        tmp4.x = min(tmp11.y, tmp11.x);
                        tmp4.x = min(tmp11.z, tmp4.x);
                        tmp11.xyz = inp.texcoord8.xyz - unity_SpecCube1_ProbePosition.xyz;
                        tmp2.xyz = tmp10.xyz * tmp4.xxx + tmp11.xyz;
                    }
                    tmp10 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp2.xyz, tmp0.w));
                    tmp0.w = tmp10.w - 1.0;
                    tmp0.w = unity_SpecCube1_HDR.w * tmp0.w + 1.0;
                    tmp0.w = log(tmp0.w);
                    tmp0.w = tmp0.w * unity_SpecCube1_HDR.y;
                    tmp0.w = exp(tmp0.w);
                    tmp0.w = tmp0.w * unity_SpecCube1_HDR.x;
                    tmp2.xyz = tmp10.xyz * tmp0.www;
                    tmp8.xyz = tmp1.www * tmp8.xyz + -tmp2.xyz;
                    tmp9.xyz = unity_SpecCube0_BoxMin.www * tmp8.xyz + tmp2.xyz;
                }
                tmp2.xyz = tmp1.xxx * tmp9.xyz;
                tmp8.xyz = -inp.texcoord1.xyz * tmp1.zzz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp8.xyz, tmp8.xyz);
                tmp0.w = max(tmp0.w, 0.001);
                tmp0.w = rsqrt(tmp0.w);
                tmp8.xyz = tmp0.www * tmp8.xyz;
                tmp0.w = dot(tmp0.xyz, -tmp6.xyz);
                tmp1.z = saturate(dot(tmp0.xyz, _WorldSpaceLightPos0.xyz));
                tmp0.x = saturate(dot(tmp0.xyz, tmp8.xyz));
                tmp0.y = saturate(dot(_WorldSpaceLightPos0.xyz, tmp8.xyz));
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.z = dot(tmp0.xy, tmp1.xy);
                tmp0.z = tmp0.z - 0.5;
                tmp1.w = 1.0 - tmp1.z;
                tmp4.x = tmp1.w * tmp1.w;
                tmp4.x = tmp4.x * tmp4.x;
                tmp1.w = tmp1.w * tmp4.x;
                tmp1.w = tmp0.z * tmp1.w + 1.0;
                tmp4.x = 1.0 - abs(tmp0.w);
                tmp5.w = tmp4.x * tmp4.x;
                tmp5.w = tmp5.w * tmp5.w;
                tmp4.x = tmp4.x * tmp5.w;
                tmp0.z = tmp0.z * tmp4.x + 1.0;
                tmp0.z = tmp0.z * tmp1.w;
                tmp1.w = tmp1.y * tmp1.y;
                tmp1.y = -tmp1.y * tmp1.y + 1.0;
                tmp5.w = abs(tmp0.w) * tmp1.y + tmp1.w;
                tmp1.y = tmp1.z * tmp1.y + tmp1.w;
                tmp0.w = abs(tmp0.w) * tmp1.y;
                tmp0.w = tmp1.z * tmp5.w + tmp0.w;
                tmp0.w = tmp0.w + 0.00001;
                tmp0.w = 0.5 / tmp0.w;
                tmp1.y = tmp1.w * tmp1.w;
                tmp5.w = tmp0.x * tmp1.y + -tmp0.x;
                tmp0.x = tmp5.w * tmp0.x + 1.0;
                tmp1.y = tmp1.y * 0.3183099;
                tmp0.x = tmp0.x * tmp0.x + 0.0000001;
                tmp0.x = tmp1.y / tmp0.x;
                tmp0.x = tmp0.x * tmp0.w;
                tmp0.x = tmp0.x * 3.141593;
                tmp0.xz = tmp1.zz * tmp0.xz;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.w = tmp1.w * tmp1.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp1.y = dot(tmp4.xyz, tmp4.xyz);
                tmp1.y = tmp1.y != 0.0;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x * tmp1.y;
                tmp1.y = tmp2.w - tmp3.y;
                tmp1.y = saturate(tmp1.y + 1.0);
                tmp6.xyz = tmp0.zzz * tmp3.xzw;
                tmp1.xzw = tmp7.xyz * tmp1.xxx + tmp6.xyz;
                tmp3.xyz = tmp3.xzw * tmp0.xxx;
                tmp0.x = 1.0 - tmp0.y;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.x = tmp0.x * tmp0.y;
                tmp6.xyz = float3(1.0, 1.0, 1.0) - tmp4.yzw;
                tmp0.xyz = tmp6.xyz * tmp0.xxx + tmp4.yzw;
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp0.xyz = tmp5.xyz * tmp1.xzw + tmp0.xyz;
                tmp1.xzw = tmp2.xyz * tmp0.www;
                tmp2.xyz = tmp1.yyy - tmp4.yzw;
                tmp2.xyz = tmp4.xxx * tmp2.xyz + tmp4.yzw;
                o.sv_target.xyz = tmp1.xzw * tmp2.xyz + tmp0.xyz;
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
			GpuProgramID 93293
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord10 : TEXCOORD10;
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
			float4 _MainTex1_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float4 _Color;
			float _BumpScale1;
			float _BumpScale2;
			float _BumpScale3;
			float _Metallic1;
			float _Metallic2;
			float _Metallic3;
			float _SmoothnessStrength1;
			float _SmoothnessStrength2;
			float _SmoothnessStrength3;
			float _Parallax1;
			float _Parallax2;
			float _Parallax3;
			float _Layer2;
			float _Layer3;
			float _ParallaxMapDef_1;
			float _ParallaxMapDef_2;
			float _ParallaxMapDef_3;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _ParallaxMap1;
			sampler2D _ParallaxMap2;
			sampler2D _ParallaxMap3;
			sampler2D _MainTex1;
			sampler2D _MainTex2;
			sampler2D _MainTex3;
			sampler2D _Masks;
			sampler2D _BumpMap1;
			sampler2D _BumpMap2;
			sampler2D _BumpMap3;
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
                o.texcoord.zw = v.texcoord.xy * _MainTex1_ST.xy + _MainTex1_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord10.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord10.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
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
                float4 tmp8;
                tmp0 = tex2D(_ParallaxMap1, inp.texcoord.zw);
                tmp1 = float4(_Layer2.x, _Layer3.x, _ParallaxMapDef_1.x, _ParallaxMapDef_2.x) != float4(0.0, 0.0, 0.0, 0.0);
                if (tmp1.x) {
                    tmp2 = tex2D(_ParallaxMap2, inp.texcoord10.xy);
                } else {
                    tmp2.x = 0.0;
                }
                if (tmp1.y) {
                    tmp3 = tex2D(_ParallaxMap3, inp.texcoord10.zw);
                } else {
                    tmp3.x = 0.0;
                }
                tmp0.x = dot(inp.texcoord8.xyz, inp.texcoord8.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.yw = tmp0.xx * inp.texcoord8.xy;
                tmp2.yzw = float3(_Parallax1.x, _Parallax2.x, _Parallax3.x) * float3(0.5, 0.5, 0.5);
                tmp0.z = tmp0.z * _Parallax1 + -tmp2.y;
                tmp0.x = inp.texcoord8.z * tmp0.x + 0.42;
                tmp0.xy = tmp0.yw / tmp0.xx;
                tmp0.zw = tmp0.zz * tmp0.xy + inp.texcoord.zw;
                tmp0.zw = tmp1.zz ? tmp0.zw : inp.texcoord.zw;
                tmp1.z = tmp1.w ? tmp1.x : 0.0;
                tmp1.w = tmp2.x * _Parallax2 + -tmp2.z;
                tmp2.xy = tmp1.ww * tmp0.xy + inp.texcoord10.xy;
                tmp1.zw = tmp1.zz ? tmp2.xy : inp.texcoord10.xy;
                tmp2.x = _ParallaxMapDef_3 != 0.0;
                tmp2.x = tmp1.y ? tmp2.x : 0.0;
                tmp2.y = tmp3.x * _Parallax3 + -tmp2.w;
                tmp0.xy = tmp2.yy * tmp0.xy + inp.texcoord10.zw;
                tmp0.xy = tmp2.xx ? tmp0.xy : inp.texcoord10.zw;
                tmp2 = tex2D(_ParallaxMap1, tmp0.zw);
                if (tmp1.x) {
                    tmp3 = tex2D(_ParallaxMap2, tmp1.zw);
                } else {
                    tmp3.x = 0.0;
                }
                if (tmp1.y) {
                    tmp4 = tex2D(_ParallaxMap3, tmp0.xy);
                } else {
                    tmp4.x = 0.0;
                }
                tmp5 = tex2D(_MainTex1, tmp0.zw);
                if (tmp1.x) {
                    tmp6 = tex2D(_MainTex2, tmp1.zw);
                }
                if (tmp1.y) {
                    tmp7 = tex2D(_MainTex3, tmp0.xy);
                }
                tmp8 = tex2D(_Masks, inp.texcoord.xy);
                tmp2.xy = tmp8.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.zw = tmp2.zz - tmp2.xy;
                tmp2.x = tmp2.x + tmp3.x;
                tmp2.x = tmp2.x - tmp2.z;
                tmp2.x = tmp2.x + 0.3125;
                tmp2.x = saturate(tmp2.x * 1.6);
                tmp2.y = tmp2.y + tmp4.x;
                tmp2.y = tmp2.y - tmp2.w;
                tmp2.y = tmp2.y + 0.3125;
                tmp2.y = saturate(tmp2.y * 1.6);
                tmp2.xy = tmp1.xy ? tmp2.xy : tmp8.xy;
                tmp2.z = tmp5.w * _SmoothnessStrength1;
                if (tmp1.x) {
                    tmp2.w = _Metallic2 - _Metallic1;
                    tmp2.w = tmp2.x * tmp2.w + _Metallic1;
                    tmp3 = tex2D(_MainTex2, tmp1.zw);
                    tmp3.x = tmp3.w * _SmoothnessStrength2 + -tmp2.z;
                    tmp2.z = tmp2.x * tmp3.x + tmp2.z;
                } else {
                    tmp2.w = _Metallic1;
                }
                if (tmp1.y) {
                    tmp3.x = _Metallic3 - tmp2.w;
                    tmp2.w = tmp2.y * tmp3.x + tmp2.w;
                    tmp3 = tex2D(_MainTex3, tmp0.xy);
                    tmp3.x = tmp3.w * _SmoothnessStrength3 + -tmp2.z;
                    tmp2.z = tmp2.y * tmp3.x + tmp2.z;
                }
                tmp3.xyz = tmp6.xyz - tmp5.xyz;
                tmp3.xyz = tmp2.xxx * tmp3.xyz + tmp5.xyz;
                tmp3.xyz = tmp1.xxx ? tmp3.xyz : tmp5.xyz;
                tmp4.xyz = tmp7.xyz - tmp3.xyz;
                tmp4.xyz = tmp2.yyy * tmp4.xyz + tmp3.xyz;
                tmp3.xyz = tmp1.yyy ? tmp4.xyz : tmp3.xyz;
                tmp4.xyz = tmp3.xyz * _Color.xyz;
                tmp3.xyz = tmp3.xyz * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp3.xyz = tmp2.www * tmp3.xyz + float3(0.04, 0.04, 0.04);
                tmp2.w = -tmp2.w * 0.96 + 0.96;
                tmp4.xyz = tmp2.www * tmp4.xyz;
                tmp5 = tex2D(_BumpMap1, tmp0.zw);
                tmp0.zw = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp5.xy = tmp0.zw * _BumpScale1.xx;
                tmp0.z = dot(tmp5.xy, tmp5.xy);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp5.z = sqrt(tmp0.z);
                if (tmp1.x) {
                    tmp6 = tex2D(_BumpMap2, tmp1.zw);
                    tmp0.zw = tmp6.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp6.xy = tmp0.zw * _BumpScale2.xx;
                    tmp0.z = dot(tmp6.xy, tmp6.xy);
                    tmp0.z = min(tmp0.z, 1.0);
                    tmp0.z = 1.0 - tmp0.z;
                    tmp6.z = sqrt(tmp0.z);
                    tmp1.xzw = tmp6.xyz - tmp5.xyz;
                    tmp1.xzw = tmp2.xxx * tmp1.xzw + tmp5.xyz;
                    tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                    tmp0.z = rsqrt(tmp0.z);
                    tmp5.xyz = tmp0.zzz * tmp1.xzw;
                }
                if (tmp1.y) {
                    tmp0 = tex2D(_BumpMap3, tmp0.xy);
                    tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp0.xy = tmp0.xy * _BumpScale3.xx;
                    tmp0.w = dot(tmp0.xy, tmp0.xy);
                    tmp0.w = min(tmp0.w, 1.0);
                    tmp0.w = 1.0 - tmp0.w;
                    tmp0.z = sqrt(tmp0.w);
                    tmp0.xyz = tmp0.xyz - tmp5.xyz;
                    tmp0.xyz = tmp2.yyy * tmp0.xyz + tmp5.xyz;
                    tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                    tmp0.w = rsqrt(tmp0.w);
                    tmp5.xyz = tmp0.www * tmp0.xyz;
                }
                tmp0.xyz = tmp5.yyy * inp.texcoord3.xyz;
                tmp0.xyz = inp.texcoord2.xyz * tmp5.xxx + tmp0.xyz;
                tmp0.xyz = inp.texcoord4.xyz * tmp5.zzz + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp2.xyw = inp.texcoord5.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyw = unity_WorldToLight._m00_m10_m20 * inp.texcoord5.xxx + tmp2.xyw;
                tmp2.xyw = unity_WorldToLight._m02_m12_m22 * inp.texcoord5.zzz + tmp2.xyw;
                tmp2.xyw = tmp2.xyw + unity_WorldToLight._m03_m13_m23;
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
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp5 = tex2D(_LightTexture0, tmp1.ww);
                tmp0.w = tmp0.w * tmp5.x;
                tmp5.x = inp.texcoord2.w;
                tmp5.y = inp.texcoord3.w;
                tmp5.z = inp.texcoord4.w;
                tmp1.w = dot(tmp5.xyz, tmp5.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyw = tmp1.www * tmp5.xyz;
                tmp6.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.w = 1.0 - tmp2.z;
                tmp5.xyz = tmp5.xyz * tmp1.www + -tmp1.xyz;
                tmp1.w = dot(tmp5.xyz, tmp5.xyz);
                tmp1.w = max(tmp1.w, 0.001);
                tmp1.w = rsqrt(tmp1.w);
                tmp5.xyz = tmp1.www * tmp5.xyz;
                tmp1.x = dot(tmp0.xyz, -tmp1.xyz);
                tmp1.y = saturate(dot(tmp0.xyz, tmp2.xyz));
                tmp0.x = saturate(dot(tmp0.xyz, tmp5.xyz));
                tmp0.y = saturate(dot(tmp2.xyz, tmp5.xyz));
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z - 0.5;
                tmp1.z = 1.0 - tmp1.y;
                tmp1.w = tmp1.z * tmp1.z;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.z = tmp1.z * tmp1.w;
                tmp1.z = tmp0.z * tmp1.z + 1.0;
                tmp1.w = 1.0 - abs(tmp1.x);
                tmp2.x = tmp1.w * tmp1.w;
                tmp2.x = tmp2.x * tmp2.x;
                tmp1.w = tmp1.w * tmp2.x;
                tmp0.z = tmp0.z * tmp1.w + 1.0;
                tmp0.z = tmp0.z * tmp1.z;
                tmp1.z = tmp0.w * tmp0.w;
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp1.w = abs(tmp1.x) * tmp0.w + tmp1.z;
                tmp0.w = tmp1.y * tmp0.w + tmp1.z;
                tmp0.w = tmp0.w * abs(tmp1.x);
                tmp0.w = tmp1.y * tmp1.w + tmp0.w;
                tmp0.w = tmp0.w + 0.00001;
                tmp0.w = 0.5 / tmp0.w;
                tmp1.x = tmp1.z * tmp1.z;
                tmp1.z = tmp0.x * tmp1.x + -tmp0.x;
                tmp0.x = tmp1.z * tmp0.x + 1.0;
                tmp1.x = tmp1.x * 0.3183099;
                tmp0.x = tmp0.x * tmp0.x + 0.0000001;
                tmp0.x = tmp1.x / tmp0.x;
                tmp0.x = tmp0.x * tmp0.w;
                tmp0.x = tmp0.x * 3.141593;
                tmp0.xz = tmp1.yy * tmp0.xz;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = tmp0.w != 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.x = tmp0.w * tmp0.x;
                tmp1.xyz = tmp0.zzz * tmp6.xyz;
                tmp0.xzw = tmp6.xyz * tmp0.xxx;
                tmp0.y = 1.0 - tmp0.y;
                tmp1.w = tmp0.y * tmp0.y;
                tmp1.w = tmp1.w * tmp1.w;
                tmp0.y = tmp0.y * tmp1.w;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.xyz = tmp2.xyz * tmp0.yyy + tmp3.xyz;
                tmp0.xyz = tmp0.xzw * tmp2.xyz;
                o.sv_target.xyz = tmp4.xyz * tmp1.xyz + tmp0.xyz;
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
			GpuProgramID 133747
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
			LOD 300
			Tags { "LIGHTMODE" = "META" "PerformanceChecks" = "False" "RenderType" = "Opaque" }
			ZClip Off
			Cull Off
			GpuProgramID 211861
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 texcoord : TEXCOORD0;
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex1_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _Metallic1;
			float _Metallic2;
			float _Metallic3;
			float _SmoothnessStrength1;
			float _SmoothnessStrength2;
			float _SmoothnessStrength3;
			float _Layer2;
			float _Layer3;
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
			sampler2D _MainTex1;
			sampler2D _MainTex2;
			sampler2D _MainTex3;
			sampler2D _Masks;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord.zw = v.texcoord.xy * _MainTex1_ST.xy + _MainTex1_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord1.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
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
                tmp0 = tex2D(_MainTex1, inp.texcoord.zw);
                tmp1.xy = float2(_Layer2.x, _Layer3.x) != float2(0.0, 0.0);
                if (tmp1.x) {
                    tmp2 = tex2D(_MainTex2, inp.texcoord1.xy);
                }
                if (tmp1.y) {
                    tmp3 = tex2D(_MainTex3, inp.texcoord1.zw);
                }
                tmp4 = tex2D(_Masks, inp.texcoord.xy);
                tmp0.w = tmp0.w * _SmoothnessStrength1;
                if (tmp1.x) {
                    tmp1.z = _Metallic2 - _Metallic1;
                    tmp1.z = tmp4.x * tmp1.z + _Metallic1;
                    tmp5 = tex2D(_MainTex2, inp.texcoord1.xy);
                    tmp1.w = tmp5.w * _SmoothnessStrength2 + -tmp0.w;
                    tmp0.w = tmp4.x * tmp1.w + tmp0.w;
                } else {
                    tmp1.z = _Metallic1;
                }
                if (tmp1.y) {
                    tmp1.w = _Metallic3 - tmp1.z;
                    tmp1.z = tmp4.y * tmp1.w + tmp1.z;
                    tmp5 = tex2D(_MainTex3, inp.texcoord1.zw);
                    tmp1.w = tmp5.w * _SmoothnessStrength3 + -tmp0.w;
                    tmp0.w = tmp4.y * tmp1.w + tmp0.w;
                }
                tmp2.xyz = tmp2.xyz - tmp0.xyz;
                tmp2.xyz = tmp4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp1.xxx ? tmp2.xyz : tmp0.xyz;
                tmp2.xyz = tmp3.xyz - tmp0.xyz;
                tmp2.xyz = tmp4.yyy * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp1.yyy ? tmp2.xyz : tmp0.xyz;
                tmp1.xyw = tmp0.xyz * _Color.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp0.xyz = tmp1.zzz * tmp0.xyz + float3(0.04, 0.04, 0.04);
                tmp1.z = -tmp1.z * 0.96 + 0.96;
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp1.xyw * tmp1.zzz + tmp0.xyz;
                tmp0.w = saturate(unity_OneOverOutputBoost);
                tmp0.xyz = log(tmp0.xyz);
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
			GpuProgramID 308891
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord10 : TEXCOORD10;
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
			float4 _MainTex1_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float _Metallic1;
			float _Metallic2;
			float _Metallic3;
			float _SmoothnessStrength1;
			float _SmoothnessStrength2;
			float _SmoothnessStrength3;
			float _Layer2;
			float _Layer3;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _ParallaxMap1;
			sampler2D _MainTex1;
			sampler2D _MainTex2;
			sampler2D _MainTex3;
			sampler2D _Masks;
			sampler2D _BumpMap1;
			sampler2D _BumpMap2;
			sampler2D _BumpMap3;
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
                o.texcoord.zw = v.texcoord.xy * _MainTex1_ST.xy + _MainTex1_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord10.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord10.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord2.w = tmp0.x;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                o.texcoord3.w = tmp0.y;
                o.texcoord4.w = tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp2.xyz = tmp1.yzx * tmp0.zxy;
                tmp1.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                o.texcoord3.xyz = tmp1.www * tmp1.xyz;
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
                tmp0 = tex2D(_ParallaxMap1, inp.texcoord.zw);
                tmp1 = tex2D(_MainTex1, inp.texcoord.zw);
                tmp0.xz = float2(_Layer2.x, _Layer3.x) != float2(0.0, 0.0);
                if (tmp0.x) {
                    tmp2 = tex2D(_MainTex2, inp.texcoord10.xy);
                }
                if (tmp0.z) {
                    tmp3 = tex2D(_MainTex3, inp.texcoord10.zw);
                }
                tmp4 = tex2D(_Masks, inp.texcoord.xy);
                tmp0.w = tmp1.w * _SmoothnessStrength1;
                if (tmp0.x) {
                    tmp1.w = _Metallic2 - _Metallic1;
                    tmp1.w = tmp4.x * tmp1.w + _Metallic1;
                    tmp5 = tex2D(_MainTex2, inp.texcoord10.xy);
                    tmp2.w = tmp5.w * _SmoothnessStrength2 + -tmp0.w;
                    tmp0.w = tmp4.x * tmp2.w + tmp0.w;
                } else {
                    tmp1.w = _Metallic1;
                }
                if (tmp0.z) {
                    tmp2.w = _Metallic3 - tmp1.w;
                    tmp1.w = tmp4.y * tmp2.w + tmp1.w;
                    tmp5 = tex2D(_MainTex3, inp.texcoord10.zw);
                    tmp2.w = tmp5.w * _SmoothnessStrength3 + -tmp0.w;
                    tmp0.w = tmp4.y * tmp2.w + tmp0.w;
                }
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp2.xyz = tmp4.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xxx ? tmp2.xyz : tmp1.xyz;
                tmp2.xyz = tmp3.xyz - tmp1.xyz;
                tmp2.xyz = tmp4.yyy * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.zzz ? tmp2.xyz : tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _Color.xyz;
                tmp1.xyz = tmp1.xyz * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp1.xyz = tmp1.www * tmp1.xyz + float3(0.04, 0.04, 0.04);
                tmp1.w = -tmp1.w * 0.96 + 0.96;
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp3 = tex2D(_BumpMap1, inp.texcoord.zw);
                tmp3.xy = tmp3.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.w = dot(tmp3.xy, tmp3.xy);
                tmp2.w = min(tmp2.w, 1.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp3.z = sqrt(tmp2.w);
                if (tmp0.x) {
                    tmp5 = tex2D(_BumpMap2, inp.texcoord10.xy);
                    tmp5.xy = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp0.x = dot(tmp5.xy, tmp5.xy);
                    tmp0.x = min(tmp0.x, 1.0);
                    tmp0.x = 1.0 - tmp0.x;
                    tmp5.z = sqrt(tmp0.x);
                    tmp5.xyz = tmp5.xyz - tmp3.xyz;
                    tmp4.xzw = tmp4.xxx * tmp5.xyz + tmp3.xyz;
                    tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                    tmp0.x = rsqrt(tmp0.x);
                    tmp3.xyz = tmp0.xxx * tmp4.xzw;
                }
                if (tmp0.z) {
                    tmp5 = tex2D(_BumpMap3, inp.texcoord10.zw);
                    tmp5.xy = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp0.x = dot(tmp5.xy, tmp5.xy);
                    tmp0.x = min(tmp0.x, 1.0);
                    tmp0.x = 1.0 - tmp0.x;
                    tmp5.z = sqrt(tmp0.x);
                    tmp4.xzw = tmp5.xyz - tmp3.xyz;
                    tmp4.xyz = tmp4.yyy * tmp4.xzw + tmp3.xyz;
                    tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                    tmp0.x = rsqrt(tmp0.x);
                    tmp3.xyz = tmp0.xxx * tmp4.xyz;
                }
                tmp4.xyz = tmp3.yyy * inp.texcoord3.xyz;
                tmp3.xyw = inp.texcoord2.xyz * tmp3.xxx + tmp4.xyz;
                tmp3.xyz = inp.texcoord4.xyz * tmp3.zzz + tmp3.xyw;
                tmp0.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.x) {
                    tmp0.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.xyz = inp.texcoord3.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.www + tmp4.xyz;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.www + tmp4.xyz;
                    tmp4.xyz = tmp4.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.y = inp.texcoord2.w;
                    tmp5.z = inp.texcoord3.w;
                    tmp5.w = inp.texcoord4.w;
                    tmp4.xyz = tmp0.xxx ? tmp4.xyz : tmp5.yzw;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.x = tmp4.y * 0.25 + 0.75;
                    tmp0.z = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp0.z, tmp0.x);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.x = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp4.z = 1.0 - tmp0.w;
                tmp0.z = dot(inp.texcoord1.xyz, tmp3.xyz);
                tmp0.z = tmp0.z + tmp0.z;
                tmp5.xyz = tmp3.xyz * -tmp0.zzz + inp.texcoord1.xyz;
                tmp6.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp7.xyz = tmp0.yyy * inp.texcoord5.xyz;
                tmp0.x = -tmp4.z * 0.7 + 1.7;
                tmp0.x = tmp0.x * tmp4.z;
                tmp0.x = tmp0.x * 6.0;
                tmp5 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp5.xyz, tmp0.x));
                tmp0.x = tmp5.w - 1.0;
                tmp0.x = unity_SpecCube0_HDR.w * tmp0.x + 1.0;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * unity_SpecCube0_HDR.y;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.x * unity_SpecCube0_HDR.x;
                tmp5.xyz = tmp5.xyz * tmp0.xxx;
                tmp0.xyz = tmp0.yyy * tmp5.xyz;
                tmp2.w = dot(-inp.texcoord1.xyz, tmp3.xyz);
                tmp3.w = tmp2.w + tmp2.w;
                tmp5.xyz = tmp3.xyz * -tmp3.www + -inp.texcoord1.xyz;
                tmp3.x = saturate(dot(tmp3.xyz, _WorldSpaceLightPos0.xyz));
                tmp2.w = saturate(tmp2.w);
                tmp5.x = dot(tmp5.xyz, _WorldSpaceLightPos0.xyz);
                tmp5.y = 1.0 - tmp2.w;
                tmp5.zw = tmp5.xy * tmp5.xy;
                tmp3.yz = tmp5.xy * tmp5.xw;
                tmp4.xy = tmp5.zy * tmp3.yz;
                tmp1.w = 1.0 - tmp1.w;
                tmp0.w = saturate(tmp0.w + tmp1.w);
                tmp5 = tex2D(unity_NHxRoughness, tmp4.xz);
                tmp1.w = tmp5.x * 16.0;
                tmp3.yzw = tmp1.www * tmp1.xyz + tmp2.xyz;
                tmp4.xzw = tmp3.xxx * tmp6.xyz;
                tmp5.xyz = tmp0.www - tmp1.xyz;
                tmp1.xyz = tmp4.yyy * tmp5.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp7.xyz * tmp2.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp3.yzw * tmp4.xzw + tmp0.xyz;
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
			GpuProgramID 338834
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord10 : TEXCOORD10;
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
			float4 _MainTex1_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float4 _Color;
			float _Metallic1;
			float _Metallic2;
			float _Metallic3;
			float _SmoothnessStrength1;
			float _SmoothnessStrength2;
			float _SmoothnessStrength3;
			float _Layer2;
			float _Layer3;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex1;
			sampler2D _MainTex2;
			sampler2D _MainTex3;
			sampler2D _Masks;
			sampler2D _BumpMap1;
			sampler2D _BumpMap2;
			sampler2D _BumpMap3;
			sampler2D _LightTexture0;
			sampler2D unity_NHxRoughness;
			
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
                o.texcoord.zw = v.texcoord.xy * _MainTex1_ST.xy + _MainTex1_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord10.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord10.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
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
                o.texcoord2.w = tmp0.x;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp1.yzx * tmp2.zxy;
                tmp1.xyz = tmp2.yzx * tmp1.zxy + -tmp3.xyz;
                o.texcoord4.xyz = tmp2.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                o.texcoord3.xyz = tmp0.xxx * tmp1.xyz;
                o.texcoord3.w = tmp0.y;
                o.texcoord4.w = tmp0.z;
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
                tmp0 = tex2D(_MainTex1, inp.texcoord.zw);
                tmp1.xy = float2(_Layer2.x, _Layer3.x) != float2(0.0, 0.0);
                if (tmp1.x) {
                    tmp2 = tex2D(_MainTex2, inp.texcoord10.xy);
                }
                if (tmp1.y) {
                    tmp3 = tex2D(_MainTex3, inp.texcoord10.zw);
                }
                tmp4 = tex2D(_Masks, inp.texcoord.xy);
                tmp0.w = tmp0.w * _SmoothnessStrength1;
                if (tmp1.x) {
                    tmp1.z = _Metallic2 - _Metallic1;
                    tmp1.z = tmp4.x * tmp1.z + _Metallic1;
                    tmp5 = tex2D(_MainTex2, inp.texcoord10.xy);
                    tmp1.w = tmp5.w * _SmoothnessStrength2 + -tmp0.w;
                    tmp0.w = tmp4.x * tmp1.w + tmp0.w;
                } else {
                    tmp1.z = _Metallic1;
                }
                if (tmp1.y) {
                    tmp1.w = _Metallic3 - tmp1.z;
                    tmp1.z = tmp4.y * tmp1.w + tmp1.z;
                    tmp5 = tex2D(_MainTex3, inp.texcoord10.zw);
                    tmp1.w = tmp5.w * _SmoothnessStrength3 + -tmp0.w;
                    tmp0.w = tmp4.y * tmp1.w + tmp0.w;
                }
                tmp2.xyz = tmp2.xyz - tmp0.xyz;
                tmp2.xyz = tmp4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp1.xxx ? tmp2.xyz : tmp0.xyz;
                tmp2.xyz = tmp3.xyz - tmp0.xyz;
                tmp2.xyz = tmp4.yyy * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp1.yyy ? tmp2.xyz : tmp0.xyz;
                tmp2.xyz = tmp0.xyz * _Color.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp0.xyz = tmp1.zzz * tmp0.xyz + float3(0.04, 0.04, 0.04);
                tmp1.z = -tmp1.z * 0.96 + 0.96;
                tmp3 = tex2D(_BumpMap1, inp.texcoord.zw);
                tmp3.xy = tmp3.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp3.xy, tmp3.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.z = sqrt(tmp1.w);
                if (tmp1.x) {
                    tmp5 = tex2D(_BumpMap2, inp.texcoord10.xy);
                    tmp5.xy = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp1.x = dot(tmp5.xy, tmp5.xy);
                    tmp1.x = min(tmp1.x, 1.0);
                    tmp1.x = 1.0 - tmp1.x;
                    tmp5.z = sqrt(tmp1.x);
                    tmp5.xyz = tmp5.xyz - tmp3.xyz;
                    tmp4.xzw = tmp4.xxx * tmp5.xyz + tmp3.xyz;
                    tmp1.x = dot(tmp4.xyz, tmp4.xyz);
                    tmp1.x = rsqrt(tmp1.x);
                    tmp3.xyz = tmp1.xxx * tmp4.xzw;
                }
                if (tmp1.y) {
                    tmp5 = tex2D(_BumpMap3, inp.texcoord10.zw);
                    tmp5.xy = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp1.x = dot(tmp5.xy, tmp5.xy);
                    tmp1.x = min(tmp1.x, 1.0);
                    tmp1.x = 1.0 - tmp1.x;
                    tmp5.z = sqrt(tmp1.x);
                    tmp1.xyw = tmp5.xyz - tmp3.xyz;
                    tmp1.xyw = tmp4.yyy * tmp1.xyw + tmp3.xyz;
                    tmp2.w = dot(tmp1.xyz, tmp1.xyz);
                    tmp2.w = rsqrt(tmp2.w);
                    tmp3.xyz = tmp1.xyw * tmp2.www;
                }
                tmp1.xyw = tmp3.yyy * inp.texcoord3.xyz;
                tmp1.xyw = inp.texcoord2.xyz * tmp3.xxx + tmp1.xyw;
                tmp1.xyw = inp.texcoord4.xyz * tmp3.zzz + tmp1.xyw;
                tmp3.xyz = inp.texcoord5.yyy * unity_WorldToLight._m01_m11_m21;
                tmp3.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord5.xxx + tmp3.xyz;
                tmp3.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord5.zzz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToLight._m03_m13_m23;
                tmp2.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.w) {
                    tmp2.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.xyz = inp.texcoord5.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord5.xxx + tmp4.xyz;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord5.zzz + tmp4.xyz;
                    tmp4.xyz = tmp4.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp4.xyz = tmp2.www ? tmp4.xyz : inp.texcoord5.xyz;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp2.w = tmp4.y * 0.25 + 0.75;
                    tmp3.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp2.w, tmp3.w);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp2.w = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp3.x = dot(tmp3.xyz, tmp3.xyz);
                tmp3 = tex2D(_LightTexture0, tmp3.xx);
                tmp2.w = tmp2.w * tmp3.x;
                tmp3.xyz = tmp2.www * _LightColor0.xyz;
                tmp2.w = dot(-inp.texcoord1.xyz, tmp1.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp4.xyz = tmp1.xyw * -tmp2.www + -inp.texcoord1.xyz;
                tmp5.x = inp.texcoord2.w;
                tmp5.y = inp.texcoord3.w;
                tmp5.z = inp.texcoord4.w;
                tmp1.x = saturate(dot(tmp1.xyz, tmp5.xyz));
                tmp1.y = dot(tmp4.xyz, tmp5.xyz);
                tmp1.y = tmp1.y * tmp1.y;
                tmp4.x = tmp1.y * tmp1.y;
                tmp4.y = 1.0 - tmp0.w;
                tmp4 = tex2D(unity_NHxRoughness, tmp4.xy);
                tmp0.w = tmp4.x * 16.0;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp2.xyz * tmp1.zzz + tmp0.xyz;
                tmp1.xyz = tmp1.xxx * tmp3.xyz;
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
			GpuProgramID 442006
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
			GpuProgramID 498669
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 texcoord : TEXCOORD0;
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex1_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _Metallic1;
			float _Metallic2;
			float _Metallic3;
			float _SmoothnessStrength1;
			float _SmoothnessStrength2;
			float _SmoothnessStrength3;
			float _Layer2;
			float _Layer3;
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
			sampler2D _MainTex1;
			sampler2D _MainTex2;
			sampler2D _MainTex3;
			sampler2D _Masks;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord.zw = v.texcoord.xy * _MainTex1_ST.xy + _MainTex1_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord1.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
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
                tmp0 = tex2D(_MainTex1, inp.texcoord.zw);
                tmp1.xy = float2(_Layer2.x, _Layer3.x) != float2(0.0, 0.0);
                if (tmp1.x) {
                    tmp2 = tex2D(_MainTex2, inp.texcoord1.xy);
                }
                if (tmp1.y) {
                    tmp3 = tex2D(_MainTex3, inp.texcoord1.zw);
                }
                tmp4 = tex2D(_Masks, inp.texcoord.xy);
                tmp0.w = tmp0.w * _SmoothnessStrength1;
                if (tmp1.x) {
                    tmp1.z = _Metallic2 - _Metallic1;
                    tmp1.z = tmp4.x * tmp1.z + _Metallic1;
                    tmp5 = tex2D(_MainTex2, inp.texcoord1.xy);
                    tmp1.w = tmp5.w * _SmoothnessStrength2 + -tmp0.w;
                    tmp0.w = tmp4.x * tmp1.w + tmp0.w;
                } else {
                    tmp1.z = _Metallic1;
                }
                if (tmp1.y) {
                    tmp1.w = _Metallic3 - tmp1.z;
                    tmp1.z = tmp4.y * tmp1.w + tmp1.z;
                    tmp5 = tex2D(_MainTex3, inp.texcoord1.zw);
                    tmp1.w = tmp5.w * _SmoothnessStrength3 + -tmp0.w;
                    tmp0.w = tmp4.y * tmp1.w + tmp0.w;
                }
                tmp2.xyz = tmp2.xyz - tmp0.xyz;
                tmp2.xyz = tmp4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp1.xxx ? tmp2.xyz : tmp0.xyz;
                tmp2.xyz = tmp3.xyz - tmp0.xyz;
                tmp2.xyz = tmp4.yyy * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp1.yyy ? tmp2.xyz : tmp0.xyz;
                tmp1.xyw = tmp0.xyz * _Color.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp0.xyz = tmp1.zzz * tmp0.xyz + float3(0.04, 0.04, 0.04);
                tmp1.z = -tmp1.z * 0.96 + 0.96;
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp1.xyw * tmp1.zzz + tmp0.xyz;
                tmp0.w = saturate(unity_OneOverOutputBoost);
                tmp0.xyz = log(tmp0.xyz);
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
	CustomEditor "LayersStandardShaderGUI"
}