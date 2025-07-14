// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "TankiOnline/Hiding/BillboardTree" {
	Properties {
		_MainTex ("Texture Image", 2D) = "white" {}
		_FakeNormal ("FakeNormal", 2D) = "white" {}
		_FoliageMask ("Foliage mask", 2D) = "white" {}
		_Cutoff ("Cutoff", Range(0, 1)) = 0.5
		_TransColor ("Transmission Color", Color) = (1,1,1,1)
		_TransWeight ("Transmission Weight", Range(0, 1)) = 1
		_TransFallof ("Transmission Falloff", Range(0.01, 10)) = 1
		_TransDistortion ("Transmission Distortion", Range(0, 1)) = 1
		_HueVariation ("Hue Variation", Color) = (1,0.5,0,0.1)
		_FrameInfo ("FrameInfo", Vector) = (1,1,0,1)
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+500" "RenderType" = "TransparentCutoff" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+500" "RenderType" = "TransparentCutoff" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			GpuProgramID 27840
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float texcoord4 : TEXCOORD4;
				float3 color1 : COLOR1;
				float2 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float3 _HidingCenter;
			float _MinHidingRadius;
			float _MaxHidingRadius;
			float _HidingSpeed;
			float _HidingStartTime;
			float4 _FrameInfo;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _Cutoff;
			float4 _HueVariation;
			float _TransWeight;
			float _TransFallof;
			float _TransDistortion;
			float4 _TransColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _FoliageMask;
			sampler2D _FakeNormal;
			
			// Keywords: 
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
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                tmp0.x = dot(unity_ObjectToWorld._m02_m12_m22, unity_ObjectToWorld._m02_m12_m22);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * unity_ObjectToWorld._m22_m02_m12;
                tmp1.xyz = unity_ObjectToWorld._m01_m11_m21 * float3(0.5, 0.5, 0.5) + unity_ObjectToWorld._m03_m13_m23;
                tmp2.xyz = tmp1.xyz - _WorldSpaceCameraPos;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.w = rsqrt(tmp0.w);
                tmp3 = tmp0.wwww * unity_ObjectToWorld._m01_m01_m21_m11;
                tmp0.w = dot(tmp2.xyz, tmp3.xyz);
                tmp4.xyz = -tmp0.www * tmp3.wzy + tmp2.yzx;
                tmp0.w = min(tmp0.w, 0.99);
                tmp0.w = max(tmp0.w, -0.99);
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * tmp4.xyz;
                tmp1.w = dot(tmp0.xyz, tmp4.xyz);
                tmp1.w = min(tmp1.w, 0.99);
                tmp5.y = max(tmp1.w, -0.99);
                tmp1.w = abs(tmp5.y) * -0.0187293 + 0.074261;
                tmp1.w = tmp1.w * abs(tmp5.y) + -0.2121144;
                tmp1.w = tmp1.w * abs(tmp5.y) + 1.570729;
                tmp2.w = 1.0 - abs(tmp5.y);
                tmp2.w = sqrt(tmp2.w);
                tmp4.w = tmp1.w * tmp2.w;
                tmp4.w = tmp4.w * -2.0 + 3.141593;
                tmp5.w = tmp5.y < -tmp5.y;
                tmp4.w = tmp5.w ? tmp4.w : 0.0;
                tmp6.z = tmp1.w * tmp2.w + tmp4.w;
                tmp7.xyz = tmp0.xyz * tmp4.xyz;
                tmp0.xyz = tmp0.zxy * tmp4.yzx + -tmp7.xyz;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp1.w = tmp1.w > 0.8;
                tmp2.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = dot(tmp3.xyz, tmp0.xyz);
                tmp0.x = tmp0.x < 0.0;
                tmp0.y = sqrt(tmp2.w);
                tmp6.x = min(tmp0.y, 0.99);
                tmp5.xz = tmp0.xx ? -tmp6.xz : tmp6.xz;
                tmp0.xyz = tmp1.www ? tmp5.xyz : float3(0.0, 1.0, 0.0);
                tmp1.w = 1.0 - tmp0.y;
                tmp4.xyz = tmp1.yzz * tmp3.wzw;
                tmp5.xy = tmp1.xx * tmp3.xx + tmp4.yx;
                tmp6 = tmp3.ywzw * tmp3.ywzy;
                tmp7.xyz = tmp6.zzy + tmp6.yxx;
                tmp8.xyz = tmp1.xyz * tmp7.xyz;
                tmp6.xyz = tmp7.xyz * tmp0.yyy + tmp6.xyz;
                tmp5.xy = -tmp3.wz * tmp5.xy + tmp8.yz;
                tmp5.xy = tmp1.ww * tmp5.xy;
                tmp5.zw = tmp1.xx * tmp3.zw;
                tmp0.y = tmp1.z * tmp3.y + -tmp5.z;
                tmp1.x = -tmp1.y * tmp3.y + tmp5.w;
                tmp1.y = tmp1.y * tmp3.z + -tmp4.z;
                tmp1.z = tmp4.y + tmp4.x;
                tmp1.z = -tmp3.y * tmp1.z + tmp8.x;
                tmp1.y = tmp0.x * tmp1.y;
                tmp4.w = tmp1.z * tmp1.w + tmp1.y;
                tmp7.w = tmp1.x * tmp0.x + tmp5.y;
                tmp5.w = tmp0.y * tmp0.x + tmp5.x;
                tmp5.y = tmp6.y;
                tmp1.xyz = tmp0.xxx * tmp3.zyw;
                tmp0.x = tmp0.z * -0.3183099 + 4.0;
                tmp0.yz = tmp3.zz * tmp3.yw;
                tmp2.xyz = -tmp0.www * tmp3.ywz + tmp2.xyz;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2.x = sqrt(tmp2.x);
                tmp2.x = min(tmp2.x, 0.99);
                tmp7.xy = tmp0.yz * tmp1.ww + -tmp1.zy;
                tmp4.xz = tmp0.zy * tmp1.ww + tmp1.yz;
                tmp5.z = tmp7.y;
                tmp5.x = tmp6.w * tmp1.w + tmp1.x;
                tmp4.y = tmp6.w * tmp1.w + -tmp1.x;
                tmp1.y = dot(tmp5, unity_ObjectToWorld._m00_m10_m20_m30);
                tmp7.y = tmp4.x;
                tmp7.z = tmp6.z;
                tmp4.x = tmp6.x;
                tmp1.z = dot(tmp7, unity_ObjectToWorld._m00_m10_m20_m30);
                tmp1.x = dot(tmp4, unity_ObjectToWorld._m00_m10_m20_m30);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp1 = tmp0.yyyy * tmp1.xxzy;
                tmp0.y = abs(tmp0.w) * -0.0187293 + 0.074261;
                tmp0.y = tmp0.y * abs(tmp0.w) + -0.2121144;
                tmp0.y = tmp0.y * abs(tmp0.w) + 1.570729;
                tmp0.z = 1.0 - abs(tmp0.w);
                tmp0.z = sqrt(tmp0.z);
                tmp2.y = tmp0.z * tmp0.y;
                tmp2.y = tmp2.y * -2.0 + 3.141593;
                tmp2.z = tmp0.w < -tmp0.w;
                tmp2.y = tmp2.z ? tmp2.y : 0.0;
                tmp0.y = tmp0.y * tmp0.z + tmp2.y;
                tmp0.y = 1.570796 - tmp0.y;
                tmp0.y = tmp0.y * 0.3183099;
                tmp0.y = min(tmp0.y, 0.0);
                tmp0.y = tmp0.y + 2.0;
                tmp0.z = floor(tmp0.y);
                tmp0.y = tmp0.y - tmp0.z;
                tmp0.z = tmp0.y < 0.5;
                tmp2.y = asint(_FrameInfo.y);
                tmp2.y = tmp2.y - 1;
                tmp2.y = floor(tmp2.y);
                tmp2.y = 0.5 / tmp2.y;
                tmp2.y = tmp2.y * 0.5;
                tmp2.y = 0.5 / tmp2.y;
                tmp2.z = tmp0.y * tmp2.y;
                tmp0.y = -tmp2.y * tmp0.y + tmp2.y;
                tmp0.y = tmp0.z ? tmp2.z : tmp0.y;
                tmp0.z = _FrameInfo.y - 1.0;
                tmp0.z = tmp0.y / tmp0.z;
                tmp0.z = tmp0.z * 0.5;
                tmp2.yzw = unity_ObjectToWorld._m01_m11_m21 * tmp0.zzz + unity_ObjectToWorld._m03_m13_m23;
                tmp3.xy = tmp1.zw * tmp2.yy;
                tmp0.z = tmp2.w * tmp1.y + -tmp3.x;
                tmp3.x = -tmp2.z * tmp1.y + tmp3.y;
                tmp3.yzw = tmp1.wzw * tmp2.zww;
                tmp6.xy = tmp2.yy * tmp1.xx + tmp3.zy;
                tmp8 = tmp1.ywzw * tmp1.ywzy;
                tmp9.xyz = tmp8.zzy + tmp8.yxx;
                tmp10.xyz = tmp2.yzw * tmp9.xyz;
                tmp8.xyz = tmp9.xyz * tmp2.xxx + tmp8.xyz;
                tmp1.x = 1.0 - tmp2.x;
                tmp2.x = tmp2.z * tmp1.z + -tmp3.w;
                tmp2.y = tmp3.z + tmp3.y;
                tmp2.y = -tmp1.y * tmp2.y + tmp10.x;
                tmp2.zw = -tmp1.wz * tmp6.xy + tmp10.yz;
                tmp2.zw = tmp1.xx * tmp2.zw;
                tmp2.x = -tmp0.w * tmp2.x;
                tmp6.w = tmp2.y * tmp1.x + tmp2.x;
                tmp9.w = tmp0.z * -tmp0.w + tmp2.z;
                tmp2.w = tmp3.x * -tmp0.w + tmp2.w;
                tmp3.xyz = -tmp0.www * tmp1.zyw;
                tmp0.zw = tmp1.zz * tmp1.yw;
                tmp9.y = tmp8.y;
                tmp2.xy = tmp0.zw * tmp1.xx + -tmp3.zy;
                tmp6.xz = tmp0.wz * tmp1.xx + tmp3.yz;
                tmp9.z = tmp2.y;
                tmp9.x = tmp8.w * tmp1.x + tmp3.x;
                tmp6.y = tmp8.w * tmp1.x + -tmp3.x;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp3.y = dot(tmp5, tmp1);
                tmp3.z = dot(tmp7, tmp1);
                tmp3.x = dot(tmp4, tmp1);
                tmp3.w = tmp1.w;
                tmp1.y = dot(tmp9, tmp3);
                tmp2.y = tmp6.x;
                tmp2.z = tmp8.z;
                tmp6.x = tmp8.x;
                tmp1.x = dot(tmp6, tmp3);
                tmp1.z = dot(tmp2, tmp3);
                tmp2.x = min(tmp0.y, 1.0);
                tmp3.xyz = unity_ObjectToWorld._m01_m11_m21 * float3(0.1, 0.1, 0.1);
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp2.yz = float2(1.0, 0.0);
                tmp3.xyz = tmp2.xyx * tmp0.zzz;
                tmp1.xyz = -tmp2.zxz * tmp3.xyz + tmp1.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixV._m01_m11_m21_m31;
                tmp2 = unity_MatrixV._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixV._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1.xyz = tmp1.xyz - _HidingCenter;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp1 = unity_MatrixV._m03_m13_m23_m33 * tmp3.wwww + tmp2;
                tmp2 = tmp1.yyyy * UNITY_MATRIX_P._m01_m11_m21_m31;
                tmp2 = UNITY_MATRIX_P._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = UNITY_MATRIX_P._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = UNITY_MATRIX_P._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.w = floor(tmp0.y);
                o.texcoord5.y = tmp0.y - tmp0.w;
                tmp2.w = asint(tmp0.w);
                tmp2.xy = trunc(_FrameInfo.xy);
                tmp0.y = 2.0 / tmp2.x;
                tmp0.y = 1.0 / tmp0.y;
                tmp1.w = tmp0.x * tmp0.y;
                tmp1.w = floor(tmp1.w);
                tmp2.z = asint(tmp1.w);
                tmp2.zw = tmp2.zw + int2(1, 1);
                tmp2.zw = floor(tmp2.zw);
                tmp2.zw = tmp2.zw / tmp2.xy;
                tmp3.xy = tmp2.zw >= -tmp2.zw;
                tmp2.zw = frac(abs(tmp2.zw));
                tmp2.zw = tmp3.xy ? tmp2.zw : -tmp2.zw;
                tmp2.zw = tmp2.zw * tmp2.xy + v.texcoord.xy;
                o.texcoord.zw = tmp2.zw / tmp2.xy;
                tmp2.z = tmp1.w / tmp2.x;
                o.texcoord5.x = tmp0.y * tmp0.x + -tmp1.w;
                tmp0.x = tmp2.z >= -tmp2.z;
                tmp0.y = frac(abs(tmp2.z));
                tmp0.x = tmp0.x ? tmp0.y : -tmp0.y;
                tmp0.x = tmp0.x * tmp2.x + v.texcoord.x;
                o.texcoord.x = tmp0.x / tmp2.x;
                tmp0.x = tmp0.w / tmp2.y;
                tmp0.y = tmp0.x >= -tmp0.x;
                tmp0.x = frac(abs(tmp0.x));
                tmp0.x = tmp0.y ? tmp0.x : -tmp0.x;
                tmp0.x = tmp0.x * tmp2.y + v.texcoord.y;
                o.texcoord.y = tmp0.x / tmp2.y;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.xyw = tmp1.xyz * tmp0.xxx + float3(0.0, 0.0, 1.0);
                tmp0.xyw = tmp0.xyw * float3(0.5, 0.5, 0.5) + -tmp2.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                o.texcoord2.xyz = tmp0.xyw * tmp1.xxx;
                tmp0.x = _Time.y - _HidingStartTime;
                tmp0.x = saturate(tmp0.x * _HidingSpeed);
                tmp0.y = _MaxHidingRadius - _MinHidingRadius;
                tmp0.x = tmp0.x * tmp0.y + _MinHidingRadius;
                o.texcoord4.x = saturate(tmp0.z / tmp0.x);
                tmp0.x = dot(unity_SHAr.xy, float2(1.0, 1.0));
                tmp0.y = dot(unity_SHAg.xy, float2(1.0, 1.0));
                tmp0.z = dot(unity_SHAb.xy, float2(1.0, 1.0));
                o.color1.xyz = tmp0.xyz - unity_SHC.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.zw);
                tmp1 = tex2D(_MainTex, inp.texcoord.zy);
                tmp0 = tmp0 - tmp1;
                tmp0 = inp.texcoord5.yyyy * tmp0 + tmp1;
                tmp1 = tex2D(_MainTex, inp.texcoord.xw);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 - tmp2;
                tmp1 = inp.texcoord5.yyyy * tmp1 + tmp2;
                tmp0 = tmp0 - tmp1;
                tmp0 = inp.texcoord5.xxxx * tmp0.wxyz + tmp1.wxyz;
                tmp0.x = saturate(tmp0.x);
                tmp1.x = tmp0.x - _Cutoff;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp1.x = tmp1.x + unity_ObjectToWorld._m23;
                tmp2 = tex2D(_FoliageMask, inp.texcoord.zw);
                tmp3 = tex2D(_FoliageMask, inp.texcoord.zy);
                tmp2 = tmp2 - tmp3;
                tmp2 = inp.texcoord5.yyyy * tmp2 + tmp3;
                tmp3 = tex2D(_FoliageMask, inp.texcoord.xw);
                tmp4 = tex2D(_FoliageMask, inp.texcoord.xy);
                tmp3 = tmp3 - tmp4;
                tmp3 = inp.texcoord5.yyyy * tmp3 + tmp4;
                tmp2 = tmp2 - tmp3;
                tmp2 = inp.texcoord5.xxxx * tmp2.wxyz + tmp3.wxyz;
                tmp1.x = tmp2.y * 3.0 + tmp1.x;
                tmp1.y = floor(tmp1.x);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = tmp2.z * 0.5 + tmp1.x;
                tmp1.x = tmp1.x - 0.3;
                tmp1.x = saturate(tmp1.x * _HueVariation.w);
                tmp1.yzw = _HueVariation.xyz - tmp0.yzw;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + tmp0.yzw;
                tmp1.w = max(tmp1.z, tmp1.y);
                tmp1.w = max(tmp1.w, tmp1.x);
                tmp2.y = max(tmp0.w, tmp0.z);
                tmp2.y = max(tmp0.y, tmp2.y);
                tmp1.w = tmp2.y / tmp1.w;
                tmp1.w = tmp1.w * 0.5 + 0.5;
                tmp1.xyz = saturate(tmp1.www * tmp1.xyz);
                tmp1.xyz = tmp1.xyz - tmp0.yzw;
                tmp2.x = saturate(tmp2.x);
                tmp0.yzw = tmp2.xxx * tmp1.xyz + tmp0.yzw;
                tmp1 = tex2D(_FakeNormal, inp.texcoord.zw);
                tmp1.xy = tmp1.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp1.xy, tmp1.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.z = sqrt(tmp1.w);
                tmp3 = tex2D(_FakeNormal, inp.texcoord.zy);
                tmp2.xy = tmp3.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.z = sqrt(tmp1.w);
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp1.xyz = inp.texcoord5.yyy * tmp1.xyz + tmp2.xyz;
                tmp3 = tex2D(_FakeNormal, inp.texcoord.xw);
                tmp2.xy = tmp3.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.z = sqrt(tmp1.w);
                tmp3 = tex2D(_FakeNormal, inp.texcoord.xy);
                tmp3.xy = tmp3.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp3.xy, tmp3.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.z = sqrt(tmp1.w);
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = inp.texcoord5.yyy * tmp2.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp1.xyz = inp.texcoord5.xxx * tmp1.xyz + tmp2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = dot(_WorldSpaceLightPos0, unity_MatrixV._m00_m10_m20_m30);
                tmp2.y = dot(_WorldSpaceLightPos0, unity_MatrixV._m01_m11_m21_m31);
                tmp2.z = dot(_WorldSpaceLightPos0, unity_MatrixV._m02_m12_m22_m32);
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp3.xyz = tmp1.xyz * _TransDistortion.xxx + tmp2.xyz;
                tmp1.x = dot(tmp2.xyz, tmp1.xyz);
                tmp1.yzw = inp.texcoord2.xyz - float3(-0.0, 0.1, -0.0);
                tmp1.y = dot(tmp1.xyz, -tmp3.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = log(tmp1.y);
                tmp1.y = tmp1.y * _TransFallof;
                tmp1.y = exp(tmp1.y);
                tmp0.x = tmp0.x * tmp1.y;
                tmp1.yzw = tmp0.xxx * _TransColor.xyz;
                tmp2.xyz = tmp0.yzw * _LightColor0.xyz;
                tmp1.yzw = tmp1.yzw * tmp2.xyz;
                tmp1.yzw = tmp1.yzw * _TransWeight.xxx;
                tmp1.yzw = tmp1.yzw + tmp1.yzw;
                tmp0.x = tmp1.x * 0.5 + 0.5;
                tmp1.x = saturate(tmp1.x);
                tmp1.yzw = _LightColor0.xyz * tmp0.xxx + tmp1.yzw;
                tmp0.x = tmp1.x * tmp1.x;
                tmp0.x = tmp1.x * tmp0.x;
                tmp1.x = tmp2.w * tmp2.w;
                tmp1.x = tmp1.x * tmp1.x;
                tmp2.x = tmp2.w * tmp2.w + -tmp1.x;
                tmp0.x = tmp0.x * tmp2.x + tmp1.x;
                tmp2.xyz = inp.color1.xyz + float3(0.1, 0.1, 0.1);
                tmp1.xyz = tmp1.yzw * tmp0.xxx + tmp2.xyz;
                o.sv_target.xyz = tmp0.yzw * tmp1.xyz;
                o.sv_target.w = inp.texcoord4.x;
                return o;
			}
			ENDCG
		}
	}
}