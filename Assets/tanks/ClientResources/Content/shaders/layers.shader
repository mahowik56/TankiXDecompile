Shader "TankiOnline/Layers" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		[NoScaleOffset] _Mask2 ("Mask(R)", 2D) = "black" {}
		[NoScaleOffset] _Mask3 ("Mask(G)", 2D) = "black" {}
		_MainTex ("Color (RGB), Roughness (A)", 2D) = "white" {}
		_MainTex2 ("Color (RGB), Roughness (A)", 2D) = "white" {}
		_MainTex3 ("Color (RGB), Roughness (A)", 2D) = "white" {}
		_Roughness ("Roughness", Range(0, 1)) = 1
		_Roughness2 ("Roughness", Range(0, 1)) = 1
		_Roughness3 ("Roughness", Range(0, 1)) = 1
		[NoScaleOffset] _SurfaceMap ("Metallic(R), Occlusion(G), Height(B), Specularity(A)", 2D) = "white" {}
		[NoScaleOffset] _SurfaceMap2 ("Metallic(R), Occlusion(G), Height(B), Specularity(A)", 2D) = "white" {}
		[NoScaleOffset] _SurfaceMap3 ("Metallic(R), Occlusion(G), Height(B), Specularity(A)", 2D) = "white" {}
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		_Specularity ("Specularity", Range(0, 1)) = 0.5
		_OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1
		[Toggle(_PARALLAX)] _UseParallax ("Parallax", Float) = 0
		[Toggle(_PARALLAX2)] _UseParallax2 ("Parallax", Float) = 0
		[Toggle(_PARALLAX3)] _UseParallax3 ("Parallax", Float) = 0
		_Parallax ("Height Scale", Range(0.005, 0.08)) = 0.02
		_Parallax2 ("Height Scale", Range(0.005, 0.08)) = 0.02
		_Parallax3 ("Height Scale", Range(0.005, 0.08)) = 0.02
		[NoScaleOffset] [Normal] _BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("Normal Map Scale", Float) = 1
		[NoScaleOffset] [Normal] _BumpMap2 ("Normal Map", 2D) = "bump" {}
		_BumpScale2 ("Normal Map Scale", Float) = 1
		[NoScaleOffset] [Normal] _BumpMap3 ("Normal Map", 2D) = "bump" {}
		_BumpScale3 ("Normal Map Scale", Float) = 1
		_Glossiness ("Sync smoothness data", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 300
		Tags { "PerformanceChecks" = "False" "QUEUE" = "Geometry+1" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDBASE" "PerformanceChecks" = "False" "QUEUE" = "Geometry+1" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			ZClip Off
			GpuProgramID 8679
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float4 texcoord8 : TEXCOORD8;
				float4 texcoord9 : TEXCOORD9;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float _Roughness;
			float _Roughness2;
			float _Roughness3;
			float _Metallic;
			float _Specularity;
			float _OcclusionStrength;
			float _BumpScale;
			float _BumpScale2;
			float _BumpScale3;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Mask2;
			sampler2D _Mask3;
			sampler2D _MainTex;
			sampler2D _SurfaceMap;
			sampler2D _BumpMap;
			sampler2D _SurfaceMap2;
			sampler2D _MainTex2;
			sampler2D _BumpMap2;
			sampler2D _SurfaceMap3;
			sampler2D _MainTex3;
			sampler2D _BumpMap3;
			
			// Keywords: DIRECTIONAL _LAYER3
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                o.texcoord1 = tmp0;
                o.texcoord.w = 0.0;
                tmp0.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord2.w = 0.0;
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
                o.texcoord3.w = 0.0;
                o.texcoord4.xyz = tmp1.xyz;
                o.texcoord4.w = 0.0;
                tmp0.x = tmp1.y * tmp1.y;
                tmp0.x = tmp1.x * tmp1.x + -tmp0.x;
                tmp1 = tmp1.yzzx * tmp1.xyzz;
                tmp2.x = dot(unity_SHBr, tmp1);
                tmp2.y = dot(unity_SHBg, tmp1);
                tmp2.z = dot(unity_SHBb, tmp1);
                o.texcoord5.xyz = unity_SHC.xyz * tmp0.xxx + tmp2.xyz;
                o.texcoord5.w = 0.0;
                o.texcoord8.zw = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord8.xy = v.texcoord.xy;
                o.texcoord9.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord9.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
                return o;
			}
			// Keywords: DIRECTIONAL _LAYER3
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
                tmp0.x = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.yzw = tmp0.xxx * inp.texcoord.xyz;
                tmp1 = tex2D(_Mask2, inp.texcoord8.xy);
                tmp2 = tex2D(_Mask3, inp.texcoord8.xy);
                tmp3 = tex2D(_MainTex, inp.texcoord8.zw);
                tmp3.w = tmp3.w * _Roughness;
                tmp4 = tex2D(_SurfaceMap, inp.texcoord8.zw);
                tmp5 = tex2D(_BumpMap, inp.texcoord8.zw);
                tmp1.yz = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp5.xy = tmp1.yz * _BumpScale.xx;
                tmp1.y = dot(tmp5.xy, tmp5.xy);
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.y = 1.0 - tmp1.y;
                tmp5.z = sqrt(tmp1.y);
                tmp6 = tex2D(_SurfaceMap2, inp.texcoord9.xy);
                tmp1.x = tmp1.x * 2.0 + -1.0;
                tmp1.y = tmp4.z - tmp1.x;
                tmp1.x = tmp1.x + tmp6.z;
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = tmp1.x + 0.3125;
                tmp1.x = saturate(tmp1.x * 1.6);
                tmp7 = tex2D(_MainTex2, inp.texcoord9.xy);
                tmp7.w = tmp7.w * _Roughness2;
                tmp7 = tmp7 - tmp3;
                tmp3 = tmp1.xxxx * tmp7 + tmp3;
                tmp6 = tmp6 - tmp4;
                tmp4 = tmp1.xxxx * tmp6 + tmp4;
                tmp6 = tex2D(_BumpMap2, inp.texcoord9.xy);
                tmp1.yz = tmp6.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp6.xy = tmp1.yz * _BumpScale2.xx;
                tmp1.y = dot(tmp6.xy, tmp6.xy);
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.y = 1.0 - tmp1.y;
                tmp6.z = sqrt(tmp1.y);
                tmp1.yzw = tmp6.xyz - tmp5.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + tmp5.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xzw = tmp1.www * tmp1.xyz;
                tmp5 = tex2D(_SurfaceMap3, inp.texcoord9.zw);
                tmp2.y = tmp2.y * 2.0 + -1.0;
                tmp4.z = tmp4.z - tmp2.y;
                tmp2.y = tmp2.y + tmp5.z;
                tmp2.y = tmp2.y - tmp4.z;
                tmp2.y = tmp2.y + 0.3125;
                tmp2.y = saturate(tmp2.y * 1.6);
                tmp6 = tex2D(_MainTex3, inp.texcoord9.zw);
                tmp6.w = tmp6.w * _Roughness3;
                tmp6 = tmp6 - tmp3;
                tmp3 = tmp2.yyyy * tmp6 + tmp3;
                tmp5.xyz = tmp5.xyw - tmp4.xyw;
                tmp4.xyz = tmp2.yyy * tmp5.xyz + tmp4.xyw;
                tmp5 = tex2D(_BumpMap3, inp.texcoord9.zw);
                tmp5.xy = tmp5.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp5.xy = tmp5.xy * _BumpScale3.xx;
                tmp4.w = dot(tmp5.xy, tmp5.xy);
                tmp4.w = min(tmp4.w, 1.0);
                tmp4.w = 1.0 - tmp4.w;
                tmp5.z = sqrt(tmp4.w);
                tmp1.xyz = -tmp1.xyz * tmp1.www + tmp5.xyz;
                tmp1.xyz = tmp2.yyy * tmp1.xyz + tmp2.xzw;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp3.xyz * _Color.xyz;
                tmp1.w = tmp4.x * _Metallic;
                tmp2.w = 1.0 - _OcclusionStrength;
                tmp3.x = tmp4.z * _Specularity;
                tmp2.w = tmp4.y * _OcclusionStrength + tmp2.w;
                tmp4.yzw = tmp1.yyy * inp.texcoord3.xyz;
                tmp4.yzw = tmp1.xxx * inp.texcoord2.xyz + tmp4.yzw;
                tmp1.xyz = tmp1.zzz * inp.texcoord4.xyz + tmp4.yzw;
                tmp3.y = dot(tmp1.xyz, tmp1.xyz);
                tmp3.y = rsqrt(tmp3.y);
                tmp5.xyz = tmp1.xyz * tmp3.yyy;
                tmp1.x = dot(tmp5.xyz, tmp0.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = -_Metallic * tmp4.x + 1.0;
                tmp1.z = tmp3.x * 0.08;
                tmp2.xyz = min(tmp2.xyz, float3(1.0, 1.0, 1.0));
                tmp4.xyz = tmp1.yyy * tmp2.xyz;
                tmp2.xyz = -tmp3.xxx * float3(0.08, 0.08, 0.08) + tmp2.xyz;
                tmp1.yzw = tmp1.www * tmp2.xyz + tmp1.zzz;
                tmp2.x = dot(-tmp0.xyz, tmp5.xyz);
                tmp2.x = tmp2.x + tmp2.x;
                tmp0.yzw = tmp5.xyz * -tmp2.xxx + -tmp0.yzw;
                tmp2.x = tmp2.w + tmp1.x;
                tmp2.x = tmp2.x * tmp2.x + tmp2.w;
                tmp2.x = saturate(tmp2.x - 1.0);
                tmp2.x = tmp2.x * tmp3.x;
                tmp5.w = 1.0;
                tmp3.x = dot(unity_SHAr, tmp5);
                tmp3.y = dot(unity_SHAg, tmp5);
                tmp3.z = dot(unity_SHAb, tmp5);
                tmp3.xyz = tmp3.xyz + inp.texcoord5.xyz;
                tmp2.y = unity_SpecCube0_ProbePosition.w > 0.0;
                if (tmp2.y) {
                    tmp2.y = dot(tmp0.xyz, tmp0.xyz);
                    tmp2.y = rsqrt(tmp2.y);
                    tmp6.xyz = tmp0.yzw * tmp2.yyy;
                    tmp7.xyz = unity_SpecCube0_BoxMax.xyz - inp.texcoord1.xyz;
                    tmp7.xyz = tmp7.xyz / tmp6.xyz;
                    tmp8.xyz = unity_SpecCube0_BoxMin.xyz - inp.texcoord1.xyz;
                    tmp8.xyz = tmp8.xyz / tmp6.xyz;
                    tmp9.xyz = tmp6.xyz > float3(0.0, 0.0, 0.0);
                    tmp7.xyz = tmp9.xyz ? tmp7.xyz : tmp8.xyz;
                    tmp2.y = min(tmp7.y, tmp7.x);
                    tmp2.y = min(tmp7.z, tmp2.y);
                    tmp7.xyz = inp.texcoord1.xyz - unity_SpecCube0_ProbePosition.xyz;
                    tmp6.xyz = tmp6.xyz * tmp2.yyy + tmp7.xyz;
                } else {
                    tmp6.xyz = tmp0.yzw;
                }
                tmp2.y = tmp3.w * 6.0;
                tmp6 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp6.xyz, tmp2.y));
                tmp2.z = tmp6.w - 1.0;
                tmp2.z = unity_SpecCube0_HDR.w * tmp2.z + 1.0;
                tmp2.z = log(tmp2.z);
                tmp2.z = tmp2.z * unity_SpecCube0_HDR.y;
                tmp2.z = exp(tmp2.z);
                tmp2.z = tmp2.z * unity_SpecCube0_HDR.x;
                tmp7.xyz = tmp6.xyz * tmp2.zzz;
                tmp4.w = unity_SpecCube0_BoxMin.w < 0.99999;
                if (tmp4.w) {
                    tmp4.w = unity_SpecCube1_ProbePosition.w > 0.0;
                    if (tmp4.w) {
                        tmp4.w = dot(tmp0.xyz, tmp0.xyz);
                        tmp4.w = rsqrt(tmp4.w);
                        tmp8.xyz = tmp0.yzw * tmp4.www;
                        tmp9.xyz = unity_SpecCube1_BoxMax.xyz - inp.texcoord1.xyz;
                        tmp9.xyz = tmp9.xyz / tmp8.xyz;
                        tmp10.xyz = unity_SpecCube1_BoxMin.xyz - inp.texcoord1.xyz;
                        tmp10.xyz = tmp10.xyz / tmp8.xyz;
                        tmp11.xyz = tmp8.xyz > float3(0.0, 0.0, 0.0);
                        tmp9.xyz = tmp11.xyz ? tmp9.xyz : tmp10.xyz;
                        tmp4.w = min(tmp9.y, tmp9.x);
                        tmp4.w = min(tmp9.z, tmp4.w);
                        tmp9.xyz = inp.texcoord1.xyz - unity_SpecCube1_ProbePosition.xyz;
                        tmp0.yzw = tmp8.xyz * tmp4.www + tmp9.xyz;
                    }
                    tmp8 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp0.yzw, tmp2.y));
                    tmp0.y = tmp8.w - 1.0;
                    tmp0.y = unity_SpecCube1_HDR.w * tmp0.y + 1.0;
                    tmp0.y = log(tmp0.y);
                    tmp0.y = tmp0.y * unity_SpecCube1_HDR.y;
                    tmp0.y = exp(tmp0.y);
                    tmp0.y = tmp0.y * unity_SpecCube1_HDR.x;
                    tmp0.yzw = tmp8.xyz * tmp0.yyy;
                    tmp6.xyz = tmp2.zzz * tmp6.xyz + -tmp0.yzw;
                    tmp7.xyz = unity_SpecCube0_BoxMin.www * tmp6.xyz + tmp0.yzw;
                }
                tmp0.yzw = tmp2.www * tmp3.xyz;
                tmp6 = tmp3.wwww * float4(-1.0, -0.0275, -0.572, 0.022) + float4(1.0, 0.0425, 1.04, -0.04);
                tmp2.y = tmp6.x * tmp6.x;
                tmp2.z = tmp1.x * -9.28;
                tmp2.z = exp(tmp2.z);
                tmp2.y = min(tmp2.z, tmp2.y);
                tmp2.y = tmp2.y * tmp6.x + tmp6.y;
                tmp2.yz = tmp2.yy * float2(-1.04, 1.04) + tmp6.zw;
                tmp2.yzw = tmp1.yzw * tmp2.yyy + tmp2.zzz;
                tmp3.xyz = tmp1.yzw * tmp0.yzw;
                tmp2.yzw = tmp7.xyz * tmp2.yzw + -tmp3.xyz;
                tmp2.yzw = tmp2.xxx * tmp2.yzw + tmp3.xyz;
                tmp0.yzw = tmp0.yzw * tmp4.xyz + tmp2.yzw;
                tmp2.yzw = inp.texcoord.xyz * tmp0.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.yzw = tmp0.xxx * tmp2.yzw;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, tmp2.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp2.y = dot(tmp5.xyz, tmp2.xyz);
                tmp2.z = dot(tmp5.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.yz = max(tmp2.yz, float2(0.0, 0.0));
                tmp3.xyz = tmp2.zzz * _LightColor0.xyz;
                tmp2.w = tmp2.z * -5.55473 + -6.98316;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.z = exp(tmp2.z);
                tmp2.w = tmp1.x * -5.55473 + -6.98316;
                tmp1.x = tmp1.x * tmp2.w;
                tmp1.x = exp(tmp1.x);
                tmp2.w = tmp0.x * tmp0.x;
                tmp4.w = dot(tmp2.xy, tmp3.xy);
                tmp4.w = tmp4.w + 0.5;
                tmp5.x = 1.0 - tmp2.z;
                tmp2.z = tmp4.w * tmp2.z + tmp5.x;
                tmp5.x = 1.0 - tmp1.x;
                tmp1.x = tmp4.w * tmp1.x + tmp5.x;
                tmp1.x = tmp1.x * tmp2.z;
                tmp2.z = tmp3.w * 0.95 + 0.05;
                tmp2.z = tmp2.z * tmp2.z;
                tmp3.w = tmp0.x * -5.55473 + -6.98316;
                tmp0.x = tmp0.x * tmp3.w;
                tmp0.x = exp(tmp0.x);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp1.yzw;
                tmp1.yzw = tmp0.xxx * tmp5.xyz + tmp1.yzw;
                tmp0.x = tmp2.z * tmp2.z;
                tmp3.w = tmp2.y * tmp2.y;
                tmp2.y = -tmp2.y * tmp2.y + 1.0;
                tmp2.y = tmp0.x * tmp3.w + tmp2.y;
                tmp2.y = tmp2.y * tmp2.y;
                tmp0.x = tmp0.x / tmp2.y;
                tmp2.y = tmp2.z * 0.5;
                tmp2.z = tmp2.y * tmp2.y;
                tmp2.y = -tmp2.y * tmp2.y + 1.0;
                tmp2.y = tmp2.w * tmp2.y + tmp2.z;
                tmp2.y = tmp2.y * 4.0;
                tmp2.y = 1.0 / tmp2.y;
                tmp0.x = tmp0.x * tmp2.y;
                tmp1.yzw = tmp0.xxx * tmp1.yzw;
                tmp1.yzw = tmp1.yzw * tmp2.xxx;
                tmp1.xyz = tmp4.xyz * tmp1.xxx + tmp1.yzw;
                tmp0.xyz = tmp3.xyz * tmp1.xyz + tmp0.yzw;
                o.sv_target.xyz = min(tmp0.xyz, float3(32.0, 32.0, 32.0));
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDADD" "PerformanceChecks" = "False" "QUEUE" = "Geometry+1" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			GpuProgramID 67531
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
				float4 texcoord8 : TEXCOORD8;
				float4 texcoord9 : TEXCOORD9;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _MainTex_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float _Roughness;
			float _Roughness2;
			float _Roughness3;
			float _Metallic;
			float _Specularity;
			float _OcclusionStrength;
			float _BumpScale;
			float _BumpScale2;
			float _BumpScale3;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _Mask2;
			sampler2D _Mask3;
			sampler2D _MainTex;
			sampler2D _SurfaceMap;
			sampler2D _BumpMap;
			sampler2D _SurfaceMap2;
			sampler2D _MainTex2;
			sampler2D _BumpMap2;
			sampler2D _SurfaceMap3;
			sampler2D _MainTex3;
			sampler2D _BumpMap3;
			
			// Keywords: POINT _LAYER3
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
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.w = 0.0;
                o.texcoord.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                o.texcoord1 = tmp0;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                o.texcoord2.w = 0.0;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp3.xyz = tmp1.yzx * tmp2.zxy;
                tmp1.xyz = tmp2.yzx * tmp1.zxy + -tmp3.xyz;
                o.texcoord4.xyz = tmp2.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                o.texcoord3.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3.w = 0.0;
                o.texcoord4.w = 0.0;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord8.zw = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord8.xy = v.texcoord.xy;
                o.texcoord9.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord9.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
                return o;
			}
			// Keywords: POINT _LAYER3
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_BumpMap3, inp.texcoord9.zw);
                tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * _BumpScale3.xx;
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = sqrt(tmp0.w);
                tmp1 = tex2D(_BumpMap2, inp.texcoord9.xy);
                tmp1.xy = tmp1.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy * _BumpScale2.xx;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = sqrt(tmp0.w);
                tmp2 = tex2D(_BumpMap, inp.texcoord8.zw);
                tmp2.xy = tmp2.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xy = tmp2.xy * _BumpScale.xx;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp2.z = sqrt(tmp0.w);
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp3 = tex2D(_Mask2, inp.texcoord8.xy);
                tmp0.w = tmp3.x * 2.0 + -1.0;
                tmp3 = tex2D(_SurfaceMap2, inp.texcoord9.xy);
                tmp1.w = tmp0.w + tmp3.z;
                tmp4 = tex2D(_SurfaceMap, inp.texcoord8.zw);
                tmp0.w = tmp4.z - tmp0.w;
                tmp0.w = tmp1.w - tmp0.w;
                tmp0.w = tmp0.w + 0.3125;
                tmp0.w = saturate(tmp0.w * 1.6);
                tmp1.xyz = tmp0.www * tmp1.xyz + tmp2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp0.xyz = -tmp1.xyz * tmp1.www + tmp0.xyz;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2 = tmp3 - tmp4;
                tmp2 = tmp0.wwww * tmp2 + tmp4;
                tmp3 = tex2D(_Mask3, inp.texcoord8.xy);
                tmp1.w = tmp3.y * 2.0 + -1.0;
                tmp2.z = tmp2.z - tmp1.w;
                tmp3 = tex2D(_SurfaceMap3, inp.texcoord9.zw);
                tmp1.w = tmp1.w + tmp3.z;
                tmp3.xyz = tmp3.xyw - tmp2.xyw;
                tmp1.w = tmp1.w - tmp2.z;
                tmp1.w = tmp1.w + 0.3125;
                tmp1.w = saturate(tmp1.w * 1.6);
                tmp0.xyz = tmp1.www * tmp0.xyz + tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                tmp1.xyz = tmp0.yyy * inp.texcoord3.xyz;
                tmp1.xyz = tmp0.xxx * inp.texcoord2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.zzz * inp.texcoord4.xyz + tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                tmp1.x = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * inp.texcoord.xyz;
                tmp4.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord1.xyz;
                tmp2.z = dot(tmp4.xyz, tmp4.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp5.xyz = tmp4.xyz * tmp2.zzz + tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp4.xyz = tmp2.zzz * tmp4.xyz;
                tmp1.y = dot(tmp5.xyz, tmp5.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp5.xyz = tmp1.yyy * tmp5.xyz;
                tmp1.y = dot(tmp0.xyz, tmp5.xyz);
                tmp0.x = dot(tmp0.xyz, tmp4.xyz);
                tmp0.y = dot(tmp4.xyz, tmp5.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.z = max(tmp1.y, 0.0);
                tmp1.y = tmp0.z * tmp0.z;
                tmp0.z = -tmp0.z * tmp0.z + 1.0;
                tmp4 = tex2D(_MainTex2, inp.texcoord9.xy);
                tmp4.w = tmp4.w * _Roughness2;
                tmp5 = tex2D(_MainTex, inp.texcoord8.zw);
                tmp5.w = tmp5.w * _Roughness;
                tmp4 = tmp4 - tmp5;
                tmp4 = tmp0.wwww * tmp4 + tmp5;
                tmp5 = tex2D(_MainTex3, inp.texcoord9.zw);
                tmp5.w = tmp5.w * _Roughness3;
                tmp5 = tmp5 - tmp4;
                tmp4 = tmp1.wwww * tmp5 + tmp4;
                tmp2.xyz = tmp1.www * tmp3.xyz + tmp2.xyw;
                tmp0.w = tmp4.w * 0.95 + 0.05;
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.z = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * 0.5;
                tmp0.z = tmp1.z * tmp1.y + tmp0.z;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp1.z / tmp0.z;
                tmp1.yz = tmp0.wy * tmp0.wy;
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = tmp1.z * tmp0.w + tmp1.y;
                tmp1.y = dot(tmp1.xy, tmp4.xy);
                tmp3.xyz = tmp4.xyz * _Color.xyz;
                tmp3.xyz = min(tmp3.xyz, float3(1.0, 1.0, 1.0));
                tmp1.y = tmp1.y + 0.5;
                tmp0.w = tmp0.w * 4.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.w = tmp0.y * -5.55473 + -6.98316;
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.y = exp(tmp0.y);
                tmp0.w = tmp2.z * _Specularity;
                tmp4.xyz = -tmp0.www * float3(0.08, 0.08, 0.08) + tmp3.xyz;
                tmp1.z = tmp2.x * _Metallic;
                tmp1.w = tmp0.w * 0.08;
                tmp4.xyz = tmp1.zzz * tmp4.xyz + tmp1.www;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp5.xyz + tmp4.xyz;
                tmp4.xyz = tmp0.zzz * tmp4.xyz;
                tmp0.y = 1.0 - _OcclusionStrength;
                tmp0.y = tmp2.y * _OcclusionStrength + tmp0.y;
                tmp0.z = -_Metallic * tmp2.x + 1.0;
                tmp2.xyz = tmp0.zzz * tmp3.xyz;
                tmp0.z = tmp0.y + tmp1.x;
                tmp0.y = tmp0.z * tmp0.z + tmp0.y;
                tmp0.y = saturate(tmp0.y - 1.0);
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.yzw = tmp4.xyz * tmp0.yyy;
                tmp1.z = tmp1.x * -5.55473 + -6.98316;
                tmp1.x = tmp1.x * tmp1.z;
                tmp1.x = exp(tmp1.x);
                tmp1.z = 1.0 - tmp1.x;
                tmp1.x = tmp1.y * tmp1.x + tmp1.z;
                tmp1.z = tmp0.x * -5.55473 + -6.98316;
                tmp1.z = tmp0.x * tmp1.z;
                tmp1.z = exp(tmp1.z);
                tmp1.w = 1.0 - tmp1.z;
                tmp1.y = tmp1.y * tmp1.z + tmp1.w;
                tmp1.x = tmp1.x * tmp1.y;
                tmp0.yzw = tmp2.xyz * tmp1.xxx + tmp0.yzw;
                tmp1.x = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp1 = tex2D(_LightTexture0, tmp1.xx);
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.xyz = tmp0.yzw * tmp1.xyz;
                o.sv_target.xyz = min(tmp0.xyz, float3(32.0, 32.0, 32.0));
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 300
			Tags { "LIGHTMODE" = "META" "PerformanceChecks" = "False" "QUEUE" = "Geometry+1" "RenderType" = "Opaque" }
			ZClip Off
			Cull Off
			GpuProgramID 175600
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord6 : TEXCOORD6;
				float4 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
			float4 _Color;
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
			sampler2D _Mask2;
			sampler2D _Mask3;
			sampler2D _MainTex;
			sampler2D _SurfaceMap;
			sampler2D _SurfaceMap2;
			sampler2D _MainTex2;
			sampler2D _SurfaceMap3;
			sampler2D _MainTex3;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
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
                o.texcoord6.zw = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.xy = v.texcoord.xy;
                o.texcoord7.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord7.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_Mask2, inp.texcoord6.xy);
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp1 = tex2D(_SurfaceMap2, inp.texcoord7.xy);
                tmp0.y = tmp0.x + tmp1.z;
                tmp2 = tex2D(_SurfaceMap, inp.texcoord6.zw);
                tmp0.x = tmp2.z - tmp0.x;
                tmp0.x = tmp0.y - tmp0.x;
                tmp0.x = tmp0.x + 0.3125;
                tmp0.x = saturate(tmp0.x * 1.6);
                tmp0.y = tmp1.z - tmp2.z;
                tmp0.y = tmp0.x * tmp0.y + tmp2.z;
                tmp1 = tex2D(_Mask3, inp.texcoord6.xy);
                tmp0.z = tmp1.y * 2.0 + -1.0;
                tmp0.y = tmp0.y - tmp0.z;
                tmp1 = tex2D(_SurfaceMap3, inp.texcoord7.zw);
                tmp0.z = tmp0.z + tmp1.z;
                tmp0.y = tmp0.z - tmp0.y;
                tmp0.y = tmp0.y + 0.3125;
                tmp0.y = saturate(tmp0.y * 1.6);
                tmp1 = tex2D(_MainTex2, inp.texcoord7.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord6.zw);
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp0.xzw = tmp0.xxx * tmp1.xyz + tmp2.xyz;
                tmp1 = tex2D(_MainTex3, inp.texcoord7.zw);
                tmp1.xyz = tmp1.xyz - tmp0.xzw;
                tmp0.xyz = tmp0.yyy * tmp1.xyz + tmp0.xzw;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
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
		Tags { "PerformanceChecks" = "False" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			LOD 150
			Tags { "LIGHTMODE" = "FORWARDBASE" "PerformanceChecks" = "False" "QUEUE" = "Geometry" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			ZClip Off
			GpuProgramID 257462
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord6 : TEXCOORD6;
				float4 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Mask2;
			sampler2D _Mask3;
			sampler2D _MainTex;
			sampler2D _MainTex2;
			sampler2D _MainTex3;
			
			// Keywords: DIRECTIONAL _LAYER3
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
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp0.w = tmp0.y * tmp0.y;
                tmp0.w = tmp0.x * tmp0.x + -tmp0.w;
                tmp1 = tmp0.yzzx * tmp0.xyzz;
                tmp0.x = dot(unity_SHBr, tmp1);
                tmp0.y = dot(unity_SHBg, tmp1);
                tmp0.z = dot(unity_SHBb, tmp1);
                o.texcoord3.xyz = unity_SHC.xyz * tmp0.www + tmp0.xyz;
                o.texcoord3.w = 0.0;
                o.texcoord6.zw = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.xy = v.texcoord.xy;
                o.texcoord7.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord7.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
                return o;
			}
			// Keywords: DIRECTIONAL _LAYER3
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp0.x = dot(tmp0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp1 = tex2D(_Mask2, inp.texcoord6.xy);
                tmp2 = tex2D(_MainTex2, inp.texcoord7.xy);
                tmp3 = tex2D(_MainTex, inp.texcoord6.zw);
                tmp0.yzw = tmp2.xyz - tmp3.xyz;
                tmp0.yzw = tmp1.xxx * tmp0.yzw + tmp3.xyz;
                tmp1 = tex2D(_MainTex3, inp.texcoord7.zw);
                tmp1.xyz = tmp1.xyz - tmp0.yzw;
                tmp2 = tex2D(_Mask3, inp.texcoord6.xy);
                tmp0.yzw = tmp2.yyy * tmp1.xyz + tmp0.yzw;
                tmp0.yzw = tmp0.yzw * _Color.xyz;
                tmp1.xyz = tmp0.yzw * _LightColor0.xyz;
                tmp0.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                o.sv_target.xyz = min(tmp0.xyz, float3(32.0, 32.0, 32.0));
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 150
			Tags { "LIGHTMODE" = "META" "PerformanceChecks" = "False" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
			ZClip Off
			Cull Off
			GpuProgramID 272606
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord6 : TEXCOORD6;
				float4 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex2_ST;
			float4 _MainTex3_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
			float4 _Color;
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
			sampler2D _Mask2;
			sampler2D _Mask3;
			sampler2D _MainTex;
			sampler2D _MainTex2;
			sampler2D _MainTex3;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
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
                o.texcoord6.zw = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.xy = v.texcoord.xy;
                o.texcoord7.xy = v.texcoord.xy * _MainTex2_ST.xy + _MainTex2_ST.zw;
                o.texcoord7.zw = v.texcoord.xy * _MainTex3_ST.xy + _MainTex3_ST.zw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_Mask2, inp.texcoord6.xy);
                tmp1 = tex2D(_MainTex2, inp.texcoord7.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord6.zw);
                tmp0.yzw = tmp1.xyz - tmp2.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + tmp2.xyz;
                tmp1 = tex2D(_MainTex3, inp.texcoord7.zw);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                tmp2 = tex2D(_Mask3, inp.texcoord6.xy);
                tmp0.xyz = tmp2.yyy * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
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
	Fallback "Legacy Shaders/VertexLit"
	CustomEditor "TankiOnlineShaderGUI"
}