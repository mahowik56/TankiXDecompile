Shader "Hidden/ColorCorrectionCurvesSimple" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_RgbTex ("_RgbTex (RGB)", 2D) = "" {}
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 16160
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _Saturation;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _RgbTex;
			
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.yw = float2(0.125, 0.375);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xz = tmp1.yz;
                tmp2 = tex2D(_RgbTex, tmp0.zw);
                tmp0 = tex2D(_RgbTex, tmp0.xy);
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp0.xyz = tmp0.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                o.sv_target.w = tmp1.w;
                tmp1.y = 0.625;
                tmp1 = tex2D(_RgbTex, tmp1.xy);
                tmp0.xyz = tmp1.xyz * float3(0.0, 0.0, 1.0) + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                o.sv_target.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                return o;
			}
			ENDCG
		}
	}
}