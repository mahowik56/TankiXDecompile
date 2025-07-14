Shader "Hidden/Post FX/Depth Of Field" {
	Properties {
		_MainTex ("", 2D) = "black" {}
	}
	SubShader {
		Pass {
			Name "COC CALCULATION"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 44892
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _Distance;
			float _LensCoeff;
			float _RcpMaxCoC;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_CameraDepthTexture, inp.texcoord.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.y = tmp0.x - _Distance;
                tmp0.x = max(tmp0.x, 0.00001);
                tmp0.y = tmp0.y * _LensCoeff;
                tmp0.x = tmp0.y / tmp0.x;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = tmp0.x * _RcpMaxCoC + 0.5;
                o.sv_target = saturate(tmp0.xxxx);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "COC TEMPORAL FILTER"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 77252
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float3 _TaaParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _CameraMotionVectorsTexture;
			sampler2D _CoCTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
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
                tmp0.xy = _MainTex_TexelSize.yy * float2(-0.0, -1.0);
                tmp1.xy = _MainTex_TexelSize.xy * float2(-1.0, -0.0);
                tmp2.x = 0.0;
                tmp2.yw = inp.texcoord.xy - _TaaParams.xy;
                tmp2.z = tex2D(_CoCTex, tmp2.yw);
                tmp2.yw = -_MainTex_TexelSize.xy * float2(0.5, 0.5) + inp.texcoord.xy;
                //unsupported_gather4;
                tmp1.z = tmp2.y;
                tmp0.w = tmp2.y < tmp2.z;
                tmp1.xyz = tmp0.www ? tmp1.xyz : tmp2.xxz;
                tmp0.w = tmp2.w < tmp1.z;
                tmp0.z = tmp2.w;
                tmp0.xyw = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp1.xy = _MainTex_TexelSize.yy * float2(0.0, 1.0);
                tmp2.xw = _MainTex_TexelSize.xy * float2(0.5, 0.5) + inp.texcoord.xy;
                //unsupported_gather4;
                tmp1.w = tmp2.x < tmp0.w;
                tmp1.z = tmp2.x;
                tmp0.xyw = tmp1.www ? tmp1.xyz : tmp0.xyw;
                tmp1.x = tmp2.w < tmp0.w;
                tmp3.xy = _MainTex_TexelSize.xy * float2(1.0, 0.0);
                tmp3.z = tmp2.w;
                tmp0.xyw = tmp1.xxx ? tmp3.xyz : tmp0.xyw;
                tmp0.xy = tmp0.xy + inp.texcoord.xy;
                tmp0.xy = tex2D(_CameraMotionVectorsTexture, tmp0.xy);
                tmp0.xy = inp.texcoord.xy - tmp0.xy;
                tmp0.x = tex2D(_MainTex, tmp0.xy);
                tmp0.y = max(tmp2.y, tmp2.z);
                tmp0.xy = max(tmp0.wz, tmp0.xy);
                tmp0.y = max(tmp2.x, tmp0.y);
                tmp0.y = max(tmp3.z, tmp0.y);
                tmp0.x = min(tmp0.y, tmp0.x);
                tmp0.x = tmp0.x - tmp2.z;
                o.sv_target = _TaaParams.zzzz * tmp0.xxxx + tmp2.zzzz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "DOWNSAMPLE AND PREFILTER"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 135377
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _CoCTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                //unsupported_gather4;
                tmp0 = tmp0 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp1.x = min(tmp0.w, tmp0.z);
                tmp1.y = min(tmp0.y, tmp1.x);
                tmp1.x = max(tmp0.y, tmp1.x);
                tmp1.x = max(tmp0.x, tmp1.x);
                tmp1.y = min(tmp0.x, tmp1.y);
                tmp1.z = tmp1.x < -tmp1.y;
                tmp1.x = tmp1.z ? tmp1.y : tmp1.x;
                tmp1.x = tmp1.x * _MaxCoC;
                tmp1.y = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.y = 1.0 / tmp1.y;
                tmp1.y = saturate(tmp1.y * abs(tmp1.x));
                o.sv_target.w = tmp1.x;
                tmp1.x = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.x = tmp1.y * tmp1.x;
                //unsupported_gather4;
                tmp3.x = tmp2.y;
                //unsupported_gather4;
                tmp3.y = tmp4.z;
                //unsupported_gather4;
                tmp3.z = tmp5.y;
                tmp6 = max(tmp4.xzyw, tmp5.xywz);
                tmp6 = max(tmp2, tmp6);
                tmp6 = tmp6 + float4(1.0, 1.0, 1.0, 1.0);
                tmp0 = abs(tmp0) / tmp6;
                tmp1.yzw = tmp0.yyy * tmp3.xyz;
                tmp3.x = tmp2.x;
                tmp3.y = tmp4.x;
                tmp3.z = tmp5.x;
                tmp1.yzw = tmp3.xyz * tmp0.xxx + tmp1.yzw;
                tmp4.x = tmp2.z;
                tmp5.x = tmp2.w;
                tmp5.y = tmp4.w;
                tmp4.z = tmp5.w;
                tmp1.yzw = tmp4.xyz * tmp0.zzz + tmp1.yzw;
                tmp1.yzw = tmp5.xyz * tmp0.www + tmp1.yzw;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.z + tmp0.x;
                tmp0.x = tmp0.w + tmp0.x;
                tmp0.x = max(tmp0.x, 0.00001);
                tmp0.xyz = tmp1.yzw / tmp0.xxx;
                o.sv_target.xyz = tmp1.xxx * tmp0.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "BOKEH FILTER (SMALL)"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 245121
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			float _RcpAspect;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[16] = {
                    float4(0.0, 0.0, 0.0, 0.0),
                    float4(0.5454546, 0.0, 0.0, 0.0),
                    float4(0.1685547, 0.5187581, 0.0, 0.0),
                    float4(-0.441282, 0.3206101, 0.0, 0.0),
                    float4(-0.441282, -0.3206102, 0.0, 0.0),
                    float4(0.1685548, -0.5187581, 0.0, 0.0),
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.809017, 0.5877852, 0.0, 0.0),
                    float4(0.309017, 0.9510565, 0.0, 0.0),
                    float4(-0.309017, 0.9510565, 0.0, 0.0),
                    float4(-0.8090171, 0.5877852, 0.0, 0.0),
                    float4(-1.0, 0.0, 0.0, 0.0),
                    float4(-0.8090169, -0.5877854, 0.0, 0.0),
                    float4(-0.3090166, -0.9510566, 0.0, 0.0),
                    float4(0.3090171, -0.9510565, 0.0, 0.0),
                    float4(0.8090169, -0.5877853, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.w = 1.0;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 16; i += 1) {
                    tmp4.yz = _MaxCoC.xx * icb[i + 0].xy;
                    tmp0.z = dot(tmp4.xy, tmp4.xy);
                    tmp0.z = sqrt(tmp0.z);
                    tmp4.x = tmp4.y * _RcpAspect;
                    tmp4.xy = tmp4.xz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp4.xy);
                    tmp5.x = min(tmp0.w, tmp4.w);
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x - tmp0.z;
                    tmp5.x = _MainTex_TexelSize.y * 2.0 + tmp5.x;
                    tmp5.x = saturate(tmp5.x / tmp0.x);
                    tmp0.z = -tmp0.z - tmp4.w;
                    tmp0.z = _MainTex_TexelSize.y * 2.0 + tmp0.z;
                    tmp0.z = saturate(tmp0.z / tmp0.x);
                    tmp4.w = -tmp4.w >= _MainTex_TexelSize.y;
                    tmp4.w = tmp4.w ? 1.0 : 0.0;
                    tmp0.z = tmp0.z * tmp4.w;
                    tmp1.xyz = tmp4.xyz;
                    tmp2 = tmp1 * tmp5.xxxx + tmp2;
                    tmp3 = tmp1 * tmp0.zzzz + tmp3;
                }
                tmp0.x = tmp2.w == 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.xyz = tmp2.xyz / tmp0.xxx;
                tmp0.w = tmp3.w == 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w + tmp3.w;
                tmp1.xyz = tmp3.xyz / tmp0.www;
                tmp0.w = tmp3.w * 0.1963495;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "BOKEH FILTER (MEDIUM)"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 312673
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			float _RcpAspect;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[22] = {
                    float4(0.0, 0.0, 0.0, 0.0),
                    float4(0.5333334, 0.0, 0.0, 0.0),
                    float4(0.3325279, 0.4169768, 0.0, 0.0),
                    float4(-0.1186778, 0.5199616, 0.0, 0.0),
                    float4(-0.4805167, 0.2314047, 0.0, 0.0),
                    float4(-0.4805167, -0.2314047, 0.0, 0.0),
                    float4(-0.1186776, -0.5199617, 0.0, 0.0),
                    float4(0.3325278, -0.4169769, 0.0, 0.0),
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.9009688, 0.4338838, 0.0, 0.0),
                    float4(0.6234898, 0.7818315, 0.0, 0.0),
                    float4(0.222521, 0.9749279, 0.0, 0.0),
                    float4(-0.2225209, 0.9749279, 0.0, 0.0),
                    float4(-0.62349, 0.7818314, 0.0, 0.0),
                    float4(-0.9009688, 0.4338838, 0.0, 0.0),
                    float4(-1.0, 0.0, 0.0, 0.0),
                    float4(-0.9009688, -0.4338838, 0.0, 0.0),
                    float4(-0.6234896, -0.7818316, 0.0, 0.0),
                    float4(-0.2225205, -0.974928, 0.0, 0.0),
                    float4(0.2225215, -0.9749278, 0.0, 0.0),
                    float4(0.6234897, -0.7818316, 0.0, 0.0),
                    float4(0.9009688, -0.4338838, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.w = 1.0;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 22; i += 1) {
                    tmp4.yz = _MaxCoC.xx * icb[i + 0].xy;
                    tmp0.z = dot(tmp4.xy, tmp4.xy);
                    tmp0.z = sqrt(tmp0.z);
                    tmp4.x = tmp4.y * _RcpAspect;
                    tmp4.xy = tmp4.xz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp4.xy);
                    tmp5.x = min(tmp0.w, tmp4.w);
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x - tmp0.z;
                    tmp5.x = _MainTex_TexelSize.y * 2.0 + tmp5.x;
                    tmp5.x = saturate(tmp5.x / tmp0.x);
                    tmp0.z = -tmp0.z - tmp4.w;
                    tmp0.z = _MainTex_TexelSize.y * 2.0 + tmp0.z;
                    tmp0.z = saturate(tmp0.z / tmp0.x);
                    tmp4.w = -tmp4.w >= _MainTex_TexelSize.y;
                    tmp4.w = tmp4.w ? 1.0 : 0.0;
                    tmp0.z = tmp0.z * tmp4.w;
                    tmp1.xyz = tmp4.xyz;
                    tmp2 = tmp1 * tmp5.xxxx + tmp2;
                    tmp3 = tmp1 * tmp0.zzzz + tmp3;
                }
                tmp0.x = tmp2.w == 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.xyz = tmp2.xyz / tmp0.xxx;
                tmp0.w = tmp3.w == 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w + tmp3.w;
                tmp1.xyz = tmp3.xyz / tmp0.www;
                tmp0.w = tmp3.w * 0.1427997;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "BOKEH FILTER (LARGE)"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 338183
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			float _RcpAspect;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[43] = {
                    float4(0.0, 0.0, 0.0, 0.0),
                    float4(0.3636364, 0.0, 0.0, 0.0),
                    float4(0.2267236, 0.2843024, 0.0, 0.0),
                    float4(-0.0809167, 0.3545192, 0.0, 0.0),
                    float4(-0.327625, 0.1577759, 0.0, 0.0),
                    float4(-0.327625, -0.1577759, 0.0, 0.0),
                    float4(-0.0809166, -0.3545193, 0.0, 0.0),
                    float4(0.2267235, -0.2843024, 0.0, 0.0),
                    float4(0.6818182, 0.0, 0.0, 0.0),
                    float4(0.614297, 0.2958298, 0.0, 0.0),
                    float4(0.4251067, 0.5330669, 0.0, 0.0),
                    float4(0.1517189, 0.6647236, 0.0, 0.0),
                    float4(-0.1517188, 0.6647236, 0.0, 0.0),
                    float4(-0.4251068, 0.5330669, 0.0, 0.0),
                    float4(-0.614297, 0.2958299, 0.0, 0.0),
                    float4(-0.6818182, 0.0, 0.0, 0.0),
                    float4(-0.614297, -0.2958298, 0.0, 0.0),
                    float4(-0.4251066, -0.533067, 0.0, 0.0),
                    float4(-0.1517186, -0.6647236, 0.0, 0.0),
                    float4(0.1517192, -0.6647235, 0.0, 0.0),
                    float4(0.4251066, -0.533067, 0.0, 0.0),
                    float4(0.614297, -0.2958298, 0.0, 0.0),
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.9555728, 0.2947552, 0.0, 0.0),
                    float4(0.8262388, 0.5633201, 0.0, 0.0),
                    float4(0.6234898, 0.7818315, 0.0, 0.0),
                    float4(0.365341, 0.9308738, 0.0, 0.0),
                    float4(0.07473, 0.9972038, 0.0, 0.0),
                    float4(-0.2225209, 0.9749279, 0.0, 0.0),
                    float4(-0.5000001, 0.8660254, 0.0, 0.0),
                    float4(-0.733052, 0.6801727, 0.0, 0.0),
                    float4(-0.9009688, 0.4338838, 0.0, 0.0),
                    float4(-0.9888309, 0.1490421, 0.0, 0.0),
                    float4(-0.9888308, -0.1490425, 0.0, 0.0),
                    float4(-0.9009688, -0.4338838, 0.0, 0.0),
                    float4(-0.7330518, -0.6801728, 0.0, 0.0),
                    float4(-0.4999999, -0.8660254, 0.0, 0.0),
                    float4(-0.222521, -0.9749279, 0.0, 0.0),
                    float4(0.0747303, -0.9972038, 0.0, 0.0),
                    float4(0.3653415, -0.9308736, 0.0, 0.0),
                    float4(0.6234897, -0.7818316, 0.0, 0.0),
                    float4(0.8262388, -0.56332, 0.0, 0.0),
                    float4(0.9555729, -0.2947548, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.w = 1.0;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 43; i += 1) {
                    tmp4.yz = _MaxCoC.xx * icb[i + 0].xy;
                    tmp0.z = dot(tmp4.xy, tmp4.xy);
                    tmp0.z = sqrt(tmp0.z);
                    tmp4.x = tmp4.y * _RcpAspect;
                    tmp4.xy = tmp4.xz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp4.xy);
                    tmp5.x = min(tmp0.w, tmp4.w);
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x - tmp0.z;
                    tmp5.x = _MainTex_TexelSize.y * 2.0 + tmp5.x;
                    tmp5.x = saturate(tmp5.x / tmp0.x);
                    tmp0.z = -tmp0.z - tmp4.w;
                    tmp0.z = _MainTex_TexelSize.y * 2.0 + tmp0.z;
                    tmp0.z = saturate(tmp0.z / tmp0.x);
                    tmp4.w = -tmp4.w >= _MainTex_TexelSize.y;
                    tmp4.w = tmp4.w ? 1.0 : 0.0;
                    tmp0.z = tmp0.z * tmp4.w;
                    tmp1.xyz = tmp4.xyz;
                    tmp2 = tmp1 * tmp5.xxxx + tmp2;
                    tmp3 = tmp1 * tmp0.zzzz + tmp3;
                }
                tmp0.x = tmp2.w == 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.xyz = tmp2.xyz / tmp0.xxx;
                tmp0.w = tmp3.w == 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w + tmp3.w;
                tmp1.xyz = tmp3.xyz / tmp0.www;
                tmp0.w = tmp3.w * 0.0730603;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "BOKEH FILTER (VERY LARGE)"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 440229
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			float _RcpAspect;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[71] = {
                    float4(0.0, 0.0, 0.0, 0.0),
                    float4(0.2758621, 0.0, 0.0, 0.0),
                    float4(0.1719972, 0.2156777, 0.0, 0.0),
                    float4(-0.0613851, 0.2689457, 0.0, 0.0),
                    float4(-0.2485432, 0.1196921, 0.0, 0.0),
                    float4(-0.2485432, -0.1196921, 0.0, 0.0),
                    float4(-0.061385, -0.2689457, 0.0, 0.0),
                    float4(0.1719972, -0.2156777, 0.0, 0.0),
                    float4(0.5172414, 0.0, 0.0, 0.0),
                    float4(0.4660183, 0.2244226, 0.0, 0.0),
                    float4(0.3224947, 0.4043956, 0.0, 0.0),
                    float4(0.1150971, 0.5042731, 0.0, 0.0),
                    float4(-0.115097, 0.5042731, 0.0, 0.0),
                    float4(-0.3224948, 0.4043955, 0.0, 0.0),
                    float4(-0.4660183, 0.2244226, 0.0, 0.0),
                    float4(-0.5172414, 0.0, 0.0, 0.0),
                    float4(-0.4660183, -0.2244226, 0.0, 0.0),
                    float4(-0.3224946, -0.4043956, 0.0, 0.0),
                    float4(-0.1150968, -0.5042731, 0.0, 0.0),
                    float4(0.1150973, -0.504273, 0.0, 0.0),
                    float4(0.3224947, -0.4043956, 0.0, 0.0),
                    float4(0.4660183, -0.2244226, 0.0, 0.0),
                    float4(0.7586207, 0.0, 0.0, 0.0),
                    float4(0.7249173, 0.2236074, 0.0, 0.0),
                    float4(0.6268018, 0.4273463, 0.0, 0.0),
                    float4(0.4729922, 0.5931135, 0.0, 0.0),
                    float4(0.2771552, 0.7061801, 0.0, 0.0),
                    float4(0.0566917, 0.7564995, 0.0, 0.0),
                    float4(-0.168809, 0.7396005, 0.0, 0.0),
                    float4(-0.3793104, 0.6569847, 0.0, 0.0),
                    float4(-0.5561084, 0.5159931, 0.0, 0.0),
                    float4(-0.6834936, 0.3291532, 0.0, 0.0),
                    float4(-0.7501475, 0.1130664, 0.0, 0.0),
                    float4(-0.7501475, -0.1130667, 0.0, 0.0),
                    float4(-0.6834936, -0.3291532, 0.0, 0.0),
                    float4(-0.5561083, -0.5159932, 0.0, 0.0),
                    float4(-0.3793103, -0.6569848, 0.0, 0.0),
                    float4(-0.168809, -0.7396005, 0.0, 0.0),
                    float4(0.0566919, -0.7564994, 0.0, 0.0),
                    float4(0.2771556, -0.7061799, 0.0, 0.0),
                    float4(0.4729922, -0.5931137, 0.0, 0.0),
                    float4(0.6268018, -0.4273462, 0.0, 0.0),
                    float4(0.7249174, -0.2236071, 0.0, 0.0),
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.9749279, 0.2225209, 0.0, 0.0),
                    float4(0.9009688, 0.4338838, 0.0, 0.0),
                    float4(0.7818315, 0.6234898, 0.0, 0.0),
                    float4(0.6234898, 0.7818315, 0.0, 0.0),
                    float4(0.4338836, 0.9009689, 0.0, 0.0),
                    float4(0.222521, 0.9749279, 0.0, 0.0),
                    float4(0.0, 1.0, 0.0, 0.0),
                    float4(-0.2225209, 0.9749279, 0.0, 0.0),
                    float4(-0.4338838, 0.9009688, 0.0, 0.0),
                    float4(-0.62349, 0.7818314, 0.0, 0.0),
                    float4(-0.7818317, 0.6234896, 0.0, 0.0),
                    float4(-0.9009688, 0.4338838, 0.0, 0.0),
                    float4(-0.9749279, 0.2225209, 0.0, 0.0),
                    float4(-1.0, 0.0, 0.0, 0.0),
                    float4(-0.9749279, -0.2225209, 0.0, 0.0),
                    float4(-0.9009688, -0.4338838, 0.0, 0.0),
                    float4(-0.7818314, -0.6234899, 0.0, 0.0),
                    float4(-0.6234896, -0.7818316, 0.0, 0.0),
                    float4(-0.4338835, -0.900969, 0.0, 0.0),
                    float4(-0.2225205, -0.974928, 0.0, 0.0),
                    float4(0.0, -1.0, 0.0, 0.0),
                    float4(0.2225215, -0.9749278, 0.0, 0.0),
                    float4(0.4338835, -0.900969, 0.0, 0.0),
                    float4(0.6234897, -0.7818316, 0.0, 0.0),
                    float4(0.7818314, -0.6234899, 0.0, 0.0),
                    float4(0.9009688, -0.4338838, 0.0, 0.0),
                    float4(0.9749279, -0.2225209, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.w = 1.0;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 71; i += 1) {
                    tmp4.yz = _MaxCoC.xx * icb[i + 0].xy;
                    tmp0.z = dot(tmp4.xy, tmp4.xy);
                    tmp0.z = sqrt(tmp0.z);
                    tmp4.x = tmp4.y * _RcpAspect;
                    tmp4.xy = tmp4.xz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp4.xy);
                    tmp5.x = min(tmp0.w, tmp4.w);
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x - tmp0.z;
                    tmp5.x = _MainTex_TexelSize.y * 2.0 + tmp5.x;
                    tmp5.x = saturate(tmp5.x / tmp0.x);
                    tmp0.z = -tmp0.z - tmp4.w;
                    tmp0.z = _MainTex_TexelSize.y * 2.0 + tmp0.z;
                    tmp0.z = saturate(tmp0.z / tmp0.x);
                    tmp4.w = -tmp4.w >= _MainTex_TexelSize.y;
                    tmp4.w = tmp4.w ? 1.0 : 0.0;
                    tmp0.z = tmp0.z * tmp4.w;
                    tmp1.xyz = tmp4.xyz;
                    tmp2 = tmp1 * tmp5.xxxx + tmp2;
                    tmp3 = tmp1 * tmp0.zzzz + tmp3;
                }
                tmp0.x = tmp2.w == 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.xyz = tmp2.xyz / tmp0.xxx;
                tmp0.w = tmp3.w == 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w + tmp3.w;
                tmp1.xyz = tmp3.xyz / tmp0.www;
                tmp0.w = tmp3.w * 0.0442478;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "POSTFILTER"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 484560
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = -_MainTex_TexelSize * float4(0.5, 0.5, -0.5, 0.5) + inp.texcoord.xyxy;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0 = tmp0 + tmp1;
                tmp1 = _MainTex_TexelSize * float4(-0.5, 0.5, 0.5, 0.5) + inp.texcoord.xyxy;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp0 = tmp0 + tmp2;
                tmp0 = tmp1 + tmp0;
                o.sv_target = tmp0 * float4(0.25, 0.25, 0.25, 0.25);
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		Pass {
			Name "COC CALCULATION"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 580281
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _Distance;
			float _LensCoeff;
			float _RcpMaxCoC;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_CameraDepthTexture, inp.texcoord.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.y = tmp0.x - _Distance;
                tmp0.x = max(tmp0.x, 0.00001);
                tmp0.y = tmp0.y * _LensCoeff;
                tmp0.x = tmp0.y / tmp0.x;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = tmp0.x * _RcpMaxCoC + 0.5;
                o.sv_target = saturate(tmp0.xxxx);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "COC TEMPORAL FILTER"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 626885
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float3 _TaaParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CoCTex;
			sampler2D _CameraMotionVectorsTexture;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
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
                float4 tmp4;
                float4 tmp5;
                tmp0.xy = _MainTex_TexelSize.yy * float2(-0.0, -1.0);
                tmp1.xy = inp.texcoord.xy - _TaaParams.xy;
                tmp1 = tex2D(_CoCTex, tmp1.xy);
                tmp2 = -_MainTex_TexelSize * float4(1.0, 0.0, 0.0, 1.0) + inp.texcoord.xyxy;
                tmp3 = tex2D(_CoCTex, tmp2.xy);
                tmp2 = tex2D(_CoCTex, tmp2.zw);
                tmp0.w = tmp3.x < tmp1.x;
                tmp4.z = tmp0.w ? tmp3.x : tmp1.x;
                tmp1.y = max(tmp1.x, tmp3.x);
                tmp1.y = max(tmp2.x, tmp1.y);
                tmp1.z = tmp2.x < tmp4.z;
                tmp0.z = tmp2.x;
                tmp2.xy = _MainTex_TexelSize.xy * float2(1.0, 0.0);
                tmp2.zw = -tmp2.xy;
                tmp4.xy = tmp0.ww ? tmp2.zw : 0.0;
                tmp0.xyz = tmp1.zzz ? tmp0.xyz : tmp4.xyz;
                tmp3.xy = _MainTex_TexelSize.yy * float2(0.0, 1.0);
                tmp4 = _MainTex_TexelSize * float4(0.0, 1.0, 1.0, 0.0) + inp.texcoord.xyxy;
                tmp5 = tex2D(_CoCTex, tmp4.xy);
                tmp4 = tex2D(_CoCTex, tmp4.zw);
                tmp0.w = tmp5.x < tmp0.z;
                tmp3.z = tmp5.x;
                tmp1.y = max(tmp1.y, tmp5.x);
                tmp1.y = max(tmp4.x, tmp1.y);
                tmp0.xyz = tmp0.www ? tmp3.xyz : tmp0.xyz;
                tmp0.w = tmp4.x < tmp0.z;
                tmp0.z = min(tmp4.x, tmp0.z);
                tmp0.xy = tmp0.ww ? tmp2.xy : tmp0.xy;
                tmp0.xy = tmp0.xy + inp.texcoord.xy;
                tmp2 = tex2D(_CameraMotionVectorsTexture, tmp0.xy);
                tmp0.xy = inp.texcoord.xy - tmp2.xy;
                tmp2 = tex2D(_MainTex, tmp0.xy);
                tmp0.x = max(tmp0.z, tmp2.x);
                tmp0.x = min(tmp1.y, tmp0.x);
                tmp0.x = tmp0.x - tmp1.x;
                o.sv_target = _TaaParams.zzzz * tmp0.xxxx + tmp1.xxxx;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "DOWNSAMPLE AND PREFILTER"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 691415
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _CoCTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                tmp0 = -_MainTex_TexelSize * float4(0.5, 0.5, -0.5, 0.5) + inp.texcoord.xyxy;
                tmp1 = tex2D(_MainTex, tmp0.zw);
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.w = max(tmp1.z, tmp1.y);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = tmp0.w + 1.0;
                tmp2 = -_MainTex_TexelSize * float4(0.5, 0.5, -0.5, 0.5) + inp.texcoord1.xyxy;
                tmp3 = tex2D(_CoCTex, tmp2.zw);
                tmp2 = tex2D(_CoCTex, tmp2.xy);
                tmp1.w = tmp2.x * 2.0 + -1.0;
                tmp2.x = tmp3.x * 2.0 + -1.0;
                tmp0.w = abs(tmp2.x) / tmp0.w;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.y = max(tmp0.z, tmp0.y);
                tmp2.y = max(tmp0.x, tmp2.y);
                tmp2.y = tmp2.y + 1.0;
                tmp2.y = abs(tmp1.w) / tmp2.y;
                tmp0.xyz = tmp0.xyz * tmp2.yyy + tmp1.xyz;
                tmp0.w = tmp0.w + tmp2.y;
                tmp3 = _MainTex_TexelSize * float4(-0.5, 0.5, 0.5, 0.5) + inp.texcoord.xyxy;
                tmp4 = tex2D(_MainTex, tmp3.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp1.x = max(tmp4.z, tmp4.y);
                tmp1.x = max(tmp1.x, tmp4.x);
                tmp1.x = tmp1.x + 1.0;
                tmp5 = _MainTex_TexelSize * float4(-0.5, 0.5, 0.5, 0.5) + inp.texcoord1.xyxy;
                tmp6 = tex2D(_CoCTex, tmp5.xy);
                tmp5 = tex2D(_CoCTex, tmp5.zw);
                tmp1.y = tmp5.x * 2.0 + -1.0;
                tmp1.z = tmp6.x * 2.0 + -1.0;
                tmp1.x = abs(tmp1.z) / tmp1.x;
                tmp1.z = min(tmp1.y, tmp1.z);
                tmp0.xyz = tmp4.xyz * tmp1.xxx + tmp0.xyz;
                tmp0.w = tmp0.w + tmp1.x;
                tmp1.x = max(tmp3.z, tmp3.y);
                tmp1.x = max(tmp1.x, tmp3.x);
                tmp1.x = tmp1.x + 1.0;
                tmp1.x = abs(tmp1.y) / tmp1.x;
                tmp0.xyz = tmp3.xyz * tmp1.xxx + tmp0.xyz;
                tmp0.w = tmp0.w + tmp1.x;
                tmp0.w = max(tmp0.w, 0.00001);
                tmp0.xyz = tmp0.xyz / tmp0.www;
                tmp0.w = min(tmp1.z, tmp2.x);
                tmp1.x = max(tmp1.z, tmp2.x);
                tmp1.x = max(tmp1.x, tmp1.w);
                tmp0.w = min(tmp0.w, tmp1.w);
                tmp1.y = tmp1.x < -tmp0.w;
                tmp0.w = tmp1.y ? tmp0.w : tmp1.x;
                tmp0.w = tmp0.w * _MaxCoC;
                tmp1.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = saturate(abs(tmp0.w) * tmp1.x);
                o.sv_target.w = tmp0.w;
                tmp0.w = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "BOKEH FILTER (SMALL)"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 753545
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			float _RcpAspect;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[16] = {
                    float4(0.0, 0.0, 0.0, 0.0),
                    float4(0.5454546, 0.0, 0.0, 0.0),
                    float4(0.1685547, 0.5187581, 0.0, 0.0),
                    float4(-0.441282, 0.3206101, 0.0, 0.0),
                    float4(-0.441282, -0.3206102, 0.0, 0.0),
                    float4(0.1685548, -0.5187581, 0.0, 0.0),
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.809017, 0.5877852, 0.0, 0.0),
                    float4(0.309017, 0.9510565, 0.0, 0.0),
                    float4(-0.309017, 0.9510565, 0.0, 0.0),
                    float4(-0.8090171, 0.5877852, 0.0, 0.0),
                    float4(-1.0, 0.0, 0.0, 0.0),
                    float4(-0.8090169, -0.5877854, 0.0, 0.0),
                    float4(-0.3090166, -0.9510566, 0.0, 0.0),
                    float4(0.3090171, -0.9510565, 0.0, 0.0),
                    float4(0.8090169, -0.5877853, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.w = 1.0;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 16; i += 1) {
                    tmp4.yz = _MaxCoC.xx * icb[i + 0].xy;
                    tmp0.z = dot(tmp4.xy, tmp4.xy);
                    tmp0.z = sqrt(tmp0.z);
                    tmp4.x = tmp4.y * _RcpAspect;
                    tmp4.xy = tmp4.xz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp4.xy);
                    tmp5.x = min(tmp0.w, tmp4.w);
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x - tmp0.z;
                    tmp5.x = _MainTex_TexelSize.y * 2.0 + tmp5.x;
                    tmp5.x = saturate(tmp5.x / tmp0.x);
                    tmp0.z = -tmp0.z - tmp4.w;
                    tmp0.z = _MainTex_TexelSize.y * 2.0 + tmp0.z;
                    tmp0.z = saturate(tmp0.z / tmp0.x);
                    tmp4.w = -tmp4.w >= _MainTex_TexelSize.y;
                    tmp4.w = tmp4.w ? 1.0 : 0.0;
                    tmp0.z = tmp0.z * tmp4.w;
                    tmp1.xyz = tmp4.xyz;
                    tmp2 = tmp1 * tmp5.xxxx + tmp2;
                    tmp3 = tmp1 * tmp0.zzzz + tmp3;
                }
                tmp0.x = tmp2.w == 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.xyz = tmp2.xyz / tmp0.xxx;
                tmp0.w = tmp3.w == 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w + tmp3.w;
                tmp1.xyz = tmp3.xyz / tmp0.www;
                tmp0.w = tmp3.w * 0.1963495;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "BOKEH FILTER (MEDIUM)"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 817948
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			float _RcpAspect;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[22] = {
                    float4(0.0, 0.0, 0.0, 0.0),
                    float4(0.5333334, 0.0, 0.0, 0.0),
                    float4(0.3325279, 0.4169768, 0.0, 0.0),
                    float4(-0.1186778, 0.5199616, 0.0, 0.0),
                    float4(-0.4805167, 0.2314047, 0.0, 0.0),
                    float4(-0.4805167, -0.2314047, 0.0, 0.0),
                    float4(-0.1186776, -0.5199617, 0.0, 0.0),
                    float4(0.3325278, -0.4169769, 0.0, 0.0),
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.9009688, 0.4338838, 0.0, 0.0),
                    float4(0.6234898, 0.7818315, 0.0, 0.0),
                    float4(0.222521, 0.9749279, 0.0, 0.0),
                    float4(-0.2225209, 0.9749279, 0.0, 0.0),
                    float4(-0.62349, 0.7818314, 0.0, 0.0),
                    float4(-0.9009688, 0.4338838, 0.0, 0.0),
                    float4(-1.0, 0.0, 0.0, 0.0),
                    float4(-0.9009688, -0.4338838, 0.0, 0.0),
                    float4(-0.6234896, -0.7818316, 0.0, 0.0),
                    float4(-0.2225205, -0.974928, 0.0, 0.0),
                    float4(0.2225215, -0.9749278, 0.0, 0.0),
                    float4(0.6234897, -0.7818316, 0.0, 0.0),
                    float4(0.9009688, -0.4338838, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.w = 1.0;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 22; i += 1) {
                    tmp4.yz = _MaxCoC.xx * icb[i + 0].xy;
                    tmp0.z = dot(tmp4.xy, tmp4.xy);
                    tmp0.z = sqrt(tmp0.z);
                    tmp4.x = tmp4.y * _RcpAspect;
                    tmp4.xy = tmp4.xz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp4.xy);
                    tmp5.x = min(tmp0.w, tmp4.w);
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x - tmp0.z;
                    tmp5.x = _MainTex_TexelSize.y * 2.0 + tmp5.x;
                    tmp5.x = saturate(tmp5.x / tmp0.x);
                    tmp0.z = -tmp0.z - tmp4.w;
                    tmp0.z = _MainTex_TexelSize.y * 2.0 + tmp0.z;
                    tmp0.z = saturate(tmp0.z / tmp0.x);
                    tmp4.w = -tmp4.w >= _MainTex_TexelSize.y;
                    tmp4.w = tmp4.w ? 1.0 : 0.0;
                    tmp0.z = tmp0.z * tmp4.w;
                    tmp1.xyz = tmp4.xyz;
                    tmp2 = tmp1 * tmp5.xxxx + tmp2;
                    tmp3 = tmp1 * tmp0.zzzz + tmp3;
                }
                tmp0.x = tmp2.w == 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.xyz = tmp2.xyz / tmp0.xxx;
                tmp0.w = tmp3.w == 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w + tmp3.w;
                tmp1.xyz = tmp3.xyz / tmp0.www;
                tmp0.w = tmp3.w * 0.1427997;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "BOKEH FILTER (LARGE)"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 916595
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			float _RcpAspect;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[43] = {
                    float4(0.0, 0.0, 0.0, 0.0),
                    float4(0.3636364, 0.0, 0.0, 0.0),
                    float4(0.2267236, 0.2843024, 0.0, 0.0),
                    float4(-0.0809167, 0.3545192, 0.0, 0.0),
                    float4(-0.327625, 0.1577759, 0.0, 0.0),
                    float4(-0.327625, -0.1577759, 0.0, 0.0),
                    float4(-0.0809166, -0.3545193, 0.0, 0.0),
                    float4(0.2267235, -0.2843024, 0.0, 0.0),
                    float4(0.6818182, 0.0, 0.0, 0.0),
                    float4(0.614297, 0.2958298, 0.0, 0.0),
                    float4(0.4251067, 0.5330669, 0.0, 0.0),
                    float4(0.1517189, 0.6647236, 0.0, 0.0),
                    float4(-0.1517188, 0.6647236, 0.0, 0.0),
                    float4(-0.4251068, 0.5330669, 0.0, 0.0),
                    float4(-0.614297, 0.2958299, 0.0, 0.0),
                    float4(-0.6818182, 0.0, 0.0, 0.0),
                    float4(-0.614297, -0.2958298, 0.0, 0.0),
                    float4(-0.4251066, -0.533067, 0.0, 0.0),
                    float4(-0.1517186, -0.6647236, 0.0, 0.0),
                    float4(0.1517192, -0.6647235, 0.0, 0.0),
                    float4(0.4251066, -0.533067, 0.0, 0.0),
                    float4(0.614297, -0.2958298, 0.0, 0.0),
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.9555728, 0.2947552, 0.0, 0.0),
                    float4(0.8262388, 0.5633201, 0.0, 0.0),
                    float4(0.6234898, 0.7818315, 0.0, 0.0),
                    float4(0.365341, 0.9308738, 0.0, 0.0),
                    float4(0.07473, 0.9972038, 0.0, 0.0),
                    float4(-0.2225209, 0.9749279, 0.0, 0.0),
                    float4(-0.5000001, 0.8660254, 0.0, 0.0),
                    float4(-0.733052, 0.6801727, 0.0, 0.0),
                    float4(-0.9009688, 0.4338838, 0.0, 0.0),
                    float4(-0.9888309, 0.1490421, 0.0, 0.0),
                    float4(-0.9888308, -0.1490425, 0.0, 0.0),
                    float4(-0.9009688, -0.4338838, 0.0, 0.0),
                    float4(-0.7330518, -0.6801728, 0.0, 0.0),
                    float4(-0.4999999, -0.8660254, 0.0, 0.0),
                    float4(-0.222521, -0.9749279, 0.0, 0.0),
                    float4(0.0747303, -0.9972038, 0.0, 0.0),
                    float4(0.3653415, -0.9308736, 0.0, 0.0),
                    float4(0.6234897, -0.7818316, 0.0, 0.0),
                    float4(0.8262388, -0.56332, 0.0, 0.0),
                    float4(0.9555729, -0.2947548, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.w = 1.0;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 43; i += 1) {
                    tmp4.yz = _MaxCoC.xx * icb[i + 0].xy;
                    tmp0.z = dot(tmp4.xy, tmp4.xy);
                    tmp0.z = sqrt(tmp0.z);
                    tmp4.x = tmp4.y * _RcpAspect;
                    tmp4.xy = tmp4.xz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp4.xy);
                    tmp5.x = min(tmp0.w, tmp4.w);
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x - tmp0.z;
                    tmp5.x = _MainTex_TexelSize.y * 2.0 + tmp5.x;
                    tmp5.x = saturate(tmp5.x / tmp0.x);
                    tmp0.z = -tmp0.z - tmp4.w;
                    tmp0.z = _MainTex_TexelSize.y * 2.0 + tmp0.z;
                    tmp0.z = saturate(tmp0.z / tmp0.x);
                    tmp4.w = -tmp4.w >= _MainTex_TexelSize.y;
                    tmp4.w = tmp4.w ? 1.0 : 0.0;
                    tmp0.z = tmp0.z * tmp4.w;
                    tmp1.xyz = tmp4.xyz;
                    tmp2 = tmp1 * tmp5.xxxx + tmp2;
                    tmp3 = tmp1 * tmp0.zzzz + tmp3;
                }
                tmp0.x = tmp2.w == 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.xyz = tmp2.xyz / tmp0.xxx;
                tmp0.w = tmp3.w == 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w + tmp3.w;
                tmp1.xyz = tmp3.xyz / tmp0.www;
                tmp0.w = tmp3.w * 0.0730603;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "BOKEH FILTER (VERY LARGE)"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 963103
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _MaxCoC;
			float _RcpAspect;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[71] = {
                    float4(0.0, 0.0, 0.0, 0.0),
                    float4(0.2758621, 0.0, 0.0, 0.0),
                    float4(0.1719972, 0.2156777, 0.0, 0.0),
                    float4(-0.0613851, 0.2689457, 0.0, 0.0),
                    float4(-0.2485432, 0.1196921, 0.0, 0.0),
                    float4(-0.2485432, -0.1196921, 0.0, 0.0),
                    float4(-0.061385, -0.2689457, 0.0, 0.0),
                    float4(0.1719972, -0.2156777, 0.0, 0.0),
                    float4(0.5172414, 0.0, 0.0, 0.0),
                    float4(0.4660183, 0.2244226, 0.0, 0.0),
                    float4(0.3224947, 0.4043956, 0.0, 0.0),
                    float4(0.1150971, 0.5042731, 0.0, 0.0),
                    float4(-0.115097, 0.5042731, 0.0, 0.0),
                    float4(-0.3224948, 0.4043955, 0.0, 0.0),
                    float4(-0.4660183, 0.2244226, 0.0, 0.0),
                    float4(-0.5172414, 0.0, 0.0, 0.0),
                    float4(-0.4660183, -0.2244226, 0.0, 0.0),
                    float4(-0.3224946, -0.4043956, 0.0, 0.0),
                    float4(-0.1150968, -0.5042731, 0.0, 0.0),
                    float4(0.1150973, -0.504273, 0.0, 0.0),
                    float4(0.3224947, -0.4043956, 0.0, 0.0),
                    float4(0.4660183, -0.2244226, 0.0, 0.0),
                    float4(0.7586207, 0.0, 0.0, 0.0),
                    float4(0.7249173, 0.2236074, 0.0, 0.0),
                    float4(0.6268018, 0.4273463, 0.0, 0.0),
                    float4(0.4729922, 0.5931135, 0.0, 0.0),
                    float4(0.2771552, 0.7061801, 0.0, 0.0),
                    float4(0.0566917, 0.7564995, 0.0, 0.0),
                    float4(-0.168809, 0.7396005, 0.0, 0.0),
                    float4(-0.3793104, 0.6569847, 0.0, 0.0),
                    float4(-0.5561084, 0.5159931, 0.0, 0.0),
                    float4(-0.6834936, 0.3291532, 0.0, 0.0),
                    float4(-0.7501475, 0.1130664, 0.0, 0.0),
                    float4(-0.7501475, -0.1130667, 0.0, 0.0),
                    float4(-0.6834936, -0.3291532, 0.0, 0.0),
                    float4(-0.5561083, -0.5159932, 0.0, 0.0),
                    float4(-0.3793103, -0.6569848, 0.0, 0.0),
                    float4(-0.168809, -0.7396005, 0.0, 0.0),
                    float4(0.0566919, -0.7564994, 0.0, 0.0),
                    float4(0.2771556, -0.7061799, 0.0, 0.0),
                    float4(0.4729922, -0.5931137, 0.0, 0.0),
                    float4(0.6268018, -0.4273462, 0.0, 0.0),
                    float4(0.7249174, -0.2236071, 0.0, 0.0),
                    float4(1.0, 0.0, 0.0, 0.0),
                    float4(0.9749279, 0.2225209, 0.0, 0.0),
                    float4(0.9009688, 0.4338838, 0.0, 0.0),
                    float4(0.7818315, 0.6234898, 0.0, 0.0),
                    float4(0.6234898, 0.7818315, 0.0, 0.0),
                    float4(0.4338836, 0.9009689, 0.0, 0.0),
                    float4(0.222521, 0.9749279, 0.0, 0.0),
                    float4(0.0, 1.0, 0.0, 0.0),
                    float4(-0.2225209, 0.9749279, 0.0, 0.0),
                    float4(-0.4338838, 0.9009688, 0.0, 0.0),
                    float4(-0.62349, 0.7818314, 0.0, 0.0),
                    float4(-0.7818317, 0.6234896, 0.0, 0.0),
                    float4(-0.9009688, 0.4338838, 0.0, 0.0),
                    float4(-0.9749279, 0.2225209, 0.0, 0.0),
                    float4(-1.0, 0.0, 0.0, 0.0),
                    float4(-0.9749279, -0.2225209, 0.0, 0.0),
                    float4(-0.9009688, -0.4338838, 0.0, 0.0),
                    float4(-0.7818314, -0.6234899, 0.0, 0.0),
                    float4(-0.6234896, -0.7818316, 0.0, 0.0),
                    float4(-0.4338835, -0.900969, 0.0, 0.0),
                    float4(-0.2225205, -0.974928, 0.0, 0.0),
                    float4(0.0, -1.0, 0.0, 0.0),
                    float4(0.2225215, -0.9749278, 0.0, 0.0),
                    float4(0.4338835, -0.900969, 0.0, 0.0),
                    float4(0.6234897, -0.7818316, 0.0, 0.0),
                    float4(0.7818314, -0.6234899, 0.0, 0.0),
                    float4(0.9009688, -0.4338838, 0.0, 0.0),
                    float4(0.9749279, -0.2225209, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = _MainTex_TexelSize.y + _MainTex_TexelSize.y;
                tmp1.w = 1.0;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 71; i += 1) {
                    tmp4.yz = _MaxCoC.xx * icb[i + 0].xy;
                    tmp0.z = dot(tmp4.xy, tmp4.xy);
                    tmp0.z = sqrt(tmp0.z);
                    tmp4.x = tmp4.y * _RcpAspect;
                    tmp4.xy = tmp4.xz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp4.xy);
                    tmp5.x = min(tmp0.w, tmp4.w);
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x - tmp0.z;
                    tmp5.x = _MainTex_TexelSize.y * 2.0 + tmp5.x;
                    tmp5.x = saturate(tmp5.x / tmp0.x);
                    tmp0.z = -tmp0.z - tmp4.w;
                    tmp0.z = _MainTex_TexelSize.y * 2.0 + tmp0.z;
                    tmp0.z = saturate(tmp0.z / tmp0.x);
                    tmp4.w = -tmp4.w >= _MainTex_TexelSize.y;
                    tmp4.w = tmp4.w ? 1.0 : 0.0;
                    tmp0.z = tmp0.z * tmp4.w;
                    tmp1.xyz = tmp4.xyz;
                    tmp2 = tmp1 * tmp5.xxxx + tmp2;
                    tmp3 = tmp1 * tmp0.zzzz + tmp3;
                }
                tmp0.x = tmp2.w == 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.xyz = tmp2.xyz / tmp0.xxx;
                tmp0.w = tmp3.w == 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w + tmp3.w;
                tmp1.xyz = tmp3.xyz / tmp0.www;
                tmp0.w = tmp3.w * 0.0442478;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "POSTFILTER"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1041638
			CGPROGRAM
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = -_MainTex_TexelSize * float4(0.5, 0.5, -0.5, 0.5) + inp.texcoord.xyxy;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0 = tmp0 + tmp1;
                tmp1 = _MainTex_TexelSize * float4(-0.5, 0.5, 0.5, 0.5) + inp.texcoord.xyxy;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp0 = tmp0 + tmp2;
                tmp0 = tmp1 + tmp0;
                o.sv_target = tmp0 * float4(0.25, 0.25, 0.25, 0.25);
                return o;
			}
			ENDCG
		}
	}
}