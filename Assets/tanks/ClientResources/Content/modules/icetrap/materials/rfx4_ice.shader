Shader "KriptoFX/RFX4/Ice" {
	Properties {
		[HDR] _Color ("Main Color", Color) = (1,1,1,1)
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
		_MainTex ("Base (RGB) Emission Tex (A)", 2D) = "white" {}
		_Cube ("Reflection Cubemap", Cube) = "" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_FPOW ("FPOW Fresnel", Float) = 5
		_R0 ("R0 Fresnel", Float) = 0.05
		_BumpAmt ("Distortion", Float) = 10
		_RefractiveStrength ("Refractive Strength", Float) = 10
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		GrabPass {
			"_GrabTextureIce"
		}
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			Fog {
				Mode 0
			}
			GpuProgramID 40731
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
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _CutoutTex_ST;
			float4 _BumpMap_ST;
			float _RefractiveStrength;
			float _FPOW;
			float _R0;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _ReflectColor;
			float _BumpAmt;
			float4 _GrabTextureIce_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BumpMap;
			sampler2D _MainTex;
			samplerCUBE _Cube;
			sampler2D _GrabTextureIce;
			
			// Keywords: DISTORT_ON
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
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.zw = v.texcoord.xy * _CutoutTex_ST.xy + _CutoutTex_ST.zw;
                tmp0.w = dot(v.normal.xyz, v.normal.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * v.normal.xyz;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp3.xyz = tmp3.xyz - v.vertex.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * tmp3.xyz;
                tmp0.w = dot(tmp2.xyz, tmp4.xyz);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _FPOW;
                tmp0.w = exp(tmp0.w);
                tmp1.z = 1.0 - _R0;
                o.texcoord1.z = saturate(tmp1.z * tmp0.w + _R0);
                o.texcoord1.xy = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                o.texcoord1.w = 1.0;
                tmp2.z = dot(v.normal.xyz, tmp3.xyz);
                tmp4.xyz = v.normal.zxy * v.tangent.yzx;
                tmp4.xyz = v.normal.yzx * v.tangent.zxy + -tmp4.xyz;
                tmp4.xyz = tmp4.xyz * v.tangent.www;
                tmp2.y = dot(tmp4.xyz, tmp3.xyz);
                tmp2.x = dot(v.tangent.xyz, tmp3.xyz);
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xy = tmp0.ww * tmp2.xy;
                tmp0.w = 1.0 / _RefractiveStrength;
                tmp2.xy = tmp2.xy * tmp0.ww;
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w >= 0.0;
                tmp2.xy = tmp0.ww ? tmp2.xy : 0.0;
                tmp1.y = tmp1.y * _ProjectionParams.x;
                tmp1.xy = tmp1.ww + tmp1.xy;
                o.texcoord2.xy = tmp1.xy * float2(0.5, 0.5) + tmp2.xy;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = sqrt(tmp0.w);
                o.texcoord2.z = tmp1.w / tmp0.w;
                o.texcoord2.w = tmp1.w;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp1.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                o.texcoord3.xyz = tmp1.xyz * -tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: DISTORT_ON
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_BumpMap, inp.texcoord1.xy);
                tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = sqrt(tmp0.w);
                tmp1.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.xy = tmp0.xy * _BumpAmt.xx;
                tmp0.xy = tmp0.xy * _GrabTextureIce_TexelSize.xy;
                tmp1.xyz = tmp1.xyz * inp.texcoord3.xyz;
                tmp1 = texCUBE(_Cube, tmp1.xyz);
                tmp0.z = dot(tmp1, float4(0.33, 0.33, 0.33, 0.33));
                tmp1.xy = tmp0.xy * float2(0.1, 0.1) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * inp.texcoord2.zz + inp.texcoord2.xy;
                tmp0.xy = tmp0.xy / inp.texcoord2.ww;
                tmp2 = tex2D(_GrabTextureIce, tmp0.xy);
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp0.x = tmp1.x * _Color.x;
                tmp0.y = tmp0.z * tmp1.w + -tmp0.x;
                tmp0.x = inp.texcoord1.z * tmp0.y + tmp0.x;
                tmp0.yzw = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = -tmp1.xyz * tmp0.xxx + tmp0.xxx;
                tmp0.xyz = inp.texcoord1.zzz * tmp1.xyz + tmp0.yzw;
                tmp0.xyz = tmp0.xyz * _ReflectColor.xyz;
                tmp0.xyz = tmp2.xyz * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0);
                o.sv_target.xyz = tmp2.xyz * _Color.xyz + tmp0.xyz;
                o.sv_target.w = _Color.w;
                return o;
			}
			ENDCG
		}
	}
}