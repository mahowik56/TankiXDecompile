Shader "DomeCutOut" {
	Properties {
		_MainTex ("RGBA Texture Image", 2D) = "white" {}
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
		_MainAlpha ("Main alpha", Range(0, 1)) = 1
		_Alpha ("Alpha", Range(0, 3)) = 1
		_EdgeAlpha ("Edge Alpha", Range(0, 1)) = 1
		_EdgeColor ("Edge Color", Color) = (1,1,1,1)
		_EdgeThickness ("Edge Thickness", Range(1, 10)) = 1
		_EdgePow ("Edge Pow", Range(1, 3)) = 1
		_MainColor ("Main Color", Color) = (1,1,1,1)
		_OutlineMask ("Outline Mask", 2D) = "white" {}
		_OutlineBorder ("Outline Border", 2D) = "white" {}
		_OutlineAlpha ("Outline Alpha", Range(0, 3)) = 1
		_RimDistance ("Rim Distance", Range(0, 1)) = 1
		_RimPower ("Rim Power", Range(0, 20)) = 1
		_IntersectionSize ("Intersection Size", Range(0, 1)) = 0.3
	}
	SubShader {
		LOD 300
		Pass {
			LOD 300
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZClip Off
			ZWrite Off
			GpuProgramID 23126
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float _RimDistance;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ShaftAimingForceFieldData;
			float4 _ShaftAimingForceFieldSettings;
			float _Cutoff;
			float _Alpha;
			float _EdgeAlpha;
			float _EdgeThickness;
			float _EdgePow;
			float _OutlineAlpha;
			float _RimPower;
			float _MainAlpha;
			float _IntersectionSize;
			float4 _MainColor;
			float4 _EdgeColor;
			float _Radius0;
			float _Radius1;
			float _Radius2;
			float _Radius3;
			float _Radius4;
			float3 _pos0;
			float3 _pos1;
			float3 _pos2;
			float3 _pos3;
			float3 _pos4;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _OutlineMask;
			sampler2D _OutlineBorder;
			sampler2D _CameraDepthTexture;
			
			// Keywords: 
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToObject._m03_m13_m23;
                tmp2.xyz = tmp2.xyz - v.vertex.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(v.normal.xyz, tmp2.xyz);
                tmp0.z = 1.0 - tmp0.z;
                tmp2.x = 1.0 - _RimDistance;
                tmp0.z = tmp0.z - tmp2.x;
                tmp2.x = 1.0 - tmp2.x;
                tmp2.x = 1.0 / tmp2.x;
                tmp0.z = saturate(tmp0.z * tmp2.x);
                tmp2.x = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                o.color = tmp0.zzzz * tmp2.xxxx;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord3.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.w = tmp0.w;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * _MainColor;
                tmp1.x = _Time.y * 0.1666667 + inp.texcoord.x;
                tmp1.y = inp.texcoord.y;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tmp1 * _MainColor;
                tmp2 = tex2D(_OutlineMask, inp.texcoord.xy);
                tmp3 = tex2D(_OutlineBorder, inp.texcoord.xy);
                tmp2.xyz = inp.texcoord2.xyz - _pos0;
                tmp2.xy = tmp2.xy * tmp2.xy;
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.x = tmp2.z * tmp2.z + tmp2.x;
                tmp2.x = sqrt(tmp2.x);
                tmp3.xyz = inp.texcoord2.xyz - _pos1;
                tmp2.yz = tmp3.xy * tmp3.xy;
                tmp2.y = tmp2.z + tmp2.y;
                tmp2.y = tmp3.z * tmp3.z + tmp2.y;
                tmp2.y = sqrt(tmp2.y);
                tmp3.xyz = inp.texcoord2.xyz - _pos2;
                tmp3.xy = tmp3.xy * tmp3.xy;
                tmp2.z = tmp3.y + tmp3.x;
                tmp2.z = tmp3.z * tmp3.z + tmp2.z;
                tmp2.z = sqrt(tmp2.z);
                tmp2.xyz = tmp2.xyz / float3(_Radius0.x, _Radius1.x, _Radius2.x);
                tmp3.xyz = inp.texcoord2.xyz - _pos3;
                tmp3.xy = tmp3.xy * tmp3.xy;
                tmp3.x = tmp3.y + tmp3.x;
                tmp3.x = tmp3.z * tmp3.z + tmp3.x;
                tmp3.x = sqrt(tmp3.x);
                tmp3.x = tmp3.x / _Radius3;
                tmp4.xyz = inp.texcoord2.xyz - _pos4;
                tmp3.yz = tmp4.xy * tmp4.xy;
                tmp3.y = tmp3.z + tmp3.y;
                tmp3.y = tmp4.z * tmp4.z + tmp3.y;
                tmp3.y = sqrt(tmp3.y);
                tmp3.y = tmp3.y / _Radius4;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xy = float2(1.0, 1.0) - tmp3.xy;
                tmp3.xy = max(tmp3.xy, float2(0.0, 0.0));
                tmp4 = float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x) * float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x);
                tmp4 = tmp4 * float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x) + float4(1.0, 1.0, 1.0, 1.0);
                tmp2.xy = tmp2.xy / tmp4.xy;
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.y = tmp2.z / tmp4.z;
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.y = tmp3.x / tmp4.w;
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.y = _Radius4 * _Radius4;
                tmp2.y = tmp2.y * _Radius4 + 1.0;
                tmp2.y = tmp3.y / tmp2.y;
                tmp2.x = tmp2.y + tmp2.x;
                tmp0.w = -tmp2.x * 0.2 + tmp0.w;
                tmp4.w = -tmp1.w * 0.1666667 + tmp0.w;
                tmp0.w = _Cutoff >= tmp4.w;
                if (tmp0.w) {
                    tmp0.w = _Alpha * _EdgeColor.w;
                    tmp1.w = inp.color.w * _RimPower + 1.0;
                    tmp0.w = tmp0.w * tmp1.w;
                    tmp0.w = tmp3.w * tmp0.w;
                    tmp1.w = _MainColor.w + _MainColor.w;
                    tmp2.y = _Cutoff - tmp4.w;
                    tmp2.y = log(tmp2.y);
                    tmp2.y = tmp2.y * _EdgePow;
                    tmp2.y = exp(tmp2.y);
                    tmp2.y = tmp2.y * _EdgeThickness;
                    tmp1.w = tmp1.w / tmp2.y;
                    tmp2.y = -tmp2.w * _MainColor.w + 1.0;
                    tmp2.y = tmp2.y * _OutlineAlpha;
                    tmp5.w = tmp0.w * tmp1.w + tmp2.y;
                    tmp5.xyz = _EdgeColor.xyz;
                    tmp5 = min(tmp5, float4(1.0, 1.0, 1.0, 1.0));
                    tmp6 = tmp2.xxxx * tmp5;
                    tmp5 = tmp6 * float4(2.0, 2.0, 2.0, 2.0) + tmp5;
                } else {
                    tmp4.xyz = tmp0.xyz * tmp1.xyz;
                    tmp0.x = _Cutoff < tmp4.w;
                    tmp0.y = _EdgeAlpha * _EdgeColor.w;
                    tmp0.z = inp.color.w * _RimPower + 1.0;
                    tmp0.y = tmp0.z * tmp0.y;
                    tmp0.y = tmp3.w * tmp0.y;
                    tmp0.z = tmp4.w + tmp4.w;
                    tmp0.w = tmp4.w - _Cutoff;
                    tmp0.w = log(tmp0.w);
                    tmp0.w = tmp0.w * _EdgePow;
                    tmp0.w = exp(tmp0.w);
                    tmp0.w = tmp0.w * _EdgeThickness;
                    tmp0.z = tmp0.z / tmp0.w;
                    tmp0.w = -tmp2.w * _MainColor.w + 1.0;
                    tmp0.w = tmp0.w * _OutlineAlpha;
                    tmp1.w = tmp0.y * tmp0.z + tmp0.w;
                    tmp1.xyz = _EdgeColor.xyz;
                    tmp1 = min(tmp1, float4(1.0, 1.0, 1.0, 1.0));
                    tmp2 = tmp1 * tmp2.xxxx;
                    tmp1 = tmp2 * float4(10.0, 10.0, 10.0, 10.0) + tmp1;
                    tmp5 = tmp0.xxxx ? tmp1 : tmp4;
                }
                tmp0.xy = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp0 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - _ProjectionParams.y;
                tmp0.y = inp.texcoord3.z - _ProjectionParams.y;
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = tmp0.x / _IntersectionSize;
                tmp0.y = tmp0.x <= 1.0;
                tmp0.x = saturate(tmp0.x);
                tmp0.z = tmp0.x * 2.666667;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = min(tmp0.x, tmp0.z);
                tmp1.w = min(tmp0.x, 1.0);
                tmp1.xyz = _EdgeColor.xyz;
                tmp0 = tmp0.yyyy ? tmp1 : tmp5;
                tmp0 = tmp0 * _MainAlpha.xxxx;
                tmp1.xyz = _ShaftAimingForceFieldData.xyz - inp.texcoord2.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x - _ShaftAimingForceFieldSettings.x;
                tmp1.y = _ShaftAimingForceFieldSettings.y - _ShaftAimingForceFieldSettings.x;
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp1.y = _ShaftAimingForceFieldData.w * _ShaftAimingForceFieldSettings.z;
                tmp1.x = tmp1.x - 1.0;
                tmp1.x = tmp1.y * tmp1.x + 1.0;
                o.sv_target = tmp0 * tmp1.xxxx;
                return o;
			}
			ENDCG
		}
		Pass {
			LOD 300
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZClip Off
			ZWrite Off
			Cull Front
			GpuProgramID 74265
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float _RimDistance;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ShaftAimingForceFieldData;
			float4 _ShaftAimingForceFieldSettings;
			float _Cutoff;
			float _Alpha;
			float _EdgeAlpha;
			float _EdgeThickness;
			float _EdgePow;
			float _OutlineAlpha;
			float _RimPower;
			float _MainAlpha;
			float _IntersectionSize;
			float4 _MainColor;
			float4 _EdgeColor;
			float _Radius0;
			float _Radius1;
			float _Radius2;
			float _Radius3;
			float _Radius4;
			float3 _pos0;
			float3 _pos1;
			float3 _pos2;
			float3 _pos3;
			float3 _pos4;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _OutlineMask;
			sampler2D _OutlineBorder;
			sampler2D _CameraDepthTexture;
			
			// Keywords: 
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToObject._m03_m13_m23;
                tmp2.xyz = tmp2.xyz - v.vertex.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(v.normal.xyz, tmp2.xyz);
                tmp0.z = 1.0 - tmp0.z;
                tmp2.x = 1.0 - _RimDistance;
                tmp0.z = tmp0.z - tmp2.x;
                tmp2.x = 1.0 - tmp2.x;
                tmp2.x = 1.0 / tmp2.x;
                tmp0.z = saturate(tmp0.z * tmp2.x);
                tmp2.x = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                o.color = tmp0.zzzz * tmp2.xxxx;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord3.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.w = tmp0.w;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                tmp0.xyz = inp.texcoord2.xyz - _pos0;
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.z * tmp0.z + tmp0.x;
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x / _Radius0;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = max(tmp0.x, 0.0);
                tmp1 = float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x) * float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x);
                tmp1 = tmp1 * float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x) + float4(1.0, 1.0, 1.0, 1.0);
                tmp0.yzw = inp.texcoord2.xyz - _pos1;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _Radius1;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.xy = tmp0.xy / tmp1.xy;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.yzw = inp.texcoord2.xyz - _pos2;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _Radius2;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = tmp0.y / tmp1.z;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.yzw = inp.texcoord2.xyz - _pos3;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _Radius3;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = tmp0.y / tmp1.w;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.yzw = inp.texcoord2.xyz - _pos4;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _Radius4;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = _Radius4 * _Radius4;
                tmp0.z = tmp0.z * _Radius4 + 1.0;
                tmp0.y = tmp0.y / tmp0.z;
                tmp0.x = tmp0.y + tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * _MainColor;
                tmp0.y = -tmp0.x * 0.2 + tmp1.w;
                tmp2.x = _Time.y * 0.1666667 + inp.texcoord.x;
                tmp2.y = inp.texcoord.y;
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tmp2 * _MainColor;
                tmp3.w = -tmp2.w * 0.1666667 + tmp0.y;
                tmp3.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.y = tmp3.w - _Cutoff;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * _EdgePow;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp0.y * _EdgeThickness;
                tmp0.z = tmp3.w + tmp3.w;
                tmp0.y = tmp0.z / tmp0.y;
                tmp1 = tex2D(_OutlineMask, inp.texcoord.xy);
                tmp0.z = -tmp1.w * _MainColor.w + 1.0;
                tmp0.z = tmp0.z * _OutlineAlpha;
                tmp1 = tex2D(_OutlineBorder, inp.texcoord.xy);
                tmp1.xy = float2(_Alpha.x, _EdgeAlpha.x) * _EdgeColor.ww;
                tmp0.w = tmp1.w * tmp1.y;
                tmp2.w = tmp0.w * tmp0.y + tmp0.z;
                tmp2.xyz = _EdgeColor.xyz;
                tmp2 = min(tmp2, float4(1.0, 1.0, 1.0, 1.0));
                tmp4 = tmp0.xxxx * tmp2;
                tmp2 = tmp4 * float4(10.0, 10.0, 10.0, 10.0) + tmp2;
                tmp0.y = _Cutoff < tmp3.w;
                tmp2 = tmp0.yyyy ? tmp2 : tmp3;
                tmp0.y = inp.color.w * _RimPower + 1.0;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.y = tmp1.w * tmp0.y;
                tmp0.w = _Cutoff - tmp3.w;
                tmp1.x = tmp3.w < _Cutoff;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _EdgePow;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _EdgeThickness;
                tmp1.y = _MainColor.w + _MainColor.w;
                tmp0.w = tmp1.y / tmp0.w;
                tmp3.w = tmp0.y * tmp0.w + tmp0.z;
                tmp3.xyz = _EdgeColor.xyz;
                tmp3 = min(tmp3, float4(1.0, 1.0, 1.0, 1.0));
                tmp0 = tmp0.xxxx * tmp3;
                tmp0 = tmp0 * float4(2.0, 2.0, 2.0, 2.0) + tmp3;
                tmp0 = tmp1.xxxx ? tmp0 : tmp2;
                tmp1.xy = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp1 = tex2D(_CameraDepthTexture, tmp1.xy);
                tmp1.x = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = tmp1.x - _ProjectionParams.y;
                tmp1.y = inp.texcoord3.z - _ProjectionParams.y;
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = tmp1.x / _IntersectionSize;
                tmp1.y = saturate(tmp1.x);
                tmp1.x = tmp1.x <= 1.0;
                tmp1.z = 1.0 - tmp1.y;
                tmp1.y = tmp1.y * 2.666667;
                tmp1.z = tmp1.z * tmp1.y;
                tmp1.y = min(tmp1.z, tmp1.y);
                tmp2.w = min(tmp1.y, 1.0);
                tmp2.xyz = _EdgeColor.xyz;
                tmp0 = tmp1.xxxx ? tmp2 : tmp0;
                tmp0 = tmp0 * _MainAlpha.xxxx;
                tmp1.xyz = _ShaftAimingForceFieldData.xyz - inp.texcoord2.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x - _ShaftAimingForceFieldSettings.x;
                tmp1.y = _ShaftAimingForceFieldSettings.y - _ShaftAimingForceFieldSettings.x;
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp1.x = tmp1.x - 1.0;
                tmp1.y = _ShaftAimingForceFieldData.w * _ShaftAimingForceFieldSettings.z;
                tmp1.x = tmp1.y * tmp1.x + 1.0;
                o.sv_target = tmp0 * tmp1.xxxx;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		LOD 150
		Pass {
			LOD 150
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZClip Off
			ZWrite Off
			GpuProgramID 183617
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float _RimDistance;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ShaftAimingForceFieldData;
			float4 _ShaftAimingForceFieldSettings;
			float _Cutoff;
			float _Alpha;
			float _EdgeAlpha;
			float _EdgeThickness;
			float _EdgePow;
			float _OutlineAlpha;
			float _RimPower;
			float _MainAlpha;
			float4 _MainColor;
			float4 _EdgeColor;
			float _Radius0;
			float _Radius1;
			float _Radius2;
			float _Radius3;
			float _Radius4;
			float3 _pos0;
			float3 _pos1;
			float3 _pos2;
			float3 _pos3;
			float3 _pos4;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _OutlineMask;
			sampler2D _OutlineBorder;
			
			// Keywords: 
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToObject._m03_m13_m23;
                tmp2.xyz = tmp2.xyz - v.vertex.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(v.normal.xyz, tmp2.xyz);
                tmp0.z = 1.0 - tmp0.z;
                tmp2.x = 1.0 - _RimDistance;
                tmp0.z = tmp0.z - tmp2.x;
                tmp2.x = 1.0 - tmp2.x;
                tmp2.x = 1.0 / tmp2.x;
                tmp0.z = saturate(tmp0.z * tmp2.x);
                tmp2.x = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                o.color = tmp0.zzzz * tmp2.xxxx;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord3.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.w = tmp0.w;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * _MainColor;
                tmp1.x = _Time.y * 0.1666667 + inp.texcoord.x;
                tmp1.y = inp.texcoord.y;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tmp1 * _MainColor;
                tmp2 = tex2D(_OutlineMask, inp.texcoord.xy);
                tmp3 = tex2D(_OutlineBorder, inp.texcoord.xy);
                tmp2.xyz = inp.texcoord2.xyz - _pos0;
                tmp2.xy = tmp2.xy * tmp2.xy;
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.x = tmp2.z * tmp2.z + tmp2.x;
                tmp2.x = sqrt(tmp2.x);
                tmp3.xyz = inp.texcoord2.xyz - _pos1;
                tmp2.yz = tmp3.xy * tmp3.xy;
                tmp2.y = tmp2.z + tmp2.y;
                tmp2.y = tmp3.z * tmp3.z + tmp2.y;
                tmp2.y = sqrt(tmp2.y);
                tmp3.xyz = inp.texcoord2.xyz - _pos2;
                tmp3.xy = tmp3.xy * tmp3.xy;
                tmp2.z = tmp3.y + tmp3.x;
                tmp2.z = tmp3.z * tmp3.z + tmp2.z;
                tmp2.z = sqrt(tmp2.z);
                tmp2.xyz = tmp2.xyz / float3(_Radius0.x, _Radius1.x, _Radius2.x);
                tmp3.xyz = inp.texcoord2.xyz - _pos3;
                tmp3.xy = tmp3.xy * tmp3.xy;
                tmp3.x = tmp3.y + tmp3.x;
                tmp3.x = tmp3.z * tmp3.z + tmp3.x;
                tmp3.x = sqrt(tmp3.x);
                tmp3.x = tmp3.x / _Radius3;
                tmp4.xyz = inp.texcoord2.xyz - _pos4;
                tmp3.yz = tmp4.xy * tmp4.xy;
                tmp3.y = tmp3.z + tmp3.y;
                tmp3.y = tmp4.z * tmp4.z + tmp3.y;
                tmp3.y = sqrt(tmp3.y);
                tmp3.y = tmp3.y / _Radius4;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xy = float2(1.0, 1.0) - tmp3.xy;
                tmp3.xy = max(tmp3.xy, float2(0.0, 0.0));
                tmp4 = float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x) * float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x);
                tmp4 = tmp4 * float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x) + float4(1.0, 1.0, 1.0, 1.0);
                tmp2.xy = tmp2.xy / tmp4.xy;
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.y = tmp2.z / tmp4.z;
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.y = tmp3.x / tmp4.w;
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.y = _Radius4 * _Radius4;
                tmp2.y = tmp2.y * _Radius4 + 1.0;
                tmp2.y = tmp3.y / tmp2.y;
                tmp2.x = tmp2.y + tmp2.x;
                tmp0.w = -tmp2.x * 0.2 + tmp0.w;
                tmp4.w = -tmp1.w * 0.1666667 + tmp0.w;
                tmp0.w = _Cutoff >= tmp4.w;
                if (tmp0.w) {
                    tmp0.w = _Alpha * _EdgeColor.w;
                    tmp1.w = inp.color.w * _RimPower + 1.0;
                    tmp0.w = tmp0.w * tmp1.w;
                    tmp0.w = tmp3.w * tmp0.w;
                    tmp1.w = _MainColor.w + _MainColor.w;
                    tmp2.y = _Cutoff - tmp4.w;
                    tmp2.y = log(tmp2.y);
                    tmp2.y = tmp2.y * _EdgePow;
                    tmp2.y = exp(tmp2.y);
                    tmp2.y = tmp2.y * _EdgeThickness;
                    tmp1.w = tmp1.w / tmp2.y;
                    tmp2.y = -tmp2.w * _MainColor.w + 1.0;
                    tmp2.y = tmp2.y * _OutlineAlpha;
                    tmp5.w = tmp0.w * tmp1.w + tmp2.y;
                    tmp5.xyz = _EdgeColor.xyz;
                    tmp5 = min(tmp5, float4(1.0, 1.0, 1.0, 1.0));
                    tmp6 = tmp2.xxxx * tmp5;
                    tmp5 = tmp6 * float4(2.0, 2.0, 2.0, 2.0) + tmp5;
                } else {
                    tmp4.xyz = tmp0.xyz * tmp1.xyz;
                    tmp0.x = _Cutoff < tmp4.w;
                    tmp0.y = _EdgeAlpha * _EdgeColor.w;
                    tmp0.z = inp.color.w * _RimPower + 1.0;
                    tmp0.y = tmp0.z * tmp0.y;
                    tmp0.y = tmp3.w * tmp0.y;
                    tmp0.z = tmp4.w + tmp4.w;
                    tmp0.w = tmp4.w - _Cutoff;
                    tmp0.w = log(tmp0.w);
                    tmp0.w = tmp0.w * _EdgePow;
                    tmp0.w = exp(tmp0.w);
                    tmp0.w = tmp0.w * _EdgeThickness;
                    tmp0.z = tmp0.z / tmp0.w;
                    tmp0.w = -tmp2.w * _MainColor.w + 1.0;
                    tmp0.w = tmp0.w * _OutlineAlpha;
                    tmp1.w = tmp0.y * tmp0.z + tmp0.w;
                    tmp1.xyz = _EdgeColor.xyz;
                    tmp1 = min(tmp1, float4(1.0, 1.0, 1.0, 1.0));
                    tmp2 = tmp1 * tmp2.xxxx;
                    tmp1 = tmp2 * float4(10.0, 10.0, 10.0, 10.0) + tmp1;
                    tmp5 = tmp0.xxxx ? tmp1 : tmp4;
                }
                tmp0 = tmp5 * _MainAlpha.xxxx;
                tmp1.xyz = _ShaftAimingForceFieldData.xyz - inp.texcoord2.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x - _ShaftAimingForceFieldSettings.x;
                tmp1.y = _ShaftAimingForceFieldSettings.y - _ShaftAimingForceFieldSettings.x;
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp1.y = _ShaftAimingForceFieldData.w * _ShaftAimingForceFieldSettings.z;
                tmp1.x = tmp1.x - 1.0;
                tmp1.x = tmp1.y * tmp1.x + 1.0;
                o.sv_target = tmp0 * tmp1.xxxx;
                return o;
			}
			ENDCG
		}
		Pass {
			LOD 150
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZClip Off
			ZWrite Off
			Cull Front
			GpuProgramID 208157
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float _RimDistance;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ShaftAimingForceFieldData;
			float4 _ShaftAimingForceFieldSettings;
			float _Cutoff;
			float _Alpha;
			float _EdgeAlpha;
			float _EdgeThickness;
			float _EdgePow;
			float _OutlineAlpha;
			float _RimPower;
			float _MainAlpha;
			float4 _MainColor;
			float4 _EdgeColor;
			float _Radius0;
			float _Radius1;
			float _Radius2;
			float _Radius3;
			float _Radius4;
			float3 _pos0;
			float3 _pos1;
			float3 _pos2;
			float3 _pos3;
			float3 _pos4;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _OutlineMask;
			sampler2D _OutlineBorder;
			
			// Keywords: 
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToObject._m03_m13_m23;
                tmp2.xyz = tmp2.xyz - v.vertex.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(v.normal.xyz, tmp2.xyz);
                tmp0.z = 1.0 - tmp0.z;
                tmp2.x = 1.0 - _RimDistance;
                tmp0.z = tmp0.z - tmp2.x;
                tmp2.x = 1.0 - tmp2.x;
                tmp2.x = 1.0 / tmp2.x;
                tmp0.z = saturate(tmp0.z * tmp2.x);
                tmp2.x = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                o.color = tmp0.zzzz * tmp2.xxxx;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord3.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.w = tmp0.w;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                tmp0.xyz = inp.texcoord2.xyz - _pos0;
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.z * tmp0.z + tmp0.x;
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x / _Radius0;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = max(tmp0.x, 0.0);
                tmp1 = float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x) * float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x);
                tmp1 = tmp1 * float4(_Radius0.x, _Radius1.x, _Radius2.x, _Radius3.x) + float4(1.0, 1.0, 1.0, 1.0);
                tmp0.yzw = inp.texcoord2.xyz - _pos1;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _Radius1;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.xy = tmp0.xy / tmp1.xy;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.yzw = inp.texcoord2.xyz - _pos2;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _Radius2;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = tmp0.y / tmp1.z;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.yzw = inp.texcoord2.xyz - _pos3;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _Radius3;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = tmp0.y / tmp1.w;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.yzw = inp.texcoord2.xyz - _pos4;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _Radius4;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = _Radius4 * _Radius4;
                tmp0.z = tmp0.z * _Radius4 + 1.0;
                tmp0.y = tmp0.y / tmp0.z;
                tmp0.x = tmp0.y + tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * _MainColor;
                tmp0.y = -tmp0.x * 0.2 + tmp1.w;
                tmp2.x = _Time.y * 0.1666667 + inp.texcoord.x;
                tmp2.y = inp.texcoord.y;
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tmp2 * _MainColor;
                tmp3.w = -tmp2.w * 0.1666667 + tmp0.y;
                tmp3.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.y = tmp3.w - _Cutoff;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * _EdgePow;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp0.y * _EdgeThickness;
                tmp0.z = tmp3.w + tmp3.w;
                tmp0.y = tmp0.z / tmp0.y;
                tmp1 = tex2D(_OutlineMask, inp.texcoord.xy);
                tmp0.z = -tmp1.w * _MainColor.w + 1.0;
                tmp0.z = tmp0.z * _OutlineAlpha;
                tmp1 = tex2D(_OutlineBorder, inp.texcoord.xy);
                tmp1.xy = float2(_Alpha.x, _EdgeAlpha.x) * _EdgeColor.ww;
                tmp0.w = tmp1.w * tmp1.y;
                tmp2.w = tmp0.w * tmp0.y + tmp0.z;
                tmp2.xyz = _EdgeColor.xyz;
                tmp2 = min(tmp2, float4(1.0, 1.0, 1.0, 1.0));
                tmp4 = tmp0.xxxx * tmp2;
                tmp2 = tmp4 * float4(10.0, 10.0, 10.0, 10.0) + tmp2;
                tmp0.y = _Cutoff < tmp3.w;
                tmp2 = tmp0.yyyy ? tmp2 : tmp3;
                tmp0.y = inp.color.w * _RimPower + 1.0;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.y = tmp1.w * tmp0.y;
                tmp0.w = _Cutoff - tmp3.w;
                tmp1.x = tmp3.w < _Cutoff;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _EdgePow;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _EdgeThickness;
                tmp1.y = _MainColor.w + _MainColor.w;
                tmp0.w = tmp1.y / tmp0.w;
                tmp3.w = tmp0.y * tmp0.w + tmp0.z;
                tmp3.xyz = _EdgeColor.xyz;
                tmp3 = min(tmp3, float4(1.0, 1.0, 1.0, 1.0));
                tmp0 = tmp0.xxxx * tmp3;
                tmp0 = tmp0 * float4(2.0, 2.0, 2.0, 2.0) + tmp3;
                tmp0 = tmp1.xxxx ? tmp0 : tmp2;
                tmp0 = tmp0 * _MainAlpha.xxxx;
                tmp1.xyz = _ShaftAimingForceFieldData.xyz - inp.texcoord2.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x - _ShaftAimingForceFieldSettings.x;
                tmp1.y = _ShaftAimingForceFieldSettings.y - _ShaftAimingForceFieldSettings.x;
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp1.x = tmp1.x - 1.0;
                tmp1.y = _ShaftAimingForceFieldData.w * _ShaftAimingForceFieldSettings.z;
                tmp1.x = tmp1.y * tmp1.x + 1.0;
                o.sv_target = tmp0 * tmp1.xxxx;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Unlit/Transparent Cutout"
}