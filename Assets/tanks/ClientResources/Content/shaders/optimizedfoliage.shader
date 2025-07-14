Shader "TankiOnline/OptimizedFoliage" {
	Properties {
		_HueVariation ("Hue Variation", Color) = (1,0.5,0,0.1)
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Opaque (A)", 2D) = "white" {}
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
		_TransColor ("Transmission Color", Color) = (1,1,1,1)
		_TransWeight ("Transmission Weight", Range(0, 1)) = 1
		_TransFallof ("Transmission Falloff", Range(0.01, 10)) = 1
		_TransDistortion ("Transmission Distortion", Range(0, 1)) = 1
		[Space] _ShadowIntensity ("Shadow Intensity", Range(0, 1)) = 1
		_ShadowFixOffset ("Shadow Fix Offset", Float) = 0
		[Space] _WindShakeTime ("Wind Shake Time", Range(0, 5)) = 1
		_WindShakeWindspeed ("Wind Shake Windspeed", Range(0, 5)) = 1
		_WindShakeBending ("Wind Shake Bending", Range(0, 5)) = 1
	}
	SubShader {
		LOD 510
		Tags { "PerformanceChecks" = "False" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			LOD 510
			Tags { "LIGHTMODE" = "FORWARDBASE" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 36786
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
				float3 color : COLOR0;
				float3 color1 : COLOR1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _LightColor0;
			float _WindShakeTime;
			float _WindShakeWindspeed;
			float _WindShakeBending;
			float4 _HueVariation;
			float4 _MainTex_ST;
			float4 _TransColor;
			float _TransWeight;
			float _TransFallof;
			float _TransDistortion;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.zzzz * float4(0.024, 0.08, 0.08, 0.2);
                tmp0 = v.vertex.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp0;
                tmp1.x = _WindShakeTime + _WindShakeTime;
                tmp1.x = -tmp1.x * _Time.x;
                tmp1.yz = float2(_WindShakeWindspeed.x, _WindShakeBending.x) + float2(1.0, 1.0);
                tmp1.w = tmp1.y * tmp1.x;
                tmp1.x = tmp1.x * 2.0;
                tmp2.y = tmp1.y * tmp1.x;
                tmp1.x = tmp1.z * v.texcoord.y;
                tmp2.xzw = tmp1.www * float3(1.2, 1.6, 4.8);
                tmp0 = tmp0 + tmp2;
                tmp0 = frac(tmp0);
                tmp0 = tmp0 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp2 = tmp0 * tmp0;
                tmp3 = tmp0 * tmp2;
                tmp0 = tmp3 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp0;
                tmp3 = tmp2 * tmp3;
                tmp2 = tmp2 * tmp3;
                tmp0 = tmp3 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp0;
                tmp0 = tmp2 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp0;
                tmp0 = tmp1.xxxx * tmp0;
                tmp0 = tmp0 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp0 = tmp0 * tmp0;
                tmp0 = tmp0 * tmp0;
                tmp1.x = dot(tmp0, float4(0.006, 0.02, -0.02, 0.1));
                tmp0.x = dot(tmp0, float4(0.024, 0.04, -0.12, 0.096));
                tmp0.yz = tmp1.xx * unity_WorldToObject._m02_m22;
                tmp0.xy = unity_WorldToObject._m00_m20 * tmp0.xx + tmp0.yz;
                tmp0.xy = v.vertex.xz - tmp0.xy;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.yyyy + tmp1;
                tmp0.x = tmp0.x + v.normal.y;
                tmp0.x = tmp0.x + v.normal.x;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.yzw = _WorldSpaceCameraPos - tmp1.xyz;
                o.texcoord1 = tmp1;
                o.texcoord.xyz = tmp0.yzw;
                o.texcoord.w = 0.0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
                tmp2.x = floor(tmp0.x);
                tmp0.x = tmp0.x - tmp2.x;
                tmp2.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp2.x = tmp2.x + unity_ObjectToWorld._m23;
                tmp2.x = tmp2.x + v.color.x;
                tmp2.x = tmp2.x + v.color.y;
                tmp2.x = tmp2.x + v.color.z;
                tmp2.y = floor(tmp2.x);
                tmp2.x = tmp2.x - tmp2.y;
                tmp0.x = tmp0.x * 0.5 + tmp2.x;
                tmp0.x = tmp0.x - 0.3;
                o.texcoord7.y = saturate(tmp0.x * _HueVariation.w);
                o.texcoord7.x = 0.0;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.yzw * tmp0.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = tmp0.w + 0.5;
                tmp2.x = dot(tmp1.xyz, tmp0.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.y = tmp2.x * -5.55473 + -6.98316;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = exp(tmp2.x);
                tmp2.y = 1.0 - tmp2.x;
                tmp2.x = tmp0.w * tmp2.x + tmp2.y;
                tmp2.y = dot(tmp1.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.y = max(tmp2.y, 0.0);
                tmp2.z = tmp2.y * -5.55473 + -6.98316;
                tmp2.z = tmp2.y * tmp2.z;
                tmp3.xyz = tmp2.yyy * _LightColor0.xyz;
                tmp2.y = exp(tmp2.z);
                tmp2.z = 1.0 - tmp2.y;
                tmp0.w = tmp0.w * tmp2.y + tmp2.z;
                tmp0.w = tmp2.x * tmp0.w;
                tmp2.xyz = tmp1.xyz * _TransDistortion.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp0.xyz, -tmp2.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _TransFallof;
                tmp0.x = exp(tmp0.x);
                tmp2.xyz = _TransColor.xyz * _TransWeight.xxx;
                tmp0.xyz = tmp0.xxx * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                o.color.xyz = tmp3.xyz * tmp0.www + tmp0.xyz;
                tmp0.x = tmp1.y * tmp1.y;
                tmp0.x = tmp1.x * tmp1.x + -tmp0.x;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp0.xyz = unity_SHC.xyz * tmp0.xxx + tmp3.xyz;
                tmp1.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp1);
                tmp2.y = dot(unity_SHAg, tmp1);
                tmp2.z = dot(unity_SHAb, tmp1);
                o.color1.xyz = tmp0.xyz + tmp2.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0.w = _Color.w * tmp0.w + -_Cutoff;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp1.xyz = -_Color.xyz * tmp0.xyz + _HueVariation.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xyz = inp.texcoord7.yyy * tmp1.xyz + tmp0.xyz;
                tmp0.w = max(tmp1.z, tmp1.y);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.y = max(tmp0.z, tmp0.y);
                tmp0.x = max(tmp0.y, tmp0.x);
                tmp0.x = tmp0.x / tmp0.w;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.xyz = saturate(tmp0.xxx * tmp1.xyz);
                tmp1.xyz = inp.color.xyz + inp.color1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = min(tmp0.xyz, float3(32.0, 32.0, 32.0));
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 510
			Tags { "LIGHTMODE" = "FORWARDADD" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 128899
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
				float3 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float _WindShakeTime;
			float _WindShakeWindspeed;
			float _WindShakeBending;
			float4 _HueVariation;
			float4 _MainTex_ST;
			float4 _TransColor;
			float _TransWeight;
			float _TransFallof;
			float _TransDistortion;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _MainTex;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.zzzz * float4(0.024, 0.08, 0.08, 0.2);
                tmp0 = v.vertex.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp0;
                tmp1.x = _WindShakeTime + _WindShakeTime;
                tmp1.x = -tmp1.x * _Time.x;
                tmp1.yz = float2(_WindShakeWindspeed.x, _WindShakeBending.x) + float2(1.0, 1.0);
                tmp1.w = tmp1.y * tmp1.x;
                tmp1.x = tmp1.x * 2.0;
                tmp2.y = tmp1.y * tmp1.x;
                tmp1.x = tmp1.z * v.texcoord.y;
                tmp2.xzw = tmp1.www * float3(1.2, 1.6, 4.8);
                tmp0 = tmp0 + tmp2;
                tmp0 = frac(tmp0);
                tmp0 = tmp0 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp2 = tmp0 * tmp0;
                tmp3 = tmp0 * tmp2;
                tmp0 = tmp3 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp0;
                tmp3 = tmp2 * tmp3;
                tmp2 = tmp2 * tmp3;
                tmp0 = tmp3 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp0;
                tmp0 = tmp2 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp0;
                tmp0 = tmp1.xxxx * tmp0;
                tmp0 = tmp0 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp0 = tmp0 * tmp0;
                tmp0 = tmp0 * tmp0;
                tmp1.x = dot(tmp0, float4(0.006, 0.02, -0.02, 0.1));
                tmp0.x = dot(tmp0, float4(0.024, 0.04, -0.12, 0.096));
                tmp0.yz = tmp1.xx * unity_WorldToObject._m02_m22;
                tmp0.xy = unity_WorldToObject._m00_m20 * tmp0.xx + tmp0.yz;
                tmp0.xy = v.vertex.xz - tmp0.xy;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.yyyy + tmp1;
                tmp0.x = tmp0.x + v.normal.y;
                tmp0.x = tmp0.x + v.normal.x;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.yzw = _WorldSpaceCameraPos - tmp1.xyz;
                o.texcoord.xyz = tmp0.yzw;
                o.texcoord.w = 0.0;
                o.texcoord1 = tmp1;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                o.texcoord2.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.yyy * unity_WorldToLight._m01_m11_m21;
                tmp3.xyz = unity_WorldToLight._m00_m10_m20 * tmp1.xxx + tmp3.xyz;
                tmp3.xyz = unity_WorldToLight._m02_m12_m22 * tmp1.zzz + tmp3.xyz;
                o.texcoord3.xyz = unity_WorldToLight._m03_m13_m23 * tmp1.www + tmp3.xyz;
                tmp1.xyz = _WorldSpaceLightPos0.xyz - tmp1.xyz;
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
                tmp1.w = floor(tmp0.x);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp1.w = tmp1.w + unity_ObjectToWorld._m23;
                tmp1.w = tmp1.w + v.color.x;
                tmp1.w = tmp1.w + v.color.y;
                tmp1.w = tmp1.w + v.color.z;
                tmp2.w = floor(tmp1.w);
                tmp1.w = tmp1.w - tmp2.w;
                tmp0.x = tmp0.x * 0.5 + tmp1.w;
                tmp0.x = tmp0.x - 0.3;
                o.texcoord7.y = saturate(tmp0.x * _HueVariation.w);
                o.texcoord7.x = 0.0;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = tmp0.w + 0.5;
                tmp1.w = dot(tmp2.xyz, tmp0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp2.w = tmp1.w * -5.55473 + -6.98316;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = exp(tmp1.w);
                tmp2.w = 1.0 - tmp1.w;
                tmp1.w = tmp0.w * tmp1.w + tmp2.w;
                tmp2.w = dot(tmp2.xyz, tmp1.xyz);
                tmp1.xyz = tmp2.xyz * _TransDistortion.xxx + tmp1.xyz;
                tmp0.x = dot(tmp0.xyz, -tmp1.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _TransFallof;
                tmp0.x = exp(tmp0.x);
                tmp0.y = max(tmp2.w, 0.0);
                tmp0.z = tmp0.y * -5.55473 + -6.98316;
                tmp0.z = tmp0.y * tmp0.z;
                tmp1.xyz = tmp0.yyy * _LightColor0.xyz;
                tmp0.y = exp(tmp0.z);
                tmp0.z = 1.0 - tmp0.y;
                tmp0.y = tmp0.w * tmp0.y + tmp0.z;
                tmp0.y = tmp1.w * tmp0.y;
                tmp2.xyz = _TransColor.xyz * _TransWeight.xxx;
                tmp0.xzw = tmp0.xxx * tmp2.xyz;
                tmp0.xzw = tmp0.xzw * _LightColor0.xyz;
                o.color.xyz = tmp1.xyz * tmp0.yyy + tmp0.xzw;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0.w = _Color.w * tmp0.w + -_Cutoff;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp1.xyz = -_Color.xyz * tmp0.xyz + _HueVariation.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xyz = inp.texcoord7.yyy * tmp1.xyz + tmp0.xyz;
                tmp0.w = max(tmp1.z, tmp1.y);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.y = max(tmp0.z, tmp0.y);
                tmp0.x = max(tmp0.y, tmp0.x);
                tmp0.x = tmp0.x / tmp0.w;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.xyz = saturate(tmp0.xxx * tmp1.xyz);
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp1 = tex2D(_LightTexture0, tmp0.ww);
                tmp1.xyz = tmp1.xxx * inp.color.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = min(tmp0.xyz, float3(32.0, 32.0, 32.0));
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "SHADOWCASTER"
			LOD 510
			Tags { "LIGHTMODE" = "SHADOWCASTER" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 176683
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 texcoord6 : TEXCOORD6;
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _WindShakeTime;
			float _WindShakeWindspeed;
			float _WindShakeBending;
			float4 _MainTex_ST;
			float _ShadowFixOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			float4 _Color;
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
                tmp0.x = unity_LightShadowBias.z != 0.0;
                if (tmp0.x) {
                    tmp1 = unity_ObjectToWorld._m10_m10_m10_m10 * unity_MatrixV._m01_m11_m21_m31;
                    tmp1 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                    tmp1 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                    tmp1 = unity_MatrixV._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                    tmp2 = unity_ObjectToWorld._m11_m11_m11_m11 * unity_MatrixV._m01_m11_m21_m31;
                    tmp2 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp2;
                    tmp2 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp2;
                    tmp2 = unity_MatrixV._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp2;
                    tmp3 = unity_ObjectToWorld._m12_m12_m12_m12 * unity_MatrixV._m01_m11_m21_m31;
                    tmp3 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp3;
                    tmp3 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp3;
                    tmp3 = unity_MatrixV._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp3;
                    tmp4 = unity_ObjectToWorld._m13_m13_m13_m13 * unity_MatrixV._m01_m11_m21_m31;
                    tmp4 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp4;
                    tmp4 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp4;
                    tmp4 = unity_MatrixV._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp4;
                    tmp2 = tmp2 * v.vertex.yyyy;
                    tmp1 = tmp1 * v.vertex.xxxx + tmp2;
                    tmp1 = tmp3 * v.vertex.zzzz + tmp1;
                    tmp1 = tmp4 * v.vertex.wwww + tmp1;
                    tmp0.y = tmp1.z - _ShadowFixOffset;
                    tmp2 = unity_WorldToObject._m01_m11_m21_m31 * unity_MatrixInvV._m10_m10_m10_m10;
                    tmp2 = unity_WorldToObject._m00_m10_m20_m30 * unity_MatrixInvV._m00_m00_m00_m00 + tmp2;
                    tmp2 = unity_WorldToObject._m02_m12_m22_m32 * unity_MatrixInvV._m20_m20_m20_m20 + tmp2;
                    tmp2 = unity_WorldToObject._m03_m13_m23_m33 * unity_MatrixInvV._m30_m30_m30_m30 + tmp2;
                    tmp3 = unity_WorldToObject._m01_m11_m21_m31 * unity_MatrixInvV._m11_m11_m11_m11;
                    tmp3 = unity_WorldToObject._m00_m10_m20_m30 * unity_MatrixInvV._m01_m01_m01_m01 + tmp3;
                    tmp3 = unity_WorldToObject._m02_m12_m22_m32 * unity_MatrixInvV._m21_m21_m21_m21 + tmp3;
                    tmp3 = unity_WorldToObject._m03_m13_m23_m33 * unity_MatrixInvV._m31_m31_m31_m31 + tmp3;
                    tmp4 = unity_WorldToObject._m01_m11_m21_m31 * unity_MatrixInvV._m12_m12_m12_m12;
                    tmp4 = unity_WorldToObject._m00_m10_m20_m30 * unity_MatrixInvV._m02_m02_m02_m02 + tmp4;
                    tmp4 = unity_WorldToObject._m02_m12_m22_m32 * unity_MatrixInvV._m22_m22_m22_m22 + tmp4;
                    tmp4 = unity_WorldToObject._m03_m13_m23_m33 * unity_MatrixInvV._m32_m32_m32_m32 + tmp4;
                    tmp5 = unity_WorldToObject._m01_m11_m21_m31 * unity_MatrixInvV._m13_m13_m13_m13;
                    tmp5 = unity_WorldToObject._m00_m10_m20_m30 * unity_MatrixInvV._m03_m03_m03_m03 + tmp5;
                    tmp5 = unity_WorldToObject._m02_m12_m22_m32 * unity_MatrixInvV._m23_m23_m23_m23 + tmp5;
                    tmp5 = unity_WorldToObject._m03_m13_m23_m33 * unity_MatrixInvV._m33_m33_m33_m33 + tmp5;
                    tmp3 = tmp1.yyyy * tmp3;
                    tmp2 = tmp1.xxxx * tmp2 + tmp3;
                    tmp2 = tmp0.yyyy * tmp4 + tmp2;
                    tmp1 = tmp1.wwww * tmp5.xzyw + tmp2.xzyw;
                } else {
                    tmp1 = v.vertex.xzyw;
                }
                tmp0.yz = float2(_WindShakeWindspeed.x, _WindShakeBending.x) + float2(1.0, 1.0);
                tmp2 = tmp1.yyyy * float4(0.024, 0.08, 0.08, 0.2);
                tmp2 = tmp1.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp2;
                tmp0.w = _WindShakeTime + _WindShakeTime;
                tmp0.w = -tmp0.w * _Time.x;
                tmp0.y = tmp0.y * tmp0.w;
                tmp2 = tmp0.yyyy * float4(1.2, 2.0, 1.6, 4.8) + tmp2;
                tmp2 = frac(tmp2);
                tmp2 = tmp2 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp3 = tmp2 * tmp2;
                tmp4 = tmp2 * tmp3;
                tmp5 = tmp3 * tmp4;
                tmp3 = tmp3 * tmp5;
                tmp2 = tmp4 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp2;
                tmp2 = tmp5 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp2;
                tmp2 = tmp3 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp2;
                tmp0.y = tmp0.z * v.texcoord.y;
                tmp2 = tmp0.yyyy * tmp2;
                tmp2 = tmp2 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp2 = tmp2 * tmp2;
                tmp2 = tmp2 * tmp2;
                tmp0.y = dot(tmp2, float4(0.024, 0.04, -0.12, 0.096));
                tmp0.z = dot(tmp2, float4(0.006, 0.02, -0.02, 0.1));
                tmp0.zw = tmp0.zz * unity_WorldToObject._m02_m22;
                tmp0.yz = unity_WorldToObject._m00_m20 * tmp0.yy + tmp0.zw;
                tmp0.yz = tmp1.xy - tmp0.yz;
                tmp2 = tmp1.zzzz * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp2;
                tmp2 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp2;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp2.xyz, tmp2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp2.xyz;
                tmp2.xyz = -tmp1.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.x = dot(tmp0.xyz, tmp2.xyz);
                tmp2.x = -tmp2.x * tmp2.x + 1.0;
                tmp2.x = sqrt(tmp2.x);
                tmp2.x = tmp2.x * unity_LightShadowBias.z;
                tmp0.yzw = -tmp0.yzw * tmp2.xxx + tmp1.xyz;
                tmp0.xyz = tmp0.xxx ? tmp0.yzw : tmp1.xyz;
                tmp2 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp2;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                tmp1.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp1.x + tmp0.z;
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
                o.position.xyw = tmp0.xyw;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0.x = _Color.w * tmp0.w + -_Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		LOD 500
		Tags { "PerformanceChecks" = "False" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			LOD 500
			Tags { "LIGHTMODE" = "FORWARDBASE" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 227689
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
				float3 color : COLOR0;
				float3 color1 : COLOR1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _LightColor0;
			float _WindShakeTime;
			float _WindShakeWindspeed;
			float _WindShakeBending;
			float4 _HueVariation;
			float4 _MainTex_ST;
			float4 _TransColor;
			float _TransWeight;
			float _TransFallof;
			float _TransDistortion;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.zzzz * float4(0.024, 0.08, 0.08, 0.2);
                tmp0 = v.vertex.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp0;
                tmp1.x = _WindShakeTime + _WindShakeTime;
                tmp1.x = -tmp1.x * _Time.x;
                tmp1.yz = float2(_WindShakeWindspeed.x, _WindShakeBending.x) + float2(1.0, 1.0);
                tmp1.w = tmp1.y * tmp1.x;
                tmp1.x = tmp1.x * 2.0;
                tmp2.y = tmp1.y * tmp1.x;
                tmp1.x = tmp1.z * v.texcoord.y;
                tmp2.xzw = tmp1.www * float3(1.2, 1.6, 4.8);
                tmp0 = tmp0 + tmp2;
                tmp0 = frac(tmp0);
                tmp0 = tmp0 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp2 = tmp0 * tmp0;
                tmp3 = tmp0 * tmp2;
                tmp0 = tmp3 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp0;
                tmp3 = tmp2 * tmp3;
                tmp2 = tmp2 * tmp3;
                tmp0 = tmp3 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp0;
                tmp0 = tmp2 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp0;
                tmp0 = tmp1.xxxx * tmp0;
                tmp0 = tmp0 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp0 = tmp0 * tmp0;
                tmp0 = tmp0 * tmp0;
                tmp1.x = dot(tmp0, float4(0.006, 0.02, -0.02, 0.1));
                tmp0.x = dot(tmp0, float4(0.024, 0.04, -0.12, 0.096));
                tmp0.yz = tmp1.xx * unity_WorldToObject._m02_m22;
                tmp0.xy = unity_WorldToObject._m00_m20 * tmp0.xx + tmp0.yz;
                tmp0.xy = v.vertex.xz - tmp0.xy;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.yyyy + tmp1;
                tmp0.x = tmp0.x + v.normal.y;
                tmp0.x = tmp0.x + v.normal.x;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.yzw = _WorldSpaceCameraPos - tmp1.xyz;
                o.texcoord1 = tmp1;
                o.texcoord.xyz = tmp0.yzw;
                o.texcoord.w = 0.0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.x = tmp1.y * tmp1.y;
                tmp2.x = tmp1.x * tmp1.x + -tmp2.x;
                tmp3 = tmp1.yzzx * tmp1.xyzz;
                tmp4.x = dot(unity_SHBr, tmp3);
                tmp4.y = dot(unity_SHBg, tmp3);
                tmp4.z = dot(unity_SHBb, tmp3);
                tmp2.xyz = unity_SHC.xyz * tmp2.xxx + tmp4.xyz;
                o.texcoord3.xyz = tmp2.xyz;
                o.texcoord3.w = 0.0;
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
                tmp2.w = floor(tmp0.x);
                tmp0.x = tmp0.x - tmp2.w;
                tmp2.w = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp2.w = tmp2.w + unity_ObjectToWorld._m23;
                tmp2.w = tmp2.w + v.color.x;
                tmp2.w = tmp2.w + v.color.y;
                tmp2.w = tmp2.w + v.color.z;
                tmp3.x = floor(tmp2.w);
                tmp2.w = tmp2.w - tmp3.x;
                tmp0.x = tmp0.x * 0.5 + tmp2.w;
                tmp0.x = tmp0.x - 0.3;
                o.texcoord7.y = saturate(tmp0.x * _HueVariation.w);
                o.texcoord7.x = 0.0;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.yzw * tmp0.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = tmp0.w + 0.5;
                tmp2.w = dot(tmp1.xyz, tmp0.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp3.x = tmp2.w * -5.55473 + -6.98316;
                tmp2.w = tmp2.w * tmp3.x;
                tmp2.w = exp(tmp2.w);
                tmp3.x = 1.0 - tmp2.w;
                tmp2.w = tmp0.w * tmp2.w + tmp3.x;
                tmp3.x = dot(tmp1.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.x = max(tmp3.x, 0.0);
                tmp3.y = tmp3.x * -5.55473 + -6.98316;
                tmp3.y = tmp3.x * tmp3.y;
                tmp3.xzw = tmp3.xxx * _LightColor0.xyz;
                tmp3.y = exp(tmp3.y);
                tmp4.x = 1.0 - tmp3.y;
                tmp0.w = tmp0.w * tmp3.y + tmp4.x;
                tmp0.w = tmp2.w * tmp0.w;
                tmp4.xyz = tmp1.xyz * _TransDistortion.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp0.xyz, -tmp4.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _TransFallof;
                tmp0.x = exp(tmp0.x);
                tmp4.xyz = _TransColor.xyz * _TransWeight.xxx;
                tmp0.xyz = tmp0.xxx * tmp4.xyz;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                o.color.xyz = tmp3.xzw * tmp0.www + tmp0.xyz;
                tmp1.w = 1.0;
                tmp0.x = dot(unity_SHAr, tmp1);
                tmp0.y = dot(unity_SHAg, tmp1);
                tmp0.z = dot(unity_SHAb, tmp1);
                o.color1.xyz = tmp2.xyz + tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0.w = _Color.w * tmp0.w + -_Cutoff;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp1.xyz = -_Color.xyz * tmp0.xyz + _HueVariation.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xyz = inp.texcoord7.yyy * tmp1.xyz + tmp0.xyz;
                tmp0.w = max(tmp1.z, tmp1.y);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.y = max(tmp0.z, tmp0.y);
                tmp0.x = max(tmp0.y, tmp0.x);
                tmp0.x = tmp0.x / tmp0.w;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.xyz = saturate(tmp0.xxx * tmp1.xyz);
                tmp1.xyz = inp.color.xyz + inp.color1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = min(tmp0.xyz, float3(32.0, 32.0, 32.0));
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "SHADOWCASTER"
			LOD 500
			Tags { "LIGHTMODE" = "SHADOWCASTER" "PerformanceChecks" = "False" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 277512
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 texcoord6 : TEXCOORD6;
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _WindShakeTime;
			float _WindShakeWindspeed;
			float _WindShakeBending;
			float4 _MainTex_ST;
			float _ShadowFixOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			float4 _Color;
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
                tmp0.x = unity_LightShadowBias.z != 0.0;
                if (tmp0.x) {
                    tmp1 = unity_ObjectToWorld._m10_m10_m10_m10 * unity_MatrixV._m01_m11_m21_m31;
                    tmp1 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                    tmp1 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                    tmp1 = unity_MatrixV._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                    tmp2 = unity_ObjectToWorld._m11_m11_m11_m11 * unity_MatrixV._m01_m11_m21_m31;
                    tmp2 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp2;
                    tmp2 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp2;
                    tmp2 = unity_MatrixV._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp2;
                    tmp3 = unity_ObjectToWorld._m12_m12_m12_m12 * unity_MatrixV._m01_m11_m21_m31;
                    tmp3 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp3;
                    tmp3 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp3;
                    tmp3 = unity_MatrixV._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp3;
                    tmp4 = unity_ObjectToWorld._m13_m13_m13_m13 * unity_MatrixV._m01_m11_m21_m31;
                    tmp4 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp4;
                    tmp4 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp4;
                    tmp4 = unity_MatrixV._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp4;
                    tmp2 = tmp2 * v.vertex.yyyy;
                    tmp1 = tmp1 * v.vertex.xxxx + tmp2;
                    tmp1 = tmp3 * v.vertex.zzzz + tmp1;
                    tmp1 = tmp4 * v.vertex.wwww + tmp1;
                    tmp0.y = tmp1.z - _ShadowFixOffset;
                    tmp2 = unity_WorldToObject._m01_m11_m21_m31 * unity_MatrixInvV._m10_m10_m10_m10;
                    tmp2 = unity_WorldToObject._m00_m10_m20_m30 * unity_MatrixInvV._m00_m00_m00_m00 + tmp2;
                    tmp2 = unity_WorldToObject._m02_m12_m22_m32 * unity_MatrixInvV._m20_m20_m20_m20 + tmp2;
                    tmp2 = unity_WorldToObject._m03_m13_m23_m33 * unity_MatrixInvV._m30_m30_m30_m30 + tmp2;
                    tmp3 = unity_WorldToObject._m01_m11_m21_m31 * unity_MatrixInvV._m11_m11_m11_m11;
                    tmp3 = unity_WorldToObject._m00_m10_m20_m30 * unity_MatrixInvV._m01_m01_m01_m01 + tmp3;
                    tmp3 = unity_WorldToObject._m02_m12_m22_m32 * unity_MatrixInvV._m21_m21_m21_m21 + tmp3;
                    tmp3 = unity_WorldToObject._m03_m13_m23_m33 * unity_MatrixInvV._m31_m31_m31_m31 + tmp3;
                    tmp4 = unity_WorldToObject._m01_m11_m21_m31 * unity_MatrixInvV._m12_m12_m12_m12;
                    tmp4 = unity_WorldToObject._m00_m10_m20_m30 * unity_MatrixInvV._m02_m02_m02_m02 + tmp4;
                    tmp4 = unity_WorldToObject._m02_m12_m22_m32 * unity_MatrixInvV._m22_m22_m22_m22 + tmp4;
                    tmp4 = unity_WorldToObject._m03_m13_m23_m33 * unity_MatrixInvV._m32_m32_m32_m32 + tmp4;
                    tmp5 = unity_WorldToObject._m01_m11_m21_m31 * unity_MatrixInvV._m13_m13_m13_m13;
                    tmp5 = unity_WorldToObject._m00_m10_m20_m30 * unity_MatrixInvV._m03_m03_m03_m03 + tmp5;
                    tmp5 = unity_WorldToObject._m02_m12_m22_m32 * unity_MatrixInvV._m23_m23_m23_m23 + tmp5;
                    tmp5 = unity_WorldToObject._m03_m13_m23_m33 * unity_MatrixInvV._m33_m33_m33_m33 + tmp5;
                    tmp3 = tmp1.yyyy * tmp3;
                    tmp2 = tmp1.xxxx * tmp2 + tmp3;
                    tmp2 = tmp0.yyyy * tmp4 + tmp2;
                    tmp1 = tmp1.wwww * tmp5.xzyw + tmp2.xzyw;
                } else {
                    tmp1 = v.vertex.xzyw;
                }
                tmp0.yz = float2(_WindShakeWindspeed.x, _WindShakeBending.x) + float2(1.0, 1.0);
                tmp2 = tmp1.yyyy * float4(0.024, 0.08, 0.08, 0.2);
                tmp2 = tmp1.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp2;
                tmp0.w = _WindShakeTime + _WindShakeTime;
                tmp0.w = -tmp0.w * _Time.x;
                tmp0.y = tmp0.y * tmp0.w;
                tmp2 = tmp0.yyyy * float4(1.2, 2.0, 1.6, 4.8) + tmp2;
                tmp2 = frac(tmp2);
                tmp2 = tmp2 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp3 = tmp2 * tmp2;
                tmp4 = tmp2 * tmp3;
                tmp5 = tmp3 * tmp4;
                tmp3 = tmp3 * tmp5;
                tmp2 = tmp4 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp2;
                tmp2 = tmp5 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp2;
                tmp2 = tmp3 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp2;
                tmp0.y = tmp0.z * v.texcoord.y;
                tmp2 = tmp0.yyyy * tmp2;
                tmp2 = tmp2 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp2 = tmp2 * tmp2;
                tmp2 = tmp2 * tmp2;
                tmp0.y = dot(tmp2, float4(0.024, 0.04, -0.12, 0.096));
                tmp0.z = dot(tmp2, float4(0.006, 0.02, -0.02, 0.1));
                tmp0.zw = tmp0.zz * unity_WorldToObject._m02_m22;
                tmp0.yz = unity_WorldToObject._m00_m20 * tmp0.yy + tmp0.zw;
                tmp0.yz = tmp1.xy - tmp0.yz;
                tmp2 = tmp1.zzzz * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp2;
                tmp2 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp2;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp2.xyz, tmp2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp2.xyz;
                tmp2.xyz = -tmp1.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.x = dot(tmp0.xyz, tmp2.xyz);
                tmp2.x = -tmp2.x * tmp2.x + 1.0;
                tmp2.x = sqrt(tmp2.x);
                tmp2.x = tmp2.x * unity_LightShadowBias.z;
                tmp0.yzw = -tmp0.yzw * tmp2.xxx + tmp1.xyz;
                tmp0.xyz = tmp0.xxx ? tmp0.yzw : tmp1.xyz;
                tmp2 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp2;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                tmp1.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp1.x + tmp0.z;
                o.texcoord6.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord6.zw = float2(0.0, 0.0);
                o.position.xyw = tmp0.xyw;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0.x = _Color.w * tmp0.w + -_Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Legacy Shaders/Transparent/Cutout/VertexLit"
}