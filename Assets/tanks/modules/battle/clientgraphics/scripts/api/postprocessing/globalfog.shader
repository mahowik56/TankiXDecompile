Shader "Hidden/GlobalFog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 41466
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 _FrustumCornersWS;
			float4 _HeightParams;
			float4 _MainTex_TexelSize;
			float _FogFacCoef;
			int _horizontalFog;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _DistanceParams;
			float4 _FogColor;
			float4 _SceneFogParams;
			float4 _CameraWS;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                const float4 icb[4] = {
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.0, 1.0, 0.0, 0.0),
                    float4(0.0, 0.0, 1.0, 0.0),
                    float4(0.0, 0.0, 0.0, 1.0)
                };
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * float4(0.1, 0.1, 0.1, 0.1) + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xxy;
                tmp0.x = 1 - _horizontalFog;
                tmp0.x = floor(tmp0.x);
                tmp0.y = _HeightParams.x + _WorldSpaceCameraPos.y;
                tmp0.y = abs(tmp0.y) * _FogFacCoef;
                tmp0.z = floor(_horizontalFog);
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp1.w = v.vertex.z;
                tmp0.y = asint(v.vertex.z);
                tmp1.x = dot(_FrustumCornersWS._m00_m10_m20_m30, icb[tmp0.y + 0]);
                tmp1.y = dot(_FrustumCornersWS._m01_m11_m21_m31, icb[tmp0.y + 0]);
                tmp1.z = dot(_FrustumCornersWS._m02_m12_m22_m32, icb[tmp0.y + 0]);
                o.texcoord2 = tmp0.xxxx * tmp1;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = -_HeightParams.z * 2.0 + 1.0;
                tmp1 = tex2D(_CameraDepthTexture, inp.texcoord1.xy);
                tmp0.y = _ZBufferParams.x * tmp1.x + _ZBufferParams.y;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.z = tmp0.y * inp.texcoord2.y + _CameraWS.y;
                tmp0.z = tmp0.z - _HeightParams.x;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.z = tmp0.z + _HeightParams.y;
                tmp0.x = min(tmp0.x, 0.0);
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.w = tmp0.y * inp.texcoord2.y + 0.00001;
                tmp0.x = tmp0.x / abs(tmp0.w);
                tmp0.x = _HeightParams.z * tmp0.z + -tmp0.x;
                tmp1.xyz = tmp0.yyy * inp.texcoord2.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.z + -_ProjectionParams.y;
                tmp0.y = tmp0.y + _DistanceParams.x;
                tmp1.xyz = tmp1.xyz * _HeightParams.www;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.x = -tmp0.z * tmp0.x + tmp0.y;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = saturate(tmp0.x * _SceneFogParams.z + _SceneFogParams.w);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 - _FogColor;
                o.sv_target = tmp0.xxxx * tmp1 + _FogColor;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 91090
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 _FrustumCornersWS;
			float4 _HeightParams;
			float4 _MainTex_TexelSize;
			float _FogFacCoef;
			int _horizontalFog;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _DistanceParams;
			float4 _FogColor;
			float4 _SceneFogParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                const float4 icb[4] = {
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.0, 1.0, 0.0, 0.0),
                    float4(0.0, 0.0, 1.0, 0.0),
                    float4(0.0, 0.0, 0.0, 1.0)
                };
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * float4(0.1, 0.1, 0.1, 0.1) + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xxy;
                tmp0.x = 1 - _horizontalFog;
                tmp0.x = floor(tmp0.x);
                tmp0.y = _HeightParams.x + _WorldSpaceCameraPos.y;
                tmp0.y = abs(tmp0.y) * _FogFacCoef;
                tmp0.z = floor(_horizontalFog);
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp1.w = v.vertex.z;
                tmp0.y = asint(v.vertex.z);
                tmp1.x = dot(_FrustumCornersWS._m00_m10_m20_m30, icb[tmp0.y + 0]);
                tmp1.y = dot(_FrustumCornersWS._m01_m11_m21_m31, icb[tmp0.y + 0]);
                tmp1.z = dot(_FrustumCornersWS._m02_m12_m22_m32, icb[tmp0.y + 0]);
                o.texcoord2 = tmp0.xxxx * tmp1;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_CameraDepthTexture, inp.texcoord1.xy);
                tmp0.x = _ZBufferParams.x * tmp0.x + _ZBufferParams.y;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x * _ProjectionParams.z + -_ProjectionParams.y;
                tmp0.x = tmp0.x + _DistanceParams.x;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = saturate(tmp0.x * _SceneFogParams.z + _SceneFogParams.w);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 - _FogColor;
                o.sv_target = tmp0.xxxx * tmp1 + _FogColor;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 188344
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 _FrustumCornersWS;
			float4 _HeightParams;
			float4 _MainTex_TexelSize;
			float _FogFacCoef;
			int _horizontalFog;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _DistanceParams;
			float4 _FogColor;
			float4 _SceneFogParams;
			float4 _CameraWS;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                const float4 icb[4] = {
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.0, 1.0, 0.0, 0.0),
                    float4(0.0, 0.0, 1.0, 0.0),
                    float4(0.0, 0.0, 0.0, 1.0)
                };
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * float4(0.1, 0.1, 0.1, 0.1) + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xxy;
                tmp0.x = 1 - _horizontalFog;
                tmp0.x = floor(tmp0.x);
                tmp0.y = _HeightParams.x + _WorldSpaceCameraPos.y;
                tmp0.y = abs(tmp0.y) * _FogFacCoef;
                tmp0.z = floor(_horizontalFog);
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp1.w = v.vertex.z;
                tmp0.y = asint(v.vertex.z);
                tmp1.x = dot(_FrustumCornersWS._m00_m10_m20_m30, icb[tmp0.y + 0]);
                tmp1.y = dot(_FrustumCornersWS._m01_m11_m21_m31, icb[tmp0.y + 0]);
                tmp1.z = dot(_FrustumCornersWS._m02_m12_m22_m32, icb[tmp0.y + 0]);
                o.texcoord2 = tmp0.xxxx * tmp1;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = -_HeightParams.z * 2.0 + 1.0;
                tmp1 = tex2D(_CameraDepthTexture, inp.texcoord1.xy);
                tmp0.y = _ZBufferParams.x * tmp1.x + _ZBufferParams.y;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.z = tmp0.y * inp.texcoord2.y + _CameraWS.y;
                tmp0.z = tmp0.z - _HeightParams.x;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.z = tmp0.z + _HeightParams.y;
                tmp0.x = min(tmp0.x, 0.0);
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.w = tmp0.y * inp.texcoord2.y + 0.00001;
                tmp1.xyz = tmp0.yyy * inp.texcoord2.xyz;
                tmp1.xyz = tmp1.xyz * _HeightParams.www;
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.x = tmp0.x / abs(tmp0.w);
                tmp0.x = _HeightParams.z * tmp0.z + -tmp0.x;
                tmp0.x = -tmp0.y * tmp0.x + _DistanceParams.x;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = saturate(tmp0.x * _SceneFogParams.z + _SceneFogParams.w);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 - _FogColor;
                o.sv_target = tmp0.xxxx * tmp1 + _FogColor;
                return o;
			}
			ENDCG
		}
	}
}