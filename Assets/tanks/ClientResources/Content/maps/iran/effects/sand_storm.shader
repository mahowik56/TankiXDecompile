Shader "Shader Forge/sand_storm" {
	Properties {
		_Color ("Color", Color) = (0.7098039,0.5529412,0.3686275,1)
		_cloud_nrm ("cloud_nrm", 2D) = "white" {}
		_sand_storm_nrm ("sand_storm_nrm", 2D) = "white" {}
		_cloud_ao ("cloud_ao", 2D) = "white" {}
		_sand_storm_ao ("sand_storm_ao", 2D) = "white" {}
		_sand_storm_mask ("sand_storm_mask", 2D) = "white" {}
		_distortion_nrm ("distortion_nrm", 2D) = "white" {}
		_speed_1 ("speed_1", Range(-10, 10)) = 0
		_speed_2 ("speed_2", Range(-10, 10)) = 1
		_distortion_scale ("distortion_scale", Range(0, 5)) = 1
		_distortion_speed ("distortion_speed", Range(-10, 10)) = 0
		_distortion_speed_1 ("distortion_speed_1", Range(-10, 10)) = 0
		_refl_amount ("refl_amount", Range(0, 0.2)) = 0
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			GpuProgramID 25082
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _Color;
			float4 _cloud_nrm_ST;
			float4 _sand_storm_nrm_ST;
			float4 _cloud_ao_ST;
			float4 _sand_storm_ao_ST;
			float _distortion_scale;
			float4 _sand_storm_mask_ST;
			float4 _distortion_nrm_ST;
			float _speed_2;
			float _speed_1;
			float _distortion_speed;
			float _distortion_speed_1;
			float _refl_amount;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _distortion_nrm;
			sampler2D _cloud_nrm;
			sampler2D _sand_storm_nrm;
			sampler2D _sand_storm_ao;
			sampler2D _cloud_ao;
			sampler2D _sand_storm_mask;
			
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
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.x = 0.0;
                tmp0.z = _TimeEditor.x + _Time.x;
                tmp0.y = tmp0.z * _speed_2;
                tmp1.xyw = tmp0.zzz * float3(_speed_1.x, _distortion_speed.x, _distortion_speed_1.x);
                tmp0.zw = inp.texcoord.xy * _distortion_scale.xx + tmp1.xy;
                tmp0.zw = tmp0.zw * _distortion_nrm_ST.xy + _distortion_nrm_ST.zw;
                tmp2 = tex2D(_distortion_nrm, tmp0.zw);
                tmp0.zw = tmp2.xy * _refl_amount.xx + inp.texcoord.xy;
                tmp0.xy = tmp0.xy + tmp0.zw;
                tmp1.xy = tmp0.xy * _cloud_nrm_ST.xy + _cloud_nrm_ST.zw;
                tmp0.xy = tmp0.xy * _cloud_ao_ST.xy + _cloud_ao_ST.zw;
                tmp2 = tex2D(_cloud_ao, tmp0.xy);
                tmp3 = tex2D(_cloud_nrm, tmp1.xy);
                tmp2.xzw = tmp3.xyz * float3(-1.0, -1.0, 1.0);
                tmp1.z = 0.0;
                tmp0.xy = tmp1.zw + tmp0.zw;
                tmp1.xy = tmp0.xy * _cloud_nrm_ST.xy + _cloud_nrm_ST.zw;
                tmp0.xy = tmp0.xy * _cloud_ao_ST.xy + _cloud_ao_ST.zw;
                tmp4 = tex2D(_cloud_ao, tmp0.xy);
                tmp0.x = tmp2.y + tmp4.y;
                tmp1 = tex2D(_cloud_nrm, tmp1.xy);
                tmp1.xyz = tmp1.xyz + float3(0.0, 0.0, 1.0);
                tmp0.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.xyw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp1.xyw / tmp1.zzz;
                tmp1.xyz = -tmp3.xyz * float3(-1.0, -1.0, 1.0) + tmp1.xyz;
                tmp1.xyz = tmp1.xyz + float3(0.0, 0.0, 1.0);
                tmp2.xz = tmp0.zw * _sand_storm_nrm_ST.xy + _sand_storm_nrm_ST.zw;
                tmp3 = tex2D(_sand_storm_nrm, tmp2.xz);
                tmp2.xzw = tmp3.xyz * float3(-1.0, -1.0, 1.0);
                tmp0.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.xyw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp1.xyw / tmp1.zzz;
                tmp1.xyz = -tmp3.xyz * float3(-1.0, -1.0, 1.0) + tmp1.xyz;
                tmp2.xzw = tmp1.yyy * inp.texcoord4.xyz;
                tmp2.xzw = tmp1.xxx * inp.texcoord3.xyz + tmp2.xzw;
                tmp0.y = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp3.xyz = tmp0.yyy * inp.texcoord2.xyz;
                tmp2.xzw = tmp1.zzz * tmp3.xyz + tmp2.xzw;
                tmp0.y = dot(tmp2.xyz, tmp2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp2.xzw = tmp0.yyy * tmp2.xzw;
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.y = dot(tmp3.xyz, tmp3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp4.xyz = tmp0.yyy * tmp3.xyz;
                tmp1.w = dot(tmp2.xyz, tmp4.xyz);
                tmp1.x = dot(tmp1.xyz, tmp4.xyz);
                tmp1.xy = max(tmp1.xw, float2(0.0, 0.0));
                tmp1.xz = float2(1.0, 1.00001) - tmp1.xy;
                tmp1.y = tmp1.y * 0.2021154 + 0.7978846;
                tmp1.w = tmp1.z * tmp1.z;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.z = tmp1.w * tmp1.z;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp3.xyz = tmp3.xyz * tmp0.yyy + tmp4.xyz;
                tmp0.y = dot(tmp3.xyz, tmp3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp0.y = dot(tmp4.xyz, tmp3.xyz);
                tmp1.w = dot(tmp2.xyz, tmp3.xyz);
                tmp2.x = dot(tmp2.xyz, tmp4.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.y = max(tmp0.y, 0.0);
                tmp2.z = tmp0.y + tmp0.y;
                tmp2.z = tmp2.z * tmp0.y + -0.5;
                tmp0.y = 1.0 - tmp0.y;
                tmp1.z = tmp2.z * tmp1.z + 1.0;
                tmp2.w = max(tmp2.x, 0.0);
                tmp2.x = max(-tmp2.x, 0.0);
                tmp3.x = 1.00001 - tmp2.w;
                tmp3.y = tmp3.x * tmp3.x;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.x = tmp3.y * tmp3.x;
                tmp2.z = tmp2.z * tmp3.x + 1.0;
                tmp1.z = tmp1.z * tmp2.z;
                tmp3.xy = tmp0.zw * _sand_storm_ao_ST.xy + _sand_storm_ao_ST.zw;
                tmp0.zw = tmp0.zw * _sand_storm_mask_ST.xy + _sand_storm_mask_ST.zw;
                tmp4 = tex2D(_sand_storm_mask, tmp0.zw);
                o.sv_target.w = tmp4.x;
                tmp3 = tex2D(_sand_storm_ao, tmp3.xy);
                tmp0.z = tmp3.y * tmp3.y + -0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp3.xzw = float3(1.0, 1.0, 1.0) - _Color.xyz;
                tmp4.xyz = -tmp0.zzz * tmp3.xzw + float3(1.0, 1.0, 1.0);
                tmp0.z = tmp3.y * tmp3.y;
                tmp0.x = tmp0.x * tmp3.y;
                tmp0.x = tmp0.x * 0.5;
                tmp0.w = tmp0.z + tmp0.z;
                tmp0.z = tmp0.z > 0.5;
                tmp5.xyz = tmp0.www * _Color.xyz;
                tmp4.xyz = saturate(tmp0.zzz ? tmp4.xyz : tmp5.xyz);
                tmp5.xyz = tmp1.xxx - tmp4.xyz;
                tmp5.xyz = tmp5.xyz * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp5.xyz = _Color.xyz * float3(10.0, 10.0, 10.0) + tmp5.xyz;
                tmp5.xyz = tmp2.xxx * tmp5.xyz + tmp2.www;
                tmp5.xyz = tmp1.zzz * tmp2.www + tmp5.xyz;
                tmp6.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xzw = tmp0.xxx * tmp6.xyz;
                tmp0.xzw = tmp5.xyz * _LightColor0.xyz + tmp0.xzw;
                tmp1.x = tmp2.w * 0.2021154 + 0.7978846;
                tmp1.x = tmp1.x * tmp1.y + 0.00001;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = tmp1.x * 0.25;
                tmp1.x = tmp1.x * tmp2.w;
                tmp1.y = log(tmp1.w);
                tmp1.z = tmp1.w * tmp1.w;
                tmp2.xzw = tmp1.zzz * _LightColor0.xyz;
                tmp1.y = tmp1.y * 0.0001;
                tmp1.y = exp(tmp1.y);
                tmp1.y = tmp1.y * 0.3183258;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.x = tmp1.x * 0.7853982;
                tmp1.xyz = tmp1.xxx * tmp2.xzw;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1.w = tmp0.y * tmp0.y;
                tmp1.w = tmp1.w * tmp1.w;
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.y = tmp0.y * 0.96 + 0.04;
                tmp1.xyz = tmp0.yyy * tmp1.xyz;
                tmp0.y = tmp2.y * tmp2.y + -0.5;
                tmp1.w = tmp2.y * tmp2.y;
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp2.xyz = -tmp0.yyy * tmp3.xzw + float3(1.0, 1.0, 1.0);
                tmp0.y = tmp1.w + tmp1.w;
                tmp1.w = tmp1.w > 0.5;
                tmp3.xyz = tmp0.yyy * _Color.xyz;
                tmp2.xyz = saturate(tmp1.www ? tmp2.xyz : tmp3.xyz);
                tmp2.xyz = tmp2.xyz + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.48, 0.48, 0.48);
                o.sv_target.xyz = tmp0.xzw * tmp2.xyz + tmp1.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			GpuProgramID 125511
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _Color;
			float4 _cloud_nrm_ST;
			float4 _sand_storm_nrm_ST;
			float4 _cloud_ao_ST;
			float4 _sand_storm_ao_ST;
			float _distortion_scale;
			float4 _sand_storm_mask_ST;
			float4 _distortion_nrm_ST;
			float _speed_2;
			float _speed_1;
			float _distortion_speed;
			float _distortion_speed_1;
			float _refl_amount;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _distortion_nrm;
			sampler2D _cloud_nrm;
			sampler2D _sand_storm_nrm;
			sampler2D _LightTexture0;
			sampler2D _sand_storm_ao;
			sampler2D _cloud_ao;
			sampler2D _sand_storm_mask;
			
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
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord3.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord4.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                float4 tmp5;
                tmp0.x = 0.0;
                tmp0.z = _TimeEditor.x + _Time.x;
                tmp0.y = tmp0.z * _speed_2;
                tmp1.xyw = tmp0.zzz * float3(_speed_1.x, _distortion_speed.x, _distortion_speed_1.x);
                tmp0.zw = inp.texcoord.xy * _distortion_scale.xx + tmp1.xy;
                tmp0.zw = tmp0.zw * _distortion_nrm_ST.xy + _distortion_nrm_ST.zw;
                tmp2 = tex2D(_distortion_nrm, tmp0.zw);
                tmp0.zw = tmp2.xy * _refl_amount.xx + inp.texcoord.xy;
                tmp0.xy = tmp0.xy + tmp0.zw;
                tmp1.xy = tmp0.xy * _cloud_nrm_ST.xy + _cloud_nrm_ST.zw;
                tmp0.xy = tmp0.xy * _cloud_ao_ST.xy + _cloud_ao_ST.zw;
                tmp2 = tex2D(_cloud_ao, tmp0.xy);
                tmp3 = tex2D(_cloud_nrm, tmp1.xy);
                tmp2.xzw = tmp3.xyz * float3(-1.0, -1.0, 1.0);
                tmp1.z = 0.0;
                tmp0.xy = tmp1.zw + tmp0.zw;
                tmp0.xy = tmp0.xy * _cloud_nrm_ST.xy + _cloud_nrm_ST.zw;
                tmp1 = tex2D(_cloud_nrm, tmp0.xy);
                tmp1.xyz = tmp1.xyz + float3(0.0, 0.0, 1.0);
                tmp0.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.xyw = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp1.xyw / tmp1.zzz;
                tmp1.xyz = -tmp3.xyz * float3(-1.0, -1.0, 1.0) + tmp1.xyz;
                tmp1.xyz = tmp1.xyz + float3(0.0, 0.0, 1.0);
                tmp0.xy = tmp0.zw * _sand_storm_nrm_ST.xy + _sand_storm_nrm_ST.zw;
                tmp3 = tex2D(_sand_storm_nrm, tmp0.xy);
                tmp2.xzw = tmp3.xyz * float3(-1.0, -1.0, 1.0);
                tmp0.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.xyw = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp1.xyw / tmp1.zzz;
                tmp1.xyz = -tmp3.xyz * float3(-1.0, -1.0, 1.0) + tmp1.xyz;
                tmp2.xzw = tmp1.yyy * inp.texcoord4.xyz;
                tmp2.xzw = tmp1.xxx * inp.texcoord3.xyz + tmp2.xzw;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp2.xzw = tmp1.zzz * tmp3.xyz + tmp2.xzw;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xzw = tmp0.xxx * tmp2.xzw;
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.y = dot(tmp2.xyz, tmp4.xyz);
                tmp1.x = dot(tmp1.xyz, tmp4.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp0.y = max(tmp0.y, 0.0);
                tmp1.y = 1.00001 - tmp0.y;
                tmp0.y = tmp0.y * 0.2021154 + 0.7978846;
                tmp1.z = tmp1.y * tmp1.y;
                tmp1.z = tmp1.z * tmp1.z;
                tmp1.y = tmp1.z * tmp1.y;
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp1.z = dot(tmp4.xyz, tmp4.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp4.xyz = tmp1.zzz * tmp4.xyz;
                tmp3.xyz = tmp3.xyz * tmp0.xxx + tmp4.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.x = dot(tmp4.xyz, tmp3.xyz);
                tmp1.z = dot(tmp2.xyz, tmp3.xyz);
                tmp1.w = dot(tmp2.xyz, tmp4.xyz);
                tmp1.z = max(tmp1.z, 0.0);
                tmp0.x = max(tmp0.x, 0.0);
                tmp2.x = tmp0.x + tmp0.x;
                tmp2.x = tmp2.x * tmp0.x + -0.5;
                tmp0.x = 1.0 - tmp0.x;
                tmp1.y = tmp2.x * tmp1.y + 1.0;
                tmp2.z = max(tmp1.w, 0.0);
                tmp1.w = max(-tmp1.w, 0.0);
                tmp2.w = 1.00001 - tmp2.z;
                tmp3.x = tmp2.w * tmp2.w;
                tmp3.x = tmp3.x * tmp3.x;
                tmp2.w = tmp2.w * tmp3.x;
                tmp2.x = tmp2.x * tmp2.w + 1.0;
                tmp1.y = tmp1.y * tmp2.x;
                tmp2.xw = tmp0.zw * _sand_storm_ao_ST.xy + _sand_storm_ao_ST.zw;
                tmp0.zw = tmp0.zw * _sand_storm_mask_ST.xy + _sand_storm_mask_ST.zw;
                tmp3 = tex2D(_sand_storm_mask, tmp0.zw);
                tmp4 = tex2D(_sand_storm_ao, tmp2.xw);
                tmp0.z = tmp4.y * tmp4.y + -0.5;
                tmp0.w = tmp4.y * tmp4.y;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp3.yzw = float3(1.0, 1.0, 1.0) - _Color.xyz;
                tmp4.xyz = -tmp0.zzz * tmp3.yzw + float3(1.0, 1.0, 1.0);
                tmp0.z = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp5.xyz = tmp0.zzz * _Color.xyz;
                tmp4.xyz = saturate(tmp0.www ? tmp4.xyz : tmp5.xyz);
                tmp5.xyz = tmp1.xxx - tmp4.xyz;
                tmp5.xyz = tmp5.xyz * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp5.xyz = _Color.xyz * float3(10.0, 10.0, 10.0) + tmp5.xyz;
                tmp5.xyz = tmp1.www * tmp5.xyz + tmp2.zzz;
                tmp1.xyw = tmp1.yyy * tmp2.zzz + tmp5.xyz;
                tmp0.z = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp5 = tex2D(_LightTexture0, tmp0.zz);
                tmp5.xyz = tmp5.xxx * _LightColor0.xyz;
                tmp1.xyw = tmp1.xyw * tmp5.xyz;
                tmp0.z = tmp2.z * 0.2021154 + 0.7978846;
                tmp0.y = tmp0.z * tmp0.y + 0.00001;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.y = tmp0.y * 0.25;
                tmp0.y = tmp0.y * tmp2.z;
                tmp0.z = log(tmp1.z);
                tmp0.w = tmp1.z * tmp1.z;
                tmp2.xzw = tmp0.www * tmp5.xyz;
                tmp0.z = tmp0.z * 0.0001;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * 0.3183258;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = tmp0.y * 0.7853982;
                tmp0.yzw = tmp0.yyy * tmp2.xzw;
                tmp0.yzw = tmp0.yzw * _LightColor0.xyz;
                tmp1.z = tmp0.x * tmp0.x;
                tmp1.z = tmp1.z * tmp1.z;
                tmp0.x = tmp0.x * tmp1.z;
                tmp0.x = tmp0.x * 0.96 + 0.04;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = tmp2.y * tmp2.y + -0.5;
                tmp1.z = tmp2.y * tmp2.y;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp2.xyz = -tmp0.www * tmp3.yzw + float3(1.0, 1.0, 1.0);
                tmp0.w = tmp1.z + tmp1.z;
                tmp1.z = tmp1.z > 0.5;
                tmp3.yzw = tmp0.www * _Color.xyz;
                tmp2.xyz = saturate(tmp1.zzz ? tmp2.xyz : tmp3.yzw);
                tmp2.xyz = tmp2.xyz + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.48, 0.48, 0.48);
                tmp0.xyz = tmp1.xyw * tmp2.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp3.xxx * tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Alternativa/Invisible"
	CustomEditor "ShaderForgeMaterialInspector"
}