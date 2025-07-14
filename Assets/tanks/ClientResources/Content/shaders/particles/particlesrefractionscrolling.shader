Shader "TankiOnline/Particles/Refraction (Scrolling)" {
	Properties {
		[Normal] _DistortionMap ("Distortion", 2D) = "bumb" {}
		_Refraction ("Refraction", Range(0.01, 1000)) = 5
		_ScrollVelocity ("Scroll velocity", Vector) = (0,0,0,0)
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		GrabPass {
		}
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			ColorMask RGB
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 53524
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 color : COLOR0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _DistortionMap_ST;
			float4 _ScrollVelocity;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _GrabTexture_TexelSize;
			float _Refraction;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DistortionMap;
			sampler2D _GrabTexture;
			
			// Keywords: 
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                o.color = v.color;
                tmp0.xyz = tmp0.xwy * float3(0.5, 0.5, -0.5);
                tmp0.xy = tmp0.yy + tmp0.xz;
                o.texcoord1.xy = tmp0.xy / tmp0.ww;
                tmp0.xy = v.texcoord.xy * _DistortionMap_ST.xy + _DistortionMap_ST.zw;
                o.texcoord.xy = -_ScrollVelocity.xy * _Time.yy + tmp0.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_DistortionMap, inp.texcoord.xy);
                tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * _GrabTexture_TexelSize.xy;
                tmp0.xy = tmp0.xy * _Refraction.xx;
                tmp0.xy = tmp0.xy * inp.color.ww + inp.texcoord1.xy;
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                o.sv_target.xyz = tmp0.xyz * inp.color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
}