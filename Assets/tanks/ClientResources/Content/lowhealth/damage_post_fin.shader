Shader "Shader Forge/damage_post_fin" {
	Properties {
		[HideInInspector] _MainTex ("MainTex", 2D) = "white" {}
		_distortion ("distortion", 2D) = "white" {}
		_TV_lines ("TV_lines", 2D) = "white" {}
		_mask ("mask", 2D) = "white" {}
		_dist_amount ("dist_amount", Range(0, 1)) = 0
		_damage_pixel_offset ("damage_pixel_offset", Range(0, 1)) = 0.15
		_ani_speed ("ani_speed", Range(0, 5)) = 0
		_damaged_pixel_mask ("damaged_pixel_mask", Range(0, 1)) = 1
		_pixel_mask_ani_speed ("pixel_mask_ani_speed", Range(0, 1)) = 0.3
		_fade_min ("fade_min", Range(0, 1)) = 0.18
		_fade_max ("fade_max", Range(0, 1)) = 0.72
		_fade_color ("fade_color", Color) = (1,0.145098,0,1)
		_desaturate ("desaturate", Range(0, 1)) = 0.35
		_color_distort_size ("color_distort_size", Range(0, 0.1)) = 0.002
		_color_distort_speed ("color_distort_speed", Range(0, 20)) = 14.5
		_TV_lines_speed ("TV_lines_speed", Range(0, 1)) = 1
		_line_size ("line_size", Float) = 40
		_TV_vis ("TV_vis", Range(0, 1)) = 0
		_TV_speed_mask ("TV_speed_mask", Range(0, 1)) = 0.25
		_lines_blink_speed ("lines_blink_speed", Range(0, 1)) = 0.12
		_damage_lvl ("damage_lvl", Range(0, 100)) = 0
		_damage_lvl_start ("damage_lvl_start", Float) = 0
		_damage_lvl_1 ("damage_lvl_1", Float) = 25
		_damage_lvl_2 ("damage_lvl_2", Float) = 50
		_damage_lvl_3 ("damage_lvl_3", Float) = 75
		_damage_lvl_4 ("damage_lvl_4", Float) = 100
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+1" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+1" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			ZClip Off
			ZTest Always
			ZWrite Off
			GpuProgramID 34789
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_ST;
			float _dist_amount;
			float _damage_pixel_offset;
			float _ani_speed;
			float4 _mask_ST;
			float _damaged_pixel_mask;
			float _pixel_mask_ani_speed;
			float _fade_min;
			float _fade_max;
			float4 _fade_color;
			float _desaturate;
			float _color_distort_size;
			float _color_distort_speed;
			float _TV_lines_speed;
			float _line_size;
			float _TV_vis;
			float _TV_speed_mask;
			float _lines_blink_speed;
			float _damage_lvl;
			float _damage_lvl_1;
			float _damage_lvl_2;
			float _damage_lvl_3;
			float _damage_lvl_4;
			float _damage_lvl_start;
			float4 _distortion_ST;
			float4 _TV_lines_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _distortion;
			sampler2D _mask;
			sampler2D _MainTex;
			sampler2D _TV_lines;
			
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
                tmp0.xy = inp.texcoord.xy * _distortion_ST.xy + _distortion_ST.zw;
                tmp0 = tex2D(_distortion, tmp0.xy);
                tmp0 = tmp0.xxyy * _dist_amount.xxxx + inp.texcoord.xxyy;
                tmp1.x = _dist_amount + 1.0;
                tmp0 = tmp0 / tmp1.xxxx;
                tmp0 = tmp0 - inp.texcoord.xxyy;
                tmp1.x = 1.0 / _damage_pixel_offset;
                tmp1.xy = saturate(tmp0.yw * tmp1.xx);
                tmp1.zw = tmp1.xy * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp1.xy = tmp1.xy * tmp1.xy;
                tmp1.xy = tmp1.xy * tmp1.zw;
                tmp1.z = _ani_speed * _Time.y;
                tmp1.w = frac(tmp1.z);
                tmp2.xy = tmp1.zz * float2(3.5, 10.3);
                tmp2.xy = frac(tmp2.xy);
                tmp1.z = tmp1.w * tmp2.x;
                tmp1.z = tmp2.y * tmp1.z;
                tmp1.xy = tmp1.xy * tmp1.zz;
                tmp0 = tmp0 * tmp1.zzzz;
                tmp0 = tmp0 * float4(1.0, 0.0, 0.0, 1.0) + inp.texcoord.xyxy;
                tmp1.z = _pixel_mask_ani_speed * _Time.y;
                tmp1.z = tmp1.z * 5.0;
                tmp1.z = frac(tmp1.z);
                tmp2.xyz = tmp1.zzz >= float3(0.3, 0.6, 0.9);
                tmp2.xyz = tmp2.xyz ? 1.0 : 0.0;
                tmp1.zw = inp.texcoord.xy * _mask_ST.xy + _mask_ST.zw;
                tmp3 = tex2D(_mask, tmp1.zw);
                tmp1.z = tmp3.y - tmp3.x;
                tmp1.z = tmp2.x * tmp1.z + tmp3.x;
                tmp1.w = tmp3.z - tmp1.z;
                tmp1.z = tmp2.y * tmp1.w + tmp1.z;
                tmp1.w = tmp3.w - tmp1.z;
                tmp1.z = tmp2.z * tmp1.w + tmp1.z;
                tmp2.xy = float2(_damage_lvl.x, _damage_lvl_1.x) - _damage_lvl_start.xx;
                tmp1.w = 1.0 / tmp2.x;
                tmp1.w = saturate(tmp1.w * tmp2.y);
                tmp2.x = tmp1.w * -2.0 + 3.0;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.x = -_damaged_pixel_mask * tmp1.w + 1.0;
                tmp1.z = tmp2.x >= tmp1.z;
                tmp1.z = tmp1.z ? 0.0 : 1.0;
                tmp1.xy = tmp1.zz * tmp1.xy + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp1.xy);
                tmp4.y = tmp3.y;
                tmp1.xy = float2(_damage_lvl.x, _damage_lvl_3.x) - _damage_lvl_2.xx;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = saturate(tmp1.x * tmp1.y);
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.y = tmp1.x * _color_distort_size;
                tmp1.x = tmp1.x * _TV_vis;
                tmp2.xzw = float3(_color_distort_speed.x, _TV_lines_speed.xx) * _Time.yyy;
                tmp2.xzw = tmp2.xzw * float3(1.1, 0.0, 1.0);
                tmp2.x = inp.texcoord.y * 256.0 + tmp2.x;
                tmp2.zw = inp.texcoord.xy * _line_size.xx + tmp2.zw;
                tmp2.zw = tmp2.zw * _TV_lines_ST.xy + _TV_lines_ST.zw;
                tmp5 = tex2D(_TV_lines, tmp2.zw);
                tmp2.x = sin(tmp2.x);
                tmp2.z = inp.texcoord.x * 2.0 + -1.0;
                tmp2.x = tmp2.z * 2.0 + tmp2.x;
                tmp6.xz = tmp1.yy * tmp2.xx;
                tmp6.yw = float2(0.0, 0.0);
                tmp0 = tmp0 + tmp6;
                tmp0 = tmp0 * _MainTex_ST + _MainTex_ST;
                tmp6 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp4.z = tmp0.z;
                tmp4.x = tmp6.x;
                tmp0.xyz = tmp4.xyz - tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.www;
                tmp0.xyz = tmp1.zzz * tmp0.xyz + tmp3.xyz;
                tmp0.w = dot(tmp0.xyz, float3(0.3, 0.59, 0.11));
                tmp1.yzw = tmp0.www - tmp0.xyz;
                tmp0.w = _damage_lvl_4 - _damage_lvl_start;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = saturate(tmp0.w * tmp2.y);
                tmp2.x = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.x = tmp0.w * _desaturate;
                tmp1.yzw = tmp2.xxx * tmp1.yzw + tmp0.xyz;
                tmp4.w = tmp0.y;
                tmp0.xyz = tmp4.xwz * _fade_color.xyz + -tmp1.yzw;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.x = dot(tmp2.xy, tmp2.xy);
                tmp2.x = sqrt(tmp2.x);
                tmp2.x = tmp2.x - _fade_min;
                tmp2.y = _fade_max - _fade_min;
                tmp2.y = 1.0 / tmp2.y;
                tmp2.x = saturate(tmp2.y * tmp2.x);
                tmp2.y = tmp2.x * -2.0 + 3.0;
                tmp2.x = tmp2.x * tmp2.x;
                tmp2.x = tmp2.x * tmp2.y;
                tmp0.w = tmp0.w * tmp2.x;
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp1.yzw;
                tmp1.yzw = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp1.yzw = -tmp1.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.w = 1.0 - tmp5.x;
                tmp2.xyz = tmp0.xyz * tmp5.xxx;
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp1.yzw = -tmp1.yzw * tmp0.www + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp1.yzw = saturate(tmp3.xyz ? tmp1.yzw : tmp2.xyz);
                tmp1.yzw = tmp1.yzw - tmp0.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + tmp0.xyz;
                tmp2.xyz = tmp0.xyz - tmp1.xyz;
                tmp3.xw = _TV_speed_mask.xx;
                tmp3.yz = float2(1.0, 0.0);
                tmp3.xy = tmp3.xy * _Time.yy;
                tmp3.yz = tmp3.xy * tmp3.zw + inp.texcoord.xy;
                tmp3.xw = tmp3.xx * float2(0.0, 1.5) + inp.texcoord.xy;
                tmp3.xw = tmp3.xw * _TV_lines_ST.xy + _TV_lines_ST.zw;
                tmp4 = tex2D(_TV_lines, tmp3.xw);
                tmp0.w = tmp4.y <= 0.2;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp3.xy = tmp3.yz * _TV_lines_ST.xy + _TV_lines_ST.zw;
                tmp3 = tex2D(_TV_lines, tmp3.xy);
                tmp1.w = tmp3.y <= 0.5;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.xyz = tmp0.www * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.w = _lines_blink_speed * _Time.y;
                tmp1.w = tmp0.w * 3.0;
                tmp0.w = frac(tmp0.w);
                tmp0.w = tmp0.w >= 0.2;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp1.w = frac(tmp1.w);
                tmp1.w = tmp1.w >= 0.2;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}