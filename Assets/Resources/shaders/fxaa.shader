Shader "Hidden/Post FX/FXAA" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 36608
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
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_TexelSize;
			float3 _QualitySettings;
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2Dlod(_MainTex, float4(tmp0.xy, 0, 0.0));
                tmp2 = _MainTex_TexelSize * float4(0.0, 1.0, 1.0, 0.0) + tmp0.xyxy;
                tmp3 = tex2Dlod(_MainTex, float4(tmp2.xy, 0, 0.0));
                tmp2 = tex2Dlod(_MainTex, float4(tmp2.zw, 0, 0.0));
                tmp4 = _MainTex_TexelSize * float4(0.0, -1.0, -1.0, 0.0) + tmp0.xyxy;
                tmp5 = tex2Dlod(_MainTex, float4(tmp4.xy, 0, 0.0));
                tmp4 = tex2Dlod(_MainTex, float4(tmp4.zw, 0, 0.0));
                tmp0.z = max(tmp1.y, tmp3.y);
                tmp0.w = min(tmp1.y, tmp3.y);
                tmp0.z = max(tmp0.z, tmp2.y);
                tmp0.w = min(tmp0.w, tmp2.y);
                tmp2.x = max(tmp4.y, tmp5.y);
                tmp2.z = min(tmp4.y, tmp5.y);
                tmp0.z = max(tmp0.z, tmp2.x);
                tmp0.w = min(tmp0.w, tmp2.z);
                tmp2.x = tmp0.z * _QualitySettings.y;
                tmp0.z = tmp0.z - tmp0.w;
                tmp0.w = max(tmp2.x, _QualitySettings.z);
                tmp0.w = tmp0.z >= tmp0.w;
                if (tmp0.w) {
                    tmp2.xz = tmp0.xy - _MainTex_TexelSize.xy;
                    tmp6 = tex2Dlod(_MainTex, float4(tmp2.xz, 0, 0.0));
                    tmp2.xz = tmp0.xy + _MainTex_TexelSize.xy;
                    tmp7 = tex2Dlod(_MainTex, float4(tmp2.xz, 0, 0.0));
                    tmp8 = _MainTex_TexelSize * float4(1.0, -1.0, -1.0, 1.0) + tmp0.xyxy;
                    tmp9 = tex2Dlod(_MainTex, float4(tmp8.xy, 0, 0.0));
                    tmp8 = tex2Dlod(_MainTex, float4(tmp8.zw, 0, 0.0));
                    tmp0.w = tmp3.y + tmp5.y;
                    tmp2.x = tmp2.y + tmp4.y;
                    tmp0.z = 1.0 / tmp0.z;
                    tmp2.z = tmp0.w + tmp2.x;
                    tmp0.w = tmp1.y * -2.0 + tmp0.w;
                    tmp2.x = tmp1.y * -2.0 + tmp2.x;
                    tmp2.w = tmp7.y + tmp9.y;
                    tmp3.x = tmp6.y + tmp9.y;
                    tmp3.z = tmp2.y * -2.0 + tmp2.w;
                    tmp3.x = tmp5.y * -2.0 + tmp3.x;
                    tmp3.w = tmp6.y + tmp8.y;
                    tmp4.x = tmp7.y + tmp8.y;
                    tmp0.w = abs(tmp0.w) * 2.0 + abs(tmp3.z);
                    tmp2.x = abs(tmp2.x) * 2.0 + abs(tmp3.x);
                    tmp3.x = tmp4.y * -2.0 + tmp3.w;
                    tmp3.z = tmp3.y * -2.0 + tmp4.x;
                    tmp0.w = tmp0.w + abs(tmp3.x);
                    tmp2.x = tmp2.x + abs(tmp3.z);
                    tmp2.w = tmp2.w + tmp3.w;
                    tmp0.w = tmp0.w >= tmp2.x;
                    tmp2.x = tmp2.z * 2.0 + tmp2.w;
                    tmp2.z = tmp0.w ? tmp5.y : tmp4.y;
                    tmp2.y = tmp0.w ? tmp3.y : tmp2.y;
                    tmp2.w = tmp0.w ? _MainTex_TexelSize.y : _MainTex_TexelSize.x;
                    tmp2.x = tmp2.x * 0.0833333 + -tmp1.y;
                    tmp3.xy = tmp2.zy - tmp1.yy;
                    tmp2.yz = tmp1.yy + tmp2.yz;
                    tmp3.z = abs(tmp3.x) >= abs(tmp3.y);
                    tmp3.x = max(abs(tmp3.y), abs(tmp3.x));
                    tmp2.w = tmp3.z ? -tmp2.w : tmp2.w;
                    tmp0.z = saturate(tmp0.z * abs(tmp2.x));
                    tmp2.x = tmp0.w ? _MainTex_TexelSize.x : 0.0;
                    tmp3.y = tmp0.w ? 0.0 : _MainTex_TexelSize.y;
                    tmp4.xy = tmp2.ww * float2(0.5, 0.5) + tmp0.xy;
                    tmp3.w = tmp0.w ? tmp0.x : tmp4.x;
                    tmp4.x = tmp0.w ? tmp4.y : tmp0.y;
                    tmp5.x = tmp3.w - tmp2.x;
                    tmp5.y = tmp4.x - tmp3.y;
                    tmp6.x = tmp2.x + tmp3.w;
                    tmp6.y = tmp3.y + tmp4.x;
                    tmp3.w = tmp0.z * -2.0 + 3.0;
                    tmp4 = tex2Dlod(_MainTex, float4(tmp5.xy, 0, 0.0));
                    tmp0.z = tmp0.z * tmp0.z;
                    tmp7 = tex2Dlod(_MainTex, float4(tmp6.xy, 0, 0.0));
                    tmp2.y = tmp3.z ? tmp2.z : tmp2.y;
                    tmp2.z = tmp3.x * 0.25;
                    tmp3.x = -tmp2.y * 0.5 + tmp1.y;
                    tmp0.z = tmp0.z * tmp3.w;
                    tmp3.x = tmp3.x < 0.0;
                    tmp4.y = -tmp2.y * 0.5 + tmp4.y;
                    tmp4.x = -tmp2.y * 0.5 + tmp7.y;
                    tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                    tmp5.z = tmp5.x - tmp2.x;
                    tmp5.x = tmp3.z ? tmp5.x : tmp5.z;
                    tmp5.w = tmp5.y - tmp3.y;
                    tmp5.z = tmp3.z ? tmp5.y : tmp5.w;
                    tmp5.yw = ~uint2(tmp3.zw);
                    tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                    tmp5.w = tmp2.x + tmp6.x;
                    tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                    tmp5.w = tmp3.y + tmp6.y;
                    tmp6.z = tmp3.w ? tmp6.y : tmp5.w;
                    if (tmp5.y) {
                        if (!(tmp3.z)) {
                            tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                        } else {
                            tmp7.x = tmp4.y;
                        }
                        if (!(tmp3.w)) {
                            tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                        }
                        tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                        tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                        tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                        tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                        tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                        tmp5.y = tmp5.x - tmp2.x;
                        tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                        tmp5.y = tmp5.z - tmp3.y;
                        tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                        tmp5.yw = ~uint2(tmp3.zw);
                        tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                        tmp5.w = tmp2.x + tmp6.x;
                        tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                        tmp5.w = tmp3.y + tmp6.z;
                        tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                        if (tmp5.y) {
                            if (!(tmp3.z)) {
                                tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                            } else {
                                tmp7.x = tmp4.y;
                            }
                            if (!(tmp3.w)) {
                                tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                            }
                            tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                            tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                            tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                            tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                            tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                            tmp5.y = tmp5.x - tmp2.x;
                            tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                            tmp5.y = tmp5.z - tmp3.y;
                            tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                            tmp5.yw = ~uint2(tmp3.zw);
                            tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                            tmp5.w = tmp2.x + tmp6.x;
                            tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                            tmp5.w = tmp3.y + tmp6.z;
                            tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                            if (tmp5.y) {
                                if (!(tmp3.z)) {
                                    tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                                } else {
                                    tmp7.x = tmp4.y;
                                }
                                if (!(tmp3.w)) {
                                    tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                                }
                                tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                                tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                                tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                                tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                                tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                                tmp5.y = tmp5.x - tmp2.x;
                                tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                                tmp5.y = tmp5.z - tmp3.y;
                                tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                                tmp5.yw = ~uint2(tmp3.zw);
                                tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                                tmp5.w = tmp2.x + tmp6.x;
                                tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                                tmp5.w = tmp3.y + tmp6.z;
                                tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                                if (tmp5.y) {
                                    if (!(tmp3.z)) {
                                        tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                                    } else {
                                        tmp7.x = tmp4.y;
                                    }
                                    if (!(tmp3.w)) {
                                        tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                                    }
                                    tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                                    tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                                    tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                                    tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                                    tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                                    tmp5.y = -tmp2.x * 1.5 + tmp5.x;
                                    tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                                    tmp5.y = -tmp3.y * 1.5 + tmp5.z;
                                    tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                                    tmp5.yw = ~uint2(tmp3.zw);
                                    tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                                    tmp5.w = tmp2.x * 1.5 + tmp6.x;
                                    tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                                    tmp5.w = tmp3.y * 1.5 + tmp6.z;
                                    tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                                    if (tmp5.y) {
                                        if (!(tmp3.z)) {
                                            tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                                        } else {
                                            tmp7.x = tmp4.y;
                                        }
                                        if (!(tmp3.w)) {
                                            tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                                        }
                                        tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                                        tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                                        tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                                        tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                                        tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                                        tmp5.y = -tmp2.x * 2.0 + tmp5.x;
                                        tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                                        tmp5.y = -tmp3.y * 2.0 + tmp5.z;
                                        tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                                        tmp5.yw = ~uint2(tmp3.zw);
                                        tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                                        tmp5.w = tmp2.x * 2.0 + tmp6.x;
                                        tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                                        tmp5.w = tmp3.y * 2.0 + tmp6.z;
                                        tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                                        if (tmp5.y) {
                                            if (!(tmp3.z)) {
                                                tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                                            } else {
                                                tmp7.x = tmp4.y;
                                            }
                                            if (!(tmp3.w)) {
                                                tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                                            }
                                            tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                                            tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                                            tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                                            tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                                            tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                                            tmp5.y = -tmp2.x * 2.0 + tmp5.x;
                                            tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                                            tmp5.y = -tmp3.y * 2.0 + tmp5.z;
                                            tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                                            tmp5.yw = ~uint2(tmp3.zw);
                                            tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                                            tmp5.w = tmp2.x * 2.0 + tmp6.x;
                                            tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                                            tmp5.w = tmp3.y * 2.0 + tmp6.z;
                                            tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                                            if (tmp5.y) {
                                                if (!(tmp3.z)) {
                                                    tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                                                } else {
                                                    tmp7.x = tmp4.y;
                                                }
                                                if (!(tmp3.w)) {
                                                    tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                                                }
                                                tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                                                tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                                                tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                                                tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                                                tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                                                tmp5.y = -tmp2.x * 2.0 + tmp5.x;
                                                tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                                                tmp5.y = -tmp3.y * 2.0 + tmp5.z;
                                                tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                                                tmp5.yw = ~uint2(tmp3.zw);
                                                tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                                                tmp5.w = tmp2.x * 2.0 + tmp6.x;
                                                tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                                                tmp5.w = tmp3.y * 2.0 + tmp6.z;
                                                tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                                                if (tmp5.y) {
                                                    if (!(tmp3.z)) {
                                                        tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                                                    } else {
                                                        tmp7.x = tmp4.y;
                                                    }
                                                    if (!(tmp3.w)) {
                                                        tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                                                    }
                                                    tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                                                    tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                                                    tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                                                    tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                                                    tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                                                    tmp5.y = -tmp2.x * 2.0 + tmp5.x;
                                                    tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                                                    tmp5.y = -tmp3.y * 2.0 + tmp5.z;
                                                    tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                                                    tmp5.yw = ~uint2(tmp3.zw);
                                                    tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                                                    tmp5.w = tmp2.x * 2.0 + tmp6.x;
                                                    tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                                                    tmp5.w = tmp3.y * 2.0 + tmp6.z;
                                                    tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                                                    if (tmp5.y) {
                                                        if (!(tmp3.z)) {
                                                            tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                                                        } else {
                                                            tmp7.x = tmp4.y;
                                                        }
                                                        if (!(tmp3.w)) {
                                                            tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                                                        }
                                                        tmp5.y = -tmp2.y * 0.5 + tmp7.x;
                                                        tmp4.y = tmp3.z ? tmp7.x : tmp5.y;
                                                        tmp3.z = -tmp2.y * 0.5 + tmp4.x;
                                                        tmp4.x = tmp3.w ? tmp4.x : tmp3.z;
                                                        tmp3.zw = abs(tmp4.yx) >= tmp2.zz;
                                                        tmp5.y = -tmp2.x * 4.0 + tmp5.x;
                                                        tmp5.x = tmp3.z ? tmp5.x : tmp5.y;
                                                        tmp5.y = -tmp3.y * 4.0 + tmp5.z;
                                                        tmp5.z = tmp3.z ? tmp5.z : tmp5.y;
                                                        tmp5.yw = ~uint2(tmp3.zw);
                                                        tmp5.y = uint1(tmp5.w) | uint1(tmp5.y);
                                                        tmp5.w = tmp2.x * 4.0 + tmp6.x;
                                                        tmp6.x = tmp3.w ? tmp6.x : tmp5.w;
                                                        tmp5.w = tmp3.y * 4.0 + tmp6.z;
                                                        tmp6.z = tmp3.w ? tmp6.z : tmp5.w;
                                                        if (tmp5.y) {
                                                            if (!(tmp3.z)) {
                                                                tmp7 = tex2Dlod(_MainTex, float4(tmp5.xz, 0, 0.0));
                                                            } else {
                                                                tmp7.x = tmp4.y;
                                                            }
                                                            if (!(tmp3.w)) {
                                                                tmp4 = tex2Dlod(_MainTex, float4(tmp6.xz, 0, 0.0));
                                                            }
                                                            tmp4.z = -tmp2.y * 0.5 + tmp7.x;
                                                            tmp4.y = tmp3.z ? tmp7.x : tmp4.z;
                                                            tmp2.y = -tmp2.y * 0.5 + tmp4.x;
                                                            tmp4.x = tmp3.w ? tmp4.x : tmp2.y;
                                                            tmp2.yz = abs(tmp4.yx) >= tmp2.zz;
                                                            tmp3.z = -tmp2.x * 8.0 + tmp5.x;
                                                            tmp5.x = tmp2.y ? tmp5.x : tmp3.z;
                                                            tmp3.z = -tmp3.y * 8.0 + tmp5.z;
                                                            tmp5.z = tmp2.y ? tmp5.z : tmp3.z;
                                                            tmp2.x = tmp2.x * 8.0 + tmp6.x;
                                                            tmp6.x = tmp2.z ? tmp6.x : tmp2.x;
                                                            tmp2.x = tmp3.y * 8.0 + tmp6.z;
                                                            tmp6.z = tmp2.z ? tmp6.z : tmp2.x;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    tmp2.xz = tmp0.xy - tmp5.xz;
                    tmp2.x = tmp0.w ? tmp2.x : tmp2.z;
                    tmp2.yz = tmp6.xz - tmp0.xy;
                    tmp2.y = tmp0.w ? tmp2.y : tmp2.z;
                    tmp3.yz = tmp4.yx < float2(0.0, 0.0);
                    tmp2.z = tmp2.x + tmp2.y;
                    tmp3.xy = tmp3.xx != tmp3.yz;
                    tmp2.z = 1.0 / tmp2.z;
                    tmp3.z = tmp2.x < tmp2.y;
                    tmp2.x = min(tmp2.y, tmp2.x);
                    tmp2.y = tmp3.z ? tmp3.x : tmp3.y;
                    tmp0.z = tmp0.z * tmp0.z;
                    tmp2.x = tmp2.x * -tmp2.z + 0.5;
                    tmp0.z = tmp0.z * _QualitySettings.x;
                    tmp2.x = tmp2.y ? tmp2.x : 0.0;
                    tmp0.z = max(tmp0.z, tmp2.x);
                    tmp2.xy = tmp0.zz * tmp2.ww + tmp0.xy;
                    tmp3.x = tmp0.w ? tmp0.x : tmp2.x;
                    tmp3.y = tmp0.w ? tmp2.y : tmp0.y;
                    tmp0 = tex2Dlod(_MainTex, float4(tmp3.xy, 0, 0.0));
                    o.sv_target.xyz = tmp0.xyz;
                    o.sv_target.w = tmp1.y;
                } else {
                    o.sv_target = tmp1;
                }
                return o;
			}
			ENDCG
		}
	}
}