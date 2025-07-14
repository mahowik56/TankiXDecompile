Shader "Alternativa/EMPVisualEffectShader" {
	Properties {
		_MainColor ("Main Intersection Color", Color) = (1,1,1,1)
		_Color ("Main Rim Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_MainTex2 ("Main Texture", 2D) = "white" {}
		_RimColor ("Rim Color", Color) = (1,1,1,1)
		_RimWidth ("Rim Width", Range(0, 2)) = 1.777
		_RimColorMultiplier ("Rim Color Multiplier", Range(1, 10)) = 1.3
		_IntersectionColor ("Intersection Highlight Color", Color) = (1,1,1,1)
		_IntersectionDistance ("Intersection Highlight Distance", Range(0, 20)) = 2.7
		_UVSpeedMultiplier ("UV Speed Coeff", Range(0, 10)) = 1
	}
	SubShader {
		Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "SPHERE"
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 38122
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 sv_position : SV_Position0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex2_ST;
			float4 _RimColor;
			float _RimWidth;
			float _UVSpeedMultiplier;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _MainColor;
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.sv_position = tmp0;
                tmp1.xy = _Time.yy * _UVSpeedMultiplier.xx + v.texcoord.yx;
                tmp1.zw = v.texcoord.xy;
                o.texcoord.xy = tmp1.zx * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = tmp1.yw * _MainTex2_ST.xy + _MainTex2_ST.zw;
                tmp1.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp1.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = tmp1.xyz + unity_WorldToObject._m03_m13_m23;
                tmp1.xyz = tmp1.xyz - v.vertex.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.x = dot(v.normal.xyz, tmp1.xyz);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.y = 1.0 - _RimWidth;
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.y = 1.0 - tmp1.y;
                tmp1.y = 1.0 / tmp1.y;
                tmp1.x = saturate(tmp1.y * tmp1.x);
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp2 = v.color * _RimColor;
                o.color = tmp1.xxxx * tmp2;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                o.texcoord3 = v.texcoord;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.x = _Color.w * _MainColor.w;
                o.sv_target.w = tmp0.x * inp.color.w;
                o.sv_target.xyz = inp.color.xyz * _MainColor.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "RIM"
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			GpuProgramID 127917
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 sv_position : SV_Position0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex2_ST;
			float4 _RimColor;
			float _RimWidth;
			float _UVSpeedMultiplier;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _RimColorMultiplier;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _MainTex2;
			
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.sv_position = tmp0;
                tmp1.xy = _Time.yy * _UVSpeedMultiplier.xx + v.texcoord.yx;
                tmp1.zw = v.texcoord.xy;
                o.texcoord.xy = tmp1.zx * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = tmp1.yw * _MainTex2_ST.xy + _MainTex2_ST.zw;
                tmp1.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp1.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = tmp1.xyz + unity_WorldToObject._m03_m13_m23;
                tmp1.xyz = tmp1.xyz - v.vertex.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.x = dot(v.normal.xyz, tmp1.xyz);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.y = 1.0 - _RimWidth;
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.y = 1.0 - tmp1.y;
                tmp1.y = 1.0 / tmp1.y;
                tmp1.x = saturate(tmp1.y * tmp1.x);
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp2 = v.color * _RimColor;
                o.color = tmp1.xxxx * tmp2;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                o.texcoord3 = v.texcoord;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = _Color * _RimColorMultiplier.xxxx;
                tmp2.w = tmp0.w * tmp1.w;
                tmp2.xyz = tmp0.xyz * tmp1.xyz + inp.color.xyz;
                tmp0 = tex2D(_MainTex2, inp.texcoord1.xy);
                tmp3.w = tmp1.w * tmp0.w;
                tmp3.xyz = tmp0.xyz * tmp1.xyz + inp.color.xyz;
                tmp0 = tmp2 * tmp3;
                tmp1.w = tmp0.w;
                tmp2.x = dot(inp.color, inp.color);
                tmp2.w = sqrt(tmp2.x);
                tmp1.xyz = inp.color.xyz;
                tmp2.xyz = inp.color.xyz;
                tmp1 = tmp1 * tmp2;
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp1;
                o.sv_target.w = tmp0.w * _Color.w;
                o.sv_target.xyz = tmp0.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "INTERSECTION"
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 144879
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 sv_position : SV_Position0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex2_ST;
			float4 _RimColor;
			float _RimWidth;
			float _UVSpeedMultiplier;
			// $Globals ConstantBuffers for Fragment Shader
			float _IntersectionDistance;
			float4 _Color;
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
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.sv_position = tmp0;
                tmp1.xy = _Time.yy * _UVSpeedMultiplier.xx + v.texcoord.yx;
                tmp1.zw = v.texcoord.xy;
                o.texcoord.xy = tmp1.zx * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = tmp1.yw * _MainTex2_ST.xy + _MainTex2_ST.zw;
                tmp1.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp1.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp1.xyz;
                tmp1.xyz = tmp1.xyz + unity_WorldToObject._m03_m13_m23;
                tmp1.xyz = tmp1.xyz - v.vertex.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.x = dot(v.normal.xyz, tmp1.xyz);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.y = 1.0 - _RimWidth;
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.y = 1.0 - tmp1.y;
                tmp1.y = 1.0 / tmp1.y;
                tmp1.x = saturate(tmp1.y * tmp1.x);
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp2 = v.color * _RimColor;
                o.color = tmp1.xxxx * tmp2;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                o.texcoord3 = v.texcoord;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp0 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - inp.texcoord2.w;
                tmp0.x = tmp0.x / _IntersectionDistance;
                tmp0.y = saturate(tmp0.x);
                tmp0.z = tmp0.y * 2.666667;
                tmp0.y = tmp0.y * -2.666667 + 2.666667;
                tmp0.y = min(tmp0.y, tmp0.z);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.z = _Color.w * _Color.w;
                tmp1.w = tmp0.y * tmp0.z;
                tmp0.y = dot(-tmp0.xy, -tmp0.xy);
                tmp0.x = tmp0.x <= 1.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = min(tmp0.y, 1.0);
                tmp1.xyz = tmp0.yyy * float3(7.0, 7.0, 6.0) + float3(0.0, 0.0, 1.0);
                tmp0 = tmp1 * tmp0.xxxx;
                o.sv_target = tmp0 * inp.color;
                return o;
			}
			ENDCG
		}
	}
}