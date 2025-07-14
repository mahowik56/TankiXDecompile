Shader "TankiOnline/Parachute" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Opaque (A)", 2D) = "white" {}
		_BumpScale ("Normal Map Scale", Float) = 1
		[NoScaleOffset] [Normal] _BumpMap ("Normal Map", 2D) = "bump" {}
		_TransColor ("Transmission Color", Color) = (1,1,1,1)
		[NoScaleOffset] _TransMap ("Transmission Map", 2D) = "white" {}
		_TransWeight ("Transmission Weight", Range(0, 1)) = 1
		_TransFallof ("Transmission Falloff", Range(0.01, 10)) = 1
		_TransDistortion ("Transmission Distortion", Range(0, 1)) = 1
		[Space] _HidingCenter ("Hide Center  - XYZ", Vector) = (0,0,0,0)
		_MinHidingRadius ("Min Hiding Radius", Float) = 0
		_MaxHidingRadius ("Max Hiding Radius", Float) = 0
		_HidingSpeed ("HidingSpeed", Float) = 0
		_HidingStartTime ("Hiding Start Time", Float) = 0
	}
	SubShader {
		LOD 300
		Tags { "PerformanceChecks" = "False" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDBASE" "PerformanceChecks" = "False" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			Cull Off
			GpuProgramID 51188
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float4 texcoord8 : TEXCOORD8;
				float2 texcoord9 : TEXCOORD9;
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
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float _BumpScale;
			float4 _TransColor;
			float _TransWeight;
			float _TransFallof;
			float _TransDistortion;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _TransMap;
			sampler2D _BumpMap;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                o.texcoord.w = 0.0;
                o.texcoord1 = tmp0;
                tmp0.xyz = tmp0.xyz - _HidingCenter;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.yzw = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp0.yzw;
                tmp0.yzw = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp0.yzw;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                o.texcoord2.xyz = tmp0.yzw;
                o.texcoord2.w = 0.0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp0.zwy * tmp1.zxy;
                tmp0.yzw = tmp1.yzx * tmp0.wyz + -tmp2.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                o.texcoord3.xyz = tmp0.yzw * tmp1.www;
                o.texcoord3.w = 0.0;
                o.texcoord4.xyz = tmp1.xyz;
                o.texcoord4.w = 0.0;
                tmp0.y = tmp1.y * tmp1.y;
                tmp0.y = tmp1.x * tmp1.x + -tmp0.y;
                tmp1 = tmp1.yzzx * tmp1.xyzz;
                tmp2.x = dot(unity_SHBr, tmp1);
                tmp2.y = dot(unity_SHBg, tmp1);
                tmp2.z = dot(unity_SHBb, tmp1);
                o.texcoord5.xyz = unity_SHC.xyz * tmp0.yyy + tmp2.xyz;
                o.texcoord5.w = 0.0;
                o.texcoord8.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord8.zw = float2(0.0, 0.0);
                tmp0.y = _Time.y - _HidingStartTime;
                tmp0.y = saturate(tmp0.y * _HidingSpeed);
                tmp0.z = _MaxHidingRadius - _MinHidingRadius;
                tmp0.y = tmp0.y * tmp0.z + _MinHidingRadius;
                o.texcoord9.x = saturate(tmp0.x / tmp0.y);
                o.texcoord9.y = 0.0;
                return o;
			}
			// Keywords: DIRECTIONAL
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
                tmp0.x = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.yzw = tmp0.xxx * inp.texcoord.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord8.xy);
                tmp1 = tmp1 * _Color;
                tmp2.xyz = _TransColor.xyz * _TransWeight.xxx;
                tmp3 = tex2D(_TransMap, inp.texcoord8.xy);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3 = tex2D(_BumpMap, inp.texcoord8.xy);
                tmp3.xy = tmp3.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xy = tmp3.xy * _BumpScale.xx;
                tmp2.w = dot(tmp3.xy, tmp3.xy);
                tmp2.w = min(tmp2.w, 1.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp2.w = sqrt(tmp2.w);
                tmp3.yzw = tmp3.yyy * inp.texcoord3.xyz;
                tmp3.xyz = tmp3.xxx * inp.texcoord2.xyz + tmp3.yzw;
                tmp3.xyz = tmp2.www * inp.texcoord4.xyz + tmp3.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * tmp3.xyz;
                tmp1.xyz = min(tmp1.xyz, float3(1.0, 1.0, 1.0));
                tmp2.w = dot(-tmp0.xyz, tmp3.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp4.xyz = tmp3.xyz * -tmp2.www + -tmp0.yzw;
                tmp3.w = 1.0;
                tmp5.x = dot(unity_SHAr, tmp3);
                tmp5.y = dot(unity_SHAg, tmp3);
                tmp5.z = dot(unity_SHAb, tmp3);
                tmp5.xyz = tmp5.xyz + inp.texcoord5.xyz;
                tmp2.w = unity_SpecCube0_ProbePosition.w > 0.0;
                if (tmp2.w) {
                    tmp2.w = dot(tmp4.xyz, tmp4.xyz);
                    tmp2.w = rsqrt(tmp2.w);
                    tmp6.xyz = tmp2.www * tmp4.xyz;
                    tmp7.xyz = unity_SpecCube0_BoxMax.xyz - inp.texcoord1.xyz;
                    tmp7.xyz = tmp7.xyz / tmp6.xyz;
                    tmp8.xyz = unity_SpecCube0_BoxMin.xyz - inp.texcoord1.xyz;
                    tmp8.xyz = tmp8.xyz / tmp6.xyz;
                    tmp9.xyz = tmp6.xyz > float3(0.0, 0.0, 0.0);
                    tmp7.xyz = tmp9.xyz ? tmp7.xyz : tmp8.xyz;
                    tmp2.w = min(tmp7.y, tmp7.x);
                    tmp2.w = min(tmp7.z, tmp2.w);
                    tmp7.xyz = inp.texcoord1.xyz - unity_SpecCube0_ProbePosition.xyz;
                    tmp6.xyz = tmp6.xyz * tmp2.www + tmp7.xyz;
                } else {
                    tmp6.xyz = tmp4.xyz;
                }
                tmp6 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp6.xyz, 6.0));
                tmp2.w = tmp6.w - 1.0;
                tmp2.w = unity_SpecCube0_HDR.w * tmp2.w + 1.0;
                tmp2.w = log(tmp2.w);
                tmp2.w = tmp2.w * unity_SpecCube0_HDR.y;
                tmp2.w = exp(tmp2.w);
                tmp2.w = tmp2.w * unity_SpecCube0_HDR.x;
                tmp7.xyz = tmp6.xyz * tmp2.www;
                tmp3.w = unity_SpecCube0_BoxMin.w < 0.99999;
                if (tmp3.w) {
                    tmp3.w = unity_SpecCube1_ProbePosition.w > 0.0;
                    if (tmp3.w) {
                        tmp3.w = dot(tmp4.xyz, tmp4.xyz);
                        tmp3.w = rsqrt(tmp3.w);
                        tmp8.xyz = tmp3.www * tmp4.xyz;
                        tmp9.xyz = unity_SpecCube1_BoxMax.xyz - inp.texcoord1.xyz;
                        tmp9.xyz = tmp9.xyz / tmp8.xyz;
                        tmp10.xyz = unity_SpecCube1_BoxMin.xyz - inp.texcoord1.xyz;
                        tmp10.xyz = tmp10.xyz / tmp8.xyz;
                        tmp11.xyz = tmp8.xyz > float3(0.0, 0.0, 0.0);
                        tmp9.xyz = tmp11.xyz ? tmp9.xyz : tmp10.xyz;
                        tmp3.w = min(tmp9.y, tmp9.x);
                        tmp3.w = min(tmp9.z, tmp3.w);
                        tmp9.xyz = inp.texcoord1.xyz - unity_SpecCube1_ProbePosition.xyz;
                        tmp4.xyz = tmp8.xyz * tmp3.www + tmp9.xyz;
                    }
                    tmp4 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp4.xyz, 6.0));
                    tmp3.w = tmp4.w - 1.0;
                    tmp3.w = unity_SpecCube1_HDR.w * tmp3.w + 1.0;
                    tmp3.w = log(tmp3.w);
                    tmp3.w = tmp3.w * unity_SpecCube1_HDR.y;
                    tmp3.w = exp(tmp3.w);
                    tmp3.w = tmp3.w * unity_SpecCube1_HDR.x;
                    tmp4.xyz = tmp4.xyz * tmp3.www;
                    tmp6.xyz = tmp2.www * tmp6.xyz + -tmp4.xyz;
                    tmp7.xyz = unity_SpecCube0_BoxMin.www * tmp6.xyz + tmp4.xyz;
                }
                tmp4.xyz = tmp7.xyz * float3(-0.0024, -0.0024, -0.0024);
                tmp4.xyz = tmp5.xyz * tmp1.xyz + tmp4.xyz;
                tmp5.xyz = inp.texcoord.xyz * tmp0.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp5.xyz, tmp5.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp5.xyz = tmp0.xxx * tmp5.xyz;
                tmp0.x = dot(tmp3.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp2.w = dot(_WorldSpaceLightPos0.xyz, tmp5.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp3.w = tmp0.x * -5.55473 + -6.98316;
                tmp3.w = tmp0.x * tmp3.w;
                tmp3.w = exp(tmp3.w);
                tmp4.w = dot(tmp3.xyz, tmp0.xyz);
                tmp4.w = max(tmp4.w, 0.0);
                tmp5.x = tmp4.w * -5.55473 + -6.98316;
                tmp4.w = tmp4.w * tmp5.x;
                tmp4.w = exp(tmp4.w);
                tmp3.xyz = tmp3.xyz * _TransDistortion.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.y = dot(tmp0.xyz, -tmp3.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * _TransFallof;
                tmp0.y = exp(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp2.xyz;
                tmp2.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.x = dot(tmp2.xy, tmp2.xy);
                tmp0.x = tmp0.x + 0.5;
                tmp2.w = 1.0 - tmp3.w;
                tmp2.w = tmp0.x * tmp3.w + tmp2.w;
                tmp3.x = 1.0 - tmp4.w;
                tmp0.x = tmp0.x * tmp4.w + tmp3.x;
                tmp0.x = tmp0.x * tmp2.w;
                tmp3.xyz = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp0.xyz = tmp0.yzw * tmp1.xyz;
                tmp0.xyz = tmp2.xyz * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + tmp4.xyz;
                o.sv_target.w = min(tmp1.w, inp.texcoord9.x);
                o.sv_target.xyz = min(tmp0.xyz, float3(32.0, 32.0, 32.0));
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDADD" "PerformanceChecks" = "False" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 107022
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
				float4 texcoord8 : TEXCOORD8;
				float2 texcoord9 : TEXCOORD9;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float3 _HidingCenter;
			float _MinHidingRadius;
			float _MaxHidingRadius;
			float _HidingSpeed;
			float _HidingStartTime;
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float _BumpScale;
			float4 _TransColor;
			float _TransWeight;
			float _TransFallof;
			float _TransDistortion;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _MainTex;
			sampler2D _TransMap;
			sampler2D _BumpMap;
			
			// Keywords: POINT
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
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.w = 0.0;
                o.texcoord.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                o.texcoord1 = tmp0;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                o.texcoord2.w = 0.0;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp3.xyz = tmp1.yzx * tmp2.zxy;
                tmp1.xyz = tmp2.yzx * tmp1.zxy + -tmp3.xyz;
                o.texcoord4.xyz = tmp2.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                o.texcoord3.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3.w = 0.0;
                o.texcoord4.w = 0.0;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp1.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp1.xyz;
                tmp0.xyz = tmp0.xyz - _HidingCenter;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                o.texcoord8.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord8.zw = float2(0.0, 0.0);
                tmp0.y = _Time.y - _HidingStartTime;
                tmp0.y = saturate(tmp0.y * _HidingSpeed);
                tmp0.z = _MaxHidingRadius - _MinHidingRadius;
                tmp0.y = tmp0.y * tmp0.z + _MinHidingRadius;
                o.texcoord9.x = saturate(tmp0.x / tmp0.y);
                o.texcoord9.y = 0.0;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = tex2D(_BumpMap, inp.texcoord8.xy);
                tmp0.xy = tmp0.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * _BumpScale.xx;
                tmp1.xyz = tmp0.yyy * inp.texcoord3.xyz;
                tmp1.xyz = tmp0.xxx * inp.texcoord2.xyz + tmp1.xyz;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = sqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord4.xyz + tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord.xyz;
                tmp0.w = dot(tmp0.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = tmp0.w * -5.55473 + -6.98316;
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = exp(tmp0.w);
                tmp1.w = 1.0 - tmp0.w;
                tmp2.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord1.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.xyz * tmp2.www + tmp1.xyz;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * tmp3.xyz;
                tmp2.w = dot(tmp2.xyz, tmp3.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = dot(tmp2.xy, tmp2.xy);
                tmp2.w = tmp2.w + 0.5;
                tmp0.w = tmp2.w * tmp0.w + tmp1.w;
                tmp1.w = dot(tmp0.xyz, tmp2.xyz);
                tmp0.xyz = tmp0.xyz * _TransDistortion.xxx + tmp2.xyz;
                tmp0.x = dot(tmp1.xyz, -tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _TransFallof;
                tmp0.x = exp(tmp0.x);
                tmp0.y = max(tmp1.w, 0.0);
                tmp0.z = tmp0.y * -5.55473 + -6.98316;
                tmp0.z = tmp0.y * tmp0.z;
                tmp0.z = exp(tmp0.z);
                tmp1.x = 1.0 - tmp0.z;
                tmp0.z = tmp2.w * tmp0.z + tmp1.x;
                tmp0.z = tmp0.w * tmp0.z;
                tmp1 = tex2D(_MainTex, inp.texcoord8.xy);
                tmp1 = tmp1 * _Color;
                tmp1.xyz = min(tmp1.xyz, float3(1.0, 1.0, 1.0));
                o.sv_target.w = min(tmp1.w, inp.texcoord9.x);
                tmp2.xyz = tmp0.zzz * tmp1.xyz;
                tmp3.xyz = _TransColor.xyz * _TransWeight.xxx;
                tmp4 = tex2D(_TransMap, inp.texcoord8.xy);
                tmp3.xyz = tmp3.xyz * tmp4.xyz;
                tmp0.xzw = tmp0.xxx * tmp3.xyz;
                tmp1.w = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp3 = tex2D(_LightTexture0, tmp1.ww);
                tmp3.xyz = tmp3.xxx * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp0.xyz = tmp0.xzw * tmp1.xyz;
                tmp0.xyz = tmp3.xyz * tmp2.xyz + tmp0.xyz;
                o.sv_target.xyz = min(tmp0.xyz, float3(32.0, 32.0, 32.0));
                return o;
			}
			ENDCG
		}
		Pass {
			Name "SHADOWCASTER"
			LOD 300
			Tags { "LIGHTMODE" = "SHADOWCASTER" "PerformanceChecks" = "False" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			Cull Off
			GpuProgramID 187136
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
			float4 _MainTex_ST;
			float _ShadowFixOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler3D _DitherMaskLOD;
			
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
                    tmp1 = tmp1.wwww * tmp5 + tmp2;
                } else {
                    tmp1 = v.vertex;
                }
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
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
                tmp0.x = tmp0.w * _Color.w;
                tmp0.z = tmp0.x * 0.9375;
                tmp0.xy = inp.position.xy * float2(0.25, 0.25);
                tmp0 = tex3D(_DitherMaskLOD, tmp0.xyz);
                tmp0.x = tmp0.w - 0.01;
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