Shader "UpdateRankEffect/Projector/Additive" {
	Properties {
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,1)
		_ColorStrength ("Color strength", Float) = 1
		_MainTex ("Main Texture", 2D) = "gray" {}
		_FalloffTex ("FallOff", 2D) = "white" {}
	}
	SubShader {
		Tags { "QUEUE" = "Transparent+10" }
		Pass {
			Tags { "QUEUE" = "Transparent+10" }
			Blend SrcAlpha One, SrcAlpha One
			ZClip Off
			ZWrite Off
			Offset -1, -1
			Fog {
				Mode 0
			}
			GpuProgramID 6265
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 position : SV_POSITION0;
				float2 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TintColor;
			float _ColorStrength;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _FalloffTex;
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_Projector._m01_m11_m21_m31;
                tmp0 = unity_Projector._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_Projector._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = unity_Projector._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord = tmp0;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = v.vertex.yyyy * unity_ProjectorClip._m01_m11_m21_m31;
                tmp0 = unity_ProjectorClip._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ProjectorClip._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                o.texcoord1 = unity_ProjectorClip._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
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
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp0 = tex2D(_FalloffTex, tmp0.xy);
                tmp0.xy = inp.texcoord.yx < float2(0.0, 0.0);
                tmp1.xy = inp.texcoord.yx > float2(1.0, 1.0);
                tmp0.x = uint1(tmp0.x) | uint1(tmp1.x);
                tmp0.x = uint1(tmp0.y) | uint1(tmp0.x);
                tmp0.x = uint1(tmp1.y) | uint1(tmp0.x);
                if (tmp0.x) {
                    tmp1 = float4(0.0, 0.0, 0.0, 0.0);
                } else {
                    tmp1 = tex2D(_MainTex, inp.texcoord2.xy);
                }
                tmp2 = tmp1 * _TintColor;
                tmp2 = tmp2 * _ColorStrength.xxxx;
                tmp1 = tmp2 * tmp1.wwww + float4(-1.0, -1.0, -1.0, -0.0);
                tmp0 = tmp0.wwww * tmp1 + float4(1.0, 1.0, 1.0, 0.0);
                tmp1.x = tmp0.w > 1.0;
                o.sv_target.w = tmp1.x ? 1.0 : tmp0.w;
                o.sv_target.xyz = tmp0.xyz;
                return o;
			}
			ENDCG
		}
	}
}