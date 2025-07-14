Shader "Effects/Explosions/Particles/Alpha Blended Light" {
	Properties {
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_ColorStrength ("Color strength", Float) = 1
		_DiffuseThreshold ("Lighting Threshold", Range(-1.1, 1)) = 0.1
		_Diffusion ("Diffusion", Range(0.1, 10)) = 1
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Float) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 59006
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 sv_position : SV_Position0;
				float4 color : COLOR0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TintColor;
			float4 _LightColor0;
			float _DiffuseThreshold;
			float _Diffusion;
			float _ColorStrength;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
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
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.sv_position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = _WorldSpaceLightPos0.xyz - tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - 1.0;
                o.texcoord2.w = _WorldSpaceLightPos0.w * tmp0.w + 1.0;
                tmp1.xyz = _WorldSpaceLightPos0.www * -tmp0.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = saturate(dot(inp.texcoord1.xyz, inp.texcoord2.xyz));
                tmp0.x = tmp0.x * _LightColor0.x;
                tmp0.x = max(tmp0.x, _DiffuseThreshold);
                tmp0.x = tmp0.x - _DiffuseThreshold;
                tmp0.x = saturate(tmp0.x * _Diffusion);
                tmp1 = inp.color + inp.color;
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * tmp2;
                tmp2 = tmp1 * _TintColor;
                tmp0.xyz = tmp0.xxx * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * _LightColor0.www;
                tmp0.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0);
                tmp1.xyz = tmp1.xyz * _TintColor.xyz + -tmp0.xyz;
                tmp0.w = saturate(dot(tmp2.xyz, float3(0.299, 0.587, 0.114)));
                o.sv_target.w = saturate(tmp2.w);
                tmp0.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz * _ColorStrength.xxx;
                return o;
			}
			ENDCG
		}
	}
}