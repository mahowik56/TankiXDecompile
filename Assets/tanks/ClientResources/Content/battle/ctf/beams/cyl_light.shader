Shader "Shader Forge/cyl_light" {
	Properties {
		_Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
		_falloff ("falloff", Range(-1, 0)) = -0.5
		_speed ("speed", Range(0, 10)) = 3
		_noise ("noise", 2D) = "white" {}
		_center_falloff ("center_falloff", Range(-1, 0)) = -0.98
		_dust_size ("dust_size", Range(0, 1)) = 0.053
		_dust_speed ("dust_speed", Range(0, 10)) = 9
		_glow_vis ("glow_vis", Range(0, 1)) = 0.4
		_glow_falloff ("glow_falloff", Range(-1, 0)) = -0.8
		_glow_center_falloff ("glow_center_falloff", Range(-1, 0)) = -0.95
		_power ("power", Range(0, 3)) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			GpuProgramID 47045
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _falloff;
			float _speed;
			float4 _noise_ST;
			float _center_falloff;
			float _dust_size;
			float _dust_speed;
			float _glow_vis;
			float _glow_falloff;
			float _glow_center_falloff;
			float _power;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _noise;
			
			// Keywords: DIRECTIONAL
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
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy * float2(2.0, 4.0);
                tmp0.z = _dust_speed * _Time.x;
                tmp0 = tmp0.zzzz * float4(0.0, -1.0, 0.0, -2.0) + tmp0.xyxy;
                tmp0 = tmp0 * _noise_ST + _noise_ST;
                tmp1 = tex2D(_noise, tmp0.xy);
                tmp0 = tex2D(_noise, tmp0.zw);
                tmp0.x = 1.0 - tmp1.x;
                tmp0.z = dot(tmp1.xy, tmp0.xy);
                tmp0.w = tmp0.y - 0.5;
                tmp0.y = tmp0.y > 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.x = -tmp0.w * tmp0.x + 1.0;
                tmp0.x = saturate(tmp0.y ? tmp0.x : tmp0.z);
                tmp0.x = _dust_size >= tmp0.x;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.xyz = tmp0.xxx * _Color.xyz;
                tmp0.w = _speed * _Time.x;
                tmp1.y = -tmp0.w;
                tmp1.w = tmp0.w * -2.0;
                tmp1.xz = float2(0.0, 0.0);
                tmp1.xy = inp.texcoord.xy * float2(3.0, 0.5) + tmp1.xy;
                tmp1.zw = inp.texcoord.xy * float2(3.0, 0.5) + tmp1.zw;
                tmp1.zw = tmp1.zw * _noise_ST.xy + _noise_ST.zw;
                tmp2 = tex2D(_noise, tmp1.zw);
                tmp1.xy = tmp1.xy * _noise_ST.xy + _noise_ST.zw;
                tmp1 = tex2D(_noise, tmp1.xy);
                tmp0.w = 1.0 - tmp1.x;
                tmp1.x = dot(tmp1.xy, tmp2.xy);
                tmp1.y = tmp2.y - 0.5;
                tmp1.z = tmp2.y > 0.5;
                tmp1.y = -tmp1.y * 2.0 + 1.0;
                tmp0.w = -tmp1.y * tmp0.w + 1.0;
                tmp0.w = saturate(tmp1.z ? tmp0.w : tmp1.x);
                tmp1.xy = unity_ObjectToWorld._m03_m23 - _WorldSpaceCameraPos.xz;
                tmp1.z = dot(tmp1.xy, tmp1.xy);
                tmp1.z = rsqrt(tmp1.z);
                tmp1.xy = tmp1.zz * tmp1.xy;
                tmp1.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp1.zw = tmp1.zz * inp.texcoord1.xz;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = tmp1.x + 1.0;
                tmp1.y = _center_falloff + 1.0;
                tmp1.y = 1.0 / tmp1.y;
                tmp1.y = saturate(tmp1.y * tmp1.x);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = -tmp1.z * tmp1.y + 1.0;
                tmp0.w = saturate(tmp0.w + tmp1.y);
                tmp0.xyz = _Color.xyz * tmp0.www + tmp0.xyz;
                tmp0.w = _falloff + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = saturate(tmp0.w * tmp1.x);
                tmp1.y = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = -tmp1.y * tmp0.w + 1.0;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp1.yz = float2(_glow_falloff.x, _glow_center_falloff.x) + float2(1.0, 1.0);
                tmp1.yz = float2(1.0, 1.0) / tmp1.yz;
                tmp1.xy = saturate(tmp1.yz * tmp1.xx);
                tmp1.zw = tmp1.xy * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp1.xy = tmp1.xy * tmp1.xy;
                tmp0.w = tmp1.y * tmp1.w;
                tmp1.x = -tmp1.z * tmp1.x + 1.0;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.xyz = tmp0.www * _Color.xyz;
                tmp1.xyz = tmp1.xyz * _glow_vis.xxx + -tmp0.xyz;
                tmp0.xyz = inp.color.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = 1.0 - inp.color.y;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz * _power.xxx;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}