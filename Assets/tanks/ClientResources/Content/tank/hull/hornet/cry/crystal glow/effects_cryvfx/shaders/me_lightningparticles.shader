Shader "KriptoFX/ME/LightningParticles" {
	Properties {
		[HDR] _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Main Texture", 2D) = "white" {}
		_DistortTex1 ("Distort Texture1", 2D) = "white" {}
		_DistortTex2 ("Distort Texture2", 2D) = "white" {}
		_DistortSpeed ("Distort Speed Scale (xy/zw)", Vector) = (1,0.1,1,0.1)
		_Offset ("Offset", Float) = 0
		_UseVelocity ("UseVelocity", Range(0, 1)) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha One, SrcAlpha One
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 57851
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 color : COLOR0;
				float2 texcoord : TEXCOORD0;
				float texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _UseVelocity;
			float4 _MainTex_ST;
			float4 _DistortTex1_ST;
			float4 _DistortTex2_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TintColor;
			float4 _DistortSpeed;
			float _Offset;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DistortTex1;
			sampler2D _DistortTex2;
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
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color;
                tmp0.z = dot(v.texcoord1.xyz, v.texcoord1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.w = _Time.x - tmp0.z;
                o.texcoord2.x = _UseVelocity * tmp0.w + tmp0.z;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = tmp0.xy * _DistortTex1_ST.xy + _DistortTex1_ST.zw;
                o.texcoord1.zw = tmp0.xy * _DistortTex2_ST.xy + _DistortTex2_ST.zw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Time.x * 5.0;
                tmp0.xy = inp.texcoord.xy * float2(7.0, 7.0) + tmp0.xx;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.x = inp.color.w - tmp0.z;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = inp.texcoord2.xxxx * _DistortSpeed;
                tmp0 = -tmp0 * float4(1.4, 1.4, 1.25, 1.25) + inp.texcoord1;
                tmp0 = tmp0 + float4(0.4, 0.6, 0.3, 0.7);
                tmp1 = tex2D(_DistortTex2, tmp0.zw);
                tmp0 = tex2D(_DistortTex1, tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1 = _DistortSpeed * inp.texcoord2.xxxx + inp.texcoord1;
                tmp2 = tex2D(_DistortTex2, tmp1.zw);
                tmp1 = tex2D(_DistortTex1, tmp1.xy);
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy + tmp1.xy;
                tmp1.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = tmp0.zw + tmp1.xy;
                tmp0 = tmp0 * _DistortSpeed;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = saturate(tmp1.y + _Offset);
                tmp0.xy = tmp0.xy * tmp1.xx + inp.texcoord.xy;
                tmp0.xy = tmp0.zw * tmp1.xx + tmp0.xy;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp1 = _TintColor + _TintColor;
                tmp0 = tmp0.xxxx * tmp1;
                o.sv_target = tmp0 * inp.color.wwww;
                return o;
			}
			ENDCG
		}
	}
}