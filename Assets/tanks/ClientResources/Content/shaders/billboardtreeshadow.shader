// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "TankiOnline/BillboardTreeShadow" {
	Properties {
		_MainTex ("Texture Image", 2D) = "white" {}
		_Cutoff ("Cutoff", Range(0, 1)) = 0.5
		_FrameInfo ("FrameInfo", Vector) = (1,1,0,1)
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Fog {
				Mode 0
			}
			GpuProgramID 23245
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
			float4 _FrameInfo;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                tmp0.x = dot(unity_ObjectToWorld._m02_m12_m22, unity_ObjectToWorld._m02_m12_m22);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * unity_ObjectToWorld._m22_m02_m12;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * _WorldSpaceLightPos0.yzx;
                tmp0.w = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.w = rsqrt(tmp0.w);
                tmp2 = tmp0.wwww * unity_ObjectToWorld._m01_m01_m21_m11;
                tmp0.w = dot(tmp1.xyz, tmp2.xyz);
                tmp1.xyz = -tmp0.www * tmp2.wzy + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp3.xyz = tmp0.xyz * tmp1.xyz;
                tmp3.xyz = tmp0.zxy * tmp1.yzx + -tmp3.xyz;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y > 0.8;
                tmp0.x = min(tmp0.x, 0.99);
                tmp1.y = max(tmp0.x, -0.99);
                tmp0.x = dot(tmp2.xyz, tmp3.xyz);
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = min(tmp0.z, 0.99);
                tmp0.x = tmp0.x < 0.0;
                tmp1.x = tmp0.x ? -tmp0.z : tmp0.z;
                tmp0.xy = tmp0.yy ? tmp1.xy : float2(0.0, 1.0);
                tmp1 = tmp2.ywzw * tmp2.ywzy;
                tmp3.xyz = tmp1.zzy + tmp1.yxx;
                tmp1.xyz = tmp3.xyz * tmp0.yyy + tmp1.xyz;
                tmp4.y = tmp1.y;
                tmp0.y = 1.0 - tmp0.y;
                tmp5.xyz = unity_ObjectToWorld._m01_m11_m21 * float3(0.5, 0.5, 0.5) + unity_ObjectToWorld._m03_m13_m23;
                tmp6.xyz = tmp2.wzw * tmp5.yzz;
                tmp0.zw = tmp5.xx * tmp2.xx + tmp6.yx;
                tmp3.xyz = tmp3.xyz * tmp5.xyz;
                tmp0.zw = -tmp2.wz * tmp0.zw + tmp3.yz;
                tmp0.zw = tmp0.yy * tmp0.zw;
                tmp3.yz = tmp2.zw * tmp5.xx;
                tmp1.y = tmp5.z * tmp2.y + -tmp3.y;
                tmp2.x = -tmp5.y * tmp2.y + tmp3.z;
                tmp3.y = tmp5.y * tmp2.z + -tmp6.z;
                tmp3.z = tmp6.y + tmp6.x;
                tmp3.x = -tmp2.y * tmp3.z + tmp3.x;
                tmp3.y = tmp0.x * tmp3.y;
                tmp3.w = tmp3.x * tmp0.y + tmp3.y;
                tmp5.w = tmp2.x * tmp0.x + tmp0.w;
                tmp4.w = tmp1.y * tmp0.x + tmp0.z;
                tmp0.xzw = tmp0.xxx * tmp2.zyw;
                tmp2.xy = tmp2.zz * tmp2.yw;
                tmp5.xy = tmp2.xy * tmp0.yy + -tmp0.wz;
                tmp3.xz = tmp2.yx * tmp0.yy + tmp0.zw;
                tmp4.z = tmp5.y;
                tmp4.x = tmp1.w * tmp0.y + tmp0.x;
                tmp3.y = tmp1.w * tmp0.y + -tmp0.x;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp1.y = dot(tmp4, tmp0);
                tmp2 = tmp1.yyyy * unity_MatrixV._m01_m11_m21_m31;
                tmp5.y = tmp3.x;
                tmp3.x = tmp1.x;
                tmp5.z = tmp1.z;
                tmp1.x = dot(tmp5, tmp0);
                tmp0.x = dot(tmp3, tmp0);
                tmp2 = unity_MatrixV._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp1 = unity_MatrixV._m02_m12_m22_m32 * tmp1.xxxx + tmp2;
                tmp0 = unity_MatrixV._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1 = tmp0.yyyy * UNITY_MATRIX_P._m01_m11_m21_m31;
                tmp1 = UNITY_MATRIX_P._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = UNITY_MATRIX_P._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = UNITY_MATRIX_P._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.xy = trunc(_FrameInfo.xy);
                o.texcoord.xy = v.texcoord.xy / tmp0.xy;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - _Cutoff;
                o.sv_target = tmp0;
                tmp0.x = tmp1.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                return o;
			}
			ENDCG
		}
	}
}