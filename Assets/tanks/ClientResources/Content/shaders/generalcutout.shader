Shader "TankiOnline/General Cutout" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Color (RGB), Roughness (A)", 2D) = "white" {}
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
		_Roughness ("Roughness", Range(0, 1)) = 1
		[NoScaleOffset] _SurfaceMap ("Metallic(R), Occlusion(G), Height(B), Specularity(A)", 2D) = "black" {}
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		_Specularity ("Specularity", Range(0, 1)) = 0.5
		_OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1
		[Toggle(_PARALLAX)] _UseParallax ("Parallax", Float) = 0
		_Parallax ("Height Scale", Range(0.005, 0.08)) = 0.02
		_BumpScale ("Normal Map Scale", Float) = 1
		[NoScaleOffset] [Normal] _BumpMap ("Normal Map", 2D) = "bump" {}
		[HDR] _EmissionColor ("Emission Color", Color) = (0,0,0,1)
		[NoScaleOffset] _EmissionMap ("Emission", 2D) = "white" {}
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
			Offset -1, -1
			GpuProgramID 3838
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _Cutoff;
			float4 _Color;
			float _Roughness;
			float _Metallic;
			float _Specularity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
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
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
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
                tmp0.x = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.yzw = tmp0.xxx * inp.texcoord.xyz;
                tmp1.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * inp.texcoord2.xyz;
                tmp2 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp2.xyz = tmp2.xyz * _Color.xyz;
                tmp2.w = _Color.w * tmp2.w + -_Cutoff;
                tmp2.w = tmp2.w < 0.0;
                if (tmp2.w) {
                    discard;
                }
                tmp2.w = dot(tmp1.xyz, tmp0.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp3.x = 1.0 - _Metallic;
                tmp3.yz = float2(_Roughness.x, _Specularity.x) * float2(0.08, 6.0);
                tmp2.xyz = min(tmp2.xyz, float3(1.0, 1.0, 1.0));
                tmp4.xyz = tmp3.xxx * tmp2.xyz;
                tmp2.xyz = -_Specularity.xxx * float3(0.08, 0.08, 0.08) + tmp2.xyz;
                tmp2.xyz = _Metallic.xxx * tmp2.xyz + tmp3.yyy;
                tmp3.x = dot(-tmp0.xyz, tmp1.xyz);
                tmp3.x = tmp3.x + tmp3.x;
                tmp0.yzw = tmp1.xyz * -tmp3.xxx + -tmp0.yzw;
                tmp1.w = 1.0;
                tmp5.x = dot(unity_SHAr, tmp1);
                tmp5.y = dot(unity_SHAg, tmp1);
                tmp5.z = dot(unity_SHAb, tmp1);
                tmp3.xyw = tmp5.xyz + inp.texcoord3.xyz;
                tmp1.w = unity_SpecCube0_ProbePosition.w > 0.0;
                if (tmp1.w) {
                    tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                    tmp1.w = rsqrt(tmp1.w);
                    tmp5.xyz = tmp0.yzw * tmp1.www;
                    tmp6.xyz = unity_SpecCube0_BoxMax.xyz - inp.texcoord1.xyz;
                    tmp6.xyz = tmp6.xyz / tmp5.xyz;
                    tmp7.xyz = unity_SpecCube0_BoxMin.xyz - inp.texcoord1.xyz;
                    tmp7.xyz = tmp7.xyz / tmp5.xyz;
                    tmp8.xyz = tmp5.xyz > float3(0.0, 0.0, 0.0);
                    tmp6.xyz = tmp8.xyz ? tmp6.xyz : tmp7.xyz;
                    tmp1.w = min(tmp6.y, tmp6.x);
                    tmp1.w = min(tmp6.z, tmp1.w);
                    tmp6.xyz = inp.texcoord1.xyz - unity_SpecCube0_ProbePosition.xyz;
                    tmp5.xyz = tmp5.xyz * tmp1.www + tmp6.xyz;
                } else {
                    tmp5.xyz = tmp0.yzw;
                }
                tmp5 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp5.xyz, tmp3.z));
                tmp1.w = tmp5.w - 1.0;
                tmp1.w = unity_SpecCube0_HDR.w * tmp1.w + 1.0;
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * unity_SpecCube0_HDR.y;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * unity_SpecCube0_HDR.x;
                tmp6.xyz = tmp5.xyz * tmp1.www;
                tmp4.w = unity_SpecCube0_BoxMin.w < 0.99999;
                if (tmp4.w) {
                    tmp4.w = unity_SpecCube1_ProbePosition.w > 0.0;
                    if (tmp4.w) {
                        tmp4.w = dot(tmp0.xyz, tmp0.xyz);
                        tmp4.w = rsqrt(tmp4.w);
                        tmp7.xyz = tmp0.yzw * tmp4.www;
                        tmp8.xyz = unity_SpecCube1_BoxMax.xyz - inp.texcoord1.xyz;
                        tmp8.xyz = tmp8.xyz / tmp7.xyz;
                        tmp9.xyz = unity_SpecCube1_BoxMin.xyz - inp.texcoord1.xyz;
                        tmp9.xyz = tmp9.xyz / tmp7.xyz;
                        tmp10.xyz = tmp7.xyz > float3(0.0, 0.0, 0.0);
                        tmp8.xyz = tmp10.xyz ? tmp8.xyz : tmp9.xyz;
                        tmp4.w = min(tmp8.y, tmp8.x);
                        tmp4.w = min(tmp8.z, tmp4.w);
                        tmp8.xyz = inp.texcoord1.xyz - unity_SpecCube1_ProbePosition.xyz;
                        tmp0.yzw = tmp7.xyz * tmp4.www + tmp8.xyz;
                    }
                    tmp7 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp0.yzw, tmp3.z));
                    tmp0.y = tmp7.w - 1.0;
                    tmp0.y = unity_SpecCube1_HDR.w * tmp0.y + 1.0;
                    tmp0.y = log(tmp0.y);
                    tmp0.y = tmp0.y * unity_SpecCube1_HDR.y;
                    tmp0.y = exp(tmp0.y);
                    tmp0.y = tmp0.y * unity_SpecCube1_HDR.x;
                    tmp0.yzw = tmp7.xyz * tmp0.yyy;
                    tmp5.xyz = tmp1.www * tmp5.xyz + -tmp0.yzw;
                    tmp6.xyz = unity_SpecCube0_BoxMin.www * tmp5.xyz + tmp0.yzw;
                }
                tmp5 = _Roughness.xxxx * float4(-1.0, -0.0275, -0.572, 0.022) + float4(1.0, 0.0425, 1.04, -0.04);
                tmp0.y = tmp5.x * tmp5.x;
                tmp0.z = tmp2.w * -9.28;
                tmp0.z = exp(tmp0.z);
                tmp0.y = min(tmp0.z, tmp0.y);
                tmp0.y = tmp0.y * tmp5.x + tmp5.y;
                tmp0.yz = tmp0.yy * float2(-1.04, 1.04) + tmp5.zw;
                tmp0.yzw = tmp2.xyz * tmp0.yyy + tmp0.zzz;
                tmp5.xyz = tmp2.xyz * tmp3.xyw;
                tmp0.yzw = tmp6.xyz * tmp0.yzw + -tmp5.xyz;
                tmp0.yzw = _Specularity.xxx * tmp0.yzw + tmp5.xyz;
                tmp0.yzw = tmp3.xyw * tmp4.xyz + tmp0.yzw;
                tmp3.xyz = inp.texcoord.xyz * tmp0.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, tmp3.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp1.w = dot(tmp1.xyz, tmp3.xyz);
                tmp1.x = dot(tmp1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.xw = max(tmp1.xw, float2(0.0, 0.0));
                tmp3.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.y = tmp1.x * -5.55473 + -6.98316;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.x = exp(tmp1.x);
                tmp1.y = tmp2.w * -5.55473 + -6.98316;
                tmp1.y = tmp2.w * tmp1.y;
                tmp1.y = exp(tmp1.y);
                tmp1.z = tmp0.x * tmp0.x;
                tmp2.w = dot(tmp1.xy, float2(_Roughness.x, _Metallic.x));
                tmp2.w = tmp2.w + 0.5;
                tmp3.w = 1.0 - tmp1.x;
                tmp1.x = tmp2.w * tmp1.x + tmp3.w;
                tmp3.w = 1.0 - tmp1.y;
                tmp1.y = tmp2.w * tmp1.y + tmp3.w;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.y = _Roughness * 0.95 + 0.05;
                tmp1.y = tmp1.y * tmp1.y;
                tmp2.w = tmp0.x * -5.55473 + -6.98316;
                tmp0.x = tmp0.x * tmp2.w;
                tmp0.x = exp(tmp0.x);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp2.xyz = tmp0.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.x = tmp1.y * tmp1.y;
                tmp2.w = tmp1.w * tmp1.w;
                tmp1.w = -tmp1.w * tmp1.w + 1.0;
                tmp1.w = tmp0.x * tmp2.w + tmp1.w;
                tmp1.w = tmp1.w * tmp1.w;
                tmp0.x = tmp0.x / tmp1.w;
                tmp1.y = tmp1.y * 0.5;
                tmp1.w = tmp1.y * tmp1.y;
                tmp1.y = -tmp1.y * tmp1.y + 1.0;
                tmp1.y = tmp1.z * tmp1.y + tmp1.w;
                tmp1.y = tmp1.y * 4.0;
                tmp1.y = 1.0 / tmp1.y;
                tmp0.x = tmp0.x * tmp1.y;
                tmp1.yzw = tmp0.xxx * tmp2.xyz;
                tmp1.yzw = tmp1.yzw * _Specularity.xxx;
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
			Offset -1, -1
			GpuProgramID 77350
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _Cutoff;
			float4 _Color;
			float _Roughness;
			float _Metallic;
			float _Specularity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _MainTex;
			
			// Keywords: POINT
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
                o.texcoord.w = 0.0;
                o.texcoord.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord3.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
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
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0.w = _Color.w * tmp0.w + -_Cutoff;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp0.xyz = min(tmp0.xyz, float3(1.0, 1.0, 1.0));
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp1.xyz = -_Specularity.xxx * float3(0.08, 0.08, 0.08) + tmp0.xyz;
                tmp0.w = _Specularity * 0.08;
                tmp1.xyz = _Metallic.xxx * tmp1.xyz + tmp0.www;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp0.w = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * inp.texcoord.xyz;
                tmp4.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord1.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp4.xyz * tmp0.www + tmp3.xyz;
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp0.www * tmp5.xyz;
                tmp0.w = dot(tmp4.xyz, tmp5.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = tmp0.w * -5.55473 + -6.98316;
                tmp1.w = tmp0.w * tmp1.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.w = exp(tmp1.w);
                tmp1.xyz = tmp1.www * tmp2.xyz + tmp1.xyz;
                tmp1.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * inp.texcoord2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp5.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp2.w = tmp1.w * tmp1.w;
                tmp1.w = -tmp1.w * tmp1.w + 1.0;
                tmp3.w = _Roughness * 0.95 + 0.05;
                tmp3.w = tmp3.w * tmp3.w;
                tmp4.w = tmp3.w * tmp3.w;
                tmp3.w = tmp3.w * 0.5;
                tmp1.w = tmp4.w * tmp2.w + tmp1.w;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.w = tmp4.w / tmp1.w;
                tmp2.w = tmp3.w * tmp3.w;
                tmp3.w = -tmp3.w * tmp3.w + 1.0;
                tmp2.w = tmp0.w * tmp3.w + tmp2.w;
                tmp0.w = dot(tmp0.xy, float2(_Roughness.x, _Metallic.x));
                tmp0.w = tmp0.w + 0.5;
                tmp2.w = tmp2.w * 4.0;
                tmp2.w = 1.0 / tmp2.w;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _Specularity.xxx;
                tmp1.w = 1.0 - _Metallic;
                tmp0.xyz = tmp0.xyz * tmp1.www;
                tmp1.w = dot(tmp2.xyz, tmp3.xyz);
                tmp2.x = dot(tmp2.xyz, tmp4.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp1.w = max(tmp1.w, 0.0);
                tmp2.y = tmp1.w * -5.55473 + -6.98316;
                tmp1.w = tmp1.w * tmp2.y;
                tmp1.w = exp(tmp1.w);
                tmp2.y = 1.0 - tmp1.w;
                tmp1.w = tmp0.w * tmp1.w + tmp2.y;
                tmp2.y = tmp2.x * -5.55473 + -6.98316;
                tmp2.y = tmp2.x * tmp2.y;
                tmp2.y = exp(tmp2.y);
                tmp2.z = 1.0 - tmp2.y;
                tmp0.w = tmp0.w * tmp2.y + tmp2.z;
                tmp0.w = tmp1.w * tmp0.w;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp1.xyz;
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp1 = tex2D(_LightTexture0, tmp0.ww);
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.xyz = tmp2.xxx * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
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
			Offset -1, -1
			GpuProgramID 142739
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
			float _Cutoff;
			float4 _Color;
			float4 _EmissionColor;
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
			sampler2D _EmissionMap;
			
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
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0 = tmp0 * _Color;
                tmp0.w = tmp0.w >= _Cutoff;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = log(tmp0.xyz);
                tmp1.x = saturate(unity_OneOverOutputBoost);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                tmp0.xyz = exp(tmp0.xyz);
                tmp1.xyz = min(tmp0.xyz, unity_MaxOutputValue.xxx);
                tmp1.w = 1.0;
                tmp1 = unity_MetaFragmentControl ? tmp1 : float4(0.0, 0.0, 0.0, 0.0);
                tmp2 = tex2D(_EmissionMap, inp.texcoord6.xy);
                tmp0.xyz = tmp2.xyz * _EmissionColor.xyz;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp2.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp2.xyz = tmp0.xyz * tmp2.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp2.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp2.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0103093, 0.0103093, 0.0103093);
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp2.x = max(tmp0.z, 0.02);
                tmp0.w = max(tmp0.w, tmp2.x);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp2.w = tmp0.w * 0.0039216;
                tmp2.xyz = tmp0.xyz / tmp2.www;
                o.sv_target = unity_MetaFragmentControl ? tmp2 : tmp1;
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
			GpuProgramID 243370
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _Cutoff;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
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
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0.w = _Color.w * tmp0.w + -_Cutoff;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.xyz * _LightColor0.xyz;
                tmp0.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
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
			GpuProgramID 301240
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
			float _Cutoff;
			float4 _Color;
			float4 _EmissionColor;
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
			sampler2D _EmissionMap;
			
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
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0 = tmp0 * _Color;
                tmp0.w = tmp0.w >= _Cutoff;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = log(tmp0.xyz);
                tmp1.x = saturate(unity_OneOverOutputBoost);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                tmp0.xyz = exp(tmp0.xyz);
                tmp1.xyz = min(tmp0.xyz, unity_MaxOutputValue.xxx);
                tmp1.w = 1.0;
                tmp1 = unity_MetaFragmentControl ? tmp1 : float4(0.0, 0.0, 0.0, 0.0);
                tmp2 = tex2D(_EmissionMap, inp.texcoord6.xy);
                tmp0.xyz = tmp2.xyz * _EmissionColor.xyz;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp2.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp2.xyz = tmp0.xyz * tmp2.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp2.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp2.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0103093, 0.0103093, 0.0103093);
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp2.x = max(tmp0.z, 0.02);
                tmp0.w = max(tmp0.w, tmp2.x);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp2.w = tmp0.w * 0.0039216;
                tmp2.xyz = tmp0.xyz / tmp2.www;
                o.sv_target = unity_MetaFragmentControl ? tmp2 : tmp1;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Legacy Shaders/Transparent/Cutout/VertexLit"
	CustomEditor "TankiOnlineShaderGUI"
}