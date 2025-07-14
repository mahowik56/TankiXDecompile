Shader "Alternativa/HologramFlag" {
	Properties {
		_MainTex ("Main (RGB)", 2D) = "white" {}
		_HexTex ("Hex (RGB)", 2D) = "white" {}
		_HexTex2 ("Inner Hex (RGB)", 2D) = "white" {}
		_GlitchTex ("Glitch (RGB)", 2D) = "white" {}
		_GlitchLineTex ("Glitch Line (RGB)", 2D) = "white" {}
		_BannerTex ("Banner (RGB)", 2D) = "white" {}
		_ShadowTex ("Shadow", 2D) = "white" {}
		_MaskTex ("Mask (RGB)", 2D) = "white" {}
		_MaskCoef ("Alpha mask coef", Range(0, 1)) = 1
		_SpeedX ("SpeedX", Range(0, 20)) = 1
		_SpeedY ("SpeedY", Range(0, 20)) = 1
		_FrequencyX ("FrequencyX", Range(0, 10)) = 1
		_FrequencyY ("FrequencyY", Range(0, 10)) = 1
		_AmplitudeX ("AmplitudeX", Range(0, 1)) = 1
		_AmplitudeY ("AmplitudeY", Range(0, 1)) = 1
		_Color ("Main Color", Color) = (1,1,1,1)
		_ColorLine ("Line Color", Color) = (1,1,1,1)
		_EmissionIntensity ("Emission Intensity", Float) = 4
		_EmissionIntensityLine ("Emission Intensity Line", Float) = 4
		_RimColor ("Rim Color", Color) = (1,1,1,1)
		_Phase ("Phase", Float) = 1
	}
	SubShader {
		Tags { "QUEUE" = "Transparent+200" "RenderType" = "Transparent" }
		Pass {
			Name "SHADOWCASTER"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent+200" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			Cull Off
			Fog {
				Mode 0
			}
			GpuProgramID 16572
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MaskTex_ST;
			float _SpeedX;
			float _SpeedY;
			float _FrequencyX;
			float _FrequencyY;
			float _AmplitudeX;
			float _AmplitudeY;
			float _Phase;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MaskTex;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = dot(_Time.xy, float2(_SpeedX.x, _SpeedY.x));
                tmp0.x = tmp0.x + v.vertex.y;
                tmp0.x = tmp0.x + _Phase;
                tmp0.x = tmp0.x * _FrequencyY;
                tmp0.x = sin(tmp0.x);
                tmp0.y = dot(_Time.xy, float2(_SpeedX.x, _SpeedY.x));
                tmp0.z = tmp0.y + v.vertex.x;
                tmp0.z = tmp0.z + _Phase;
                tmp0.z = tmp0.z * _FrequencyX;
                tmp0.z = sin(tmp0.z);
                tmp0.xz = tmp0.xz * float2(_AmplitudeX.x, _AmplitudeY.x);
                tmp0.z = tmp0.z * v.vertex.x + v.vertex.z;
                tmp0.x = tmp0.x * v.vertex.x + tmp0.z;
                tmp0.z = v.vertex.x - v.vertex.y;
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y + _Phase;
                tmp0.y = tmp0.y * _FrequencyX;
                tmp0.y = cos(tmp0.y);
                tmp0.y = tmp0.y * _AmplitudeX;
                tmp0.x = tmp0.y * v.vertex.x + tmp0.x;
                tmp0.y = tmp0.y * v.vertex.x + v.vertex.y;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord5.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "HOLOGRAM"
			Tags { "QUEUE" = "Transparent+200" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			Cull Off
			GpuProgramID 68379
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord2 : TEXCOORD2;
				float2 texcoord3 : TEXCOORD3;
				float2 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
				float2 texcoord8 : TEXCOORD8;
				float2 texcoord4 : TEXCOORD4;
				float2 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _HexTex_ST;
			float4 _HexTex2_ST;
			float4 _GlitchTex_ST;
			float4 _GlitchLineTex_ST;
			float4 _BannerTex_ST;
			float4 _MaskTex_ST;
			float _SpeedX;
			float _SpeedY;
			float _FrequencyX;
			float _FrequencyY;
			float _AmplitudeX;
			float _AmplitudeY;
			float _Phase;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _EmissionIntensity;
			float _MaskCoef;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _HexTex;
			sampler2D _GlitchTex;
			sampler2D _GlitchLineTex;
			sampler2D _MaskTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = dot(_Time.xy, float2(_SpeedX.x, _SpeedY.x));
                tmp0.x = tmp0.x + v.vertex.y;
                tmp0.x = tmp0.x + _Phase;
                tmp0.x = tmp0.x * _FrequencyY;
                tmp0.x = sin(tmp0.x);
                tmp0.y = dot(_Time.xy, float2(_SpeedX.x, _SpeedY.x));
                tmp0.z = tmp0.y + v.vertex.x;
                tmp0.z = tmp0.z + _Phase;
                tmp0.z = tmp0.z * _FrequencyX;
                tmp0.z = sin(tmp0.z);
                tmp0.xz = tmp0.xz * float2(_AmplitudeX.x, _AmplitudeY.x);
                tmp0.z = tmp0.z * v.vertex.x + v.vertex.z;
                tmp0.x = tmp0.x * v.vertex.x + tmp0.z;
                tmp0.z = v.vertex.x - v.vertex.y;
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y + _Phase;
                tmp0.y = tmp0.y * _FrequencyX;
                tmp0.y = cos(tmp0.y);
                tmp0.y = tmp0.y * _AmplitudeX;
                tmp0.x = tmp0.y * v.vertex.x + tmp0.x;
                tmp0.y = tmp0.y * v.vertex.x + v.vertex.y;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord3.xy = v.texcoord.xy * _HexTex_ST.xy + _HexTex_ST.zw;
                tmp0.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.y = -_Time.x * 2.0 + tmp0.y;
                o.texcoord2.x = tmp0.x;
                o.texcoord6.xy = v.texcoord.xy * _HexTex2_ST.xy + _HexTex2_ST.zw;
                tmp0.xy = v.texcoord.xy * _GlitchTex_ST.xy + _GlitchTex_ST.zw;
                o.texcoord7.x = tmp0.x;
                tmp0.x = _Phase + _Time.x;
                o.texcoord7.y = -tmp0.x * 2.0 + tmp0.y;
                tmp0.yz = v.texcoord.xy * _GlitchLineTex_ST.xy + _GlitchLineTex_ST.zw;
                o.texcoord8.y = tmp0.x * 5.0 + tmp0.z;
                o.texcoord8.x = tmp0.y;
                o.texcoord4.xy = v.texcoord.xy * _BannerTex_ST.xy + _BannerTex_ST.zw;
                o.texcoord5.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Time.x * 12.0 + _Phase;
                tmp0.x = sin(tmp0.x);
                tmp0.xy = tmp0.xx + float2(0.999, 0.99);
                tmp0.zw = tmp0.xy > float2(0.0, 0.0);
                tmp0.xy = tmp0.xy < float2(0.0, 0.0);
                tmp0.xy = tmp0.zw - tmp0.xy;
                tmp0.xy = tmp0.xy + int2(1, 1);
                tmp0.xy = floor(tmp0.xy);
                tmp0.y = -tmp0.y * 0.3333333 + 1.0;
                tmp0.x = tmp0.x * 0.125;
                tmp1 = tex2D(_MaskTex, inp.texcoord5.xy);
                tmp0.z = tmp1.x + 0.3;
                tmp0.z = tmp0.z * _MaskCoef;
                tmp1 = tex2D(_GlitchLineTex, inp.texcoord8.xy);
                tmp0.w = tmp1.w * 0.4;
                tmp0.y = tmp0.z * tmp0.y + -tmp0.w;
                tmp1 = tex2D(_GlitchTex, inp.texcoord7.xy);
                tmp1 = tmp0.xxxx * tmp1;
                tmp1 = tmp1 * float4(1.2, 1.2, 1.2, 1.2);
                tmp2 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp2 = tmp2.xxxx * _Color;
                tmp1 = tmp2 * _EmissionIntensity.xxxx + tmp1;
                tmp2 = tex2D(_HexTex, inp.texcoord3.xy);
                tmp0.x = tmp1.w - tmp2.w;
                o.sv_target.xyz = tmp1.xyz;
                o.sv_target.w = tmp0.y * tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "INNER HEX"
			Tags { "QUEUE" = "Transparent+200" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			Cull Off
			GpuProgramID 190270
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord2 : TEXCOORD2;
				float2 texcoord3 : TEXCOORD3;
				float2 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
				float2 texcoord8 : TEXCOORD8;
				float2 texcoord4 : TEXCOORD4;
				float2 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _HexTex_ST;
			float4 _HexTex2_ST;
			float4 _GlitchTex_ST;
			float4 _GlitchLineTex_ST;
			float4 _BannerTex_ST;
			float4 _MaskTex_ST;
			float _SpeedX;
			float _SpeedY;
			float _FrequencyX;
			float _FrequencyY;
			float _AmplitudeX;
			float _AmplitudeY;
			float _Phase;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _RimColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _HexTex;
			sampler2D _HexTex2;
			sampler2D _MaskTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = dot(_Time.xy, float2(_SpeedX.x, _SpeedY.x));
                tmp0.x = tmp0.x + v.vertex.y;
                tmp0.x = tmp0.x + _Phase;
                tmp0.x = tmp0.x * _FrequencyY;
                tmp0.x = sin(tmp0.x);
                tmp0.y = dot(_Time.xy, float2(_SpeedX.x, _SpeedY.x));
                tmp0.z = tmp0.y + v.vertex.x;
                tmp0.z = tmp0.z + _Phase;
                tmp0.z = tmp0.z * _FrequencyX;
                tmp0.z = sin(tmp0.z);
                tmp0.xz = tmp0.xz * float2(_AmplitudeX.x, _AmplitudeY.x);
                tmp0.z = tmp0.z * v.vertex.x + v.vertex.z;
                tmp0.x = tmp0.x * v.vertex.x + tmp0.z;
                tmp0.z = v.vertex.x - v.vertex.y;
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y + _Phase;
                tmp0.y = tmp0.y * _FrequencyX;
                tmp0.y = cos(tmp0.y);
                tmp0.y = tmp0.y * _AmplitudeX;
                tmp0.x = tmp0.y * v.vertex.x + tmp0.x;
                tmp0.y = tmp0.y * v.vertex.x + v.vertex.y;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord3.xy = v.texcoord.xy * _HexTex_ST.xy + _HexTex_ST.zw;
                tmp0.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.y = -_Time.x * 2.0 + tmp0.y;
                o.texcoord2.x = tmp0.x;
                o.texcoord6.xy = v.texcoord.xy * _HexTex2_ST.xy + _HexTex2_ST.zw;
                tmp0.xy = v.texcoord.xy * _GlitchTex_ST.xy + _GlitchTex_ST.zw;
                o.texcoord7.x = tmp0.x;
                tmp0.x = _Phase + _Time.x;
                o.texcoord7.y = -tmp0.x * 2.0 + tmp0.y;
                tmp0.yz = v.texcoord.xy * _GlitchLineTex_ST.xy + _GlitchLineTex_ST.zw;
                o.texcoord8.y = tmp0.x * 5.0 + tmp0.z;
                o.texcoord8.x = tmp0.y;
                o.texcoord4.xy = v.texcoord.xy * _BannerTex_ST.xy + _BannerTex_ST.zw;
                o.texcoord5.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Time.x * 12.0 + _Phase;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x + 0.99;
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.y - tmp0.x;
                tmp0.x = tmp0.x + 1;
                tmp0.x = floor(tmp0.x);
                tmp0.x = -tmp0.x * 0.3333333 + 1.0;
                tmp1 = tex2D(_MaskTex, inp.texcoord5.xy);
                tmp0.x = tmp0.x * tmp1.x;
                tmp1 = tex2D(_HexTex, inp.texcoord3.xy);
                tmp2 = tex2D(_HexTex2, inp.texcoord6.xy);
                tmp0.y = -tmp1.w * 0.2 + tmp2.w;
                o.sv_target.xyz = tmp2.xyz * _RimColor.xyz;
                o.sv_target.w = tmp0.x * tmp0.y;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "LINE"
			Tags { "QUEUE" = "Transparent+200" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			Cull Off
			GpuProgramID 223662
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord2 : TEXCOORD2;
				float2 texcoord3 : TEXCOORD3;
				float2 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
				float2 texcoord8 : TEXCOORD8;
				float2 texcoord4 : TEXCOORD4;
				float2 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _HexTex_ST;
			float4 _HexTex2_ST;
			float4 _GlitchTex_ST;
			float4 _GlitchLineTex_ST;
			float4 _BannerTex_ST;
			float4 _MaskTex_ST;
			float _SpeedX;
			float _SpeedY;
			float _FrequencyX;
			float _FrequencyY;
			float _AmplitudeX;
			float _AmplitudeY;
			float _Phase;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLine;
			float _EmissionIntensityLine;
			float _MaskCoef;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BannerTex;
			sampler2D _MaskTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = dot(_Time.xy, float2(_SpeedX.x, _SpeedY.x));
                tmp0.x = tmp0.x + v.vertex.y;
                tmp0.x = tmp0.x + _Phase;
                tmp0.x = tmp0.x * _FrequencyY;
                tmp0.x = sin(tmp0.x);
                tmp0.y = dot(_Time.xy, float2(_SpeedX.x, _SpeedY.x));
                tmp0.z = tmp0.y + v.vertex.x;
                tmp0.z = tmp0.z + _Phase;
                tmp0.z = tmp0.z * _FrequencyX;
                tmp0.z = sin(tmp0.z);
                tmp0.xz = tmp0.xz * float2(_AmplitudeX.x, _AmplitudeY.x);
                tmp0.z = tmp0.z * v.vertex.x + v.vertex.z;
                tmp0.x = tmp0.x * v.vertex.x + tmp0.z;
                tmp0.z = v.vertex.x - v.vertex.y;
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y + _Phase;
                tmp0.y = tmp0.y * _FrequencyX;
                tmp0.y = cos(tmp0.y);
                tmp0.y = tmp0.y * _AmplitudeX;
                tmp0.x = tmp0.y * v.vertex.x + tmp0.x;
                tmp0.y = tmp0.y * v.vertex.x + v.vertex.y;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord3.xy = v.texcoord.xy * _HexTex_ST.xy + _HexTex_ST.zw;
                tmp0.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.y = -_Time.x * 2.0 + tmp0.y;
                o.texcoord2.x = tmp0.x;
                o.texcoord6.xy = v.texcoord.xy * _HexTex2_ST.xy + _HexTex2_ST.zw;
                tmp0.xy = v.texcoord.xy * _GlitchTex_ST.xy + _GlitchTex_ST.zw;
                o.texcoord7.x = tmp0.x;
                tmp0.x = _Phase + _Time.x;
                o.texcoord7.y = -tmp0.x * 2.0 + tmp0.y;
                tmp0.yz = v.texcoord.xy * _GlitchLineTex_ST.xy + _GlitchLineTex_ST.zw;
                o.texcoord8.y = tmp0.x * 5.0 + tmp0.z;
                o.texcoord8.x = tmp0.y;
                o.texcoord4.xy = v.texcoord.xy * _BannerTex_ST.xy + _BannerTex_ST.zw;
                o.texcoord5.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MaskTex, inp.texcoord5.xy);
                tmp0.x = tmp0.x * _MaskCoef;
                tmp1 = tex2D(_BannerTex, inp.texcoord4.xy);
                tmp1 = tmp1 * _ColorLine;
                tmp1 = tmp1 * _EmissionIntensityLine.xxxx;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
			}
			ENDCG
		}
	}
}