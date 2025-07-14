Shader "Hidden/P3D_BrushPreview" {
	Properties {
		_Shape ("Shape", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Tiling ("Tiling", Vector) = (1,1,0,0)
		_Offset ("Offset", Vector) = (0,0,0,0)
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+11" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+11" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			Cull Off
			Offset -1, -1
			GpuProgramID 63138
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 _WorldMatrix;
			float2 _Tiling;
			float2 _Offset;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _PaintMatrix;
			float2 _CanvasResolution;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Shape;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = _WorldMatrix._m11_m11_m11_m11 * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * _WorldMatrix._m01_m01_m01_m01 + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * _WorldMatrix._m21_m21_m21_m21 + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * _WorldMatrix._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _WorldMatrix._m10_m10_m10_m10 * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * _WorldMatrix._m00_m00_m00_m00 + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * _WorldMatrix._m20_m20_m20_m20 + tmp1;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * _WorldMatrix._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _WorldMatrix._m12_m12_m12_m12 * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * _WorldMatrix._m02_m02_m02_m02 + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * _WorldMatrix._m22_m22_m22_m22 + tmp1;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * _WorldMatrix._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _WorldMatrix._m13_m13_m13_m13 * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * _WorldMatrix._m03_m03_m03_m03 + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * _WorldMatrix._m23_m23_m23_m23 + tmp1;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * _WorldMatrix._m33_m33_m33_m33 + tmp1;
                o.position = tmp1 * v.vertex.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _Tiling + _Offset;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.xy = frac(inp.texcoord.xy);
                tmp0.xy = tmp0.xy * _CanvasResolution;
                tmp0.zw = frac(tmp0.xy);
                tmp0.zw = tmp0.zw - float2(0.5, 0.5);
                tmp0.z = max(abs(tmp0.w), abs(tmp0.z));
                tmp0.z = tmp0.z < 0.45;
                if (tmp0.z) {
                    tmp0.xy = floor(tmp0.xy);
                    tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                    tmp0.yz = tmp0.yy * _PaintMatrix._m01_m11;
                    tmp0.xy = _PaintMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                    tmp0.xy = tmp0.xy + _PaintMatrix._m02_m12;
                    tmp0.zw = tmp0.xy - float2(0.5, 0.5);
                    tmp0.z = max(abs(tmp0.w), abs(tmp0.z));
                    tmp0.z = tmp0.z <= 0.5;
                    if (tmp0.z) {
                        tmp0 = tex2D(_Shape, tmp0.xy);
                    } else {
                        tmp0.x = 0.0;
                    }
                    tmp0.x = tmp0.x * _Color.w;
                } else {
                    tmp0.x = 0.0;
                }
                tmp0.yzw = _Color.xyz;
                o.sv_target = tmp0.yzwx;
                return o;
			}
			ENDCG
		}
	}
}