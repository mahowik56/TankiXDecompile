Shader "Hidden/SESSAO" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 29793
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 ProjectionMatrixInverse;
			float Radius;
			float Bias;
			float ZThickness;
			float Intensity;
			float SampleDistributionCurve;
			float DrawDistance;
			float DrawDistanceFadeSize;
			int Downsamp;
			int HalfSampling;
			int PreserveDetails;
			int Orthographic;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _CameraDepthNormalsTexture;
			sampler2D _DitherTexture;
			sampler2D _ColorDownsampled;
			
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
                tmp0.x = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.yw = v.texcoord.xy;
                tmp0.z = 1.0;
                o.texcoord = tmp0.yxzz;
                o.texcoord1 = tmp0.ywzz;
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
                float4 tmp7;
                float4 tmp8;
                tmp0 = tex2Dlod(_CameraDepthTexture, float4(inp.texcoord.xy, 0, 0.0));
                tmp0.yz = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp1 = tmp0.zzzz * ProjectionMatrixInverse._m01_m11_m21_m31;
                tmp1 = ProjectionMatrixInverse._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = ProjectionMatrixInverse._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + ProjectionMatrixInverse._m03_m13_m23_m33;
                tmp0 = tmp0.xyzz / tmp0.wwww;
                tmp1.x = tmp0.w < -DrawDistance;
                if (tmp1.x) {
                    o.sv_target = float4(1.0, 1.0, 1.0, 1.0);
                    return o;
                }
                tmp1 = tex2D(_CameraDepthNormalsTexture, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                tmp1.z = dot(tmp1.xyz, tmp1.xyz);
                tmp1.z = 2.0 / tmp1.z;
                tmp2.xy = tmp1.xy * tmp1.zz;
                tmp2.z = tmp1.z - 1.0;
                tmp1.xy = inp.texcoord.xy * _MainTex_TexelSize.zw;
                tmp3.x = float1(int1(PreserveDetails) << 2);
                tmp3.y = float1(int1(PreserveDetails) << 1);
                tmp1.z = floor(tmp3.y);
                tmp1.z = 5.0 - tmp1.z;
                tmp1.w = floor(Downsamp);
                tmp1.z = tmp1.w * tmp1.z + tmp1.z;
                tmp1.xy = tmp1.xy / tmp1.zz;
                tmp1 = tex2Dlod(_DitherTexture, float4(tmp1.xy, 0, 0.0));
                tmp1.xy = tmp3.xy + int2(8, 4);
                tmp1.x = -HalfSampling * tmp1.y + tmp1.x;
                tmp1.y = 0.0001 - tmp0.w;
                tmp1.z = floor(Orthographic);
                tmp2.w = 10.0 - tmp1.y;
                tmp1.y = tmp1.z * tmp2.w + tmp1.y;
                tmp1.y = Radius / tmp1.y;
                tmp1.z = floor(tmp1.x);
                tmp2.w = tmp1.w * 6.0;
                tmp3.x = _ScreenParams.x / _ScreenParams.y;
                tmp3.y = log(tmp1.w);
                tmp3.y = tmp3.y * SampleDistributionCurve;
                tmp3.y = exp(tmp3.y);
                tmp3.z = abs(tmp1.w) * ZThickness;
                tmp3.z = tmp1.y * tmp3.z;
                tmp3.z = tmp3.z * 25.5;
                tmp3.w = Bias + 1.0;
                tmp1.w = 2.0 - tmp1.w;
                tmp4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp5.xy = float2(0.0, 0.0);
                for (int i = tmp5.y; i < tmp1.x; i += 1) {
                    tmp5.z = floor(i);
                    tmp5.z = tmp5.z / tmp1.z;
                    tmp5.z = tmp5.z * 6.283185 + tmp2.w;
                    tmp6.x = sin(tmp5.z);
                    tmp7.x = cos(tmp5.z);
                    tmp8.x = tmp3.x * tmp7.x;
                    tmp8.y = tmp6.x;
                    tmp5.zw = tmp3.yy * tmp8.yx;
                    tmp8.z = tmp7.x;
                    tmp6.xy = tmp8.yz * float2(0.001, 0.001);
                    tmp5.zw = tmp5.zw * tmp1.yy + tmp6.xy;
                    tmp5.zw = tmp5.zw + inp.texcoord.xy;
                    tmp6.xy = saturate(tmp5.zw);
                    tmp7 = tex2Dlod(_CameraDepthTexture, float4(tmp6.xy, 0, 0.0));
                    tmp6.xy = tmp6.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp6.z = tmp7.x * 2.0 + -1.0;
                    tmp7 = tmp6.yyyy * ProjectionMatrixInverse._m01_m11_m21_m31;
                    tmp7 = ProjectionMatrixInverse._m00_m10_m20_m30 * tmp6.xxxx + tmp7;
                    tmp6 = ProjectionMatrixInverse._m02_m12_m22_m32 * tmp6.zzzz + tmp7;
                    tmp6 = tmp6 + ProjectionMatrixInverse._m03_m13_m23_m33;
                    tmp6 = tmp6.xyzz / tmp6.wwww;
                    tmp6 = tmp6 - tmp0;
                    tmp7.x = dot(tmp6.xyz, tmp6.xyz);
                    tmp7.x = rsqrt(tmp7.x);
                    tmp6.xyz = tmp6.xyz * tmp7.xxx;
                    tmp6.x = dot(tmp6.xyz, tmp2.xyz);
                    tmp6.y = abs(tmp6.w) - 0.8;
                    tmp6.y = max(tmp6.y, 0.0);
                    tmp6.y = tmp6.y / tmp3.z;
                    tmp6.y = saturate(1.0 - tmp6.y);
                    tmp5.x = tmp5.x + tmp6.y;
                    tmp7 = tex2Dlod(_ColorDownsampled, float4(tmp5.zw, 0, 0.0));
                    tmp7.xyz = max(tmp7.xyz, float3(0.0, 0.0, 0.0));
                    tmp5.z = Bias < tmp6.x;
                    tmp5.w = saturate(tmp6.x * tmp3.w + -Bias);
                    tmp6.x = tmp6.y * tmp5.w;
                    tmp8.x = tmp6.x * tmp1.w + tmp4.x;
                    tmp6.xyz = tmp6.yyy * tmp7.xyz;
                    tmp8.yzw = tmp6.xyz * tmp5.www + tmp4.yzw;
                    tmp4 = tmp5.zzzz ? tmp8 : tmp4;
                }
                tmp0.x = tmp5.x < 0.01;
                tmp0.x = tmp0.x ? 1.0 : tmp5.x;
                tmp0.y = tmp4.x / tmp0.x;
                tmp0.y = saturate(-tmp0.y * 1.2 + 1.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * Intensity;
                tmp0.y = exp(tmp0.y);
                tmp0.z = DrawDistance / DrawDistanceFadeSize;
                tmp0.w = tmp0.w / DrawDistanceFadeSize;
                tmp0.z = saturate(tmp0.w + tmp0.z);
                tmp0.y = tmp0.y - 1.0;
                o.sv_target.w = tmp0.z * tmp0.y + 1.0;
                tmp0.xyz = tmp4.yzw / tmp0.xxx;
                tmp0.xyz = tmp0.xyz + float3(0.0001, 0.0001, 0.0001);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 98600
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 ProjectionMatrixInverse;
			float Radius;
			float Bias;
			float ZThickness;
			float Intensity;
			float SampleDistributionCurve;
			float DrawDistance;
			float DrawDistanceFadeSize;
			int Downsamp;
			int HalfSampling;
			int PreserveDetails;
			int Orthographic;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _CameraDepthNormalsTexture;
			sampler2D _DitherTexture;
			
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
                tmp0.x = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.yw = v.texcoord.xy;
                tmp0.z = 1.0;
                o.texcoord = tmp0.yxzz;
                o.texcoord1 = tmp0.ywzz;
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
                float4 tmp7;
                tmp0 = tex2Dlod(_CameraDepthTexture, float4(inp.texcoord.xy, 0, 0.0));
                tmp0.yz = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp1 = tmp0.zzzz * ProjectionMatrixInverse._m01_m11_m21_m31;
                tmp1 = ProjectionMatrixInverse._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = ProjectionMatrixInverse._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + ProjectionMatrixInverse._m03_m13_m23_m33;
                tmp0 = tmp0.xyzz / tmp0.wwww;
                tmp1 = tex2D(_CameraDepthNormalsTexture, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                tmp1.z = dot(tmp1.xyz, tmp1.xyz);
                tmp1.z = 2.0 / tmp1.z;
                tmp2.xy = tmp1.xy * tmp1.zz;
                tmp2.z = tmp1.z - 1.0;
                tmp1.xy = inp.texcoord.xy * _MainTex_TexelSize.zw;
                tmp3.x = float1(int1(PreserveDetails) << 2);
                tmp3.y = float1(int1(PreserveDetails) << 1);
                tmp1.z = floor(tmp3.y);
                tmp1.z = 5.0 - tmp1.z;
                tmp1.w = floor(Downsamp);
                tmp1.z = tmp1.w * tmp1.z + tmp1.z;
                tmp1.xy = tmp1.xy / tmp1.zz;
                tmp1 = tex2Dlod(_DitherTexture, float4(tmp1.xy, 0, 0.0));
                tmp1.xy = tmp3.xy + int2(8, 4);
                tmp1.x = -HalfSampling * tmp1.y + tmp1.x;
                tmp1.y = 0.0001 - tmp0.w;
                tmp1.z = floor(Orthographic);
                tmp2.w = 10.0 - tmp1.y;
                tmp1.y = tmp1.z * tmp2.w + tmp1.y;
                tmp1.y = Radius / tmp1.y;
                tmp1.z = floor(tmp1.x);
                tmp2.w = tmp1.w * 6.0;
                tmp3.x = _ScreenParams.x / _ScreenParams.y;
                tmp3.y = log(tmp1.w);
                tmp3.y = tmp3.y * SampleDistributionCurve;
                tmp3.y = exp(tmp3.y);
                tmp3.z = abs(tmp1.w) * ZThickness;
                tmp3.z = tmp1.y * tmp3.z;
                tmp3.z = tmp3.z * 25.5;
                tmp3.w = Bias + 1.0;
                tmp1.w = 2.0 - tmp1.w;
                tmp4.xyz = float3(0.0, 0.0, 0.0);
                for (int i = tmp4.z; i < tmp1.x; i += 1) {
                    tmp4.w = floor(i);
                    tmp4.w = tmp4.w / tmp1.z;
                    tmp4.w = tmp4.w * 194.7787 + tmp2.w;
                    tmp5.x = sin(tmp4.w);
                    tmp6.x = cos(tmp4.w);
                    tmp7.x = tmp3.x * tmp6.x;
                    tmp7.y = tmp5.x;
                    tmp5.xy = tmp3.yy * tmp7.yx;
                    tmp7.z = tmp6.x;
                    tmp5.zw = tmp7.yz * float2(0.001, 0.001);
                    tmp5.xy = tmp5.xy * tmp1.yy + tmp5.zw;
                    tmp5.xy = saturate(tmp5.xy + inp.texcoord.xy);
                    tmp6 = tex2Dlod(_CameraDepthTexture, float4(tmp5.xy, 0, 0.0));
                    tmp5.xy = tmp5.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp4.w = tmp6.x * 2.0 + -1.0;
                    tmp6 = tmp5.yyyy * ProjectionMatrixInverse._m01_m11_m21_m31;
                    tmp5 = ProjectionMatrixInverse._m00_m10_m20_m30 * tmp5.xxxx + tmp6;
                    tmp5 = ProjectionMatrixInverse._m02_m12_m22_m32 * tmp4.wwww + tmp5;
                    tmp5 = tmp5 + ProjectionMatrixInverse._m03_m13_m23_m33;
                    tmp5 = tmp5.xyzz / tmp5.wwww;
                    tmp5 = tmp5 - tmp0;
                    tmp4.w = dot(tmp5.xyz, tmp5.xyz);
                    tmp4.w = rsqrt(tmp4.w);
                    tmp5.xyz = tmp4.www * tmp5.xyz;
                    tmp4.w = dot(tmp5.xyz, tmp2.xyz);
                    tmp5.x = abs(tmp5.w) - 0.8;
                    tmp5.x = max(tmp5.x, 0.0);
                    tmp5.x = tmp5.x / tmp3.z;
                    tmp5.x = saturate(1.0 - tmp5.x);
                    tmp4.y = tmp4.y + tmp5.x;
                    tmp5.y = Bias < tmp4.w;
                    tmp4.w = saturate(tmp4.w * tmp3.w + -Bias);
                    tmp4.w = tmp5.x * tmp4.w;
                    tmp4.w = tmp4.w * tmp1.w + tmp4.x;
                    tmp4.x = tmp5.y ? tmp4.w : tmp4.x;
                }
                tmp0.x = tmp4.y < 0.01;
                tmp0.x = tmp0.x ? 1.0 : tmp4.y;
                tmp0.x = tmp4.x / tmp0.x;
                tmp0.x = saturate(-tmp0.x * 1.2 + 1.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * Intensity;
                tmp0.x = exp(tmp0.x);
                tmp0.y = DrawDistance / DrawDistanceFadeSize;
                tmp0.z = tmp0.w / DrawDistanceFadeSize;
                tmp0.y = saturate(tmp0.z + tmp0.y);
                tmp0.x = tmp0.x - 1.0;
                o.sv_target.w = tmp0.y * tmp0.x + 1.0;
                o.sv_target.xyz = float3(0.5773503, 0.5773503, 0.5773503);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 152817
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float2 Kernel;
			float DepthTolerance;
			int PreserveDetails;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _CameraDepthNormalsTexture;
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
                tmp0.x = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.yw = v.texcoord.xy;
                tmp0.z = 1.0;
                o.texcoord = tmp0.yxzz;
                o.texcoord1 = tmp0.ywzz;
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
                tmp0 = tex2D(_CameraDepthTexture, inp.texcoord.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp1 = tex2D(_CameraDepthNormalsTexture, inp.texcoord.xy);
                tmp0.yzw = tmp1.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = 2.0 / tmp0.w;
                tmp1.xy = tmp0.yz * tmp0.ww;
                tmp1.z = tmp0.w - 1.0;
                tmp0.y = dot(tmp1.xy, tmp1.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y * 2.0 + 1.0;
                tmp0.y = tmp0.y * DepthTolerance;
                tmp0.z = float1(int1(PreserveDetails) << 1);
                tmp0.z = 5 - tmp0.z;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.w = 0.0;
                tmp1.w = 0.0;
                while (true) {
                    tmp3.x = i >= tmp0.z;
                    if (tmp3.x) {
                        break;
                    }
                    tmp3.x = i + PreserveDetails;
                    tmp3.x = tmp3.x - 2;
                    tmp3.x = floor(tmp3.x);
                    tmp3.xy = tmp3.xx * Kernel;
                    tmp3.xy = tmp3.xy * _MainTex_TexelSize.xy + inp.texcoord.xy;
                    tmp4 = tex2Dlod(_CameraDepthTexture, float4(tmp3.xy, 0, 0.0));
                    tmp3.z = _ZBufferParams.z * tmp4.x + _ZBufferParams.w;
                    tmp3.z = 1.0 / tmp3.z;
                    tmp4 = tex2Dlod(_CameraDepthNormalsTexture, float4(tmp3.xy, 0, 0.0));
                    tmp4.xyz = tmp4.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                    tmp3.w = dot(tmp4.xyz, tmp4.xyz);
                    tmp3.w = 2.0 / tmp3.w;
                    tmp4.xy = tmp4.xy * tmp3.ww;
                    tmp4.z = tmp3.w - 1.0;
                    tmp3.z = tmp0.x - tmp3.z;
                    tmp3.z = abs(tmp3.z) / tmp0.y;
                    tmp3.z = saturate(1.0 - tmp3.z);
                    tmp3.w = dot(tmp4.xyz, tmp1.xyz);
                    tmp3.w = saturate(tmp3.w * 5.0 + -4.0);
                    tmp4.x = tmp3.w * tmp3.z;
                    tmp5 = tex2Dlod(_MainTex, float4(tmp3.xy, 0, 0.0));
                    tmp2 = tmp5 * tmp4.xxxx + tmp2;
                    tmp0.w = tmp3.z * tmp3.w + tmp0.w;
                    tmp1.w = tmp1.w + 1;
                }
                o.sv_target = tmp2 / tmp0.wwww;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 224490
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float ColorBleedAmount;
			float SelfBleedReduction;
			float BrightnessThreshold;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _SSAO;
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
                tmp0.x = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.yw = v.texcoord.xy;
                tmp0.z = 1.0;
                o.texcoord = tmp0.yxzz;
                o.texcoord1 = tmp0.ywzz;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp0.w);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = saturate(tmp0.w * BrightnessThreshold);
                tmp2 = tex2D(_SSAO, inp.texcoord.xy);
                tmp2 = max(tmp2, float4(0.0, 0.0, 0.0, 0.0));
                tmp1.xyz = tmp0.xyz * tmp1.xxx + -tmp2.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x * 3.0;
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = tmp1.x - 1.0;
                tmp1.x = SelfBleedReduction * tmp1.x + 1.0;
                tmp1.yzw = tmp2.xyz - float3(0.5773503, 0.5773503, 0.5773503);
                tmp1.xyz = tmp1.xxx * tmp1.yzw + float3(0.5773503, 0.5773503, 0.5773503);
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp1.w = 1.0 - tmp2.w;
                tmp0.w = tmp0.w * tmp1.w + tmp2.w;
                tmp1.w = saturate(tmp0.w * 2.0 + -1.0);
                tmp2.xyz = tmp1.www * tmp2.xyz + tmp1.xyz;
                tmp1.w = tmp0.w + tmp0.w;
                tmp1.w = saturate(tmp1.w);
                tmp1.xyz = tmp1.xyz * tmp1.www;
                tmp1.w = tmp0.w > 0.5;
                tmp1.xyz = tmp1.www ? tmp2.xyz : tmp1.xyz;
                tmp1.xyz = tmp1.xyz - tmp0.www;
                tmp1.xyz = ColorBleedAmount.xxx * tmp1.xyz + tmp0.www;
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 294534
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
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
                tmp0.x = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.yw = v.texcoord.xy;
                tmp0.z = 1.0;
                o.texcoord = tmp0.yxzz;
                o.texcoord1 = tmp0.ywzz;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_CameraDepthTexture, inp.texcoord.xy);
                o.sv_target.xyz = tmp0.xxx;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 343761
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float ColorBleedAmount;
			float SelfBleedReduction;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _SSAO;
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
                tmp0.x = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.yw = v.texcoord.xy;
                tmp0.z = 1.0;
                o.texcoord = tmp0.yxzz;
                o.texcoord1 = tmp0.ywzz;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1 = tex2D(_SSAO, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 3.0;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = SelfBleedReduction * tmp0.x + 1.0;
                tmp0.yzw = tmp1.xyz - float3(0.5773503, 0.5773503, 0.5773503);
                tmp0.xyz = tmp0.xxx * tmp0.yzw + float3(0.5773503, 0.5773503, 0.5773503);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.w = saturate(tmp1.w * 2.0 + -1.0);
                tmp1.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                tmp0.w = tmp1.w + tmp1.w;
                tmp0.w = saturate(tmp0.w);
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.w = tmp1.w > 0.5;
                tmp0.xyz = tmp0.www ? tmp1.xyz : tmp0.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.www;
                o.sv_target.xyz = ColorBleedAmount.xxx * tmp0.xyz + tmp1.www;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZWrite Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 426173
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 ProjectionMatrixInverse;
			float2 Kernel;
			float DepthTolerance;
			int PreserveDetails;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _CameraDepthNormalsTexture;
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
                tmp0.x = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.yw = v.texcoord.xy;
                tmp0.z = 1.0;
                o.texcoord = tmp0.yxzz;
                o.texcoord1 = tmp0.ywzz;
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
                tmp0 = tex2D(_CameraDepthTexture, inp.texcoord.xy);
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = ProjectionMatrixInverse._m22 * tmp0.x + ProjectionMatrixInverse._m23;
                tmp1 = tex2D(_CameraDepthNormalsTexture, inp.texcoord.xy);
                tmp0.yzw = tmp1.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = 2.0 / tmp0.w;
                tmp1.xy = tmp0.yz * tmp0.ww;
                tmp1.z = tmp0.w - 1.0;
                tmp0.y = dot(tmp1.xy, tmp1.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y * 2.0 + 1.0;
                tmp0.y = tmp0.y * DepthTolerance;
                tmp0.z = float1(int1(PreserveDetails) << 1);
                tmp0.z = 5 - tmp0.z;
                tmp2 = float4(0.0, 0.0, 0.0, 0.0);
                tmp3 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.w = 0.0;
                tmp1.w = 0.0;
                for (int i = tmp1.w; i < tmp0.z; i += 1) {
                    tmp4.x = i + PreserveDetails;
                    tmp4.x = tmp4.x - 2;
                    tmp4.x = floor(tmp4.x);
                    tmp4.xy = tmp4.xx * Kernel;
                    tmp4.xy = tmp4.xy * _MainTex_TexelSize.xy + inp.texcoord.xy;
                    tmp5 = tex2Dlod(_CameraDepthTexture, float4(tmp4.xy, 0, 0.0));
                    tmp4.z = tmp5.x * 2.0 + -1.0;
                    tmp4.z = ProjectionMatrixInverse._m22 * tmp4.z + ProjectionMatrixInverse._m23;
                    tmp5 = tex2Dlod(_CameraDepthNormalsTexture, float4(tmp4.xy, 0, 0.0));
                    tmp5.xyz = tmp5.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                    tmp4.w = dot(tmp5.xyz, tmp5.xyz);
                    tmp4.w = 2.0 / tmp4.w;
                    tmp5.xy = tmp5.xy * tmp4.ww;
                    tmp5.z = tmp4.w - 1.0;
                    tmp4.z = tmp4.z - tmp0.x;
                    tmp4.z = abs(tmp4.z) / tmp0.y;
                    tmp4.z = saturate(1.0 - tmp4.z);
                    tmp4.w = dot(tmp5.xyz, tmp1.xyz);
                    tmp4.w = saturate(tmp4.w * 5.0 + -4.0);
                    tmp5.x = tmp4.w * tmp4.z;
                    tmp6 = tex2Dlod(_MainTex, float4(tmp4.xy, 0, 0.0));
                    tmp3 = tmp3 + tmp6;
                    tmp2 = tmp6 * tmp5.xxxx + tmp2;
                    tmp0.w = tmp4.z * tmp4.w + tmp0.w;
                }
                tmp1 = tmp3 * float4(0.2, 0.2, 0.2, 0.2);
                tmp2 = tmp2 / tmp0.wwww;
                tmp0.x = tmp0.w < 1.1;
                o.sv_target = tmp0.xxxx ? tmp1 : tmp2;
                return o;
			}
			ENDCG
		}
	}
}