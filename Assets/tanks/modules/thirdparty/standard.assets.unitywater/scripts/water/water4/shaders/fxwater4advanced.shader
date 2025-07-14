Shader "FX/Water4" {
	Properties {
		_ReflectionTex ("Internal reflection", 2D) = "white" {}
		_MainTex ("Fallback texture", 2D) = "black" {}
		_ShoreTex ("Shore & Foam texture ", 2D) = "black" {}
		_BumpMap ("Normals ", 2D) = "bump" {}
		_DistortParams ("Distortions (Bump waves, Reflection, Fresnel power, Fresnel bias)", Vector) = (1,1,2,1.15)
		_InvFadeParemeter ("Auto blend parameter (Edge, Shore, Distance scale)", Vector) = (0.15,0.15,0.5,1)
		_AnimationTiling ("Animation Tiling (Displacement)", Vector) = (2.2,2.2,-1.1,-1.1)
		_AnimationDirection ("Animation Direction (displacement)", Vector) = (1,1,1,1)
		_BumpTiling ("Bump Tiling", Vector) = (1,1,-2,3)
		_BumpDirection ("Bump Direction & Speed", Vector) = (1,1,-1,1)
		_FresnelScale ("FresnelScale", Range(0.15, 4)) = 0.75
		_BaseColor ("Base color", Color) = (0.54,0.95,0.99,0.5)
		_ReflectionColor ("Reflection color", Color) = (0.54,0.95,0.99,0.5)
		_SpecularColor ("Specular color", Color) = (0.72,0.72,0.72,1)
		_WorldLightDir ("Specular light direction", Vector) = (0,0.1,-0.5,0)
		_Shininess ("Shininess", Range(2, 500)) = 200
		_Foam ("Foam (intensity, cutoff)", Vector) = (0.1,0.375,0,0)
		_GerstnerIntensity ("Per vertex displacement", Float) = 1
		_GAmplitude ("Wave Amplitude", Vector) = (0.3,0.35,0.25,0.25)
		_GFrequency ("Wave Frequency", Vector) = (1.3,1.35,1.25,1.25)
		_GSteepness ("Wave Steepness", Vector) = (1,1,1,1)
		_GSpeed ("Wave Speed", Vector) = (1.2,1.375,1.1,1.5)
		_GDirectionAB ("Wave Direction", Vector) = (0.3,0.85,0.85,0.25)
		_GDirectionCD ("Wave Direction", Vector) = (0.1,0.9,0.5,0.5)
	}
	SubShader {
		LOD 500
		Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		GrabPass {
			"_RefractionTex"
		}
		Pass {
			LOD 500
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 12203
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _GerstnerIntensity;
			float4 _BumpTiling;
			float4 _BumpDirection;
			float4 _GAmplitude;
			float4 _GFrequency;
			float4 _GSteepness;
			float4 _GSpeed;
			float4 _GDirectionAB;
			float4 _GDirectionCD;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _SpecularColor;
			float4 _BaseColor;
			float4 _ReflectionColor;
			float4 _InvFadeParemeter;
			float _Shininess;
			float4 _WorldLightDir;
			float4 _DistortParams;
			float _FresnelScale;
			float4 _Foam;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BumpMap;
			sampler2D _RefractionTex;
			sampler2D _CameraDepthTexture;
			sampler2D _ReflectionTex;
			sampler2D _ShoreTex;
			
			// Keywords: WATER_REFLECTIVE WATER_VERTEX_DISPLACEMENT_ON WATER_EDGEBLEND_ON
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
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp1.x = dot(_GDirectionAB.xy, tmp0.xy);
                tmp1.y = dot(_GDirectionAB.xy, tmp0.xy);
                tmp1.z = dot(_GDirectionCD.xy, tmp0.xy);
                tmp1.w = dot(_GDirectionCD.xy, tmp0.xy);
                tmp2 = _GSpeed * _Time;
                tmp1 = _GFrequency * tmp1 + tmp2;
                tmp1 = sin(tmp1);
                tmp3 = cos(tmp1);
                tmp4 = _GAmplitude * _GSteepness;
                tmp5 = tmp4.xyxy * _GDirectionAB;
                tmp4 = tmp4.zzww * _GDirectionCD;
                tmp6.xy = tmp5.zw;
                tmp6.zw = tmp4.xz;
                tmp5.zw = tmp4.yw;
                tmp4.z = dot(tmp3, tmp5);
                tmp4.x = dot(tmp3, tmp6);
                tmp4.y = dot(tmp1, _GAmplitude);
                tmp1.xyz = tmp4.xyz + v.vertex.xyz;
                tmp3.xy = tmp0.xz + tmp4.xz;
                o.texcoord1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                o.texcoord1.w = saturate(tmp4.y);
                tmp0 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp4 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp4 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp4;
                tmp4 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp4;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp4;
                o.position = tmp0;
                tmp4.x = dot(_GDirectionAB.xy, tmp3.xy);
                tmp4.y = dot(_GDirectionAB.xy, tmp3.xy);
                tmp4.z = dot(_GDirectionCD.xy, tmp3.xy);
                tmp4.w = dot(_GDirectionCD.xy, tmp3.xy);
                tmp2 = _GFrequency * tmp4 + tmp2;
                tmp2 = cos(tmp2);
                tmp3 = _GAmplitude * _GFrequency;
                tmp4 = tmp3.xyxy * _GDirectionAB;
                tmp3 = tmp3.zzww * _GDirectionCD;
                tmp5.xy = tmp4.zw;
                tmp5.zw = tmp3.xz;
                tmp4.zw = tmp3.yw;
                tmp1.w = dot(tmp2, tmp4);
                tmp2.x = dot(tmp2, tmp5);
                tmp2.x = -tmp2.x;
                tmp2.z = -tmp1.w;
                tmp2.xz = tmp2.xz * _GerstnerIntensity.xx;
                tmp2.y = 2.0;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord.xyz = tmp1.www * tmp2.xyz;
                o.texcoord.w = 1.0;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m21_m01_m21;
                tmp2 = unity_ObjectToWorld._m00_m20_m00_m20 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m22_m02_m22 * tmp1.zzzz + tmp2;
                tmp1 = unity_ObjectToWorld._m03_m23_m03_m23 * v.vertex.wwww + tmp1;
                tmp1 = _Time * _BumpDirection + tmp1;
                o.texcoord2 = tmp1 * _BumpTiling;
                tmp1.x = tmp0.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp0.xw * float2(0.5, 0.5);
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord4.xy = tmp0.xy * float2(0.5, 0.5);
                o.texcoord3.zw = tmp0.zw;
                o.texcoord4.zw = tmp0.zw;
                return o;
			}
			// Keywords: WATER_REFLECTIVE WATER_VERTEX_DISPLACEMENT_ON WATER_EDGEBLEND_ON
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp0 = tex2D(_RefractionTex, tmp0.xy);
                tmp1 = tex2D(_BumpMap, inp.texcoord2.xy);
                tmp1.xyz = tmp1.wwy * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2 = tex2D(_BumpMap, inp.texcoord2.zw);
                tmp1.xyz = tmp2.wwy * float3(2.0, 2.0, 2.0) + tmp1.xyz;
                tmp1.xyz = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp1.xyz * _DistortParams.xxx;
                tmp1.xyz = tmp1.xyz * float3(1.0, 0.0, 1.0) + inp.texcoord.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = tmp1.xz * _DistortParams.yy;
                tmp2.xy = tmp2.xy * float2(10.0, 10.0);
                tmp2.z = 0.0;
                tmp3.xyz = tmp2.xyz + inp.texcoord4.xyw;
                tmp2.xyz = tmp2.xyz + inp.texcoord3.xyw;
                tmp2.xy = tmp2.xy / tmp2.zz;
                tmp2 = tex2D(_ReflectionTex, tmp2.xy);
                tmp3.xy = tmp3.xy / tmp3.zz;
                tmp4 = tex2D(_CameraDepthTexture, tmp3.xy);
                tmp3 = tex2D(_RefractionTex, tmp3.xy);
                tmp0.w = _ZBufferParams.z * tmp4.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w < inp.texcoord3.z;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp3.xyz;
                tmp0.w = inp.texcoord1.w * _InvFadeParemeter.w;
                tmp3 = -tmp0.wwww * float4(0.15, 0.03, 0.01, 0.0) + _BaseColor;
                tmp3.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.xyz = tmp3.www * tmp3.xyz + tmp0.xyz;
                tmp3.xyz = _ReflectionColor.xyz - tmp2.xyz;
                tmp2.xyz = _ReflectionColor.www * tmp3.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz - tmp0.xyz;
                tmp3.xz = tmp1.xz * _FresnelScale.xx;
                tmp3.y = tmp1.y;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp5.xyz = inp.texcoord1.xyz * tmp0.www + _WorldLightDir.xyz;
                tmp0.w = dot(-tmp4.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _DistortParams.z;
                tmp0.w = exp(tmp0.w);
                tmp1.w = 1.0 - _DistortParams.w;
                tmp0.w = saturate(tmp1.w * tmp0.w + _DistortParams.w);
                tmp0.xyz = tmp0.www * tmp2.xyz + tmp0.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp5.xyz;
                tmp0.w = dot(tmp1.xyz, -tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _Shininess;
                tmp0.w = exp(tmp0.w);
                tmp0.xyz = tmp0.www * _SpecularColor.xyz + tmp0.xyz;
                tmp1 = inp.texcoord2 + inp.texcoord2;
                tmp2 = tex2D(_ShoreTex, tmp1.xy);
                tmp1 = tex2D(_ShoreTex, tmp1.zw);
                tmp1.xyz = tmp2.xyz * tmp1.xyz + float3(-0.125, -0.125, -0.125);
                tmp1.xyz = tmp1.xyz * _Foam.xxx;
                tmp2.xy = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp2 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp0.w = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - inp.texcoord3.w;
                tmp2.xy = saturate(tmp0.ww * _InvFadeParemeter.xy);
                tmp0.w = 1.0 - tmp2.y;
                o.sv_target.w = tmp2.x;
                tmp1.w = saturate(inp.texcoord1.w - _Foam.y);
                tmp0.w = tmp0.w + tmp1.w;
                o.sv_target.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		LOD 300
		Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			LOD 300
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 83955
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _GerstnerIntensity;
			float4 _BumpTiling;
			float4 _BumpDirection;
			float4 _GAmplitude;
			float4 _GFrequency;
			float4 _GSteepness;
			float4 _GSpeed;
			float4 _GDirectionAB;
			float4 _GDirectionCD;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _SpecularColor;
			float4 _BaseColor;
			float4 _ReflectionColor;
			float4 _InvFadeParemeter;
			float _Shininess;
			float4 _WorldLightDir;
			float4 _DistortParams;
			float _FresnelScale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BumpMap;
			sampler2D _ReflectionTex;
			sampler2D _CameraDepthTexture;
			
			// Keywords: WATER_REFLECTIVE WATER_VERTEX_DISPLACEMENT_ON WATER_EDGEBLEND_ON
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
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp1.x = dot(_GDirectionAB.xy, tmp0.xy);
                tmp1.y = dot(_GDirectionAB.xy, tmp0.xy);
                tmp1.z = dot(_GDirectionCD.xy, tmp0.xy);
                tmp1.w = dot(_GDirectionCD.xy, tmp0.xy);
                tmp2 = _GSpeed * _Time;
                tmp1 = _GFrequency * tmp1 + tmp2;
                tmp1 = sin(tmp1);
                tmp3 = cos(tmp1);
                tmp1.y = dot(tmp1, _GAmplitude);
                tmp4 = _GAmplitude * _GSteepness;
                tmp5 = tmp4.xyxy * _GDirectionAB;
                tmp4 = tmp4.zzww * _GDirectionCD;
                tmp6.xy = tmp5.zw;
                tmp6.zw = tmp4.xz;
                tmp5.zw = tmp4.yw;
                tmp1.z = dot(tmp3, tmp5);
                tmp1.x = dot(tmp3, tmp6);
                tmp3.xyz = tmp1.xyz + v.vertex.xyz;
                tmp1.xy = tmp0.xz + tmp1.xz;
                o.texcoord1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0 = tmp3.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp3.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp3.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp4 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp4 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp4;
                tmp4 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp4;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp4;
                o.position = tmp0;
                tmp4.x = dot(_GDirectionAB.xy, tmp1.xy);
                tmp4.y = dot(_GDirectionAB.xy, tmp1.xy);
                tmp4.z = dot(_GDirectionCD.xy, tmp1.xy);
                tmp4.w = dot(_GDirectionCD.xy, tmp1.xy);
                tmp1 = _GFrequency * tmp4 + tmp2;
                tmp1 = cos(tmp1);
                tmp2 = _GAmplitude * _GFrequency;
                tmp4 = tmp2.xyxy * _GDirectionAB;
                tmp2 = tmp2.zzww * _GDirectionCD;
                tmp5.xy = tmp4.zw;
                tmp5.zw = tmp2.xz;
                tmp4.zw = tmp2.yw;
                tmp2.x = dot(tmp1, tmp4);
                tmp1.x = dot(tmp1, tmp5);
                tmp1.x = -tmp1.x;
                tmp1.z = -tmp2.x;
                tmp1.xz = tmp1.xz * _GerstnerIntensity.xx;
                tmp1.y = 2.0;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.w = 1.0;
                tmp1 = tmp3.yyyy * unity_ObjectToWorld._m01_m21_m01_m21;
                tmp1 = unity_ObjectToWorld._m00_m20_m00_m20 * tmp3.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m22_m02_m22 * tmp3.zzzz + tmp1;
                tmp1 = unity_ObjectToWorld._m03_m23_m03_m23 * v.vertex.wwww + tmp1;
                tmp1 = _Time * _BumpDirection + tmp1;
                o.texcoord2 = tmp1 * _BumpTiling;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.zw = tmp0.zw;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: WATER_REFLECTIVE WATER_VERTEX_DISPLACEMENT_ON WATER_EDGEBLEND_ON
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = tex2D(_BumpMap, inp.texcoord2.xy);
                tmp0.xyz = tmp0.wwy * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1 = tex2D(_BumpMap, inp.texcoord2.zw);
                tmp0.xyz = tmp1.wwy * float3(2.0, 2.0, 2.0) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz - float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz * _DistortParams.xxx;
                tmp0.xyz = tmp0.xyz * float3(1.0, 0.0, 1.0);
                tmp0.w = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = inp.texcoord.xyz * tmp0.www + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xz = tmp0.xz * _FresnelScale.xx;
                tmp1.y = tmp0.y;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp3.xyz = inp.texcoord1.xyz * tmp0.www + _WorldLightDir.xyz;
                tmp0.w = dot(-tmp2.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _DistortParams.z;
                tmp0.w = exp(tmp0.w);
                tmp1.x = 1.0 - _DistortParams.w;
                tmp0.w = saturate(tmp1.x * tmp0.w + _DistortParams.w);
                tmp1.x = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w + 0.5;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.yz = tmp0.xz * _DistortParams.yy;
                tmp2.xy = tmp1.yz * float2(10.0, 10.0);
                tmp2.z = 0.0;
                tmp1.yzw = tmp2.xyz + inp.texcoord3.xyw;
                tmp1.yz = tmp1.yz / tmp1.ww;
                tmp2 = tex2D(_ReflectionTex, tmp1.yz);
                tmp1.yzw = _ReflectionColor.xyz - tmp2.xyz;
                tmp1.yzw = _ReflectionColor.www * tmp1.yzw + tmp2.xyz;
                tmp1.yzw = tmp1.yzw - _BaseColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + _BaseColor.xyz;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp3.xyz;
                tmp0.x = dot(tmp0.xyz, -tmp2.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _Shininess;
                tmp0.x = exp(tmp0.x);
                o.sv_target.xyz = tmp0.xxx * _SpecularColor.xyz + tmp1.xyz;
                tmp0.xy = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - inp.texcoord3.z;
                tmp0.x = saturate(tmp0.x * _InvFadeParemeter.x);
                o.sv_target.w = tmp0.w * tmp0.x;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		LOD 200
		Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			LOD 200
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 178979
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _BumpTiling;
			float4 _BumpDirection;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _SpecularColor;
			float4 _BaseColor;
			float4 _ReflectionColor;
			float _Shininess;
			float4 _WorldLightDir;
			float4 _DistortParams;
			float _FresnelScale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BumpMap;
			
			// Keywords: 
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
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                o.texcoord.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0 = _Time * _BumpDirection + tmp0.xzxz;
                o.texcoord1 = tmp0 * _BumpTiling;
                o.texcoord.w = 1.0;
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
                tmp0 = tex2D(_BumpMap, inp.texcoord1.xy);
                tmp0.xyz = tmp0.wwy * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1 = tex2D(_BumpMap, inp.texcoord1.zw);
                tmp0.xyz = tmp1.wwy * float3(2.0, 2.0, 2.0) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz - float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz * _DistortParams.xxx;
                tmp0.xyz = tmp0.xyz * float3(1.0, 0.0, 1.0) + float3(0.0, 1.0, 0.0);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xz = tmp0.xz * _FresnelScale.xx;
                tmp1.y = tmp0.y;
                tmp0.w = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * inp.texcoord.xyz;
                tmp3.xyz = inp.texcoord.xyz * tmp0.www + _WorldLightDir.xyz;
                tmp0.w = dot(-tmp2.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _DistortParams.z;
                tmp0.w = exp(tmp0.w);
                tmp1.x = 1.0 - _DistortParams.w;
                tmp0.w = saturate(tmp1.x * tmp0.w + _DistortParams.w);
                tmp1.x = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w * 2.0 + 0.5;
                o.sv_target.w = min(tmp0.w, 1.0);
                tmp0.w = min(tmp1.x, 1.0);
                tmp1.xyz = _ReflectionColor.xyz - _BaseColor.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz + _BaseColor.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp3.xyz;
                tmp0.x = dot(tmp0.xyz, -tmp2.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _Shininess;
                tmp0.x = exp(tmp0.x);
                o.sv_target.xyz = tmp0.xxx * _SpecularColor.xyz + tmp1.xyz;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Transparent/Diffuse"
}