Shader "TankiOnline/SimpleGrass" {
	Properties {
		[NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
		[NoScaleOffset] _LightMap ("Texture", 2D) = "white" {}
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
		_WindShakeTime ("Wind Shake Time", Range(0, 5)) = 1
		_WindShakeWindspeed ("Wind Shake Windspeed", Range(0, 5)) = 1
		_WindShakeBending ("Wind Shake Bending", Range(0, 5)) = 1
		_GrassCullingDistance ("Culling distance", Float) = 50
		_GrassCullingRange ("Culling range", Float) = 1
		_Ambient ("ambient", Float) = 0.7
	}
	SubShader {
		LOD 510
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "TransparentCutoff" }
		Pass {
			Name "FORWARD_BASE"
			LOD 510
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "TransparentCutoff" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 11423
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float4 position : SV_POSITION0;
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
			float _GrassCullingDistance;
			float _GrassCullingRange;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			float _ShadowMixStrength;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _LightMap;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = tmp0.x * 0.1 + 0.3;
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                o.color.xyz = tmp0.xyz * v.color.xyz;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x + _GrassCullingRange;
                tmp1.x = tmp1.x - _GrassCullingDistance;
                o.color.w = saturate(tmp1.x / _GrassCullingRange);
                tmp1 = v.vertex.zzzz * float4(0.024, 0.08, 0.08, 0.2);
                tmp1 = v.vertex.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp1;
                tmp2.x = -_WindShakeTime * 2.0 + 1.0;
                tmp2.x = tmp2.x - v.color.z;
                tmp2.x = tmp2.x * _Time.x;
                tmp2.yz = v.color.yw + float2(_WindShakeWindspeed.x, _WindShakeBending.x);
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.y = tmp2.z * v.texcoord.y;
                tmp1 = tmp2.xxxx * float4(1.2, 2.0, 1.6, 4.8) + tmp1;
                tmp1 = frac(tmp1);
                tmp1 = tmp1 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp3 = tmp1 * tmp1;
                tmp4 = tmp1 * tmp3;
                tmp1 = tmp4 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp1;
                tmp4 = tmp3 * tmp4;
                tmp3 = tmp3 * tmp4;
                tmp1 = tmp4 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp1;
                tmp1 = tmp3 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp1;
                tmp1 = tmp2.yyyy * tmp1;
                tmp1 = tmp1 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp1 = tmp1 * tmp1;
                tmp1 = tmp1 * tmp1;
                tmp2.x = dot(tmp1, float4(0.006, 0.02, -0.02, 0.1));
                tmp1.x = dot(tmp1, float4(0.024, 0.04, -0.12, 0.096));
                tmp1.yz = tmp2.xx * unity_WorldToObject._m02_m22;
                tmp1.xy = unity_WorldToObject._m00_m20 * tmp1.xx + tmp1.yz;
                tmp1.xy = v.vertex.xz - tmp1.xy;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.yyyy + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - inp.color.w;
                tmp1.x = tmp1.x - _Cutoff;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1 = tex2D(_LightMap, inp.texcoord1.xy);
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * unity_Lightmap_HDR.y;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * unity_Lightmap_HDR.x;
                tmp1.xyz = tmp1.xyz * tmp1.www;
                tmp1.w = _ShadowMixStrength + 2.0;
                tmp1.xyz = min(tmp1.xyz, tmp1.www);
                tmp1.xyz = tmp1.xyz + float3(0.1, 0.1, 0.1);
                tmp2.xyz = inp.color.xyz * float3(1.5, 1.5, 1.5);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 510
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Geometry" "RenderType" = "TransparentCutoff" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 69776
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
				float4 position : SV_POSITION0;
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
			float _GrassCullingDistance;
			float _GrassCullingRange;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp1.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp2.xyz;
                tmp3.xyz = _WorldSpaceLightPos0.xyz - tmp2.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - tmp2.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w + _GrassCullingRange;
                tmp0.w = tmp0.w - _GrassCullingDistance;
                o.color.w = saturate(tmp0.w / _GrassCullingRange);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.x = rsqrt(tmp0.w);
                tmp2.xyz = tmp2.xxx * tmp3.xyz;
                tmp0.x = dot(tmp0.xyz, tmp2.xyz);
                tmp0.x = tmp0.x * 0.1 + 0.3;
                tmp0.y = sqrt(tmp0.w);
                tmp0.y = tmp0.w * tmp0.y + -tmp0.w;
                tmp0.y = tmp0.y * 0.5 + tmp0.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.yzw = tmp0.yyy * _LightColor0.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                o.color.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp0 = v.vertex.zzzz * float4(0.024, 0.08, 0.08, 0.2);
                tmp0 = v.vertex.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp0;
                tmp2.x = -_WindShakeTime * 2.0 + 1.0;
                tmp2.x = tmp2.x - v.color.z;
                tmp2.x = tmp2.x * _Time.x;
                tmp2.yz = v.color.yw + float2(_WindShakeWindspeed.x, _WindShakeBending.x);
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.y = tmp2.z * v.texcoord.y;
                tmp0 = tmp2.xxxx * float4(1.2, 2.0, 1.6, 4.8) + tmp0;
                tmp0 = frac(tmp0);
                tmp0 = tmp0 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp3 = tmp0 * tmp0;
                tmp4 = tmp0 * tmp3;
                tmp0 = tmp4 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp0;
                tmp4 = tmp3 * tmp4;
                tmp3 = tmp3 * tmp4;
                tmp0 = tmp4 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp0;
                tmp0 = tmp3 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp0;
                tmp0 = tmp2.yyyy * tmp0;
                tmp0 = tmp0 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp0 = tmp0 * tmp0;
                tmp0 = tmp0 * tmp0;
                tmp2.x = dot(tmp0, float4(0.006, 0.02, -0.02, 0.1));
                tmp0.x = dot(tmp0, float4(0.024, 0.04, -0.12, 0.096));
                tmp0.yz = tmp2.xx * unity_WorldToObject._m02_m22;
                tmp0.xy = unity_WorldToObject._m00_m20 * tmp0.xx + tmp0.yz;
                tmp0.xy = v.vertex.xz - tmp0.xy;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.yyyy + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = saturate(tmp0.w - inp.color.w);
                o.sv_target.xyz = tmp0.xyz * inp.color.xyz;
                tmp0.x = tmp0.w - _Cutoff;
                o.sv_target.w = tmp0.w;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                return o;
			}
			ENDCG
		}
		Pass {
			LOD 510
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Geometry" "RenderType" = "TransparentCutoff" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 136861
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
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
			float _GrassCullingDistance;
			float _GrassCullingRange;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
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
                o.texcoord.xy = v.texcoord.xy;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x + _GrassCullingRange;
                tmp1.x = tmp1.x - _GrassCullingDistance;
                tmp1.x = tmp1.x / _GrassCullingRange;
                o.color = saturate(tmp1.xxxx);
                tmp1 = v.vertex.zzzz * float4(0.024, 0.08, 0.08, 0.2);
                tmp1 = v.vertex.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp1;
                tmp2.x = -_WindShakeTime * 2.0 + 1.0;
                tmp2.x = tmp2.x - v.color.z;
                tmp2.x = tmp2.x * _Time.x;
                tmp2.yz = v.color.yw + float2(_WindShakeWindspeed.x, _WindShakeBending.x);
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.y = tmp2.z * v.texcoord.y;
                tmp1 = tmp2.xxxx * float4(1.2, 2.0, 1.6, 4.8) + tmp1;
                tmp1 = frac(tmp1);
                tmp1 = tmp1 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp3 = tmp1 * tmp1;
                tmp4 = tmp1 * tmp3;
                tmp1 = tmp4 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp1;
                tmp4 = tmp3 * tmp4;
                tmp3 = tmp3 * tmp4;
                tmp1 = tmp4 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp1;
                tmp1 = tmp3 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp1;
                tmp1 = tmp2.yyyy * tmp1;
                tmp1 = tmp1 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp1 = tmp1 * tmp1;
                tmp1 = tmp1 * tmp1;
                tmp2.x = dot(tmp1, float4(0.006, 0.02, -0.02, 0.1));
                tmp1.x = dot(tmp1, float4(0.024, 0.04, -0.12, 0.096));
                tmp1.yz = tmp2.xx * unity_WorldToObject._m02_m22;
                tmp1.xy = unity_WorldToObject._m00_m20 * tmp1.xx + tmp1.yz;
                tmp1.xy = v.vertex.xz - tmp1.xy;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.yyyy + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0.wwww - inp.color;
                tmp0 = tmp0 - _Cutoff.xxxx;
                tmp0 = tmp0 < float4(0.0, 0.0, 0.0, 0.0);
                tmp0.xy = uint2(tmp0.zw) | uint2(tmp0.xy);
                tmp0.x = uint1(tmp0.y) | uint1(tmp0.x);
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
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "TransparentCutoff" }
		Pass {
			Name "FORWARD_BASE"
			LOD 500
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "TransparentCutoff" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 226026
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float4 position : SV_POSITION0;
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
			float _GrassCullingDistance;
			float _GrassCullingRange;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
			float _ShadowMixStrength;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _LightMap;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = tmp0.x * 0.1 + 0.3;
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                o.color.xyz = tmp0.xyz * v.color.xyz;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x + _GrassCullingRange;
                tmp1.x = tmp1.x - _GrassCullingDistance;
                o.color.w = saturate(tmp1.x / _GrassCullingRange);
                tmp1 = v.vertex.zzzz * float4(0.024, 0.08, 0.08, 0.2);
                tmp1 = v.vertex.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp1;
                tmp2.x = -_WindShakeTime * 2.0 + 1.0;
                tmp2.x = tmp2.x - v.color.z;
                tmp2.x = tmp2.x * _Time.x;
                tmp2.yz = v.color.yw + float2(_WindShakeWindspeed.x, _WindShakeBending.x);
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.y = tmp2.z * v.texcoord.y;
                tmp1 = tmp2.xxxx * float4(1.2, 2.0, 1.6, 4.8) + tmp1;
                tmp1 = frac(tmp1);
                tmp1 = tmp1 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp3 = tmp1 * tmp1;
                tmp4 = tmp1 * tmp3;
                tmp1 = tmp4 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp1;
                tmp4 = tmp3 * tmp4;
                tmp3 = tmp3 * tmp4;
                tmp1 = tmp4 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp1;
                tmp1 = tmp3 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp1;
                tmp1 = tmp2.yyyy * tmp1;
                tmp1 = tmp1 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp1 = tmp1 * tmp1;
                tmp1 = tmp1 * tmp1;
                tmp2.x = dot(tmp1, float4(0.006, 0.02, -0.02, 0.1));
                tmp1.x = dot(tmp1, float4(0.024, 0.04, -0.12, 0.096));
                tmp1.yz = tmp2.xx * unity_WorldToObject._m02_m22;
                tmp1.xy = unity_WorldToObject._m00_m20 * tmp1.xx + tmp1.yz;
                tmp1.xy = v.vertex.xz - tmp1.xy;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.yyyy + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - inp.color.w;
                tmp1.x = tmp1.x - _Cutoff;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1 = tex2D(_LightMap, inp.texcoord1.xy);
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * unity_Lightmap_HDR.y;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * unity_Lightmap_HDR.x;
                tmp1.xyz = tmp1.xyz * tmp1.www;
                tmp1.w = _ShadowMixStrength + 2.0;
                tmp1.xyz = min(tmp1.xyz, tmp1.www);
                tmp1.xyz = tmp1.xyz + float3(0.1, 0.1, 0.1);
                tmp2.xyz = inp.color.xyz * float3(1.5, 1.5, 1.5);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			LOD 500
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Geometry" "RenderType" = "TransparentCutoff" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 310138
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
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
			float _GrassCullingDistance;
			float _GrassCullingRange;
			// $Globals ConstantBuffers for Fragment Shader
			float _Cutoff;
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
                o.texcoord.xy = v.texcoord.xy;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x + _GrassCullingRange;
                tmp1.x = tmp1.x - _GrassCullingDistance;
                tmp1.x = tmp1.x / _GrassCullingRange;
                o.color = saturate(tmp1.xxxx);
                tmp1 = v.vertex.zzzz * float4(0.024, 0.08, 0.08, 0.2);
                tmp1 = v.vertex.xxxx * float4(0.048, 0.06, 0.24, 0.096) + tmp1;
                tmp2.x = -_WindShakeTime * 2.0 + 1.0;
                tmp2.x = tmp2.x - v.color.z;
                tmp2.x = tmp2.x * _Time.x;
                tmp2.yz = v.color.yw + float2(_WindShakeWindspeed.x, _WindShakeBending.x);
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.y = tmp2.z * v.texcoord.y;
                tmp1 = tmp2.xxxx * float4(1.2, 2.0, 1.6, 4.8) + tmp1;
                tmp1 = frac(tmp1);
                tmp1 = tmp1 * float4(6.408849, 6.408849, 6.408849, 6.408849) + float4(-3.141593, -3.141593, -3.141593, -3.141593);
                tmp3 = tmp1 * tmp1;
                tmp4 = tmp1 * tmp3;
                tmp1 = tmp4 * float4(-0.1616162, -0.1616162, -0.1616162, -0.1616162) + tmp1;
                tmp4 = tmp3 * tmp4;
                tmp3 = tmp3 * tmp4;
                tmp1 = tmp4 * float4(0.0083333, 0.0083333, 0.0083333, 0.0083333) + tmp1;
                tmp1 = tmp3 * float4(-0.0001984, -0.0001984, -0.0001984, -0.0001984) + tmp1;
                tmp1 = tmp2.yyyy * tmp1;
                tmp1 = tmp1 * float4(0.2153874, 0.3589791, 0.2871833, 0.8615498);
                tmp1 = tmp1 * tmp1;
                tmp1 = tmp1 * tmp1;
                tmp2.x = dot(tmp1, float4(0.006, 0.02, -0.02, 0.1));
                tmp1.x = dot(tmp1, float4(0.024, 0.04, -0.12, 0.096));
                tmp1.yz = tmp2.xx * unity_WorldToObject._m02_m22;
                tmp1.xy = unity_WorldToObject._m00_m20 * tmp1.xx + tmp1.yz;
                tmp1.xy = v.vertex.xz - tmp1.xy;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.yyyy + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0.wwww - inp.color;
                tmp0 = tmp0 - _Cutoff.xxxx;
                tmp0 = tmp0 < float4(0.0, 0.0, 0.0, 0.0);
                tmp0.xy = uint2(tmp0.zw) | uint2(tmp0.xy);
                tmp0.x = uint1(tmp0.y) | uint1(tmp0.x);
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
}