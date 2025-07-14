Shader "Hidden/Post FX/Screen Space Reflection" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10184
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
			float4x4 _WorldToCameraMatrix;
			float4x4 _CameraToWorldMatrix;
			float4x4 _ProjectToPixelMatrix;
			float4 _ProjInfo;
			float2 _ScreenSize;
			float _RayStepSize;
			float _MaxRayTraceDistance;
			float _LayerThickness;
			float _FresnelFade;
			float _FresnelFadePower;
			int _TreatBackfaceHitAsMiss;
			int _AllowBackwardsRays;
			float _ScreenEdgeFading;
			int _MaxSteps;
			float _FadeDistance;
			int _TraceBehindObjects;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _CameraGBufferTexture1;
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
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                float4 tmp11;
                float4 tmp12;
                tmp0 = tex2D(_CameraDepthTexture, inp.texcoord1.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp1.z = -tmp0.x;
                tmp2 = tex2D(_CameraGBufferTexture1, inp.texcoord1.xy);
                tmp0.y = tmp1.z < -100.0;
                tmp0.z = tmp2.w == 0.0;
                tmp0.y = uint1(tmp0.z) | uint1(tmp0.y);
                if (!(tmp0.y)) {
                    tmp0.yz = inp.texcoord1.xy * _MainTex_TexelSize.zw;
                    tmp0.yz = tmp0.yz * _ProjInfo.xy + _ProjInfo.zw;
                    tmp1.xy = tmp1.zz * tmp0.yz;
                    tmp2 = tex2D(_CameraGBufferTexture2, inp.texcoord1.xy);
                    tmp0.yzw = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp2.xyz = tmp0.zzz * _WorldToCameraMatrix._m01_m11_m21;
                    tmp2.xyz = _WorldToCameraMatrix._m00_m10_m20 * tmp0.yyy + tmp2.xyz;
                    tmp0.yzw = _WorldToCameraMatrix._m02_m12_m22 * tmp0.www + tmp2.xyz;
                    tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                    tmp1.w = rsqrt(tmp1.w);
                    tmp2.xyz = tmp1.www * tmp1.xyz;
                    tmp1.w = dot(tmp0.xyz, -tmp2.xyz);
                    tmp1.w = tmp1.w + tmp1.w;
                    tmp3.xyz = tmp0.yzw * tmp1.www + tmp2.xyz;
                    tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                    tmp1.w = rsqrt(tmp1.w);
                    tmp3.xyz = tmp1.www * tmp3.xyz;
                    tmp1.w = _AllowBackwardsRays == 0;
                    tmp2.w = tmp3.z > 0.0;
                    tmp1.w = tmp1.w ? tmp2.w : 0.0;
                    if (!(tmp1.w)) {
                        tmp0.x = tmp0.x * 0.01;
                        tmp0.x = max(tmp0.x, 0.001);
                        tmp0.xyz = tmp0.yzw * tmp0.xxx + tmp1.xyz;
                        tmp0.w = _TraceBehindObjects == 1;
                        tmp4.xy = float2(1.0, 1.0) / _ScreenSize;
                        tmp1.w = tmp3.z * _MaxRayTraceDistance + tmp0.z;
                        tmp1.w = tmp1.w > -0.01;
                        tmp2.w = -tmp0.z - 0.01;
                        tmp2.w = tmp2.w / tmp3.z;
                        tmp1.w = tmp1.w ? tmp2.w : _MaxRayTraceDistance;
                        tmp5.xyz = tmp3.xyz * tmp1.www + tmp0.xyz;
                        tmp6.xyz = tmp0.yyy * _ProjectToPixelMatrix._m01_m11_m31;
                        tmp6.xyz = _ProjectToPixelMatrix._m00_m10_m30 * tmp0.xxx + tmp6.xyz;
                        tmp6.xyz = _ProjectToPixelMatrix._m02_m12_m32 * tmp0.zzz + tmp6.xyz;
                        tmp6.xyz = tmp6.xyz + _ProjectToPixelMatrix._m03_m13_m33;
                        tmp7.xyz = tmp5.yyy * _ProjectToPixelMatrix._m01_m11_m31;
                        tmp7.xyz = _ProjectToPixelMatrix._m00_m10_m30 * tmp5.xxx + tmp7.xyz;
                        tmp7.xyz = _ProjectToPixelMatrix._m02_m12_m32 * tmp5.zzz + tmp7.xyz;
                        tmp7.xyz = tmp7.xyz + _ProjectToPixelMatrix._m03_m13_m33;
                        tmp1.w = 1.0 / tmp6.z;
                        tmp2.w = 1.0 / tmp7.z;
                        tmp4.zw = tmp1.ww * tmp6.yx;
                        tmp6.zw = tmp2.ww * tmp7.xy;
                        tmp8.xyz = tmp0.xyz * tmp1.www;
                        tmp5.xyz = tmp2.www * tmp5.xyz;
                        tmp7.zw = _ScreenSize - float2(0.5, 0.5);
                        tmp9.xy = tmp7.zw < tmp6.wz;
                        tmp9.zw = tmp6.wz < float2(0.5, 0.5);
                        tmp9.zw = uint2(tmp9.zw) | uint2(tmp9.xy);
                        tmp7.zw = tmp9.xy ? -tmp7.zw : float2(-0.5, -0.5);
                        tmp7.zw = tmp7.yx * tmp2.ww + tmp7.zw;
                        tmp7.xy = tmp7.yx * tmp2.ww + -tmp4.zw;
                        tmp7.xy = tmp7.zw / tmp7.xy;
                        tmp3.w = tmp9.z ? tmp7.x : 0.0;
                        tmp5.w = max(tmp7.y, tmp3.w);
                        tmp3.w = tmp9.w ? tmp5.w : tmp3.w;
                        tmp7.xy = tmp6.xy * tmp1.ww + -tmp6.zw;
                        tmp6.zw = tmp3.ww * tmp7.xy + tmp6.zw;
                        tmp5.w = tmp1.w - tmp2.w;
                        tmp2.w = tmp3.w * tmp5.w + tmp2.w;
                        tmp7.xyz = tmp0.xyz * tmp1.www + -tmp5.xyz;
                        tmp5.xyz = tmp3.www * tmp7.xyz + tmp5.xyz;
                        tmp7.xy = tmp6.xy * tmp1.ww + -tmp6.zw;
                        tmp3.w = dot(tmp7.xy, tmp7.xy);
                        tmp3.w = tmp3.w < 0.0001;
                        tmp7.xy = tmp6.xy * tmp1.ww + float2(0.01, 0.01);
                        tmp7.xy = tmp3.ww ? tmp7.xy : tmp6.zw;
                        tmp7.zw = -tmp6.xy * tmp1.ww + tmp7.xy;
                        tmp3.w = abs(tmp7.z) < abs(tmp7.w);
                        tmp4.zw = tmp3.ww ? tmp4.zw : tmp4.wz;
                        tmp6.xyz = tmp3.www ? tmp7.ywz : tmp7.xzw;
                        tmp5.w = tmp6.y > 0.0;
                        tmp6.w = tmp6.y < 0.0;
                        tmp5.w = tmp6.w - tmp5.w;
                        tmp7.x = floor(tmp5.w);
                        tmp5.w = tmp7.x / tmp6.y;
                        tmp7.y = tmp6.z * tmp5.w;
                        tmp5.xyz = -tmp0.xyz * tmp1.www + tmp5.xyz;
                        tmp5.xyz = tmp5.www * tmp5.xyz;
                        tmp0.x = tmp2.w - tmp1.w;
                        tmp0.x = tmp5.w * tmp0.x;
                        tmp0.y = trunc(_RayStepSize);
                        tmp5.xyw = tmp0.yyy * tmp5.xyz;
                        tmp2.w = tmp0.y * tmp0.x;
                        tmp6.x = tmp6.x * tmp7.x;
                        tmp6.y = 100000.0 - _LayerThickness;
                        tmp6.y = tmp0.z >= tmp6.y;
                        tmp6.z = tmp0.z <= 100000.0;
                        tmp6.y = tmp6.z ? tmp6.y : 0.0;
                        tmp9.x = tmp8.z;
                        tmp9.y = tmp1.w;
                        tmp6.zw = float2(-1.0, -1.0);
                        tmp10.xy = tmp4.zw;
                        tmp7.z = 0.0;
                        tmp7.w = tmp6.y;
                        tmp11.y = tmp0.z;
                        tmp8.w = tmp6.y;
                        while (true) {
                            tmp9.z = tmp7.x * tmp10.x;
                            tmp9.z = tmp6.x >= tmp9.z;
                            tmp9.w = tmp7.z < _MaxSteps;
                            tmp9.z = tmp9.w ? tmp9.z : 0.0;
                            tmp9.w = ~uint1(tmp8.w);
                            tmp9.z = tmp9.w ? tmp9.z : 0.0;
                            if (!(tmp9.z)) {
                                break;
                            }
                            tmp9.z = tmp5.w * 0.5 + tmp9.x;
                            tmp9.w = tmp2.w * 0.5 + tmp9.y;
                            tmp11.x = tmp9.z / tmp9.w;
                            tmp9.z = tmp11.x < tmp11.y;
                            tmp9.zw = tmp9.zz ? tmp11.xy : tmp11.yx;
                            tmp6.zw = tmp3.ww ? tmp10.yx : tmp10.xy;
                            tmp10.zw = tmp4.xy * tmp6.zw;
                            tmp12 = tex2Dlod(_CameraDepthTexture, float4(tmp10.zw, 0, 0.0));
                            tmp10.z = _ZBufferParams.z * tmp12.x + _ZBufferParams.w;
                            tmp10.z = 1.0 / tmp10.z;
                            tmp9.z = -tmp10.z >= tmp9.z;
                            tmp10.z = -tmp10.z - _LayerThickness;
                            tmp9.w = tmp9.w >= tmp10.z;
                            tmp7.w = tmp9.w ? tmp9.z : 0.0;
                            tmp8.w = tmp0.w ? tmp7.w : tmp9.z;
                            tmp10.xy = tmp7.xy * tmp0.yy + tmp10.xy;
                            tmp9.x = tmp5.z * tmp0.y + tmp9.x;
                            tmp9.y = tmp0.x * tmp0.y + tmp9.y;
                            tmp7.z = tmp7.z + 1;
                            tmp11.y = tmp11.x;
                        }
                        tmp4.z = -tmp5.z * tmp0.y + tmp9.x;
                        tmp0.x = -tmp0.x * tmp0.y + tmp9.y;
                        tmp0.y = floor(tmp7.z);
                        tmp4.xy = tmp5.xy * tmp0.yy + tmp8.xy;
                        tmp0.x = 1.0 / tmp0.x;
                        tmp5.xy = tmp6.zw / _ScreenSize;
                        tmp0.xzw = tmp4.xyz * tmp0.xxx + -tmp1.xyz;
                        tmp5.z = dot(tmp0.xyz, tmp3.xyz);
                        if (tmp7.w) {
                            tmp0.x = tmp0.y + tmp0.y;
                            tmp0.y = floor(_MaxSteps);
                            tmp0.x = tmp0.x / tmp0.y;
                            tmp0.x = tmp0.x - 1.0;
                            tmp0.x = max(tmp0.x, 0.0);
                            tmp0.x = 1.0 - tmp0.x;
                            tmp0.x = tmp0.x * tmp0.x;
                            tmp0.y = _MaxRayTraceDistance - tmp5.z;
                            tmp0.y = saturate(tmp0.y / _FadeDistance);
                            tmp0.x = tmp0.y * tmp0.x;
                            tmp0.y = dot(tmp3.xyz, tmp2.xyz);
                            tmp0.y = log(abs(tmp0.y));
                            tmp0.y = tmp0.y * _FresnelFadePower;
                            tmp0.y = exp(tmp0.y);
                            tmp0.z = 1.0 - _FresnelFade;
                            tmp0.w = 1.0 - tmp0.y;
                            tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                            tmp0.y = max(tmp0.y, 0.0);
                            tmp0.x = tmp0.y * tmp0.x;
                            tmp0.y = _TreatBackfaceHitAsMiss > 0;
                            if (tmp0.y) {
                                tmp1 = tex2Dlod(_CameraGBufferTexture2, float4(tmp5.xy, 0, 0.0));
                                tmp0.yzw = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                                tmp1.xyz = tmp3.yyy * _CameraToWorldMatrix._m01_m11_m21;
                                tmp1.xyz = _CameraToWorldMatrix._m00_m10_m20 * tmp3.xxx + tmp1.xyz;
                                tmp1.xyz = _CameraToWorldMatrix._m02_m12_m22 * tmp3.zzz + tmp1.xyz;
                                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                                tmp0.y = tmp0.y > 0.0;
                                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                            }
                        } else {
                            tmp0.x = 0.0;
                        }
                        tmp0.yz = float2(1.0, 1.0) - tmp5.xy;
                        tmp0.y = min(tmp0.z, tmp0.y);
                        tmp0.z = min(tmp5.x, tmp5.x);
                        tmp0.y = min(tmp0.z, tmp0.y);
                        tmp0.z = _ScreenEdgeFading * 0.1 + 0.001;
                        tmp0.y = saturate(tmp0.y / tmp0.z);
                        tmp0.y = log(tmp0.y);
                        tmp0.y = tmp0.y * 0.2;
                        tmp0.y = exp(tmp0.y);
                        tmp0.y = tmp0.y * tmp0.y;
                        o.sv_target.w = tmp0.x * tmp0.y;
                        o.sv_target.xyz = tmp5.xyz;
                    } else {
                        o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                    }
                } else {
                    o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                }
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 87432
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
			float4x4 _CameraToWorldMatrix;
			float4 _ProjInfo;
			int _AdditiveReflection;
			float _SSRMultiplier;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			sampler2D _CameraGBufferTexture1;
			sampler2D _FinalReflectionTexture;
			sampler2D _CameraGBufferTexture0;
			sampler2D _CameraGBufferTexture2;
			sampler2D _CameraReflectionsTexture;
			
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
                tmp0.xy = inp.texcoord1.xy * _MainTex_TexelSize.zw;
                tmp0.xy = tmp0.xy * _ProjInfo.xy + _ProjInfo.zw;
                tmp1 = tex2D(_CameraDepthTexture, inp.texcoord1.xy);
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp1.z = -tmp0.z;
                tmp1.xy = tmp0.xy * tmp1.zz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * _CameraToWorldMatrix._m01_m11_m21;
                tmp0.xyw = _CameraToWorldMatrix._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = _CameraToWorldMatrix._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp1 = tex2D(_CameraGBufferTexture2, inp.texcoord1.xy);
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.x = dot(tmp1.xyz, -tmp0.xyz);
                tmp0.x = 1.0 - abs(tmp0.x);
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.x = tmp0.x * tmp0.y;
                tmp1 = tex2D(_CameraGBufferTexture1, inp.texcoord1.xy);
                tmp0.y = max(tmp1.y, tmp1.x);
                tmp0.y = max(tmp1.z, tmp0.y);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = saturate(tmp0.y + tmp1.w);
                tmp0.yzw = tmp0.yyy - tmp1.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + tmp1.xyz;
                tmp0.w = 1.0 - tmp1.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp1 = tex2D(_FinalReflectionTexture, inp.texcoord1.xy);
                tmp1.yzw = tmp0.www * tmp1.yzw;
                tmp1.x = saturate(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.yzw;
                tmp1.yzw = tmp0.xyz * _SSRMultiplier.xxx;
                tmp1.yzw = tmp1.xxx * tmp1.yzw;
                tmp2 = tex2D(_CameraReflectionsTexture, inp.texcoord1.xy);
                tmp0.xyz = tmp0.xyz * _SSRMultiplier.xxx + -tmp2.xyz;
                tmp0.xyz = tmp1.xxx * tmp0.xyz + tmp2.xyz;
                tmp0.xyz = _AdditiveReflection.xxx ? tmp1.yzw : tmp0.xyz;
                tmp1 = tex2D(_CameraGBufferTexture0, inp.texcoord1.xy);
                tmp0.xyz = tmp0.xyz * tmp1.www;
                tmp2.w = 0.0;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tmp1 - tmp2;
                tmp2 = max(tmp2, float4(0.0, 0.0, 0.0, 0.0));
                tmp1 = _AdditiveReflection.xxxx ? tmp1 : tmp2;
                tmp0.w = 0.0;
                o.sv_target = tmp0 + tmp1;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 187652
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
			int _HighlightSuppression;
			float4 _Axis;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _NormalAndRoughnessTexture;
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
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                float4 tmp11;
                float4 tmp12;
                float4 tmp13;
                tmp0 = tex2D(_NormalAndRoughnessTexture, inp.texcoord1.xy);
                tmp0.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.xy = _MainTex_TexelSize.xy * _Axis.xy;
                tmp2 = tmp1.xyxy * float4(-8.0, -8.0, -6.0, -6.0) + inp.texcoord1.xyxy;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp0.w = tmp3.w * 0.0525;
                tmp4 = tex2D(_NormalAndRoughnessTexture, tmp2.xy);
                tmp4.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.z = saturate(dot(tmp0.xyz, tmp4.xyz));
                tmp1.w = tmp0.w * tmp1.z;
                tmp4.xyz = tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp3.xyz / tmp4.xyz;
                tmp3.xyz = _HighlightSuppression.xxx ? tmp4.xyz : tmp3.xyz;
                tmp4 = tex2D(_MainTex, tmp2.zw);
                tmp2.x = tmp4.w * 0.075;
                tmp5 = tex2D(_NormalAndRoughnessTexture, tmp2.zw);
                tmp2.yzw = tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = saturate(dot(tmp0.xyz, tmp2.xyz));
                tmp2.x = tmp2.y * tmp2.x;
                tmp0.w = tmp0.w * tmp1.z + tmp2.x;
                tmp2.yzw = tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp4.xyz / tmp2.yzw;
                tmp4.xyz = _HighlightSuppression.xxx ? tmp2.yzw : tmp4.xyz;
                tmp5 = tmp1.xyxy * float4(-4.0, -4.0, -2.0, -2.0) + inp.texcoord1.xyxy;
                tmp6 = tex2D(_MainTex, tmp5.xy);
                tmp1.z = tmp6.w * 0.11;
                tmp7 = tex2D(_NormalAndRoughnessTexture, tmp5.xy);
                tmp2.yzw = tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = saturate(dot(tmp0.xyz, tmp2.xyz));
                tmp2.z = tmp1.z * tmp2.y;
                tmp0.w = tmp1.z * tmp2.y + tmp0.w;
                tmp7.xyz = tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp6.xyz / tmp7.xyz;
                tmp6.xyz = _HighlightSuppression.xxx ? tmp7.xyz : tmp6.xyz;
                tmp7 = tex2D(_MainTex, tmp5.zw);
                tmp1.z = tmp7.w * 0.15;
                tmp5 = tex2D(_NormalAndRoughnessTexture, tmp5.zw);
                tmp5.xyz = tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = saturate(dot(tmp0.xyz, tmp5.xyz));
                tmp2.w = tmp1.z * tmp2.y;
                tmp0.w = tmp1.z * tmp2.y + tmp0.w;
                tmp5.xyz = tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp7.xyz / tmp5.xyz;
                tmp7.xyz = _HighlightSuppression.xxx ? tmp5.xyz : tmp7.xyz;
                tmp5 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp1.z = tmp5.w * 0.225;
                tmp2.y = dot(tmp0.xyz, tmp0.xyz);
                tmp2.y = min(tmp2.y, 1.0);
                tmp8.x = tmp1.z * tmp2.y;
                tmp0.w = tmp1.z * tmp2.y + tmp0.w;
                tmp8.yzw = tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp8.yzw = tmp5.xyz / tmp8.yzw;
                tmp5.xyz = _HighlightSuppression.xxx ? tmp8.yzw : tmp5.xyz;
                tmp8.yz = tmp1.xy * float2(2.0, 2.0) + inp.texcoord1.xy;
                tmp9 = tex2D(_MainTex, tmp8.yz);
                tmp1.z = tmp9.w * 0.15;
                tmp10 = tex2D(_NormalAndRoughnessTexture, tmp8.yz);
                tmp8.yzw = tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = saturate(dot(tmp0.xyz, tmp8.xyz));
                tmp8.y = tmp1.z * tmp2.y;
                tmp0.w = tmp1.z * tmp2.y + tmp0.w;
                tmp10.xyz = tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp9.xyz / tmp10.xyz;
                tmp9.xyz = _HighlightSuppression.xxx ? tmp10.xyz : tmp9.xyz;
                tmp10 = tmp1.xyxy * float4(4.0, 4.0, 6.0, 6.0) + inp.texcoord1.xyxy;
                tmp11 = tex2D(_MainTex, tmp10.xy);
                tmp1.z = tmp11.w * 0.11;
                tmp12 = tex2D(_NormalAndRoughnessTexture, tmp10.xy);
                tmp12.xyz = tmp12.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = saturate(dot(tmp0.xyz, tmp12.xyz));
                tmp8.z = tmp1.z * tmp2.y;
                tmp0.w = tmp1.z * tmp2.y + tmp0.w;
                tmp12.xyz = tmp11.xyz + float3(1.0, 1.0, 1.0);
                tmp12.xyz = tmp11.xyz / tmp12.xyz;
                tmp11.xyz = _HighlightSuppression.xxx ? tmp12.xyz : tmp11.xyz;
                tmp12 = tex2D(_MainTex, tmp10.zw);
                tmp1.z = tmp12.w * 0.075;
                tmp10 = tex2D(_NormalAndRoughnessTexture, tmp10.zw);
                tmp10.xyz = tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.y = saturate(dot(tmp0.xyz, tmp10.xyz));
                tmp8.w = tmp1.z * tmp2.y;
                tmp0.w = tmp1.z * tmp2.y + tmp0.w;
                tmp10.xyz = tmp12.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp12.xyz / tmp10.xyz;
                tmp12.xyz = _HighlightSuppression.xxx ? tmp10.xyz : tmp12.xyz;
                tmp1.xy = tmp1.xy * float2(8.0, 8.0) + inp.texcoord1.xy;
                tmp10 = tex2D(_MainTex, tmp1.xy);
                tmp1.z = tmp10.w * 0.0525;
                tmp13 = tex2D(_NormalAndRoughnessTexture, tmp1.xy);
                tmp13.xyz = tmp13.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp0.x = saturate(dot(tmp0.xyz, tmp13.xyz));
                tmp0.y = tmp0.x * tmp1.z;
                tmp0.x = tmp1.z * tmp0.x + tmp0.w;
                tmp1.xyz = tmp10.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp10.xyz / tmp1.xyz;
                tmp10.xyz = _HighlightSuppression.xxx ? tmp1.xyz : tmp10.xyz;
                tmp0.z = tmp0.x > 0.01;
                if (tmp0.z) {
                    tmp13 = tmp2.xxxx * tmp4;
                    tmp1 = tmp3 * tmp1.wwww + tmp13;
                    tmp1 = tmp6 * tmp2.zzzz + tmp1;
                    tmp1 = tmp7 * tmp2.wwww + tmp1;
                    tmp1 = tmp5 * tmp8.xxxx + tmp1;
                    tmp1 = tmp9 * tmp8.yyyy + tmp1;
                    tmp1 = tmp11 * tmp8.zzzz + tmp1;
                    tmp1 = tmp12 * tmp8.wwww + tmp1;
                    tmp1 = tmp10 * tmp0.yyyy + tmp1;
                    tmp0.x = 1.0 / tmp0.x;
                    tmp0.y = max(tmp0.x, 2.0);
                    tmp0.y = sqrt(tmp0.y);
                    tmp0.y = tmp0.y * tmp1.w;
                    o.sv_target.w = min(tmp0.y, 1.0);
                    tmp0.yzw = tmp0.xxx * tmp1.xyz;
                    tmp1.xyz = -tmp1.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                    tmp1.xyz = tmp0.yzw / tmp1.xyz;
                    o.sv_target.xyz = _HighlightSuppression.xxx ? tmp1.xyz : tmp0.yzw;
                    return o;
                } else {
                    tmp0.xyz = tmp3.xyz + tmp4.xyz;
                    tmp0.xyz = tmp6.xyz + tmp0.xyz;
                    tmp0.xyz = tmp7.xyz + tmp0.xyz;
                    tmp0.xyz = tmp5.xyz + tmp0.xyz;
                    tmp0.xyz = tmp9.xyz + tmp0.xyz;
                    tmp0.xyz = tmp11.xyz + tmp0.xyz;
                    tmp0.xyz = tmp12.xyz + tmp0.xyz;
                    tmp0.xyz = tmp10.xyz + tmp0.xyz;
                    tmp1.xyz = tmp0.xyz * float3(0.1111111, 0.1111111, 0.1111111);
                    tmp0.xyz = -tmp0.xyz * float3(0.1111111, 0.1111111, 0.1111111) + float3(1.0, 1.0, 1.0);
                    tmp0.xyz = tmp1.xyz / tmp0.xyz;
                    o.sv_target.xyz = _HighlightSuppression.xxx ? tmp0.xyz : tmp1.xyz;
                    o.sv_target.w = 0.0;
                    return o;
                }
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 201071
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
			float4x4 _WorldToCameraMatrix;
			float4 _ProjInfo;
			float2 _ReflectionBufferSize;
			int _HalfResolution;
			float _ScreenEdgeFading;
			int _BilateralUpsampling;
			float _PixelsPerMeterAtOneMeter;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraGBufferTexture1;
			sampler2D _HitPointTexture;
			sampler2D _CameraDepthTexture;
			sampler2D _CameraGBufferTexture2;
			sampler2D _ReflectionTexture0;
			sampler2D _ReflectionTexture1;
			sampler2D _ReflectionTexture2;
			sampler2D _ReflectionTexture3;
			sampler2D _ReflectionTexture4;
			sampler2D _NormalAndRoughnessTexture;
			
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
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                float4 tmp11;
                float4 tmp12;
                tmp0 = tex2D(_CameraGBufferTexture1, inp.texcoord1.xy);
                tmp0.x = 1.0 - tmp0.w;
                tmp1 = tex2D(_HitPointTexture, inp.texcoord1.xy);
                tmp2 = tex2D(_CameraDepthTexture, inp.texcoord1.xy);
                tmp0.y = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp2.z = -tmp0.y;
                tmp0.yz = inp.texcoord1.xy * _MainTex_TexelSize.zw;
                tmp0.yz = tmp0.yz * _ProjInfo.xy + _ProjInfo.zw;
                tmp2.xy = tmp2.zz * tmp0.yz;
                tmp3 = tex2D(_CameraGBufferTexture2, inp.texcoord1.xy);
                tmp0.yzw = tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.xyw = tmp0.zzz * _WorldToCameraMatrix._m01_m11_m21;
                tmp1.xyw = _WorldToCameraMatrix._m00_m10_m20 * tmp0.yyy + tmp1.xyw;
                tmp0.yzw = _WorldToCameraMatrix._m02_m12_m22 * tmp0.www + tmp1.xyw;
                tmp1.x = dot(tmp2.xyz, tmp2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyw = tmp1.xxx * tmp2.xyz;
                tmp2.x = dot(tmp0.xyz, -tmp1.xyz);
                tmp2.x = tmp2.x + tmp2.x;
                tmp0.yzw = tmp0.yzw * tmp2.xxx + tmp1.xyw;
                tmp0.y = dot(tmp0.xyz, tmp0.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.y = tmp0.y * tmp1.z + tmp2.z;
                tmp0.z = log(tmp0.x);
                tmp0.z = tmp0.z * 1.333333;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp1.z * tmp0.z;
                tmp0.z = tmp0.z * _PixelsPerMeterAtOneMeter;
                tmp0.y = tmp0.z / tmp0.y;
                tmp0.z = _HalfResolution == 1;
                tmp0.w = tmp0.y * 0.5;
                tmp0.y = tmp0.z ? tmp0.w : tmp0.y;
                tmp0.y = tmp0.y + 15.0;
                tmp0.y = tmp0.y * 0.0625;
                tmp0.y = log(tmp0.y);
                tmp0.y = min(tmp0.y, 4.0);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = asint(tmp0.y);
                tmp0.w = tmp0.z + 1;
                tmp0.w = min(tmp0.w, 4);
                tmp1.x = trunc(tmp0.y);
                tmp0.y = tmp0.y - tmp1.x;
                tmp1.x = _BilateralUpsampling == 1;
                if (tmp1.x) {
                    tmp1.x = floor(-tmp0.z);
                    tmp1.x = exp(tmp1.x);
                    tmp1 = tmp1.xxxx * _ReflectionBufferSize.xyxy;
                    tmp1 = floor(tmp1);
                    tmp2 = inp.texcoord1.xyxy * tmp1.zwzw + float4(-0.5, -0.5, -0.5, -0.5);
                    tmp2 = floor(tmp2);
                    tmp2 = tmp2 + float4(1.5, 0.5, 0.5, 1.5);
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0) / tmp1;
                    tmp3 = tmp2 * tmp3;
                    if (!(tmp0.z)) {
                        tmp4 = tex2Dlod(_ReflectionTexture0, float4(tmp3.zy, 0, 0.0));
                        tmp5 = tex2Dlod(_ReflectionTexture0, float4(tmp3.xy, 0, 0.0));
                        tmp6 = tex2Dlod(_ReflectionTexture0, float4(tmp3.zw, 0, 0.0));
                        tmp7 = tex2Dlod(_ReflectionTexture0, float4(tmp3.xw, 0, 0.0));
                    } else {
                        tmp1.x = tmp0.z == 1;
                        if (tmp1.x) {
                            tmp4 = tex2Dlod(_ReflectionTexture1, float4(tmp3.zy, 0, 0.0));
                        } else {
                            tmp1.y = tmp0.z == 2;
                            if (tmp1.y) {
                                tmp4 = tex2Dlod(_ReflectionTexture2, float4(tmp3.zy, 0, 0.0));
                            } else {
                                tmp1.y = tmp0.z == 3;
                                if (tmp1.y) {
                                    tmp4 = tex2Dlod(_ReflectionTexture3, float4(tmp3.zy, 0, 0.0));
                                } else {
                                    tmp4 = tex2Dlod(_ReflectionTexture4, float4(tmp3.zy, 0, 0.0));
                                }
                            }
                        }
                        if (tmp1.x) {
                            tmp5 = tex2Dlod(_ReflectionTexture1, float4(tmp3.xy, 0, 0.0));
                        } else {
                            tmp1.y = tmp0.z == 2;
                            if (tmp1.y) {
                                tmp5 = tex2Dlod(_ReflectionTexture2, float4(tmp3.xy, 0, 0.0));
                            } else {
                                tmp1.y = tmp0.z == 3;
                                if (tmp1.y) {
                                    tmp5 = tex2Dlod(_ReflectionTexture3, float4(tmp3.xy, 0, 0.0));
                                } else {
                                    tmp5 = tex2Dlod(_ReflectionTexture4, float4(tmp3.xy, 0, 0.0));
                                }
                            }
                        }
                        if (tmp1.x) {
                            tmp6 = tex2Dlod(_ReflectionTexture1, float4(tmp3.zw, 0, 0.0));
                        } else {
                            tmp1.y = tmp0.z == 2;
                            if (tmp1.y) {
                                tmp6 = tex2Dlod(_ReflectionTexture2, float4(tmp3.zw, 0, 0.0));
                            } else {
                                tmp1.y = tmp0.z == 3;
                                if (tmp1.y) {
                                    tmp6 = tex2Dlod(_ReflectionTexture3, float4(tmp3.zw, 0, 0.0));
                                } else {
                                    tmp6 = tex2Dlod(_ReflectionTexture4, float4(tmp3.zw, 0, 0.0));
                                }
                            }
                        }
                        if (tmp1.x) {
                            tmp7 = tex2Dlod(_ReflectionTexture1, float4(tmp3.xw, 0, 0.0));
                        } else {
                            tmp1.x = tmp0.z == 2;
                            if (tmp1.x) {
                                tmp7 = tex2Dlod(_ReflectionTexture2, float4(tmp3.xw, 0, 0.0));
                            } else {
                                tmp1.x = tmp0.z == 3;
                                if (tmp1.x) {
                                    tmp7 = tex2Dlod(_ReflectionTexture3, float4(tmp3.xw, 0, 0.0));
                                } else {
                                    tmp7 = tex2Dlod(_ReflectionTexture4, float4(tmp3.xw, 0, 0.0));
                                }
                            }
                        }
                    }
                    tmp1.xy = inp.texcoord1.xy * tmp1.zw + -tmp2.zy;
                    tmp1.zw = float2(1.0, 1.0) - tmp1.yx;
                    tmp2.x = tmp1.z * tmp1.w;
                    tmp1.zw = tmp1.zw * tmp1.xy;
                    tmp1.x = tmp1.y * tmp1.x;
                    tmp8 = float4(1.0, 1.0, 1.0, 1.0) / _ReflectionBufferSize.xyxy;
                    tmp9 = tmp3.zyxw * _ReflectionBufferSize.xyxy + float4(-0.5, -0.5, -0.5, -0.5);
                    tmp9 = floor(tmp9);
                    tmp9 = tmp9 + float4(0.5, 0.5, 0.5, 0.5);
                    tmp9 = tmp8 * tmp9;
                    tmp3 = tmp3 * _ReflectionBufferSize.xyxy + float4(-0.5, -0.5, -0.5, -0.5);
                    tmp3 = floor(tmp3);
                    tmp3 = tmp3 + float4(0.5, 0.5, 0.5, 0.5);
                    tmp3 = tmp8 * tmp3;
                    tmp10 = tex2Dlod(_NormalAndRoughnessTexture, float4(inp.texcoord1.xy, 0, 0.0));
                    tmp2.yzw = tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp11 = tex2Dlod(_NormalAndRoughnessTexture, float4(tmp9.xy, 0, 0.0));
                    tmp12 = tex2Dlod(_NormalAndRoughnessTexture, float4(tmp3.xy, 0, 0.0));
                    tmp3 = tex2Dlod(_NormalAndRoughnessTexture, float4(tmp3.zw, 0, 0.0));
                    tmp9 = tex2Dlod(_NormalAndRoughnessTexture, float4(tmp9.zw, 0, 0.0));
                    tmp10.xyz = tmp11.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp11.xyz = tmp12.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp3.xyz = tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp9.xyz = tmp9.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp1.y = saturate(dot(tmp2.xyz, tmp10.xyz));
                    tmp1.y = tmp1.y * tmp2.x;
                    tmp2.x = saturate(dot(tmp2.xyz, tmp11.xyz));
                    tmp1.z = tmp1.z * tmp2.x;
                    tmp2.x = saturate(dot(tmp2.xyz, tmp3.xyz));
                    tmp1.w = tmp1.w * tmp2.x;
                    tmp2.x = saturate(dot(tmp2.xyz, tmp9.xyz));
                    tmp1.x = tmp1.x * tmp2.x;
                    tmp2.x = tmp10.w - tmp11.w;
                    tmp2.x = sqrt(abs(tmp2.x));
                    tmp2.x = sqrt(tmp2.x);
                    tmp2.x = 1.0 - tmp2.x;
                    tmp1.y = tmp1.y * tmp2.x;
                    tmp2.x = tmp10.w - tmp12.w;
                    tmp2.x = sqrt(abs(tmp2.x));
                    tmp2.x = sqrt(tmp2.x);
                    tmp2.x = 1.0 - tmp2.x;
                    tmp1.z = tmp1.z * tmp2.x;
                    tmp2.x = tmp10.w - tmp3.w;
                    tmp2.x = sqrt(abs(tmp2.x));
                    tmp2.x = sqrt(tmp2.x);
                    tmp2.x = 1.0 - tmp2.x;
                    tmp1.w = tmp1.w * tmp2.x;
                    tmp2.x = tmp10.w - tmp9.w;
                    tmp2.x = sqrt(abs(tmp2.x));
                    tmp2.x = sqrt(tmp2.x);
                    tmp2.x = 1.0 - tmp2.x;
                    tmp1.x = tmp1.x * tmp2.x;
                    tmp1 = max(tmp1, float4(0.001, 0.001, 0.001, 0.001));
                    tmp2.x = tmp1.z + tmp1.y;
                    tmp2.x = tmp1.w + tmp2.x;
                    tmp2.x = tmp1.x + tmp2.x;
                    tmp2.x = 1.0 / tmp2.x;
                    tmp3 = tmp1.zzzz * tmp5;
                    tmp3 = tmp4 * tmp1.yyyy + tmp3;
                    tmp3 = tmp6 * tmp1.wwww + tmp3;
                    tmp1 = tmp7 * tmp1.xxxx + tmp3;
                    tmp1 = tmp2.xxxx * tmp1;
                    tmp2.x = floor(-tmp0.w);
                    tmp2.x = exp(tmp2.x);
                    tmp3 = tmp2.xxxx * _ReflectionBufferSize.xyxy;
                    tmp3 = floor(tmp3);
                    tmp4 = inp.texcoord1.xyxy * tmp3.zwzw + float4(-0.5, -0.5, -0.5, -0.5);
                    tmp4 = floor(tmp4);
                    tmp4 = tmp4 + float4(1.5, 0.5, 0.5, 1.5);
                    tmp5 = float4(1.0, 1.0, 1.0, 1.0) / tmp3;
                    tmp5 = tmp4 * tmp5;
                    tmp2.x = tmp0.w == 1;
                    if (tmp2.x) {
                        tmp6 = tex2Dlod(_ReflectionTexture1, float4(tmp5.zy, 0, 0.0));
                        tmp7 = tex2Dlod(_ReflectionTexture1, float4(tmp5.xy, 0, 0.0));
                        tmp9 = tex2Dlod(_ReflectionTexture1, float4(tmp5.zw, 0, 0.0));
                        tmp11 = tex2Dlod(_ReflectionTexture1, float4(tmp5.xw, 0, 0.0));
                    } else {
                        tmp2.x = tmp0.w == 2;
                        if (tmp2.x) {
                            tmp6 = tex2Dlod(_ReflectionTexture2, float4(tmp5.zy, 0, 0.0));
                        } else {
                            tmp3.x = tmp0.w == 3;
                            if (tmp3.x) {
                                tmp6 = tex2Dlod(_ReflectionTexture3, float4(tmp5.zy, 0, 0.0));
                            } else {
                                tmp6 = tex2Dlod(_ReflectionTexture4, float4(tmp5.zy, 0, 0.0));
                            }
                        }
                        if (tmp2.x) {
                            tmp7 = tex2Dlod(_ReflectionTexture2, float4(tmp5.xy, 0, 0.0));
                        } else {
                            tmp3.x = tmp0.w == 3;
                            if (tmp3.x) {
                                tmp7 = tex2Dlod(_ReflectionTexture3, float4(tmp5.xy, 0, 0.0));
                            } else {
                                tmp7 = tex2Dlod(_ReflectionTexture4, float4(tmp5.xy, 0, 0.0));
                            }
                        }
                        if (tmp2.x) {
                            tmp9 = tex2Dlod(_ReflectionTexture2, float4(tmp5.zw, 0, 0.0));
                        } else {
                            tmp3.x = tmp0.w == 3;
                            if (tmp3.x) {
                                tmp9 = tex2Dlod(_ReflectionTexture3, float4(tmp5.zw, 0, 0.0));
                            } else {
                                tmp9 = tex2Dlod(_ReflectionTexture4, float4(tmp5.zw, 0, 0.0));
                            }
                        }
                        if (tmp2.x) {
                            tmp11 = tex2Dlod(_ReflectionTexture2, float4(tmp5.xw, 0, 0.0));
                        } else {
                            tmp2.x = tmp0.w == 3;
                            if (tmp2.x) {
                                tmp11 = tex2Dlod(_ReflectionTexture3, float4(tmp5.xw, 0, 0.0));
                            } else {
                                tmp11 = tex2Dlod(_ReflectionTexture4, float4(tmp5.xw, 0, 0.0));
                            }
                        }
                    }
                    tmp3.xy = inp.texcoord1.xy * tmp3.zw + -tmp4.zy;
                    tmp3.zw = float2(1.0, 1.0) - tmp3.yx;
                    tmp2.x = tmp3.z * tmp3.w;
                    tmp3.zw = tmp3.zw * tmp3.xy;
                    tmp3.x = tmp3.y * tmp3.x;
                    tmp4 = tmp5.zyxw * _ReflectionBufferSize.xyxy + float4(-0.5, -0.5, -0.5, -0.5);
                    tmp4 = floor(tmp4);
                    tmp4 = tmp4 + float4(0.5, 0.5, 0.5, 0.5);
                    tmp4 = tmp8 * tmp4;
                    tmp5 = tmp5 * _ReflectionBufferSize.xyxy + float4(-0.5, -0.5, -0.5, -0.5);
                    tmp5 = floor(tmp5);
                    tmp5 = tmp5 + float4(0.5, 0.5, 0.5, 0.5);
                    tmp5 = tmp8 * tmp5;
                    tmp8 = tex2Dlod(_NormalAndRoughnessTexture, float4(tmp4.xy, 0, 0.0));
                    tmp12 = tex2Dlod(_NormalAndRoughnessTexture, float4(tmp5.xy, 0, 0.0));
                    tmp5 = tex2Dlod(_NormalAndRoughnessTexture, float4(tmp5.zw, 0, 0.0));
                    tmp4 = tex2Dlod(_NormalAndRoughnessTexture, float4(tmp4.zw, 0, 0.0));
                    tmp8.xyz = tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp10.xyz = tmp12.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp5.xyz = tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp4.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                    tmp3.y = saturate(dot(tmp2.xyz, tmp8.xyz));
                    tmp2.x = tmp2.x * tmp3.y;
                    tmp3.y = saturate(dot(tmp2.xyz, tmp10.xyz));
                    tmp3.y = tmp3.y * tmp3.z;
                    tmp3.z = saturate(dot(tmp2.xyz, tmp5.xyz));
                    tmp3.z = tmp3.z * tmp3.w;
                    tmp2.y = saturate(dot(tmp2.xyz, tmp4.xyz));
                    tmp2.y = tmp2.y * tmp3.x;
                    tmp2.z = tmp10.w - tmp8.w;
                    tmp2.z = sqrt(abs(tmp2.z));
                    tmp2.z = sqrt(tmp2.z);
                    tmp2.z = 1.0 - tmp2.z;
                    tmp2.x = tmp2.z * tmp2.x;
                    tmp2.z = tmp10.w - tmp12.w;
                    tmp2.z = sqrt(abs(tmp2.z));
                    tmp2.z = sqrt(tmp2.z);
                    tmp2.z = 1.0 - tmp2.z;
                    tmp2.w = tmp10.w - tmp5.w;
                    tmp2.w = sqrt(abs(tmp2.w));
                    tmp2.w = sqrt(tmp2.w);
                    tmp2.w = 1.0 - tmp2.w;
                    tmp2.zw = tmp2.zw * tmp3.yz;
                    tmp3.x = tmp10.w - tmp4.w;
                    tmp3.x = sqrt(abs(tmp3.x));
                    tmp3.x = sqrt(tmp3.x);
                    tmp3.x = 1.0 - tmp3.x;
                    tmp2.y = tmp2.y * tmp3.x;
                    tmp2 = max(tmp2, float4(0.001, 0.001, 0.001, 0.001));
                    tmp3.x = tmp2.z + tmp2.x;
                    tmp3.x = tmp2.w + tmp3.x;
                    tmp3.x = tmp2.y + tmp3.x;
                    tmp3.x = 1.0 / tmp3.x;
                    tmp4 = tmp2.zzzz * tmp7;
                    tmp4 = tmp6 * tmp2.xxxx + tmp4;
                    tmp4 = tmp9 * tmp2.wwww + tmp4;
                    tmp2 = tmp11 * tmp2.yyyy + tmp4;
                    tmp2 = tmp2 * tmp3.xxxx + -tmp1;
                    tmp1 = tmp0.yyyy * tmp2.wxyz + tmp1.wxyz;
                    o.sv_target.xyz = tmp1.yzw;
                } else {
                    if (!(tmp0.z)) {
                        tmp2 = tex2Dlod(_ReflectionTexture0, float4(inp.texcoord1.xy, 0, 0.0));
                    } else {
                        tmp1.y = tmp0.z == 1;
                        if (tmp1.y) {
                            tmp2 = tex2Dlod(_ReflectionTexture1, float4(inp.texcoord1.xy, 0, 0.0));
                        } else {
                            tmp1.y = tmp0.z == 2;
                            if (tmp1.y) {
                                tmp2 = tex2Dlod(_ReflectionTexture2, float4(inp.texcoord1.xy, 0, 0.0));
                            } else {
                                tmp0.z = tmp0.z == 3;
                                if (tmp0.z) {
                                    tmp2 = tex2Dlod(_ReflectionTexture3, float4(inp.texcoord1.xy, 0, 0.0));
                                } else {
                                    tmp2 = tex2Dlod(_ReflectionTexture4, float4(inp.texcoord1.xy, 0, 0.0));
                                }
                            }
                        }
                    }
                    tmp0.z = tmp0.w == 1;
                    if (tmp0.z) {
                        tmp3 = tex2Dlod(_ReflectionTexture1, float4(inp.texcoord1.xy, 0, 0.0));
                    } else {
                        tmp0.z = tmp0.w == 2;
                        if (tmp0.z) {
                            tmp3 = tex2Dlod(_ReflectionTexture2, float4(inp.texcoord1.xy, 0, 0.0));
                        } else {
                            tmp0.z = tmp0.w == 3;
                            if (tmp0.z) {
                                tmp3 = tex2Dlod(_ReflectionTexture3, float4(inp.texcoord1.xy, 0, 0.0));
                            } else {
                                tmp3 = tex2Dlod(_ReflectionTexture4, float4(inp.texcoord1.xy, 0, 0.0));
                            }
                        }
                    }
                    tmp1.yzw = tmp3.xyz - tmp2.xyz;
                    o.sv_target.xyz = tmp0.yyy * tmp1.yzw + tmp2.xyz;
                    tmp1.x = min(tmp2.w, tmp3.w);
                }
                tmp0.y = min(tmp1.x, 1.0);
                tmp0.zw = float2(1.0, 1.0) - inp.texcoord1.xy;
                tmp0.z = min(tmp0.w, tmp0.z);
                tmp0.z = min(tmp0.z, inp.texcoord1.x);
                tmp0.w = _ScreenEdgeFading * 0.1 + 0.001;
                tmp0.z = saturate(tmp0.z / tmp0.w);
                tmp0.z = log(tmp0.z);
                tmp0.z = tmp0.z * 0.2;
                tmp0.z = exp(tmp0.z);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.x = saturate(tmp0.x * 0.3);
                tmp0.x = 1.0 - tmp0.x;
                o.sv_target.w = tmp0.x * tmp0.y;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 295135
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
			float2 _ReflectionBufferSize;
			int _LastMip;
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
                float4 tmp3;
                tmp0.x = floor(-_LastMip);
                tmp0.x = exp(tmp0.x);
                tmp0.xy = tmp0.xx * _ReflectionBufferSize;
                tmp0.xy = floor(tmp0.xy);
                tmp0.zw = inp.texcoord1.xy * tmp0.xy + float2(-0.5, -0.5);
                tmp0.xy = float2(1.0, 1.0) / tmp0.xy;
                tmp0.zw = floor(tmp0.zw);
                tmp0.zw = tmp0.zw + float2(0.5, 0.5);
                tmp1.xy = tmp0.xy * tmp0.zw;
                tmp1.zw = tmp0.zw * tmp0.xy + tmp0.xy;
                tmp0 = tex2D(_MainTex, tmp1.xw);
                tmp2 = tex2D(_MainTex, tmp1.zy);
                tmp3 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp1 = min(tmp1, tmp3);
                tmp0 = min(tmp0, tmp2);
                o.sv_target = min(tmp0, tmp1);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 361276
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
			sampler2D _HitPointTexture;
			sampler2D _MainTex;
			sampler2D _CameraReflectionsTexture;
			
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
                tmp0 = tex2D(_CameraReflectionsTexture, inp.texcoord1.xy);
                tmp1 = tex2D(_HitPointTexture, inp.texcoord1.xy);
                tmp0.w = tmp1.w > 0.0;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                o.sv_target.w = tmp1.w;
                o.sv_target.xyz = tmp0.www ? tmp2.xyz : tmp0.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 417095
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
			sampler2D _CameraGBufferTexture2;
			sampler2D _CameraGBufferTexture1;
			
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
                tmp0 = tex2D(_CameraGBufferTexture2, inp.texcoord1.xy);
                o.sv_target.xyz = tmp0.xyz;
                tmp0 = tex2D(_CameraGBufferTexture1, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 487049
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
                tmp0 = tex2D(_CameraDepthTexture, inp.texcoord1.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                o.sv_target.x = -tmp0.x;
                o.sv_target.yzw = float3(0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 572758
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
			float _ReflectionBlur;
			int _HighlightSuppression;
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
                const float4 icb[12] = {
                    float4(-0.326212, -0.40581, 0.0, 0.0),
                    float4(-0.840144, -0.07358, 0.0, 0.0),
                    float4(-0.695914, 0.457137, 0.0, 0.0),
                    float4(-0.203345, 0.620716, 0.0, 0.0),
                    float4(0.96234, -0.194983, 0.0, 0.0),
                    float4(0.473434, -0.480026, 0.0, 0.0),
                    float4(0.519456, 0.767022, 0.0, 0.0),
                    float4(0.185461, -0.893124, 0.0, 0.0),
                    float4(0.507431, 0.064425, 0.0, 0.0),
                    float4(0.89642, 0.412458, 0.0, 0.0),
                    float4(-0.32194, -0.932615, 0.0, 0.0),
                    float4(-0.791559, -0.59771, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = _MainTex_TexelSize.x * _ReflectionBlur;
                tmp1 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.y = 0.0;
                for (int i = tmp0.y; i < 12; i += 1) {
                    tmp0.zw = icb[i + 0].xy * tmp0.xx + inp.texcoord1.xy;
                    tmp2 = tex2D(_MainTex, tmp0.zw);
                    tmp3.xyz = tmp2.xyz + float3(1.0, 1.0, 1.0);
                    tmp3.xyz = tmp2.xyz / tmp3.xyz;
                    tmp2.xyz = _HighlightSuppression.xxx ? tmp3.xyz : tmp2.xyz;
                    tmp1 = tmp1 + tmp2;
                }
                tmp0 = tmp1 * float4(0.0833333, 0.0833333, 0.0833333, 0.0833333);
                tmp1.xyz = -tmp1.xyz * float3(0.0833333, 0.0833333, 0.0833333) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp0.xyz / tmp1.xyz;
                o.sv_target.xyz = _HighlightSuppression.xxx ? tmp1.xyz : tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}