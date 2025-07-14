Shader "Shader Forge/shield_test" {
	Properties {
		_Visibility ("Visibility", Range(0, 1)) = 1
		_Color ("Color", Color) = (1,0.682353,0,1)
		_edge_mask ("edge_mask", 2D) = "white" {}
		_gradient ("gradient", 2D) = "white" {}
		_speed ("speed", Range(-1, 3)) = 0.28
		_offset ("offset", Range(0, 1)) = 0.1
		_transparent ("transparent", Range(0, 1)) = 1
		_specularity ("specularity", Range(0, 1)) = 1
		_intersect_size ("intersect_size", Range(0, 1)) = 0.3
		_gloss ("gloss", Range(0, 1)) = 0.708
		_tint_color ("tint_color", Color) = (0.4941177,0.172549,0,1)
		_tint_size ("tint_size", Range(0, 5)) = 1
		_refraction ("refraction", Range(0, 1)) = 0.004
		_attack_point_size ("attack_point_size", Range(0, 1)) = 0.2379594
		_attack_offset ("attack_offset", Range(0, 1)) = 0
		_U ("U", Range(-1, 1)) = 1
		_V ("V", Range(-1, 1)) = 0.09942523
		_edge_thikness ("edge_thikness", Range(0, 1)) = 0
		_glow_size ("glow_size", Range(0, 1)) = 0.3
		_glow_color ("glow_color", Color) = (1,0.8627452,0.5019608,1)
		_normal ("normal", 2D) = "white" {}
		_plus_offset ("plus_offset", Range(0, 50)) = 0
	}
	SubShader {
		Tags { "QUEUE" = "Transparent+500" "RenderType" = "Opaque" }
		GrabPass {
			"_GrabTexture"
		}
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+500" "RenderType" = "Opaque" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			Cull Off
			GpuProgramID 9823
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
				float3 texcoord6 : TEXCOORD6;
				float4 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _gradient_ST;
			float _speed;
			float _offset;
			float _attack_point_size;
			float _attack_offset;
			float _U;
			float _V;
			float _plus_offset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 _edge_mask_ST;
			float _transparent;
			float _specularity;
			float _intersect_size;
			float _gloss;
			float4 _tint_color;
			float _tint_size;
			float _refraction;
			float _edge_thikness;
			float _glow_size;
			float4 _glow_color;
			float4 _normal_ST;
			float _Visibility;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _gradient;
			// Texture params for Fragment Shader
			sampler2D _normal;
			sampler2D _CameraDepthTexture;
			sampler2D _GrabTexture;
			sampler2D _edge_mask;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xy = v.texcoord2.xy + v.texcoord2.xy;
                tmp0.z = _speed * _Time.y;
                tmp0.xy = tmp0.zz * float2(2.0, 2.0) + tmp0.xy;
                tmp0.xy = tmp0.xy * _gradient_ST.xy + _gradient_ST.zw;
                tmp1 = tex2Dlod(_gradient, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = _speed.xx * _Time.yy + v.texcoord2.xy;
                tmp0.xy = tmp0.xy * _gradient_ST.xy + _gradient_ST.zw;
                tmp2 = tex2Dlod(_gradient, float4(tmp0.xy, 0, 0.0));
                tmp0.x = tmp1.x - tmp2.x;
                tmp0.x = tmp0.x * 0.5 + tmp2.x;
                tmp0.yw = v.texcoord2.xy * float2(3.0, 3.0);
                tmp0.yz = tmp0.zz * float2(3.0, 3.0) + tmp0.yw;
                tmp0.yz = tmp0.yz * _gradient_ST.xy + _gradient_ST.zw;
                tmp1 = tex2Dlod(_gradient, float4(tmp0.yz, 0, 0.0));
                tmp0.y = tmp1.x - tmp0.x;
                tmp0.x = saturate(tmp0.y * 0.5 + tmp0.x);
                tmp0.yz = v.texcoord1.xy + float2(_U.x, _V.x);
                tmp0.yz = tmp0.yz - _attack_point_size.xx;
                tmp0.y = dot(tmp0.xy, tmp0.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.z = _attack_point_size - 0.01;
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.y = tmp0.y - tmp0.z;
                tmp0.w = max(_attack_point_size, 0.01);
                tmp0.z = tmp0.w - tmp0.z;
                tmp0.y = saturate(tmp0.y / tmp0.z);
                tmp0.y = 1.0 - tmp0.y;
                tmp1.xyz = v.normal.xyz * _attack_offset.xxx;
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = v.normal.xyz * _offset.xxx;
                tmp0.xyz = tmp1.xyz * tmp0.xxx + tmp0.yzw;
                tmp0.xyz = v.normal.xyz * _plus_offset.xxx + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord3 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                o.texcoord2.xy = v.texcoord2.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                o.texcoord4.xyz = tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp3.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp3.xyz;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp3.xyz;
                o.texcoord5.xyz = tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx;
                tmp2.xyz = tmp2.yzx * tmp3.zxy + -tmp4.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord6.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord7.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord7.w = tmp0.w;
                o.texcoord7.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp, float facing: VFACE)
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
                tmp0.x = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord4.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xy = inp.texcoord.xy * _normal_ST.xy + _normal_ST.zw;
                tmp1 = tex2D(_normal, tmp1.xy);
                tmp2.xyz = tmp1.yyy * inp.texcoord6.xyz;
                tmp1.xyw = tmp1.xxx * inp.texcoord5.xyz + tmp2.xyz;
                tmp1.xyz = tmp1.zzz * tmp0.xyz + tmp1.xyw;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, tmp4.xyz));
                tmp1.w = saturate(dot(tmp2.xyz, tmp4.xyz));
                tmp2.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = dot(tmp1.xyz, tmp3.xyz);
                tmp0.x = dot(tmp3.xyz, tmp0.xyz);
                tmp0.y = max(tmp2.x, 0.0);
                tmp0.z = 1.0 - _gloss;
                tmp1.y = tmp0.z * tmp0.z;
                tmp1.z = tmp1.y * tmp1.y;
                tmp2.x = tmp0.w * tmp1.z + -tmp0.w;
                tmp0.w = tmp2.x * tmp0.w + 1.0;
                tmp0.w = tmp0.w * tmp0.w + 0.0000001;
                tmp1.z = tmp1.z * 0.3183099;
                tmp0.w = tmp1.z / tmp0.w;
                tmp1.z = -tmp0.z * tmp0.z + 1.0;
                tmp2.x = abs(tmp1.x) * tmp1.z + tmp1.y;
                tmp2.y = min(tmp0.y, 1.0);
                tmp1.y = tmp2.y * tmp1.z + tmp1.y;
                tmp1.y = tmp1.y * abs(tmp1.x);
                tmp1.x = 1.0 - abs(tmp1.x);
                tmp1.y = tmp2.y * tmp2.x + tmp1.y;
                tmp1.y = tmp1.y + 0.00001;
                tmp1.y = 0.5 / tmp1.y;
                tmp0.w = tmp0.w * tmp1.y;
                tmp0.w = tmp0.w * 3.141593;
                tmp0.w = tmp2.y * tmp0.w;
                tmp0.xw = max(tmp0.xw, float2(0.0, 0.0));
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.w = 1.0 - tmp1.w;
                tmp1.y = tmp0.w * tmp0.w;
                tmp1.y = tmp1.y * tmp1.y;
                tmp0.w = tmp0.w * tmp1.y;
                tmp0.w = tmp0.w * 0.96 + 0.04;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp1.yz = inp.texcoord2.xy + inp.texcoord2.xy;
                tmp0.w = _speed * _Time.y;
                tmp1.yz = tmp0.ww * float2(2.0, 2.0) + tmp1.yz;
                tmp1.yz = tmp1.yz * _gradient_ST.xy + _gradient_ST.zw;
                tmp3 = tex2D(_gradient, tmp1.yz);
                tmp1.yz = _speed.xx * _Time.yy + inp.texcoord2.xy;
                tmp1.yz = tmp1.yz * _gradient_ST.xy + _gradient_ST.zw;
                tmp4 = tex2D(_gradient, tmp1.yz);
                tmp1.y = tmp3.x - tmp4.x;
                tmp1.y = tmp1.y * 0.5 + tmp4.x;
                tmp3.xy = inp.texcoord2.xy * float2(3.0, 3.0);
                tmp3.xy = tmp0.ww * float2(3.0, 3.0) + tmp3.xy;
                tmp3.xy = tmp3.xy * _gradient_ST.xy + _gradient_ST.zw;
                tmp3 = tex2D(_gradient, tmp3.xy);
                tmp0.w = tmp3.x - tmp1.y;
                tmp0.w = saturate(tmp0.w * 0.5 + tmp1.y);
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.yz = inp.texcoord.xy * _edge_mask_ST.xy + _edge_mask_ST.zw;
                tmp3 = tex2D(_edge_mask, tmp1.yz);
                tmp1.y = tmp3.x - _edge_thikness;
                tmp1.z = 1.0 - _edge_thikness;
                tmp1.y = saturate(tmp1.y / tmp1.z);
                tmp1.z = tmp0.w * tmp1.y;
                tmp3.xyz = tmp1.yyy * tmp0.www + -_glow_color.xyz;
                tmp0.w = log(tmp0.x);
                tmp0.x = saturate(tmp0.x / _glow_size);
                tmp3.xyz = tmp3.xyz * tmp0.xxx;
                tmp0.x = tmp0.w * _tint_size;
                tmp0.x = exp(tmp0.x);
                tmp0.x = min(tmp0.x, 1.0);
                tmp4.xyz = _Color.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5 = _Time * float4(0.0, 0.3, 0.3, 0.0) + inp.texcoord.xyxy;
                tmp5 = tmp5 * _normal_ST + _normal_ST;
                tmp6 = tex2D(_normal, tmp5.zw);
                tmp5 = tex2D(_normal, tmp5.xy);
                tmp5.xyz = tmp5.xyz + float3(0.0, 0.0, 1.0);
                tmp7.xyz = tmp6.xyz * float3(-1.0, -1.0, 1.0);
                tmp0.w = dot(tmp5.xyz, tmp7.xyz);
                tmp5.xy = tmp0.ww * tmp5.xy;
                tmp5.xy = tmp5.xy / tmp5.zz;
                tmp5.xy = -tmp6.xy * float2(-1.0, -1.0) + tmp5.xy;
                tmp5.zw = inp.texcoord7.xy / inp.texcoord7.ww;
                tmp5.xy = tmp5.xy * _refraction.xx + tmp5.zw;
                tmp6 = tex2D(_CameraDepthTexture, tmp5.zw);
                tmp0.w = _ZBufferParams.z * tmp6.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - _ProjectionParams.y;
                tmp0.w = max(tmp0.w, 0.0);
                tmp5 = tex2D(_GrabTexture, tmp5.xy);
                tmp6.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp4.xyz = -tmp4.xyz * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp6.xyz = _Color.xyz + _Color.xyz;
                tmp6.xyz = tmp5.xyz * tmp6.xyz;
                tmp7.xyz = _Color.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = saturate(tmp7.xyz ? tmp4.xyz : tmp6.xyz);
                tmp6.xyz = tmp5.xyz - tmp4.xyz;
                tmp6.xyz = _transparent.xxx * tmp6.xyz + tmp4.xyz;
                tmp6.xyz = tmp6.xyz - _tint_color.xyz;
                tmp6.xyz = tmp0.xxx * tmp6.xyz + _tint_color.xyz;
                tmp4.xyz = tmp4.xyz - tmp6.xyz;
                tmp4.xyz = tmp1.zzz * tmp4.xyz + tmp6.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.96, 0.96, 0.96);
                tmp0.x = tmp1.w + tmp1.w;
                tmp0.x = tmp1.w * tmp0.x;
                tmp0.x = tmp0.x * tmp0.z + -0.5;
                tmp0.z = tmp1.x * tmp1.x;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp1.x * tmp0.z;
                tmp0.z = tmp0.x * tmp0.z + 1.0;
                tmp1.x = 1.0 - tmp0.y;
                tmp1.y = tmp1.x * tmp1.x;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp0.x = tmp0.x * tmp1.x + 1.0;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp1.xyz = glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp4.xyz + tmp2.xyz;
                tmp1.x = inp.texcoord7.z - _ProjectionParams.y;
                tmp1.x = max(tmp1.x, 0.0);
                tmp0.w = tmp0.w - tmp1.x;
                tmp0.w = saturate(tmp0.w / _intersect_size);
                tmp0.w = tmp0.w * 10.0;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.xyz = tmp0.www * tmp3.xyz + _glow_color.xyz;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz - tmp5.xyz;
                o.sv_target.xyz = _specularity.xxx * tmp0.xyz + tmp5.xyz;
                o.sv_target.w = _Visibility;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}