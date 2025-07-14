Shader "Hidden/Post FX/Eye Adaptation" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 33423
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 because it uses wrong array syntax (type[size] name)
#pragma exclude_renderers d3d11
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Params;
			float2 _Speed;
			float4 _ScaleOffsetRes;
			float _ExposureCompensation;
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
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
                float4 tmp3;
                tmp0.xy = float2(0.0, 0.0);
                for (int i = tmp0.y; i < 64; i += 1) {
                    tmp0.z = ((float4[1])rsc1.xxxx.Load(i))[0];
                    tmp0.x = max(tmp0.z, tmp0.x);
                }
                tmp0.x = 1.0 / tmp0.x;
                tmp0.yz = float2(0.0, 0.0);
                for (int j = tmp0.y; j < 64; j += 1) {
                    tmp0.w = ((float4[1])rsc1.xxxx.Load(j))[0];
                    tmp0.z = tmp0.w * tmp0.x + tmp0.z;
                }
                tmp0.yz = tmp0.zz * _Params.xy;
                tmp1.xy = tmp0.yz;
                tmp0.w = 0.0;
                tmp2.xy = float2(0.0, 0.0);
                for (int k = tmp0.w; k < 64; k += 1) {
                    tmp1.w = ((float4[1])rsc1.xxxx.Load(k))[0];
                    tmp2.z = tmp0.x * tmp1.w;
                    tmp2.z = min(tmp1.x, tmp2.z);
                    tmp1.w = tmp1.w * tmp0.x + -tmp2.z;
                    tmp1.xz = tmp1.xy - tmp2.zz;
                    tmp3.y = min(tmp1.w, tmp1.z);
                    tmp1.y = tmp1.z - tmp3.y;
                    tmp1.z = tmp1.z * 0.015625 + -_ScaleOffsetRes.y;
                    tmp1.z = tmp1.z / _ScaleOffsetRes.x;
                    tmp1.z = exp(tmp1.z);
                    tmp3.x = tmp3.y * tmp1.z;
                    tmp2.xy = tmp3.xy + tmp2.xy;
                }
                tmp0.x = max(tmp2.y, 0.0001);
                tmp0.x = tmp2.x / tmp0.x;
                tmp0.x = max(tmp0.x, _Params.z);
                tmp0.x = min(tmp0.x, _Params.w);
                tmp0.x = max(tmp0.x, 0.0001);
                tmp0.x = _ExposureCompensation / tmp0.x;
                tmp0.y = tex2D(_MainTex, float2(0.5, 0.5));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.z = tmp0.x > 0.0;
                tmp0.z = tmp0.z ? _Speed.x : _Speed.y;
                tmp0.z = tmp0.z * -unity_DeltaTime.x;
                tmp0.z = exp(tmp0.z);
                tmp0.z = 1.0 - tmp0.z;
                o.sv_target = tmp0.xxxx * tmp0.zzzz + tmp0.yyyy;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 120290
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 because it uses wrong array syntax (type[size] name)
#pragma exclude_renderers d3d11
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Params;
			float4 _ScaleOffsetRes;
			float _ExposureCompensation;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
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
                float4 tmp3;
                tmp0.xy = float2(0.0, 0.0);
                for (int i = tmp0.y; i < 64; i += 1) {
                    tmp0.z = ((float4[1])rsc0.xxxx.Load(i))[0];
                    tmp0.x = max(tmp0.z, tmp0.x);
                }
                tmp0.x = 1.0 / tmp0.x;
                tmp0.yz = float2(0.0, 0.0);
                for (int j = tmp0.y; j < 64; j += 1) {
                    tmp0.w = ((float4[1])rsc0.xxxx.Load(j))[0];
                    tmp0.z = tmp0.w * tmp0.x + tmp0.z;
                }
                tmp0.yz = tmp0.zz * _Params.xy;
                tmp1.xy = tmp0.yz;
                tmp0.w = 0.0;
                tmp2.xy = float2(0.0, 0.0);
                for (int k = tmp0.w; k < 64; k += 1) {
                    tmp1.w = ((float4[1])rsc0.xxxx.Load(k))[0];
                    tmp2.z = tmp0.x * tmp1.w;
                    tmp2.z = min(tmp1.x, tmp2.z);
                    tmp1.w = tmp1.w * tmp0.x + -tmp2.z;
                    tmp1.xz = tmp1.xy - tmp2.zz;
                    tmp3.y = min(tmp1.w, tmp1.z);
                    tmp1.y = tmp1.z - tmp3.y;
                    tmp1.z = tmp1.z * 0.015625 + -_ScaleOffsetRes.y;
                    tmp1.z = tmp1.z / _ScaleOffsetRes.x;
                    tmp1.z = exp(tmp1.z);
                    tmp3.x = tmp3.y * tmp1.z;
                    tmp2.xy = tmp3.xy + tmp2.xy;
                }
                tmp0.x = max(tmp2.y, 0.0001);
                tmp0.x = tmp2.x / tmp0.x;
                tmp0.x = max(tmp0.x, _Params.z);
                tmp0.x = min(tmp0.x, _Params.w);
                tmp0.x = max(tmp0.x, 0.0001);
                o.sv_target = _ExposureCompensation.xxxx / tmp0.xxxx;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 138496
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 because it uses wrong array syntax (type[size] name)
#pragma exclude_renderers d3d11
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float texcoord1 : TEXCOORD1;
				float texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Params;
			float4 _ScaleOffsetRes;
			// $Globals ConstantBuffers for Fragment Shader
			int _DebugWidth;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: 
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.xy = float2(0.0, 0.0);
                for (int i = tmp0.y; i < 64; i += 1) {
                    tmp0.z = ((float4[1])rsc0.xxxx.Load(i))[0];
                    tmp0.x = max(tmp0.z, tmp0.x);
                }
                tmp0.x = 1.0 / tmp0.x;
                tmp0.yz = float2(0.0, 0.0);
                for (int j = tmp0.y; j < 64; j += 1) {
                    tmp0.w = ((float4[1])rsc0.xxxx.Load(j))[0];
                    tmp0.z = tmp0.w * tmp0.x + tmp0.z;
                }
                tmp0.yz = tmp0.zz * _Params.xy;
                tmp1.xy = tmp0.yz;
                tmp0.w = 0.0;
                tmp2.xy = float2(0.0, 0.0);
                for (int k = tmp0.w; k < 64; k += 1) {
                    tmp1.w = ((float4[1])rsc0.xxxx.Load(k))[0];
                    tmp2.z = tmp0.x * tmp1.w;
                    tmp2.z = min(tmp1.x, tmp2.z);
                    tmp1.w = tmp1.w * tmp0.x + -tmp2.z;
                    tmp1.xz = tmp1.xy - tmp2.zz;
                    tmp3.y = min(tmp1.w, tmp1.z);
                    tmp1.y = tmp1.z - tmp3.y;
                    tmp1.z = tmp1.z * 0.015625 + -_ScaleOffsetRes.y;
                    tmp1.z = tmp1.z / _ScaleOffsetRes.x;
                    tmp1.z = exp(tmp1.z);
                    tmp3.x = tmp3.y * tmp1.z;
                    tmp2.xy = tmp3.xy + tmp2.xy;
                }
                tmp0.y = max(tmp2.y, 0.0001);
                tmp0.y = tmp2.x / tmp0.y;
                tmp0.y = max(tmp0.y, _Params.z);
                o.texcoord2.x = min(tmp0.y, _Params.w);
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.x = tmp0.x;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = log(_Params.zw);
                tmp0.xy = saturate(tmp0.xy * _ScaleOffsetRes.xx + _ScaleOffsetRes.yy);
                tmp0.x = tmp0.x < inp.texcoord.x;
                tmp0.y = inp.texcoord.x < tmp0.y;
                tmp0.x = tmp0.y ? tmp0.x : 0.0;
                tmp0.y = inp.texcoord.x * 64.0;
                tmp0.y = round(tmp0.y);
                tmp0.y = ((float4[1])rsc0.xxxx.Load(tmp0.y))[0];
                tmp0.y = saturate(tmp0.y * inp.texcoord1.x);
                tmp0.y = tmp0.y >= inp.texcoord.y;
                tmp0.z = tmp0.y ? 1.0 : 0.0;
                tmp1.xyz = tmp0.yyy ? float3(0.1, 0.8, 1.2) : float3(0.05, 0.4, 0.6);
                tmp0.xyz = tmp0.xxx ? tmp1.xyz : tmp0.zzz;
                tmp0.w = log(inp.texcoord2.x);
                tmp0.w = saturate(tmp0.w * _ScaleOffsetRes.x + _ScaleOffsetRes.y);
                tmp1.x = floor(_DebugWidth);
                tmp0.w = -tmp0.w * tmp1.x + inp.position.x;
                tmp0.w = abs(tmp0.w) < 2.0;
                o.sv_target.xyz = tmp0.www ? float3(0.8, 0.3, 0.05) : tmp0.xyz;
                o.sv_target.w = 0.7;
                return o;
			}
			ENDCG
		}
	}
}