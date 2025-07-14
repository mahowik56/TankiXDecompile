Shader "Shader Forge/repin_standart" {
	Properties {
		_Color ("Color", Color) = (0.5019608,0.5019608,0.5019608,1)
		_MainTex ("albedo", 2D) = "white" {}
		_Metallic ("Metallic", Range(0, 1)) = 0
		_Gloss ("Gloss", Range(0, 1)) = 1
		_normal ("normal", 2D) = "bump" {}
		_tile ("tile", Float) = 1
		_opacity_clip ("opacity_clip", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			ZClip Off
			GpuProgramID 24810
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
				float4 texcoord10 : TEXCOORD10;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 _MainTex_ST;
			float _Metallic;
			float _Gloss;
			float4 _normal_ST;
			float _tile;
			float4 _opacity_clip_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _normal;
			sampler2D _opacity_clip;
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL LIGHTMAP_OFF DIRLIGHTMAP_OFF DYNAMICLIGHTMAP_OFF
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
                o.texcoord3 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                o.texcoord2.xy = v.texcoord2.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord4.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord5.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord6.xyz = tmp0.www * tmp0.xyz;
                o.texcoord10 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_OFF DIRLIGHTMAP_OFF DYNAMICLIGHTMAP_OFF
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
                float4 tmp12;
                tmp0.x = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord4.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp3.xy = inp.texcoord.xy * _tile.xx;
                tmp3.zw = tmp3.xy * _normal_ST.xy + _normal_ST.zw;
                tmp4 = tex2D(_normal, tmp3.zw);
                tmp3.zw = tmp4.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp3.xy, tmp3.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = sqrt(tmp1.w);
                tmp4.xyz = tmp3.www * inp.texcoord6.xyz;
                tmp4.xyz = tmp3.zzz * inp.texcoord5.xyz + tmp4.xyz;
                tmp0.xyz = tmp1.www * tmp0.xyz + tmp4.xyz;
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp0.xyz * tmp1.www;
                tmp0.x = dot(-tmp2.xyz, tmp4.xyz);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.xyz = tmp4.xyz * -tmp0.xxx + -tmp2.xyz;
                tmp3.zw = inp.texcoord.xy * _opacity_clip_ST.xy + _opacity_clip_ST.zw;
                tmp5 = tex2D(_opacity_clip, tmp3.zw);
                tmp1.w = tmp5.x - 0.5;
                tmp1.w = tmp1.w < 0.0;
                if (tmp1.w) {
                    discard;
                }
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp5.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp5.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp0.w = -_Gloss * tmp3.w + 1.0;
                tmp1.w = tmp0.w * tmp0.w;
                tmp2.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.w) {
                    tmp2.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp6.xyz = inp.texcoord3.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp6.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord3.xxx + tmp6.xyz;
                    tmp6.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp6.xyz;
                    tmp6.xyz = tmp6.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp6.xyz = tmp2.www ? tmp6.xyz : inp.texcoord3.xyz;
                    tmp6.xyz = tmp6.xyz - unity_ProbeVolumeMin;
                    tmp6.yzw = tmp6.xyz * unity_ProbeVolumeSizeInv;
                    tmp2.w = tmp6.y * 0.25;
                    tmp5.w = unity_ProbeVolumeParams.z * 0.5;
                    tmp6.y = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp2.w = max(tmp2.w, tmp5.w);
                    tmp6.x = min(tmp6.y, tmp2.w);
                    tmp7 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp6.xzw);
                    tmp8.xyz = tmp6.xzw + float3(0.25, 0.0, 0.0);
                    tmp8 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp8.xyz);
                    tmp6.xyz = tmp6.xzw + float3(0.5, 0.0, 0.0);
                    tmp6 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp6.xyz);
                    tmp4.w = 1.0;
                    tmp7.x = dot(tmp7, tmp4);
                    tmp7.y = dot(tmp8, tmp4);
                    tmp7.z = dot(tmp6, tmp4);
                } else {
                    tmp4.w = 1.0;
                    tmp7.x = dot(unity_SHAr, tmp4);
                    tmp7.y = dot(unity_SHAg, tmp4);
                    tmp7.z = dot(unity_SHAb, tmp4);
                }
                tmp6.xyz = tmp7.xyz + inp.texcoord10.xyz;
                tmp6.xyz = max(tmp6.xyz, float3(0.0, 0.0, 0.0));
                tmp2.w = unity_SpecCube0_ProbePosition.w > 0.0;
                if (tmp2.w) {
                    tmp2.w = dot(tmp0.xyz, tmp0.xyz);
                    tmp2.w = rsqrt(tmp2.w);
                    tmp7.xyz = tmp0.xyz * tmp2.www;
                    tmp8.xyz = unity_SpecCube0_BoxMax.xyz - inp.texcoord3.xyz;
                    tmp8.xyz = tmp8.xyz / tmp7.xyz;
                    tmp9.xyz = unity_SpecCube0_BoxMin.xyz - inp.texcoord3.xyz;
                    tmp9.xyz = tmp9.xyz / tmp7.xyz;
                    tmp10.xyz = tmp7.xyz > float3(0.0, 0.0, 0.0);
                    tmp8.xyz = tmp10.xyz ? tmp8.xyz : tmp9.xyz;
                    tmp2.w = min(tmp8.y, tmp8.x);
                    tmp2.w = min(tmp8.z, tmp2.w);
                    tmp8.xyz = inp.texcoord3.xyz - unity_SpecCube0_ProbePosition.xyz;
                    tmp7.xyz = tmp7.xyz * tmp2.www + tmp8.xyz;
                } else {
                    tmp7.xyz = tmp0.xyz;
                }
                tmp2.w = -tmp0.w * 0.7 + 1.7;
                tmp2.w = tmp0.w * tmp2.w;
                tmp2.w = tmp2.w * 6.0;
                tmp7 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp7.xyz, tmp2.w));
                tmp4.w = tmp7.w - 1.0;
                tmp4.w = unity_SpecCube0_HDR.w * tmp4.w + 1.0;
                tmp4.w = log(tmp4.w);
                tmp4.w = tmp4.w * unity_SpecCube0_HDR.y;
                tmp4.w = exp(tmp4.w);
                tmp4.w = tmp4.w * unity_SpecCube0_HDR.x;
                tmp8.xyz = tmp7.xyz * tmp4.www;
                tmp5.w = unity_SpecCube0_BoxMin.w < 0.99999;
                if (tmp5.w) {
                    tmp5.w = unity_SpecCube1_ProbePosition.w > 0.0;
                    if (tmp5.w) {
                        tmp5.w = dot(tmp0.xyz, tmp0.xyz);
                        tmp5.w = rsqrt(tmp5.w);
                        tmp9.xyz = tmp0.xyz * tmp5.www;
                        tmp10.xyz = unity_SpecCube1_BoxMax.xyz - inp.texcoord3.xyz;
                        tmp10.xyz = tmp10.xyz / tmp9.xyz;
                        tmp11.xyz = unity_SpecCube1_BoxMin.xyz - inp.texcoord3.xyz;
                        tmp11.xyz = tmp11.xyz / tmp9.xyz;
                        tmp12.xyz = tmp9.xyz > float3(0.0, 0.0, 0.0);
                        tmp10.xyz = tmp12.xyz ? tmp10.xyz : tmp11.xyz;
                        tmp5.w = min(tmp10.y, tmp10.x);
                        tmp5.w = min(tmp10.z, tmp5.w);
                        tmp10.xyz = inp.texcoord3.xyz - unity_SpecCube1_ProbePosition.xyz;
                        tmp0.xyz = tmp9.xyz * tmp5.www + tmp10.xyz;
                    }
                    tmp9 = UNITY_SAMPLE_TEXCUBE_SAMPLER(unity_SpecCube0, unity_SpecCube0, float4(tmp0.xyz, tmp2.w));
                    tmp0.x = tmp9.w - 1.0;
                    tmp0.x = unity_SpecCube1_HDR.w * tmp0.x + 1.0;
                    tmp0.x = log(tmp0.x);
                    tmp0.x = tmp0.x * unity_SpecCube1_HDR.y;
                    tmp0.x = exp(tmp0.x);
                    tmp0.x = tmp0.x * unity_SpecCube1_HDR.x;
                    tmp0.xyz = tmp9.xyz * tmp0.xxx;
                    tmp7.xyz = tmp4.www * tmp7.xyz + -tmp0.xyz;
                    tmp8.xyz = unity_SpecCube0_BoxMin.www * tmp7.xyz + tmp0.xyz;
                }
                tmp0.x = dot(tmp4.xyz, tmp5.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.y = min(tmp0.x, 1.0);
                tmp0.z = saturate(dot(tmp5.xyz, tmp1.xyz));
                tmp5.xyz = tmp3.xyz * _Color.xyz;
                tmp3.xyz = tmp3.xyz * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp3.xyz = _Metallic.xxx * tmp3.xyz + float3(0.04, 0.04, 0.04);
                tmp2.w = -_Metallic * 0.96 + 0.96;
                tmp5.xyz = tmp2.www * tmp5.xyz;
                tmp2.w = 1.0 - tmp2.w;
                tmp2.x = dot(tmp4.xyz, tmp2.xyz);
                tmp1.x = saturate(dot(tmp4.xyz, tmp1.xyz));
                tmp1.y = -tmp0.w * tmp0.w + 1.0;
                tmp1.z = abs(tmp2.x) * tmp1.y + tmp1.w;
                tmp1.y = tmp0.y * tmp1.y + tmp1.w;
                tmp1.y = tmp1.y * abs(tmp2.x);
                tmp1.y = tmp0.y * tmp1.z + tmp1.y;
                tmp1.y = tmp1.y + 0.00001;
                tmp1.y = 0.5 / tmp1.y;
                tmp1.z = tmp1.w * tmp1.w;
                tmp2.y = tmp1.x * tmp1.z + -tmp1.x;
                tmp1.x = tmp2.y * tmp1.x + 1.0;
                tmp1.z = tmp1.z * 0.3183099;
                tmp1.x = tmp1.x * tmp1.x + 0.0000001;
                tmp1.x = tmp1.z / tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.x = tmp1.x * 3.141593;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.y = max(tmp0.y, 0.0);
                tmp1.x = tmp1.w * tmp1.w + 1.0;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.y = dot(tmp3.xyz, tmp3.xyz);
                tmp1.y = tmp1.y != 0.0;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp0.y = tmp0.y * tmp1.y;
                tmp1.yzw = tmp0.yyy * _LightColor0.xyz;
                tmp0.y = 1.0 - tmp0.z;
                tmp2.y = tmp0.y * tmp0.y;
                tmp2.y = tmp2.y * tmp2.y;
                tmp0.y = tmp0.y * tmp2.y;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp4.xyz = tmp4.xyz * tmp0.yyy + tmp3.xyz;
                tmp0.y = saturate(_Gloss * tmp3.w + tmp2.w);
                tmp2.x = 1.0 - abs(tmp2.x);
                tmp2.y = tmp2.x * tmp2.x;
                tmp2.y = tmp2.y * tmp2.y;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.yzw = tmp0.yyy - tmp3.xyz;
                tmp2.yzw = tmp2.xxx * tmp2.yzw + tmp3.xyz;
                tmp2.yzw = tmp2.yzw * tmp8.xyz;
                tmp2.yzw = tmp1.xxx * tmp2.yzw;
                tmp1.xyz = tmp1.yzw * tmp4.xyz + tmp2.yzw;
                tmp0.y = tmp0.z + tmp0.z;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.z = 1.0 - tmp0.x;
                tmp1.w = tmp0.z * tmp0.z;
                tmp1.w = tmp1.w * tmp1.w;
                tmp0.z = tmp0.z * tmp1.w;
                tmp0.y = tmp0.y * tmp0.w + -0.5;
                tmp0.z = tmp0.y * tmp0.z + 1.0;
                tmp0.y = tmp0.y * tmp2.x + 1.0;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz + tmp6.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp5.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZClip Off
			GpuProgramID 111252
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
				float3 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 _MainTex_ST;
			float _Metallic;
			float _Gloss;
			float4 _normal_ST;
			float _tile;
			float4 _opacity_clip_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _normal;
			sampler2D _opacity_clip;
			sampler2D _LightTexture0;
			sampler2D _MainTex;
			
			// Keywords: POINT LIGHTMAP_OFF DIRLIGHTMAP_OFF DYNAMICLIGHTMAP_OFF
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
                o.texcoord1.xy = v.texcoord1.xy;
                o.texcoord2.xy = v.texcoord2.xy;
                o.texcoord3 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord4.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord5.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord6.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord7.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT LIGHTMAP_OFF DIRLIGHTMAP_OFF DYNAMICLIGHTMAP_OFF
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.xy = inp.texcoord.xy * _opacity_clip_ST.xy + _opacity_clip_ST.zw;
                tmp0 = tex2D(_opacity_clip, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord4.xyz;
                tmp1.xy = inp.texcoord.xy * _tile.xx;
                tmp1.zw = tmp1.xy * _normal_ST.xy + _normal_ST.zw;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_normal, tmp1.zw);
                tmp1.xy = tmp1.wy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xyz = tmp1.yyy * inp.texcoord6.xyz;
                tmp3.xyz = tmp1.xxx * inp.texcoord5.xyz + tmp3.xyz;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp3.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceLightPos0.www * -inp.texcoord3.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = min(tmp0.w, 1.0);
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp3.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp4.xyz = tmp3.www * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp3.www + tmp1.xyz;
                tmp3.w = dot(tmp0.xyz, tmp4.xyz);
                tmp2.w = -_Gloss * tmp2.w + 1.0;
                tmp4.x = -tmp2.w * tmp2.w + 1.0;
                tmp4.y = tmp2.w * tmp2.w;
                tmp4.z = abs(tmp3.w) * tmp4.x + tmp4.y;
                tmp4.x = tmp1.w * tmp4.x + tmp4.y;
                tmp4.y = tmp4.y * tmp4.y;
                tmp4.x = abs(tmp3.w) * tmp4.x;
                tmp3.w = 1.0 - abs(tmp3.w);
                tmp4.x = tmp1.w * tmp4.z + tmp4.x;
                tmp4.x = tmp4.x + 0.00001;
                tmp4.x = 0.5 / tmp4.x;
                tmp4.z = dot(tmp3.xyz, tmp3.xyz);
                tmp4.z = rsqrt(tmp4.z);
                tmp3.xyz = tmp3.xyz * tmp4.zzz;
                tmp0.x = saturate(dot(tmp0.xyz, tmp3.xyz));
                tmp0.y = saturate(dot(tmp1.xyz, tmp3.xyz));
                tmp0.z = tmp0.x * tmp4.y + -tmp0.x;
                tmp0.x = tmp0.z * tmp0.x + 1.0;
                tmp0.x = tmp0.x * tmp0.x + 0.0000001;
                tmp0.z = tmp4.y * 0.3183099;
                tmp0.x = tmp0.z / tmp0.x;
                tmp0.x = tmp0.x * tmp4.x;
                tmp0.x = tmp0.x * 3.141593;
                tmp0.x = tmp1.w * tmp0.x;
                tmp0.x = max(tmp0.x, 0.0);
                tmp1.xyz = tmp2.xyz * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp2.xyz = tmp2.xyz * _Color.xyz;
                tmp1.xyz = _Metallic.xxx * tmp1.xyz + float3(0.04, 0.04, 0.04);
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = tmp0.z != 0.0;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.z = dot(inp.texcoord7.xyz, inp.texcoord7.xyz);
                tmp4 = tex2D(_LightTexture0, tmp0.zz);
                tmp3.xyz = tmp4.xxx * _LightColor0.xyz;
                tmp4.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.x = 1.0 - tmp0.y;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.x = tmp0.x * tmp0.z;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp1.xyz = tmp5.xyz * tmp0.xxx + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * tmp4.xyz;
                tmp0.x = tmp0.y + tmp0.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * tmp2.w + -0.5;
                tmp0.y = tmp3.w * tmp3.w;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp3.w * tmp0.y;
                tmp0.y = tmp0.x * tmp0.y + 1.0;
                tmp0.z = 1.0 - tmp0.w;
                tmp1.w = tmp0.z * tmp0.z;
                tmp1.w = tmp1.w * tmp1.w;
                tmp0.z = tmp0.z * tmp1.w;
                tmp0.x = tmp0.x * tmp0.z + 1.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xyz = tmp3.xyz * tmp0.xxx;
                tmp0.w = -_Metallic * 0.96 + 0.96;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "SHADOWCASTER"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Offset 1, 1
			GpuProgramID 170550
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
				float2 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _opacity_clip_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _opacity_clip;
			
			// Keywords: SHADOWS_DEPTH LIGHTMAP_OFF DIRLIGHTMAP_OFF DYNAMICLIGHTMAP_OFF
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord4 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord2.xy = v.texcoord1.xy;
                o.texcoord3.xy = v.texcoord2.xy;
                return o;
			}
			// Keywords: SHADOWS_DEPTH LIGHTMAP_OFF DIRLIGHTMAP_OFF DYNAMICLIGHTMAP_OFF
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.xy = inp.texcoord1.xy * _opacity_clip_ST.xy + _opacity_clip_ST.zw;
                tmp0 = tex2D(_opacity_clip, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
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
			Name "META"
			Tags { "LIGHTMODE" = "META" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			ZClip Off
			Cull Off
			GpuProgramID 220864
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
			float4 _Color;
			float4 _MainTex_ST;
			float _Metallic;
			float _Gloss;
			float _tile;
			// Custom ConstantBuffers for Vertex Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaVertexControl;
			CBUFFER_END
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaFragmentControl;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: SHADOWS_DEPTH LIGHTMAP_OFF DIRLIGHTMAP_OFF DYNAMICLIGHTMAP_OFF
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.vertex.z > 0.0;
                tmp0.z = tmp0.x ? 0.0001 : 0.0;
                tmp0.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp0.xyz = unity_MetaVertexControl.xxx ? tmp0.xyz : v.vertex.xyz;
                tmp0.w = tmp0.z > 0.0;
                tmp1.z = tmp0.w ? 0.0001 : 0.0;
                tmp1.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                tmp0.xyz = unity_MetaVertexControl.yyy ? tmp1.xyz : tmp0.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                o.texcoord2.xy = v.texcoord2.xy;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                o.texcoord3 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                return o;
			}
			// Keywords: SHADOWS_DEPTH LIGHTMAP_OFF DIRLIGHTMAP_OFF DYNAMICLIGHTMAP_OFF
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy * _tile.xx;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp1.xyz = tmp0.xyz * _Color.xyz + float3(-0.04, -0.04, -0.04);
                tmp1.xyz = _Metallic.xxx * tmp1.xyz + float3(0.04, 0.04, 0.04);
                tmp0.w = -_Gloss * tmp0.w + 1.0;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5);
                tmp0.w = -_Metallic * 0.96 + 0.96;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp1.xyz;
                tmp0.xyz = log(tmp0.xyz);
                tmp0.w = saturate(unity_OneOverOutputBoost);
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = exp(tmp0.xyz);
                tmp0.xyz = min(tmp0.xyz, unity_MaxOutputValue.xxx);
                tmp0.w = 1.0;
                tmp0 = unity_MetaFragmentControl ? tmp0 : float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target = unity_MetaFragmentControl ? float4(0.0, 0.0, 0.0, 0.0235294) : tmp0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}