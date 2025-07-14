Shader "Hidden/Post FX/Ambient Occlusion" {
	Properties {
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11949
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _CameraDepthTexture_ST;
			int _SampleCount;
			float _Intensity;
			float _Radius;
			float _Downsample;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthNormalsTexture;
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
                tmp0.w = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.xyz = v.texcoord.xyx;
                o.texcoord1 = tmp0;
                o.texcoord2.xy = tmp0.zw;
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
                tmp0.xy = inp.texcoord.xy * _CameraDepthTexture_ST.xy + _CameraDepthTexture_ST.zw;
                tmp1 = tex2D(_CameraDepthNormalsTexture, tmp0.xy);
                tmp1.xyz = tmp1.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = 2.0 / tmp0.z;
                tmp1.yz = tmp1.xy * tmp0.zz;
                tmp1.w = tmp0.z - 1.0;
                tmp2.xyz = tmp1.yzw * float3(1.0, 1.0, -1.0);
                tmp3 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.z = 1.0 - unity_OrthoParams.w;
                tmp0.w = tmp3.x * _ZBufferParams.x;
                tmp1.x = -unity_OrthoParams.w * tmp0.w + 1.0;
                tmp0.w = tmp0.z * tmp0.w + _ZBufferParams.y;
                tmp0.w = tmp1.x / tmp0.w;
                tmp3.xy = tmp0.xy < float2(0.0, 0.0);
                tmp1.x = uint1(tmp3.y) | uint1(tmp3.x);
                tmp1.x = uint1(tmp1.x) & uint1(0.0);
                tmp0.xy = tmp0.xy > float2(1.0, 1.0);
                tmp0.x = uint1(tmp0.y) | uint1(tmp0.x);
                tmp0.x = tmp0.x ? 0.0 : 0.0;
                tmp0.x = tmp0.x + tmp1.x;
                tmp0.x = floor(tmp0.x);
                tmp0.y = tmp0.w <= 0.00001;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.x * 100000000.0;
                tmp3.z = tmp0.w * _ProjectionParams.z + tmp0.x;
                tmp0.xy = inp.texcoord1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy - unity_CameraProjection._m02_m12;
                tmp4.x = unity_CameraProjection._m00;
                tmp4.y = unity_CameraProjection._m11;
                tmp0.xy = tmp0.xy / tmp4.xy;
                tmp0.w = 1.0 - tmp3.z;
                tmp0.w = unity_OrthoParams.w * tmp0.w + tmp3.z;
                tmp3.xy = tmp0.ww * tmp0.xy;
                tmp0.xy = inp.texcoord.xy * _Downsample.xx;
                tmp0.xy = tmp0.xy * _ScreenParams.xy;
                tmp0.xy = floor(tmp0.xy);
                tmp0.x = dot(float2(0.0671106, 0.0058372), tmp0.xy);
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.y = floor(_SampleCount);
                tmp5.x = 12.9898;
                tmp0.w = 0.0;
                tmp1.x = 0.0;
                for (int i = tmp1.x; i < _SampleCount; i += 1) {
                    tmp2.w = floor(i);
                    tmp2.w = tmp2.w * 1.0001;
                    tmp5.y = floor(tmp2.w);
                    tmp2.w = tmp5.y * 78.233;
                    tmp2.w = sin(tmp2.w);
                    tmp2.w = tmp2.w * 43758.55;
                    tmp2.w = frac(tmp2.w);
                    tmp2.w = tmp0.x + tmp2.w;
                    tmp2.w = frac(tmp2.w);
                    tmp6.z = tmp2.w * 2.0 + -1.0;
                    tmp2.w = dot(tmp5.xy, float2(1.0, 78.233));
                    tmp2.w = sin(tmp2.w);
                    tmp2.w = tmp2.w * 43758.55;
                    tmp2.w = frac(tmp2.w);
                    tmp2.w = tmp0.x + tmp2.w;
                    tmp2.w = tmp2.w * 6.283185;
                    tmp7.x = sin(tmp2.w);
                    tmp8.x = cos(tmp2.w);
                    tmp2.w = -tmp6.z * tmp6.z + 1.0;
                    tmp2.w = sqrt(tmp2.w);
                    tmp8.y = tmp7.x;
                    tmp6.xy = tmp2.ww * tmp8.xy;
                    tmp2.w = tmp5.y + 1.0;
                    tmp2.w = tmp2.w / tmp0.y;
                    tmp2.w = sqrt(tmp2.w);
                    tmp2.w = tmp2.w * _Radius;
                    tmp5.yzw = tmp2.www * tmp6.xyz;
                    tmp2.w = dot(-tmp2.xyz, tmp5.xyz);
                    tmp2.w = tmp2.w >= 0.0;
                    tmp5.yzw = tmp2.www ? -tmp5.yzw : tmp5.yzw;
                    tmp5.yzw = tmp3.xyz + tmp5.yzw;
                    tmp4.zw = tmp5.zz * unity_CameraProjection._m01_m11;
                    tmp4.zw = unity_CameraProjection._m00_m10 * tmp5.yy + tmp4.zw;
                    tmp4.zw = unity_CameraProjection._m02_m12 * tmp5.ww + tmp4.zw;
                    tmp2.w = 1.0 - tmp5.w;
                    tmp2.w = unity_OrthoParams.w * tmp2.w + tmp5.w;
                    tmp4.zw = tmp4.zw / tmp2.ww;
                    tmp4.zw = tmp4.zw + float2(1.0, 1.0);
                    tmp5.yz = tmp4.zw * _CameraDepthTexture_ST.xy;
                    tmp5.yz = tmp5.yz * float2(0.5, 0.5) + _CameraDepthTexture_ST.zw;
                    tmp6 = tex2D(_CameraDepthTexture, tmp5.yz);
                    tmp2.w = tmp6.x * _ZBufferParams.x;
                    tmp3.w = -unity_OrthoParams.w * tmp2.w + 1.0;
                    tmp2.w = tmp0.z * tmp2.w + _ZBufferParams.y;
                    tmp2.w = tmp3.w / tmp2.w;
                    tmp6.xy = tmp5.yz < float2(0.0, 0.0);
                    tmp3.w = uint1(tmp6.y) | uint1(tmp6.x);
                    tmp3.w = uint1(tmp3.w) & uint1(0.0);
                    tmp5.yz = tmp5.yz > float2(1.0, 1.0);
                    tmp5.y = uint1(tmp5.z) | uint1(tmp5.y);
                    tmp5.y = tmp5.y ? 0.0 : 0.0;
                    tmp3.w = tmp3.w + tmp5.y;
                    tmp3.w = floor(tmp3.w);
                    tmp5.y = tmp2.w <= 0.00001;
                    tmp5.y = tmp5.y ? 1.0 : 0.0;
                    tmp3.w = tmp3.w + tmp5.y;
                    tmp3.w = tmp3.w * 100000000.0;
                    tmp6.z = tmp2.w * _ProjectionParams.z + tmp3.w;
                    tmp4.zw = tmp4.zw - unity_CameraProjection._m02_m12;
                    tmp4.zw = tmp4.zw - float2(1.0, 1.0);
                    tmp4.zw = tmp4.zw / tmp4.xy;
                    tmp2.w = 1.0 - tmp6.z;
                    tmp2.w = unity_OrthoParams.w * tmp2.w + tmp6.z;
                    tmp6.xy = tmp2.ww * tmp4.zw;
                    tmp5.yzw = tmp6.xyz - tmp3.xyz;
                    tmp2.w = dot(tmp5.xyz, tmp2.xyz);
                    tmp2.w = -tmp3.z * 0.002 + tmp2.w;
                    tmp2.w = max(tmp2.w, 0.0);
                    tmp3.w = dot(tmp5.xyz, tmp5.xyz);
                    tmp3.w = tmp3.w + 0.0001;
                    tmp2.w = tmp2.w / tmp3.w;
                    tmp0.w = tmp0.w + tmp2.w;
                }
                tmp0.x = tmp0.w * _Radius;
                tmp0.x = tmp0.x * _Intensity;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 0.6;
                o.sv_target.x = exp(tmp0.x);
                o.sv_target.yzw = tmp1.yzw * float3(0.5, 0.5, -0.5) + float3(0.5, 0.5, 0.5);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 121697
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _CameraDepthTexture_ST;
			int _SampleCount;
			float _Intensity;
			float _Radius;
			float _Downsample;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthNormalsTexture;
			
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
                tmp0.w = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.xyz = v.texcoord.xyx;
                o.texcoord1 = tmp0;
                o.texcoord2.xy = tmp0.zw;
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
                tmp0.xy = inp.texcoord.xy * _CameraDepthTexture_ST.xy + _CameraDepthTexture_ST.zw;
                tmp1 = tex2D(_CameraDepthNormalsTexture, tmp0.xy);
                tmp2.xyz = tmp1.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = 2.0 / tmp0.z;
                tmp2.yz = tmp2.xy * tmp0.zz;
                tmp2.w = tmp0.z - 1.0;
                tmp3.xyz = tmp2.yzw * float3(1.0, 1.0, -1.0);
                tmp0.z = dot(tmp1.xy, float2(1.0, 0.0039216));
                tmp1.xy = tmp0.xy < float2(0.0, 0.0);
                tmp0.w = uint1(tmp1.y) | uint1(tmp1.x);
                tmp0.xy = tmp0.xy > float2(1.0, 1.0);
                tmp0.x = uint1(tmp0.y) | uint1(tmp0.x);
                tmp0.xw = uint2(tmp0.xw) & uint2(float2(0.0, 0.0));
                tmp0.x = tmp0.x + tmp0.w;
                tmp0.x = floor(tmp0.x);
                tmp0.y = tmp0.z <= 0.00001;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.x * 100000000.0;
                tmp0.x = tmp0.z * _ProjectionParams.z + tmp0.x;
                tmp0.z = -_ProjectionParams.z * 0.0000153 + tmp0.x;
                tmp1.xy = inp.texcoord1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy - unity_CameraProjection._m02_m12;
                tmp4.x = unity_CameraProjection._m00;
                tmp4.y = unity_CameraProjection._m11;
                tmp1.xy = tmp1.xy / tmp4.xy;
                tmp0.w = 1.0 - tmp0.z;
                tmp0.w = unity_OrthoParams.w * tmp0.w + tmp0.z;
                tmp0.xy = tmp0.ww * tmp1.xy;
                tmp1.xy = inp.texcoord.xy * _Downsample.xx;
                tmp1.xy = tmp1.xy * _ScreenParams.xy;
                tmp1.xy = floor(tmp1.xy);
                tmp0.w = dot(float2(0.0671106, 0.0058372), tmp1.xy);
                tmp0.w = frac(tmp0.w);
                tmp0.w = tmp0.w * 52.98292;
                tmp0.w = frac(tmp0.w);
                tmp1.x = floor(_SampleCount);
                tmp5.x = 12.9898;
                tmp1.yz = float2(0.0, 0.0);
                for (int i = tmp1.z; i < _SampleCount; i += 1) {
                    tmp1.w = floor(i);
                    tmp1.w = tmp1.w * 1.0001;
                    tmp5.y = floor(tmp1.w);
                    tmp1.w = tmp5.y * 78.233;
                    tmp1.w = sin(tmp1.w);
                    tmp1.w = tmp1.w * 43758.55;
                    tmp1.w = frac(tmp1.w);
                    tmp1.w = tmp0.w + tmp1.w;
                    tmp1.w = frac(tmp1.w);
                    tmp6.z = tmp1.w * 2.0 + -1.0;
                    tmp1.w = dot(tmp5.xy, float2(1.0, 78.233));
                    tmp1.w = sin(tmp1.w);
                    tmp1.w = tmp1.w * 43758.55;
                    tmp1.w = frac(tmp1.w);
                    tmp1.w = tmp0.w + tmp1.w;
                    tmp1.w = tmp1.w * 6.283185;
                    tmp2.x = sin(tmp1.w);
                    tmp7.x = cos(tmp1.w);
                    tmp1.w = -tmp6.z * tmp6.z + 1.0;
                    tmp1.w = sqrt(tmp1.w);
                    tmp7.y = tmp2.x;
                    tmp6.xy = tmp1.ww * tmp7.xy;
                    tmp1.w = tmp5.y + 1.0;
                    tmp1.w = tmp1.w / tmp1.x;
                    tmp1.w = sqrt(tmp1.w);
                    tmp1.w = tmp1.w * _Radius;
                    tmp5.yzw = tmp1.www * tmp6.xyz;
                    tmp1.w = dot(-tmp3.xyz, tmp5.xyz);
                    tmp1.w = tmp1.w >= 0.0;
                    tmp5.yzw = tmp1.www ? -tmp5.yzw : tmp5.yzw;
                    tmp5.yzw = tmp0.xyz + tmp5.yzw;
                    tmp4.zw = tmp5.zz * unity_CameraProjection._m01_m11;
                    tmp4.zw = unity_CameraProjection._m00_m10 * tmp5.yy + tmp4.zw;
                    tmp4.zw = unity_CameraProjection._m02_m12 * tmp5.ww + tmp4.zw;
                    tmp1.w = 1.0 - tmp5.w;
                    tmp1.w = unity_OrthoParams.w * tmp1.w + tmp5.w;
                    tmp4.zw = tmp4.zw / tmp1.ww;
                    tmp4.zw = tmp4.zw + float2(1.0, 1.0);
                    tmp5.yz = tmp4.zw * float2(0.5, 0.5);
                    tmp5.yz = tmp5.yz * _CameraDepthTexture_ST.xy + _CameraDepthTexture_ST.zw;
                    tmp6 = tex2D(_CameraDepthNormalsTexture, tmp5.yz);
                    tmp1.w = dot(tmp6.xy, float2(1.0, 0.0039216));
                    tmp6.xy = tmp5.yz < float2(0.0, 0.0);
                    tmp2.x = uint1(tmp6.y) | uint1(tmp6.x);
                    tmp2.x = uint1(tmp2.x) & uint1(0.0);
                    tmp5.yz = tmp5.yz > float2(1.0, 1.0);
                    tmp3.w = uint1(tmp5.z) | uint1(tmp5.y);
                    tmp3.w = uint1(tmp3.w) & uint1(0.0);
                    tmp2.x = tmp2.x + tmp3.w;
                    tmp2.x = floor(tmp2.x);
                    tmp3.w = tmp1.w <= 0.00001;
                    tmp3.w = tmp3.w ? 1.0 : 0.0;
                    tmp2.x = tmp2.x + tmp3.w;
                    tmp2.x = tmp2.x * 100000000.0;
                    tmp6.z = tmp1.w * _ProjectionParams.z + tmp2.x;
                    tmp4.zw = tmp4.zw - unity_CameraProjection._m02_m12;
                    tmp4.zw = tmp4.zw - float2(1.0, 1.0);
                    tmp4.zw = tmp4.zw / tmp4.xy;
                    tmp1.w = 1.0 - tmp6.z;
                    tmp1.w = unity_OrthoParams.w * tmp1.w + tmp6.z;
                    tmp6.xy = tmp1.ww * tmp4.zw;
                    tmp5.yzw = tmp6.xyz - tmp0.xyz;
                    tmp1.w = dot(tmp5.xyz, tmp3.xyz);
                    tmp1.w = -tmp0.z * 0.002 + tmp1.w;
                    tmp1.w = max(tmp1.w, 0.0);
                    tmp2.x = dot(tmp5.xyz, tmp5.xyz);
                    tmp2.x = tmp2.x + 0.0001;
                    tmp1.w = tmp1.w / tmp2.x;
                    tmp1.y = tmp1.w + tmp1.y;
                }
                tmp0.x = tmp1.y * _Radius;
                tmp0.x = tmp0.x * _Intensity;
                tmp0.x = tmp0.x / tmp1.x;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 0.6;
                o.sv_target.x = exp(tmp0.x);
                o.sv_target.yzw = tmp2.yzw * float3(0.5, 0.5, -0.5) + float3(0.5, 0.5, 0.5);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 131469
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _CameraDepthTexture_ST;
			int _SampleCount;
			float _Intensity;
			float _Radius;
			float _Downsample;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraGBufferTexture2;
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
                tmp0.w = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.xyz = v.texcoord.xyx;
                o.texcoord1 = tmp0;
                o.texcoord2.xy = tmp0.zw;
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
                tmp0.xy = inp.texcoord.xy * _CameraDepthTexture_ST.xy + _CameraDepthTexture_ST.zw;
                tmp1 = tex2D(_CameraGBufferTexture2, tmp0.xy);
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = tmp0.z != 0.0;
                tmp0.z = tmp0.z ? -1.0 : -0.0;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + tmp0.zzz;
                tmp2.xyz = tmp1.yyy * unity_WorldToCamera._m01_m11_m21;
                tmp1.xyw = unity_WorldToCamera._m00_m10_m20 * tmp1.xxx + tmp2.xyz;
                tmp1.xyz = unity_WorldToCamera._m02_m12_m22 * tmp1.zzz + tmp1.xyw;
                tmp2 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.z = 1.0 - unity_OrthoParams.w;
                tmp0.w = tmp2.x * _ZBufferParams.x;
                tmp1.w = -unity_OrthoParams.w * tmp0.w + 1.0;
                tmp0.w = tmp0.z * tmp0.w + _ZBufferParams.y;
                tmp0.w = tmp1.w / tmp0.w;
                tmp2.xy = tmp0.xy < float2(0.0, 0.0);
                tmp1.w = uint1(tmp2.y) | uint1(tmp2.x);
                tmp1.w = uint1(tmp1.w) & uint1(0.0);
                tmp0.xy = tmp0.xy > float2(1.0, 1.0);
                tmp0.x = uint1(tmp0.y) | uint1(tmp0.x);
                tmp0.x = tmp0.x ? 0.0 : 0.0;
                tmp0.x = tmp0.x + tmp1.w;
                tmp0.x = floor(tmp0.x);
                tmp0.y = tmp0.w <= 0.00001;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.x * 100000000.0;
                tmp2.z = tmp0.w * _ProjectionParams.z + tmp0.x;
                tmp0.xy = inp.texcoord1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy - unity_CameraProjection._m02_m12;
                tmp3.x = unity_CameraProjection._m00;
                tmp3.y = unity_CameraProjection._m11;
                tmp0.xy = tmp0.xy / tmp3.xy;
                tmp0.w = 1.0 - tmp2.z;
                tmp0.w = unity_OrthoParams.w * tmp0.w + tmp2.z;
                tmp2.xy = tmp0.ww * tmp0.xy;
                tmp0.xy = inp.texcoord.xy * _Downsample.xx;
                tmp0.xy = tmp0.xy * _ScreenParams.xy;
                tmp0.xy = floor(tmp0.xy);
                tmp0.x = dot(float2(0.0671106, 0.0058372), tmp0.xy);
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.y = floor(_SampleCount);
                tmp4.x = 12.9898;
                tmp0.w = 0.0;
                tmp1.w = 0.0;
                for (int i = tmp1.w; i < _SampleCount; i += 1) {
                    tmp2.w = floor(i);
                    tmp2.w = tmp2.w * 1.0001;
                    tmp4.y = floor(tmp2.w);
                    tmp2.w = tmp4.y * 78.233;
                    tmp2.w = sin(tmp2.w);
                    tmp2.w = tmp2.w * 43758.55;
                    tmp2.w = frac(tmp2.w);
                    tmp2.w = tmp0.x + tmp2.w;
                    tmp2.w = frac(tmp2.w);
                    tmp5.z = tmp2.w * 2.0 + -1.0;
                    tmp2.w = dot(tmp4.xy, float2(1.0, 78.233));
                    tmp2.w = sin(tmp2.w);
                    tmp2.w = tmp2.w * 43758.55;
                    tmp2.w = frac(tmp2.w);
                    tmp2.w = tmp0.x + tmp2.w;
                    tmp2.w = tmp2.w * 6.283185;
                    tmp6.x = sin(tmp2.w);
                    tmp7.x = cos(tmp2.w);
                    tmp2.w = -tmp5.z * tmp5.z + 1.0;
                    tmp2.w = sqrt(tmp2.w);
                    tmp7.y = tmp6.x;
                    tmp5.xy = tmp2.ww * tmp7.xy;
                    tmp2.w = tmp4.y + 1.0;
                    tmp2.w = tmp2.w / tmp0.y;
                    tmp2.w = sqrt(tmp2.w);
                    tmp2.w = tmp2.w * _Radius;
                    tmp4.yzw = tmp2.www * tmp5.xyz;
                    tmp2.w = dot(-tmp1.xyz, tmp4.xyz);
                    tmp2.w = tmp2.w >= 0.0;
                    tmp4.yzw = tmp2.www ? -tmp4.yzw : tmp4.yzw;
                    tmp4.yzw = tmp2.xyz + tmp4.yzw;
                    tmp3.zw = tmp4.zz * unity_CameraProjection._m01_m11;
                    tmp3.zw = unity_CameraProjection._m00_m10 * tmp4.yy + tmp3.zw;
                    tmp3.zw = unity_CameraProjection._m02_m12 * tmp4.ww + tmp3.zw;
                    tmp2.w = 1.0 - tmp4.w;
                    tmp2.w = unity_OrthoParams.w * tmp2.w + tmp4.w;
                    tmp3.zw = tmp3.zw / tmp2.ww;
                    tmp3.zw = tmp3.zw + float2(1.0, 1.0);
                    tmp4.yz = tmp3.zw * float2(0.5, 0.5);
                    tmp4.yz = tmp4.yz * _CameraDepthTexture_ST.xy + _CameraDepthTexture_ST.zw;
                    tmp5 = tex2D(_CameraDepthTexture, tmp4.yz);
                    tmp2.w = tmp5.x * _ZBufferParams.x;
                    tmp4.w = -unity_OrthoParams.w * tmp2.w + 1.0;
                    tmp2.w = tmp0.z * tmp2.w + _ZBufferParams.y;
                    tmp2.w = tmp4.w / tmp2.w;
                    tmp5.xy = tmp4.yz < float2(0.0, 0.0);
                    tmp4.w = uint1(tmp5.y) | uint1(tmp5.x);
                    tmp4.yz = tmp4.yz > float2(1.0, 1.0);
                    tmp4.y = uint1(tmp4.z) | uint1(tmp4.y);
                    tmp4.yw = uint2(tmp4.yw) & uint2(float2(0.0, 0.0));
                    tmp4.y = tmp4.y + tmp4.w;
                    tmp4.y = floor(tmp4.y);
                    tmp4.z = tmp2.w <= 0.00001;
                    tmp4.z = tmp4.z ? 1.0 : 0.0;
                    tmp4.y = tmp4.z + tmp4.y;
                    tmp4.y = tmp4.y * 100000000.0;
                    tmp5.z = tmp2.w * _ProjectionParams.z + tmp4.y;
                    tmp3.zw = tmp3.zw - unity_CameraProjection._m02_m12;
                    tmp3.zw = tmp3.zw - float2(1.0, 1.0);
                    tmp3.zw = tmp3.zw / tmp3.xy;
                    tmp2.w = 1.0 - tmp5.z;
                    tmp2.w = unity_OrthoParams.w * tmp2.w + tmp5.z;
                    tmp5.xy = tmp2.ww * tmp3.zw;
                    tmp4.yzw = tmp5.xyz - tmp2.xyz;
                    tmp2.w = dot(tmp4.xyz, tmp1.xyz);
                    tmp2.w = -tmp2.z * 0.002 + tmp2.w;
                    tmp2.w = max(tmp2.w, 0.0);
                    tmp3.z = dot(tmp4.xyz, tmp4.xyz);
                    tmp3.z = tmp3.z + 0.0001;
                    tmp2.w = tmp2.w / tmp3.z;
                    tmp0.w = tmp0.w + tmp2.w;
                }
                tmp0.x = tmp0.w * _Radius;
                tmp0.x = tmp0.x * _Intensity;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 0.6;
                o.sv_target.x = exp(tmp0.x);
                o.sv_target.yzw = tmp1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 220731
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
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
			sampler2D _CameraDepthNormalsTexture;
			
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
                tmp0.w = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.xyz = v.texcoord.xyx;
                o.texcoord1 = tmp0;
                o.texcoord2.xy = tmp0.zw;
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
                tmp0 = tex2D(_CameraDepthNormalsTexture, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                tmp0.z = dot(tmp0.xyz, tmp0.xyz);
                tmp0.z = 2.0 / tmp0.z;
                tmp1.yz = tmp0.xy * tmp0.zz;
                tmp1.w = tmp0.z - 1.0;
                tmp0.xyz = tmp1.yzw * float3(1.0, 1.0, -1.0);
                o.sv_target.yzw = tmp1.yzw * float3(0.5, 0.5, -0.5) + float3(0.5, 0.5, 0.5);
                tmp1.x = _MainTex_TexelSize.x;
                tmp1.y = 0.0;
                tmp2 = -tmp1.xyxy * float4(2.769231, 1.384615, 6.461538, 3.230769) + inp.texcoord2.xyxy;
                tmp1 = tmp1.xyxy * float4(2.769231, 1.384615, 6.461538, 3.230769) + inp.texcoord2.xyxy;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.yzw = tmp3.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.w = dot(tmp0.xyz, tmp3.xyz);
                tmp0.w = tmp0.w - 0.8;
                tmp0.w = saturate(tmp0.w * 5.0);
                tmp3.y = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp3.y;
                tmp0.w = tmp0.w * 0.3162162;
                tmp3.x = tmp0.w * tmp3.x;
                tmp4 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp3.x = tmp4.x * 0.227027 + tmp3.x;
                tmp4 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp3.yzw = tmp4.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.y = dot(tmp0.xyz, tmp3.xyz);
                tmp3.y = tmp3.y - 0.8;
                tmp3.y = saturate(tmp3.y * 5.0);
                tmp3.z = tmp3.y * -2.0 + 3.0;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.y = tmp3.y * tmp3.z;
                tmp3.z = tmp3.y * 0.3162162;
                tmp0.w = tmp3.y * 0.3162162 + tmp0.w;
                tmp3.x = tmp4.x * tmp3.z + tmp3.x;
                tmp2.yzw = tmp2.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = dot(tmp0.xyz, tmp2.xyz);
                tmp2.y = tmp2.y - 0.8;
                tmp2.y = saturate(tmp2.y * 5.0);
                tmp2.z = tmp2.y * -2.0 + 3.0;
                tmp2.y = tmp2.y * tmp2.y;
                tmp2.y = tmp2.y * tmp2.z;
                tmp2.z = tmp2.y * 0.0702703;
                tmp0.w = tmp2.y * 0.0702703 + tmp0.w;
                tmp2.x = tmp2.x * tmp2.z + tmp3.x;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - 0.8;
                tmp0.x = saturate(tmp0.x * 5.0);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.x * 0.0702703;
                tmp0.x = tmp0.x * 0.0702703 + tmp0.w;
                tmp0.x = tmp0.x + 0.227027;
                tmp0.y = tmp1.x * tmp0.y + tmp2.x;
                o.sv_target.x = tmp0.y / tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 268460
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
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
			sampler2D _CameraGBufferTexture2;
			
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
                tmp0.w = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.xyz = v.texcoord.xyx;
                o.texcoord1 = tmp0;
                o.texcoord2.xy = tmp0.zw;
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
                tmp0 = tex2D(_CameraGBufferTexture2, inp.texcoord2.xy);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = tmp0.w != 0.0;
                tmp0.w = tmp0.w ? -1.0 : -0.0;
                tmp0.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                tmp1.xyz = tmp0.yyy * unity_WorldToCamera._m01_m11_m21;
                tmp0.xyw = unity_WorldToCamera._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToCamera._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp1.x = _MainTex_TexelSize.x;
                tmp1.y = 0.0;
                tmp2 = -tmp1.xyxy * float4(2.769231, 1.384615, 6.461538, 3.230769) + inp.texcoord2.xyxy;
                tmp1 = tmp1.xyxy * float4(2.769231, 1.384615, 6.461538, 3.230769) + inp.texcoord2.xyxy;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.yzw = tmp3.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.w = dot(tmp0.xyz, tmp3.xyz);
                tmp0.w = tmp0.w - 0.8;
                tmp0.w = saturate(tmp0.w * 5.0);
                tmp3.y = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp3.y;
                tmp0.w = tmp0.w * 0.3162162;
                tmp3.x = tmp0.w * tmp3.x;
                tmp4 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp3.x = tmp4.x * 0.227027 + tmp3.x;
                tmp4 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp3.yzw = tmp4.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.y = dot(tmp0.xyz, tmp3.xyz);
                tmp3.y = tmp3.y - 0.8;
                tmp3.y = saturate(tmp3.y * 5.0);
                tmp3.z = tmp3.y * -2.0 + 3.0;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.y = tmp3.y * tmp3.z;
                tmp3.z = tmp3.y * 0.3162162;
                tmp0.w = tmp3.y * 0.3162162 + tmp0.w;
                tmp3.x = tmp4.x * tmp3.z + tmp3.x;
                tmp2.yzw = tmp2.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = dot(tmp0.xyz, tmp2.xyz);
                tmp2.y = tmp2.y - 0.8;
                tmp2.y = saturate(tmp2.y * 5.0);
                tmp2.z = tmp2.y * -2.0 + 3.0;
                tmp2.y = tmp2.y * tmp2.y;
                tmp2.y = tmp2.y * tmp2.z;
                tmp2.z = tmp2.y * 0.0702703;
                tmp0.w = tmp2.y * 0.0702703 + tmp0.w;
                tmp2.x = tmp2.x * tmp2.z + tmp3.x;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.y = dot(tmp0.xyz, tmp1.xyz);
                o.sv_target.yzw = tmp0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                tmp0.x = tmp1.y - 0.8;
                tmp0.x = saturate(tmp0.x * 5.0);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.x * 0.0702703;
                tmp0.x = tmp0.x * 0.0702703 + tmp0.w;
                tmp0.x = tmp0.x + 0.227027;
                tmp0.y = tmp1.x * tmp0.y + tmp2.x;
                o.sv_target.x = tmp0.y / tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 367431
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _Downsample;
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
                tmp0.w = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.xyz = v.texcoord.xyx;
                o.texcoord1 = tmp0;
                o.texcoord2.xy = tmp0.zw;
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
                tmp0.x = _MainTex_TexelSize.y / _Downsample;
                tmp0.yz = float2(1.384615, 3.230769);
                tmp1 = float4(-0.0, -2.769231, -0.0, -6.461538) * tmp0.yxzx + inp.texcoord2.xyxy;
                tmp0 = float4(0.0, 2.769231, 0.0, 6.461538) * tmp0.yxzx + inp.texcoord2.xyxy;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.yzw = tmp2.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp3.yzw = tmp3.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = dot(tmp3.xyz, tmp2.xyz);
                tmp2.y = tmp2.y - 0.8;
                tmp2.y = saturate(tmp2.y * 5.0);
                tmp2.z = tmp2.y * -2.0 + 3.0;
                tmp2.y = tmp2.y * tmp2.y;
                tmp2.y = tmp2.y * tmp2.z;
                tmp2.y = tmp2.y * 0.3162162;
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.x = tmp3.x * 0.227027 + tmp2.x;
                tmp4 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp4.yzw = tmp4.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.z = dot(tmp3.xyz, tmp4.xyz);
                tmp2.z = tmp2.z - 0.8;
                tmp2.z = saturate(tmp2.z * 5.0);
                tmp2.w = tmp2.z * -2.0 + 3.0;
                tmp2.z = tmp2.z * tmp2.z;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.w = tmp2.z * 0.3162162;
                tmp2.y = tmp2.z * 0.3162162 + tmp2.y;
                tmp2.x = tmp4.x * tmp2.w + tmp2.x;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.y = dot(tmp3.xyz, tmp1.xyz);
                tmp1.y = tmp1.y - 0.8;
                tmp1.y = saturate(tmp1.y * 5.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.z = tmp1.y * 0.0702703;
                tmp1.y = tmp1.y * 0.0702703 + tmp2.y;
                tmp1.x = tmp1.x * tmp1.z + tmp2.x;
                tmp0.yzw = tmp0.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.y = dot(tmp3.xyz, tmp0.xyz);
                o.sv_target.yzw = tmp3.yzw * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                tmp0.y = tmp0.y - 0.8;
                tmp0.y = saturate(tmp0.y * 5.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.y * 0.0702703;
                tmp0.y = tmp0.y * 0.0702703 + tmp1.y;
                tmp0.y = tmp0.y + 0.227027;
                tmp0.x = tmp0.x * tmp0.z + tmp1.x;
                o.sv_target.x = tmp0.x / tmp0.y;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 434406
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _Downsample;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _OcclusionTexture;
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
                tmp0.w = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.xyz = v.texcoord.xyx;
                o.texcoord1 = tmp0;
                o.texcoord2.xy = tmp0.zw;
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
                tmp0.xy = _MainTex_TexelSize.xy / _Downsample.xx;
                tmp1.xy = inp.texcoord2.xy - tmp0.xy;
                tmp1 = tex2D(_OcclusionTexture, tmp1.xy);
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2 = tex2D(_OcclusionTexture, inp.texcoord2.xy);
                tmp2.yzw = tmp2.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.y = dot(tmp2.xyz, tmp1.xyz);
                tmp1.y = tmp1.y - 0.8;
                tmp1.y = saturate(tmp1.y * 5.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y + tmp2.x;
                tmp0.zw = -tmp0.yx;
                tmp3 = tmp0.xzwy + inp.texcoord2.xyxy;
                tmp0.xy = tmp0.xy + inp.texcoord2.xy;
                tmp0 = tex2D(_OcclusionTexture, tmp0.xy);
                tmp4 = tex2D(_OcclusionTexture, tmp3.xy);
                tmp3 = tex2D(_OcclusionTexture, tmp3.zw);
                tmp4.yzw = tmp4.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.z = dot(tmp2.xyz, tmp4.xyz);
                tmp1.z = tmp1.z - 0.8;
                tmp1.z = saturate(tmp1.z * 5.0);
                tmp1.w = tmp1.z * -2.0 + 3.0;
                tmp1.z = tmp1.z * tmp1.z;
                tmp2.x = tmp1.z * tmp1.w;
                tmp1.y = tmp1.w * tmp1.z + tmp1.y;
                tmp1.x = tmp4.x * tmp2.x + tmp1.x;
                tmp3.yzw = tmp3.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.z = dot(tmp2.xyz, tmp3.xyz);
                tmp1.z = tmp1.z - 0.8;
                tmp1.z = saturate(tmp1.z * 5.0);
                tmp1.w = tmp1.z * -2.0 + 3.0;
                tmp1.z = tmp1.z * tmp1.z;
                tmp2.x = tmp1.z * tmp1.w;
                tmp1.y = tmp1.w * tmp1.z + tmp1.y;
                tmp1.x = tmp3.x * tmp2.x + tmp1.x;
                tmp0.yzw = tmp0.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.y = dot(tmp2.xyz, tmp0.xyz);
                tmp0.y = tmp0.y - 0.8;
                tmp0.y = saturate(tmp0.y * 5.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.w = tmp0.y * tmp0.z;
                tmp0.y = tmp0.z * tmp0.y + tmp1.y;
                tmp0.y = tmp0.y + 1.0;
                tmp0.x = tmp0.x * tmp0.w + tmp1.x;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.x = 1.0 - tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord2.xy);
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Blend Zero OneMinusSrcColor, Zero OneMinusSrcAlpha
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 515234
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
				float4 sv_target1 : SV_Target1;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _Downsample;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _OcclusionTexture;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                o.position = v.vertex;
                o.texcoord1 = v.texcoord.xyxy * float4(1.0, -1.0, 1.0, -1.0) + float4(0.0, 1.0, 0.0, 1.0);
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
                tmp0.xy = _ScreenParams.zw - float2(1.0, 1.0);
                tmp0.xy = tmp0.xy / _Downsample.xx;
                tmp1.xy = inp.texcoord1.xy - tmp0.xy;
                tmp1 = tex2D(_OcclusionTexture, tmp1.xy);
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2 = tex2D(_OcclusionTexture, inp.texcoord1.xy);
                tmp2.yzw = tmp2.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.y = dot(tmp2.xyz, tmp1.xyz);
                tmp1.y = tmp1.y - 0.8;
                tmp1.y = saturate(tmp1.y * 5.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y + tmp2.x;
                tmp0.zw = -tmp0.yx;
                tmp3 = tmp0.xzwy + inp.texcoord1.xyxy;
                tmp0.xy = tmp0.xy + inp.texcoord1.xy;
                tmp0 = tex2D(_OcclusionTexture, tmp0.xy);
                tmp4 = tex2D(_OcclusionTexture, tmp3.xy);
                tmp3 = tex2D(_OcclusionTexture, tmp3.zw);
                tmp4.yzw = tmp4.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.z = dot(tmp2.xyz, tmp4.xyz);
                tmp1.z = tmp1.z - 0.8;
                tmp1.z = saturate(tmp1.z * 5.0);
                tmp1.w = tmp1.z * -2.0 + 3.0;
                tmp1.z = tmp1.z * tmp1.z;
                tmp2.x = tmp1.z * tmp1.w;
                tmp1.y = tmp1.w * tmp1.z + tmp1.y;
                tmp1.x = tmp4.x * tmp2.x + tmp1.x;
                tmp3.yzw = tmp3.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.z = dot(tmp2.xyz, tmp3.xyz);
                tmp1.z = tmp1.z - 0.8;
                tmp1.z = saturate(tmp1.z * 5.0);
                tmp1.w = tmp1.z * -2.0 + 3.0;
                tmp1.z = tmp1.z * tmp1.z;
                tmp2.x = tmp1.z * tmp1.w;
                tmp1.y = tmp1.w * tmp1.z + tmp1.y;
                tmp1.x = tmp3.x * tmp2.x + tmp1.x;
                tmp0.yzw = tmp0.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.y = dot(tmp2.xyz, tmp0.xyz);
                tmp0.y = tmp0.y - 0.8;
                tmp0.y = saturate(tmp0.y * 5.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.w = tmp0.y * tmp0.z;
                tmp0.y = tmp0.z * tmp0.y + tmp1.y;
                tmp0.y = tmp0.y + 1.0;
                tmp0.x = tmp0.x * tmp0.w + tmp1.x;
                tmp0.xyz = tmp0.xxx / tmp0.yyy;
                tmp0.w = 0.0;
                o.sv_target = tmp0.wwwz;
                o.sv_target1 = tmp0;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 528495
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _Downsample;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _OcclusionTexture;
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
                tmp0.w = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.xyz = v.texcoord.xyx;
                o.texcoord1 = tmp0;
                o.texcoord2.xy = tmp0.zw;
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
                tmp0.xy = _MainTex_TexelSize.xy / _Downsample.xx;
                tmp1.xy = inp.texcoord2.xy - tmp0.xy;
                tmp1 = tex2D(_OcclusionTexture, tmp1.xy);
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2 = tex2D(_OcclusionTexture, inp.texcoord2.xy);
                tmp2.yzw = tmp2.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.y = dot(tmp2.xyz, tmp1.xyz);
                tmp1.y = tmp1.y - 0.8;
                tmp1.y = saturate(tmp1.y * 5.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y + tmp2.x;
                tmp0.zw = -tmp0.yx;
                tmp3 = tmp0.xzwy + inp.texcoord2.xyxy;
                tmp0.xy = tmp0.xy + inp.texcoord2.xy;
                tmp0 = tex2D(_OcclusionTexture, tmp0.xy);
                tmp4 = tex2D(_OcclusionTexture, tmp3.xy);
                tmp3 = tex2D(_OcclusionTexture, tmp3.zw);
                tmp4.yzw = tmp4.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.z = dot(tmp2.xyz, tmp4.xyz);
                tmp1.z = tmp1.z - 0.8;
                tmp1.z = saturate(tmp1.z * 5.0);
                tmp1.w = tmp1.z * -2.0 + 3.0;
                tmp1.z = tmp1.z * tmp1.z;
                tmp2.x = tmp1.z * tmp1.w;
                tmp1.y = tmp1.w * tmp1.z + tmp1.y;
                tmp1.x = tmp4.x * tmp2.x + tmp1.x;
                tmp3.yzw = tmp3.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.z = dot(tmp2.xyz, tmp3.xyz);
                tmp1.z = tmp1.z - 0.8;
                tmp1.z = saturate(tmp1.z * 5.0);
                tmp1.w = tmp1.z * -2.0 + 3.0;
                tmp1.z = tmp1.z * tmp1.z;
                tmp2.x = tmp1.z * tmp1.w;
                tmp1.y = tmp1.w * tmp1.z + tmp1.y;
                tmp1.x = tmp3.x * tmp2.x + tmp1.x;
                tmp0.yzw = tmp0.yzw * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.y = dot(tmp2.xyz, tmp0.xyz);
                tmp0.y = tmp0.y - 0.8;
                tmp0.y = saturate(tmp0.y * 5.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.w = tmp0.y * tmp0.z;
                tmp0.y = tmp0.z * tmp0.y + tmp1.y;
                tmp0.y = tmp0.y + 1.0;
                tmp0.x = tmp0.x * tmp0.w + tmp1.x;
                tmp0.x = tmp0.x / tmp0.y;
                o.sv_target.xyz = float3(1.0, 1.0, 1.0) - tmp0.xxx;
                tmp0 = tex2D(_MainTex, inp.texcoord2.xy);
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
	}
}