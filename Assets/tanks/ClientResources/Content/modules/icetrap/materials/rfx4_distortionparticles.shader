Shader "KriptoFX/RFX4/DistortionParticles" {
	Properties {
		_BumpTex ("Normalmap (RG) & Alpha (A)", 2D) = "black" {}
		_BumpAmt ("Distortion", Float) = 10
		_InvFade ("Soft Particles Factor", Float) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		GrabPass {
		}
		Pass {
			Name "BASE"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 17576
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _BumpTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _BumpAmt;
			float4 _GrabTexture_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BumpTex;
			sampler2D _GrabTexture;
			
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
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.z = tmp1.w / tmp0.x;
                tmp0.xy = tmp1.xy * float2(1.0, -1.0) + tmp1.ww;
                o.texcoord.w = tmp1.w;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                o.texcoord1.xy = v.texcoord.xy * _BumpTex_ST.xy + _BumpTex_ST.zw;
                o.color = v.color;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_BumpTex, inp.texcoord1.xy);
                tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = tmp0.y + tmp0.x;
                tmp0.xy = tmp0.xy * _BumpAmt.xx;
                tmp0.xy = tmp0.xy * _GrabTexture_TexelSize.xy;
                tmp0.xy = tmp0.xy * inp.color.ww;
                tmp0.xy = tmp0.xy * inp.texcoord.zz + inp.texcoord.xy;
                tmp0.xy = tmp0.xy / inp.texcoord.ww;
                tmp1 = tex2D(_GrabTexture, tmp0.xy);
                tmp0.x = abs(tmp0.z) - 0.01;
                tmp0.y = tmp0.x * 25.0 + -0.1;
                tmp0.x = tmp0.x * 25.0;
                o.sv_target.w = saturate(tmp0.x * tmp1.w);
                o.sv_target.xyz = tmp1.xyz;
                tmp0.x = tmp0.y < 0.0;
                if (tmp0.x) {
                    discard;
                }
                return o;
			}
			ENDCG
		}
	}
}