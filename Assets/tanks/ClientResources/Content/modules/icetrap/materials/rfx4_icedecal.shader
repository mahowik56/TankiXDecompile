Shader "KriptoFX/RFX4/Decal/Ice" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		[HDR] _ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
		_MainTex ("Base (RGB) Emission Tex (A)", 2D) = "white" {}
		_Cube ("Reflection Cubemap", Cube) = "" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_FPOW ("FPOW Fresnel", Float) = 5
		_R0 ("R0 Fresnel", Float) = 0.05
		_Cutoff ("Cutoff", Range(0, 1)) = 0.5
		_BumpAmt ("Distortion", Range(0, 1500)) = 10
	}
	SubShader {
		GrabPass {
			"_GrabTexture"
		}
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transperent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			Offset -1, -1
			GpuProgramID 49613
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_Projector;
			float4 _MainTex_ST;
			float4 _BumpMap_ST;
			float _FPOW;
			float _R0;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _ReflectColor;
			float _Cutoff;
			float _BumpAmt;
			float4 _GrabTexture_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BumpMap;
			sampler2D _MainTex;
			samplerCUBE _Cube;
			sampler2D _GrabTexture;
			
			// Keywords: DISTORT_ON
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
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                tmp2.xyz = v.vertex.yyy * unity_Projector._m01_m11_m21;
                tmp2.xyz = unity_Projector._m00_m10_m20 * v.vertex.xxx + tmp2.xyz;
                tmp2.xyz = unity_Projector._m02_m12_m22 * v.vertex.zzz + tmp2.xyz;
                tmp2.xyz = unity_Projector._m03_m13_m23 * v.vertex.www + tmp2.xyz;
                o.texcoord.xyz = tmp2.xyz;
                o.texcoord1.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = tmp2.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                tmp2.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToObject._m03_m13_m23;
                tmp2.xyz = tmp2.xyz - v.vertex.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(v.normal.xyz, v.normal.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * v.normal.xyz;
                tmp0.w = dot(tmp3.xyz, tmp2.xyz);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _FPOW;
                tmp0.w = exp(tmp0.w);
                tmp1.z = 1.0 - _R0;
                o.texcoord2.z = saturate(tmp1.z * tmp0.w + _R0);
                tmp2.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                o.texcoord3.z = tmp1.w / tmp0.w;
                tmp1.xy = tmp1.xy * float2(1.0, -1.0) + tmp1.ww;
                o.texcoord3.w = tmp1.w;
                o.texcoord3.xy = tmp1.xy * float2(0.5, 0.5);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp1.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                o.texcoord4.xyz = tmp1.xyz * -tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: DISTORT_ON
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_BumpMap, inp.texcoord2.xy);
                tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = sqrt(tmp0.w);
                tmp1.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.xy = tmp0.xy * _BumpAmt.xx;
                tmp0.xy = tmp0.xy * _GrabTexture_TexelSize.xy;
                tmp1.xyz = tmp1.xyz * inp.texcoord4.xyz;
                tmp1 = texCUBE(_Cube, tmp1.xyz);
                tmp0.z = dot(tmp1, float4(0.33, 0.33, 0.33, 0.33));
                tmp1.xy = tmp0.xy * float2(0.1, 0.1) + inp.texcoord1.xy;
                tmp0.xy = tmp0.xy * inp.texcoord3.zz + inp.texcoord3.xy;
                tmp0.xy = tmp0.xy / inp.texcoord3.ww;
                tmp2 = tex2D(_GrabTexture, tmp0.xy);
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp0.x = tmp1.x * _Color.x;
                tmp0.y = tmp0.z * tmp1.w + -tmp0.x;
                tmp0.x = inp.texcoord2.z * tmp0.y + tmp0.x;
                tmp0.xyz = tmp0.xxx * _ReflectColor.xyz;
                tmp0.xyz = tmp2.xyz * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _Cutoff.xxx;
                tmp0.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0);
                o.sv_target.xyz = tmp2.xyz * _Color.xyz + tmp0.xyz;
                tmp0.x = saturate(dot(tmp2.xyz, float3(0.33, 0.33, 0.33)));
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * 10.0;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.y = -tmp1.w * tmp0.x + 1.0;
                tmp0.x = tmp0.x * tmp1.w;
                tmp0.y = _Cutoff >= tmp0.y;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yzw = inp.texcoord.xyz <= float3(0.0, 0.0, 1.0);
                tmp1.xyz = inp.texcoord.xyz >= float3(1.0, 1.0, -1.0);
                tmp0.y = uint1(tmp0.y) | uint1(tmp1.x);
                tmp0.y = uint1(tmp0.y) | uint1(tmp0.z);
                tmp0.z = tmp0.w ? 1.0 : 0.0;
                tmp0.y = uint1(tmp0.y) | uint1(tmp1.y);
                tmp0.w = tmp1.z ? 1.0 : 0.0;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.y = tmp0.y ? 0.0 : tmp0.z;
                o.sv_target.w = tmp0.y * tmp0.x;
                return o;
			}
			ENDCG
		}
	}
}