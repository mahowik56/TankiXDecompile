Shader "Tasharen/Water" {
	Properties {
		_WaterTex ("Normal Map (RGB), Foam (A)", 2D) = "white" {}
		_ReflectionTex ("Reflection", 2D) = "white" {}
		_Cube ("Skybox", Cube) = "_Skybox" {}
		_Color0 ("Shallow Color", Color) = (1,1,1,1)
		_Color1 ("Deep Color", Color) = (0,0,0,0)
		_Specular ("Specular", Color) = (0,0,0,0)
		_Shininess ("Shininess", Range(0.01, 1)) = 1
		_Tiling ("Tiling", Range(0.025, 0.25)) = 0.25
		_ReflectionTint ("Reflection Tint", Range(0, 1)) = 0.8
		_InvRanges ("Inverse Alpha, Depth and Color ranges", Vector) = (1,0.17,0.17,0)
	}
	SubShader {
		LOD 400
		Tags { "QUEUE" = "Transparent-10" }
		GrabPass {
		}
		Pass {
			Name "FORWARD"
			LOD 400
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-10" "SHADOWSUPPORT" = "true" }
			ZClip Off
			ZWrite Off
			GpuProgramID 39411
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
				float4 texcoord5 : TEXCOORD5;
				float3 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
				float4 texcoord9 : TEXCOORD9;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color0;
			float4 _Color1;
			float4 _Specular;
			float _Tiling;
			float _ReflectionTint;
			float4 _InvRanges;
			float4 _GrabTexture_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			sampler2D _ReflectionTex;
			sampler2D _GrabTexture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp2;
                o.texcoord.w = tmp0.x;
                tmp3.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp4.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp4.xyz;
                tmp4.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp4.xyz;
                tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                tmp5.xyz = tmp3.xyz * tmp4.xyz;
                tmp5.xyz = tmp3.zxy * tmp4.yzx + -tmp5.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp5.xyz = tmp0.xxx * tmp5.xyz;
                o.texcoord.y = tmp5.x;
                o.texcoord.x = tmp4.z;
                o.texcoord.z = tmp3.y;
                o.texcoord1.x = tmp4.x;
                o.texcoord2.x = tmp4.y;
                o.texcoord1.z = tmp3.z;
                o.texcoord2.z = tmp3.x;
                o.texcoord1.w = tmp0.y;
                o.texcoord2.w = tmp0.z;
                o.texcoord1.y = tmp5.y;
                o.texcoord2.y = tmp5.z;
                o.texcoord3 = tmp2;
                tmp0.x = tmp1.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp1.x + tmp0.x;
                tmp0.x = unity_MatrixV._m22 * tmp1.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp1.w + tmp0.x;
                tmp0.z = -tmp0.x;
                tmp1.x = tmp2.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp2.xw * float2(0.5, 0.5);
                tmp0.xy = tmp1.zz + tmp1.xw;
                tmp0.w = tmp2.w;
                tmp1.x = tmp0.w - tmp2.y;
                o.texcoord5.y = tmp1.x * 0.5;
                o.texcoord4 = tmp0;
                o.texcoord5.xzw = tmp0.xzw;
                o.texcoord6.xyz = float3(0.0, 0.0, 0.0);
                o.texcoord7.xy = float2(0.0, 0.0);
                o.texcoord9 = float4(0.0, 0.0, 0.0, 0.0);
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
                float4 tmp7;
                tmp0.y = inp.texcoord.w;
                tmp0.z = inp.texcoord1.w;
                tmp0.w = inp.texcoord2.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.yzw;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xyz = tmp0.yzw - _WorldSpaceCameraPos;
                tmp3.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp3 = tex2D(_CameraDepthTexture, tmp3.xy);
                tmp0.x = _ZBufferParams.z * tmp3.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - inp.texcoord4.z;
                tmp1.w = _Time.x * 0.5;
                tmp3.xy = tmp0.yw * _Tiling.xx;
                tmp4.xy = tmp0.yw * _Tiling.xx + tmp1.ww;
                tmp4 = tex2D(_WaterTex, tmp4.xy);
                tmp3.z = -tmp3.y;
                tmp3.xy = -_Time.xx * float2(0.5, 0.5) + tmp3.zx;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp3 = tmp3 + tmp4;
                tmp1.w = tmp3.w * 0.5;
                tmp3.xyz = tmp3.xyz - float3(1.0, 1.0, 1.0);
                tmp4.xyz = saturate(tmp0.xxx * _InvRanges.xyz);
                tmp0.x = 1.0 - tmp4.y;
                tmp2.w = tmp0.x * tmp0.x;
                tmp2.w = tmp2.w * tmp0.x + -tmp0.x;
                tmp0.x = tmp2.w * 0.5 + tmp0.x;
                tmp5.xyz = _Color0.xyz - _Color1.xyz;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + _Color1.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.w = -tmp3.y;
                tmp2.x = dot(-tmp2.xyz, tmp3.xyz);
                tmp2.x = 1.0 - tmp2.x;
                tmp2.x = sqrt(tmp2.x);
                tmp2.yz = tmp3.xy * float2(0.5, 0.5) + inp.texcoord4.xy;
                tmp2.yz = tmp2.yz / inp.texcoord4.ww;
                tmp6 = tex2D(_ReflectionTex, tmp2.yz);
                tmp2.yzw = tmp5.xyz * tmp6.xyz;
                tmp3.w = tmp2.x * _ReflectionTint;
                tmp6.xyz = -tmp6.xyz * tmp5.xyz + tmp6.xyz;
                tmp2.yzw = tmp3.www * tmp6.xyz + tmp2.yzw;
                tmp4.yw = tmp3.xy * _GrabTexture_TexelSize.xy;
                tmp3.w = inp.texcoord5.z * 20.0;
                tmp3.w = tmp4.x * tmp3.w;
                tmp4.yw = tmp4.yw * tmp3.ww + inp.texcoord5.xy;
                tmp4.yw = tmp4.yw / inp.texcoord5.ww;
                tmp6 = tex2D(_GrabTexture, tmp4.yw);
                tmp7.xyz = tmp6.xyz * tmp5.xyz + -tmp6.xyz;
                tmp4.yzw = tmp4.zzz * tmp7.xyz + tmp6.xyz;
                tmp6.xyz = tmp5.xyz * tmp4.yzw + -tmp5.xyz;
                tmp5.xyz = tmp0.xxx * tmp6.xyz + tmp5.xyz;
                tmp4.yzw = tmp4.yzw - tmp5.xyz;
                tmp4.yzw = tmp0.xxx * tmp4.yzw + tmp5.xyz;
                tmp0.x = tmp4.x * 2.0 + -1.0;
                tmp0.x = 1.0 - abs(tmp0.x);
                tmp0.x = tmp0.x * tmp1.w;
                tmp1.w = tmp2.x * tmp2.x;
                tmp1.w = tmp1.w * tmp2.x;
                tmp1.w = tmp1.w * 0.8 + 0.2;
                tmp1.w = tmp4.x * tmp1.w;
                tmp2.xyz = tmp2.yzw - tmp4.yzw;
                tmp2.xyz = tmp1.www * tmp2.xyz + tmp4.yzw;
                tmp2.xyz = tmp0.xxx * float3(0.35, 0.35, 0.35) + tmp2.xyz;
                tmp0.x = tmp0.x * 0.175 + tmp1.w;
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.w = 1.0 - tmp0.x;
                tmp4.yzw = tmp0.xxx * tmp2.xyz;
                tmp0.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.x) {
                    tmp0.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord1.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord.www + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.www + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp0.xyz = tmp0.xxx ? tmp5.xyz : tmp0.yzw;
                    tmp0.xyz = tmp0.xyz - unity_ProbeVolumeMin;
                    tmp0.yzw = tmp0.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.y = tmp0.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp0.x = max(tmp0.y, tmp2.w);
                    tmp0 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp0.xzw);
                } else {
                    tmp0 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.x = saturate(dot(tmp0, unity_OcclusionMaskSelector));
                tmp5.x = dot(inp.texcoord.xyz, tmp3.xyz);
                tmp5.y = dot(inp.texcoord1.xyz, tmp3.xyz);
                tmp5.z = dot(inp.texcoord2.xyz, tmp3.xyz);
                tmp0.y = dot(tmp5.xyz, tmp5.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp5.xyz;
                tmp2.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp3.xyz, tmp0.xyz);
                tmp3.w = tmp2.w + tmp2.w;
                tmp0.yzw = tmp0.yzw * -tmp3.www + tmp3.xyz;
                tmp0.y = saturate(dot(-tmp1.xyz, tmp0.xyz));
                tmp0.z = max(tmp2.w, 0.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 256.0;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp4.x * tmp0.y;
                tmp1.xyz = tmp0.yyy * _Specular.xyz;
                tmp0.yzw = tmp4.yzw * tmp0.zzz + tmp1.xyz;
                tmp0.yzw = tmp0.yzw * _LightColor0.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp4.yzw * inp.texcoord6.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp2.xyz * tmp1.www + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			LOD 400
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent-10" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			GpuProgramID 125749
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float4 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float4 _Specular;
			float _Tiling;
			float4 _InvRanges;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			sampler2D _LightTexture0;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * tmp3.xyz;
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx + -tmp4.xyz;
                tmp2.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp2.www * tmp4.xyz;
                o.texcoord.y = tmp4.x;
                o.texcoord.x = tmp3.z;
                o.texcoord.z = tmp2.y;
                o.texcoord1.x = tmp3.x;
                o.texcoord2.x = tmp3.y;
                o.texcoord1.z = tmp2.z;
                o.texcoord2.z = tmp2.x;
                o.texcoord1.y = tmp4.y;
                o.texcoord2.y = tmp4.z;
                o.texcoord4 = tmp0;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                tmp1.z = -tmp0.z;
                tmp0.z = tmp0.y * _ProjectionParams.x;
                tmp2.xzw = tmp0.xwz * float3(0.5, 0.5, 0.5);
                tmp1.xy = tmp2.zz + tmp2.xw;
                tmp1.w = tmp0.w;
                tmp0.x = tmp1.w - tmp0.y;
                o.texcoord6.y = tmp0.x * 0.5;
                o.texcoord5 = tmp1;
                o.texcoord6.xzw = tmp1.xzw;
                o.texcoord7.xy = float2(0.0, 0.0);
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
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord3.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp0.w = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - inp.texcoord5.z;
                tmp1.w = _Time.x * 0.5;
                tmp2.xy = inp.texcoord3.xz * _Tiling.xx;
                tmp3.xy = inp.texcoord3.xz * _Tiling.xx + tmp1.ww;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp2.z = -tmp2.y;
                tmp2.xy = -_Time.xx * float2(0.5, 0.5) + tmp2.zx;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = saturate(tmp0.w * _InvRanges.x);
                tmp3.xyz = inp.texcoord3.yyy * unity_WorldToLight._m01_m11_m21;
                tmp3.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord3.xxx + tmp3.xyz;
                tmp3.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord3.zzz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToLight._m03_m13_m23;
                tmp1.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.w) {
                    tmp1.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.xyz = inp.texcoord3.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord3.xxx + tmp4.xyz;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp4.xyz;
                    tmp4.xyz = tmp4.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp4.xyz = tmp1.www ? tmp4.xyz : inp.texcoord3.xyz;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.w = tmp4.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp1.w, tmp2.w);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.w = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3 = tex2D(_LightTexture0, tmp2.ww);
                tmp4.x = dot(inp.texcoord.xyz, tmp2.xyz);
                tmp4.y = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp4.z = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp2.x = dot(tmp4.xyz, tmp4.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * tmp4.xyz;
                tmp2.w = dot(tmp0.xyz, tmp2.xyz);
                tmp3.y = tmp2.w + tmp2.w;
                tmp0.xyz = tmp2.xyz * -tmp3.yyy + tmp0.xyz;
                tmp0.x = saturate(dot(-tmp1.xyz, tmp0.xyz));
                tmp0.y = max(tmp2.w, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 256.0;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xyz = _Specular.xyz * tmp0.xxx + tmp0.yyy;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                tmp0.w = dot(tmp3.xy, tmp1.xy);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 400
			Tags { "LIGHTMODE" = "META" "QUEUE" = "Transparent-10" }
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 144199
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
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color0;
			float4 _Color1;
			float _Tiling;
			float _ReflectionTint;
			float4 _InvRanges;
			float4 _GrabTexture_TexelSize;
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
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
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			sampler2D _ReflectionTex;
			sampler2D _GrabTexture;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
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
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp1.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx + -tmp2.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord.y = tmp2.x;
                o.texcoord.x = tmp1.z;
                o.texcoord.z = tmp0.y;
                tmp3 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp3;
                tmp3 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp3.xyz;
                tmp3 = tmp3 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord.w = tmp4.x;
                o.texcoord1.x = tmp1.x;
                o.texcoord2.x = tmp1.y;
                o.texcoord1.z = tmp0.z;
                o.texcoord2.z = tmp0.x;
                o.texcoord1.w = tmp4.y;
                o.texcoord2.w = tmp4.z;
                o.texcoord1.y = tmp2.y;
                o.texcoord2.y = tmp2.z;
                tmp0 = tmp3.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp3.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp3.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp3.wwww + tmp0;
                o.texcoord3 = tmp0;
                tmp0.z = tmp3.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp3.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp3.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp3.w + tmp0.z;
                tmp1.z = -tmp0.z;
                tmp0.z = tmp0.y * _ProjectionParams.x;
                tmp2.xzw = tmp0.xwz * float3(0.5, 0.5, 0.5);
                tmp1.xy = tmp2.zz + tmp2.xw;
                tmp1.w = tmp0.w;
                tmp0.x = tmp1.w - tmp0.y;
                o.texcoord5.y = tmp0.x * 0.5;
                o.texcoord4 = tmp1;
                o.texcoord5.xzw = tmp1.xzw;
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
                tmp0.x = inp.texcoord.w;
                tmp0.z = inp.texcoord2.w;
                tmp1.xy = tmp0.xz * _Tiling.xx;
                tmp1.z = -tmp1.y;
                tmp1.xy = -_Time.xx * float2(0.5, 0.5) + tmp1.zx;
                tmp1 = tex2D(_WaterTex, tmp1.xy);
                tmp0.w = _Time.x * 0.5;
                tmp2.xy = tmp0.xz * _Tiling.xx + tmp0.ww;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp1 = tmp1 + tmp2;
                tmp2.xyz = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = tmp1.w * 0.5;
                tmp1.xy = tmp2.xy * _GrabTexture_TexelSize.xy;
                tmp1.z = inp.texcoord5.z * 20.0;
                tmp3.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp3 = tex2D(_CameraDepthTexture, tmp3.xy);
                tmp1.w = _ZBufferParams.z * tmp3.x + _ZBufferParams.w;
                tmp1.w = 1.0 / tmp1.w;
                tmp1.w = tmp1.w - inp.texcoord4.z;
                tmp3.xyz = saturate(tmp1.www * _InvRanges.xyz);
                tmp1.z = tmp1.z * tmp3.x;
                tmp1.xy = tmp1.xy * tmp1.zz + inp.texcoord5.xy;
                tmp1.xy = tmp1.xy / inp.texcoord5.ww;
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp1.w = 1.0 - tmp3.y;
                tmp3.y = tmp1.w * tmp1.w;
                tmp3.y = tmp3.y * tmp1.w + -tmp1.w;
                tmp1.w = tmp3.y * 0.5 + tmp1.w;
                tmp4.xyz = _Color0.xyz - _Color1.xyz;
                tmp4.xyz = tmp1.www * tmp4.xyz + _Color1.xyz;
                tmp5.xyz = tmp1.xyz * tmp4.xyz + -tmp1.xyz;
                tmp1.xyz = tmp3.zzz * tmp5.xyz + tmp1.xyz;
                tmp3.yzw = tmp4.xyz * tmp1.xyz + -tmp4.xyz;
                tmp3.yzw = tmp1.www * tmp3.yzw + tmp4.xyz;
                tmp1.xyz = tmp1.xyz - tmp3.yzw;
                tmp1.xyz = tmp1.www * tmp1.xyz + tmp3.yzw;
                tmp0.y = inp.texcoord1.w;
                tmp0.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp0.xyz = tmp0.xyz * tmp1.www;
                tmp2.w = -tmp2.y;
                tmp0.x = dot(-tmp0.xyz, tmp2.xyz);
                tmp0.yz = tmp2.xy * float2(0.5, 0.5) + inp.texcoord4.xy;
                tmp0.yz = tmp0.yz / inp.texcoord4.ww;
                tmp2 = tex2D(_ReflectionTex, tmp0.yz);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = sqrt(tmp0.x);
                tmp0.y = tmp0.x * _ReflectionTint;
                tmp3.yzw = tmp4.xyz * tmp2.xyz;
                tmp2.xyz = -tmp2.xyz * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp0.yyy * tmp2.xyz + tmp3.yzw;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.8 + 0.2;
                tmp0.x = tmp3.x * tmp0.x;
                tmp0.y = tmp3.x * 2.0 + -1.0;
                tmp0.y = 1.0 - abs(tmp0.y);
                tmp0.y = tmp0.y * tmp0.w;
                tmp1.xyz = tmp0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.x = tmp0.y * 0.175 + tmp0.x;
                tmp0.yzw = tmp0.yyy * float3(0.35, 0.35, 0.35) + tmp1.xyz;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0103093, 0.0103093, 0.0103093);
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.02);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp1.w = tmp0.w * 0.0039216;
                tmp1.xyz = tmp0.xyz / tmp1.www;
                tmp0.xyz = min(unity_MaxOutputValue.xxx, float3(1.0, 1.0, 1.0));
                tmp0.w = 1.0;
                tmp0 = unity_MetaFragmentControl ? tmp0 : float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target = unity_MetaFragmentControl ? tmp1 : tmp0;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		LOD 300
		Tags { "QUEUE" = "Transparent-10" }
		GrabPass {
		}
		Pass {
			Name "FORWARD"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-10" "SHADOWSUPPORT" = "true" }
			ZClip Off
			ZWrite Off
			GpuProgramID 240013
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
				float4 texcoord5 : TEXCOORD5;
				float3 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
				float4 texcoord9 : TEXCOORD9;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color0;
			float4 _Color1;
			float4 _Specular;
			float _Tiling;
			float _ReflectionTint;
			float4 _InvRanges;
			float4 _GrabTexture_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			samplerCUBE _Cube;
			sampler2D _GrabTexture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp2;
                o.texcoord.w = tmp0.x;
                tmp3.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp4.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp4.xyz;
                tmp4.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp4.xyz;
                tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                tmp5.xyz = tmp3.xyz * tmp4.xyz;
                tmp5.xyz = tmp3.zxy * tmp4.yzx + -tmp5.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp5.xyz = tmp0.xxx * tmp5.xyz;
                o.texcoord.y = tmp5.x;
                o.texcoord.x = tmp4.z;
                o.texcoord.z = tmp3.y;
                o.texcoord1.x = tmp4.x;
                o.texcoord2.x = tmp4.y;
                o.texcoord1.z = tmp3.z;
                o.texcoord2.z = tmp3.x;
                o.texcoord1.w = tmp0.y;
                o.texcoord2.w = tmp0.z;
                o.texcoord1.y = tmp5.y;
                o.texcoord2.y = tmp5.z;
                o.texcoord3 = tmp2;
                tmp0.x = tmp1.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp1.x + tmp0.x;
                tmp0.x = unity_MatrixV._m22 * tmp1.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp1.w + tmp0.x;
                tmp0.z = -tmp0.x;
                tmp1.x = tmp2.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp2.xw * float2(0.5, 0.5);
                tmp0.xy = tmp1.zz + tmp1.xw;
                tmp0.w = tmp2.w;
                tmp1.x = tmp0.w - tmp2.y;
                o.texcoord5.y = tmp1.x * 0.5;
                o.texcoord4 = tmp0;
                o.texcoord5.xzw = tmp0.xzw;
                o.texcoord6.xyz = float3(0.0, 0.0, 0.0);
                o.texcoord7.xy = float2(0.0, 0.0);
                o.texcoord9 = float4(0.0, 0.0, 0.0, 0.0);
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
                float4 tmp7;
                tmp0.y = inp.texcoord.w;
                tmp0.z = inp.texcoord1.w;
                tmp0.w = inp.texcoord2.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.yzw;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xyz = tmp0.yzw - _WorldSpaceCameraPos;
                tmp3.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp3 = tex2D(_CameraDepthTexture, tmp3.xy);
                tmp0.x = _ZBufferParams.z * tmp3.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - inp.texcoord4.z;
                tmp1.w = _Time.x * 0.5;
                tmp3.xy = tmp0.yw * _Tiling.xx;
                tmp4.xy = tmp0.yw * _Tiling.xx + tmp1.ww;
                tmp4 = tex2D(_WaterTex, tmp4.xy);
                tmp3.z = -tmp3.y;
                tmp3.xy = -_Time.xx * float2(0.5, 0.5) + tmp3.zx;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp3 = tmp3 + tmp4;
                tmp1.w = tmp3.w * 0.5;
                tmp3.xyz = tmp3.xyz - float3(1.0, 1.0, 1.0);
                tmp4.xyz = saturate(tmp0.xxx * _InvRanges.xyz);
                tmp0.x = 1.0 - tmp4.y;
                tmp2.w = tmp0.x * tmp0.x;
                tmp2.w = tmp2.w * tmp0.x + -tmp0.x;
                tmp0.x = tmp2.w * 0.5 + tmp0.x;
                tmp5.xyz = _Color0.xyz - _Color1.xyz;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + _Color1.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp6.xyz = tmp2.www * tmp2.xyz;
                tmp3.w = -tmp3.y;
                tmp2.w = dot(-tmp6.xyz, tmp3.xyz);
                tmp2.w = 1.0 - tmp2.w;
                tmp2.w = sqrt(tmp2.w);
                tmp4.y = dot(tmp2.xyz, tmp3.xyz);
                tmp4.y = tmp4.y + tmp4.y;
                tmp2.xyz = tmp3.xzw * -tmp4.yyy + tmp2.xyz;
                tmp6 = texCUBE(_Cube, tmp2.xyz);
                tmp2.xy = tmp3.xy * _GrabTexture_TexelSize.xy;
                tmp2.z = inp.texcoord5.z * 20.0;
                tmp2.z = tmp4.x * tmp2.z;
                tmp2.xy = tmp2.xy * tmp2.zz + inp.texcoord5.xy;
                tmp2.xy = tmp2.xy / inp.texcoord5.ww;
                tmp7 = tex2D(_GrabTexture, tmp2.xy);
                tmp2.xyz = tmp7.xyz * tmp5.xyz + -tmp7.xyz;
                tmp2.xyz = tmp4.zzz * tmp2.xyz + tmp7.xyz;
                tmp4.yzw = tmp5.xyz * tmp2.xyz + -tmp5.xyz;
                tmp4.yzw = tmp0.xxx * tmp4.yzw + tmp5.xyz;
                tmp2.xyz = tmp2.xyz - tmp4.yzw;
                tmp2.xyz = tmp0.xxx * tmp2.xyz + tmp4.yzw;
                tmp0.x = tmp4.x * 2.0 + -1.0;
                tmp0.x = 1.0 - abs(tmp0.x);
                tmp0.x = tmp0.x * tmp1.w;
                tmp1.w = tmp2.w * tmp2.w;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = tmp1.w * 0.8 + 0.2;
                tmp1.w = tmp4.x * tmp1.w;
                tmp4.yzw = tmp6.xyz * _ReflectionTint.xxx + -tmp2.xyz;
                tmp2.xyz = tmp1.www * tmp4.yzw + tmp2.xyz;
                tmp2.xyz = tmp0.xxx * float3(0.35, 0.35, 0.35) + tmp2.xyz;
                tmp0.x = tmp0.x * 0.175 + tmp1.w;
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.w = 1.0 - tmp0.x;
                tmp4.yzw = tmp0.xxx * tmp2.xyz;
                tmp0.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.x) {
                    tmp0.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord1.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord.www + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.www + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp0.xyz = tmp0.xxx ? tmp5.xyz : tmp0.yzw;
                    tmp0.xyz = tmp0.xyz - unity_ProbeVolumeMin;
                    tmp0.yzw = tmp0.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.y = tmp0.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp0.x = max(tmp0.y, tmp2.w);
                    tmp0 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp0.xzw);
                } else {
                    tmp0 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.x = saturate(dot(tmp0, unity_OcclusionMaskSelector));
                tmp5.x = dot(inp.texcoord.xyz, tmp3.xyz);
                tmp5.y = dot(inp.texcoord1.xyz, tmp3.xyz);
                tmp5.z = dot(inp.texcoord2.xyz, tmp3.xyz);
                tmp0.y = dot(tmp5.xyz, tmp5.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp5.xyz;
                tmp2.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp3.xyz, tmp0.xyz);
                tmp3.w = tmp2.w + tmp2.w;
                tmp0.yzw = tmp0.yzw * -tmp3.www + tmp3.xyz;
                tmp0.y = saturate(dot(-tmp1.xyz, tmp0.xyz));
                tmp0.z = max(tmp2.w, 0.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 256.0;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp4.x * tmp0.y;
                tmp1.xyz = tmp0.yyy * _Specular.xyz;
                tmp0.yzw = tmp4.yzw * tmp0.zzz + tmp1.xyz;
                tmp0.yzw = tmp0.yzw * _LightColor0.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp4.yzw * inp.texcoord6.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp2.xyz * tmp1.www + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			LOD 300
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent-10" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			GpuProgramID 266086
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float4 texcoord6 : TEXCOORD6;
				float2 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float4 _Specular;
			float _Tiling;
			float4 _InvRanges;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			sampler2D _LightTexture0;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * tmp3.xyz;
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx + -tmp4.xyz;
                tmp2.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp2.www * tmp4.xyz;
                o.texcoord.y = tmp4.x;
                o.texcoord.x = tmp3.z;
                o.texcoord.z = tmp2.y;
                o.texcoord1.x = tmp3.x;
                o.texcoord2.x = tmp3.y;
                o.texcoord1.z = tmp2.z;
                o.texcoord2.z = tmp2.x;
                o.texcoord1.y = tmp4.y;
                o.texcoord2.y = tmp4.z;
                o.texcoord4 = tmp0;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                tmp1.z = -tmp0.z;
                tmp0.z = tmp0.y * _ProjectionParams.x;
                tmp2.xzw = tmp0.xwz * float3(0.5, 0.5, 0.5);
                tmp1.xy = tmp2.zz + tmp2.xw;
                tmp1.w = tmp0.w;
                tmp0.x = tmp1.w - tmp0.y;
                o.texcoord6.y = tmp0.x * 0.5;
                o.texcoord5 = tmp1;
                o.texcoord6.xzw = tmp1.xzw;
                o.texcoord7.xy = float2(0.0, 0.0);
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
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord3.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp0.w = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - inp.texcoord5.z;
                tmp1.w = _Time.x * 0.5;
                tmp2.xy = inp.texcoord3.xz * _Tiling.xx;
                tmp3.xy = inp.texcoord3.xz * _Tiling.xx + tmp1.ww;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp2.z = -tmp2.y;
                tmp2.xy = -_Time.xx * float2(0.5, 0.5) + tmp2.zx;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = saturate(tmp0.w * _InvRanges.x);
                tmp3.xyz = inp.texcoord3.yyy * unity_WorldToLight._m01_m11_m21;
                tmp3.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord3.xxx + tmp3.xyz;
                tmp3.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord3.zzz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToLight._m03_m13_m23;
                tmp1.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.w) {
                    tmp1.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.xyz = inp.texcoord3.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord3.xxx + tmp4.xyz;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp4.xyz;
                    tmp4.xyz = tmp4.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp4.xyz = tmp1.www ? tmp4.xyz : inp.texcoord3.xyz;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.w = tmp4.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp1.w, tmp2.w);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.w = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3 = tex2D(_LightTexture0, tmp2.ww);
                tmp4.x = dot(inp.texcoord.xyz, tmp2.xyz);
                tmp4.y = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp4.z = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp2.x = dot(tmp4.xyz, tmp4.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * tmp4.xyz;
                tmp2.w = dot(tmp0.xyz, tmp2.xyz);
                tmp3.y = tmp2.w + tmp2.w;
                tmp0.xyz = tmp2.xyz * -tmp3.yyy + tmp0.xyz;
                tmp0.x = saturate(dot(-tmp1.xyz, tmp0.xyz));
                tmp0.y = max(tmp2.w, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 256.0;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xyz = _Specular.xyz * tmp0.xxx + tmp0.yyy;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                tmp0.w = dot(tmp3.xy, tmp1.xy);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 300
			Tags { "LIGHTMODE" = "META" "QUEUE" = "Transparent-10" }
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 332382
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
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color0;
			float4 _Color1;
			float _Tiling;
			float _ReflectionTint;
			float4 _InvRanges;
			float4 _GrabTexture_TexelSize;
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
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
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			samplerCUBE _Cube;
			sampler2D _GrabTexture;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
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
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp1.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx + -tmp2.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord.y = tmp2.x;
                o.texcoord.x = tmp1.z;
                o.texcoord.z = tmp0.y;
                tmp3 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp3;
                tmp3 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp3.xyz;
                tmp3 = tmp3 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord.w = tmp4.x;
                o.texcoord1.x = tmp1.x;
                o.texcoord2.x = tmp1.y;
                o.texcoord1.z = tmp0.z;
                o.texcoord2.z = tmp0.x;
                o.texcoord1.w = tmp4.y;
                o.texcoord2.w = tmp4.z;
                o.texcoord1.y = tmp2.y;
                o.texcoord2.y = tmp2.z;
                tmp0 = tmp3.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp3.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp3.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp3.wwww + tmp0;
                o.texcoord3 = tmp0;
                tmp0.z = tmp3.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp3.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp3.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp3.w + tmp0.z;
                tmp1.z = -tmp0.z;
                tmp0.z = tmp0.y * _ProjectionParams.x;
                tmp2.xzw = tmp0.xwz * float3(0.5, 0.5, 0.5);
                tmp1.xy = tmp2.zz + tmp2.xw;
                tmp1.w = tmp0.w;
                tmp0.x = tmp1.w - tmp0.y;
                o.texcoord5.y = tmp0.x * 0.5;
                o.texcoord4 = tmp1;
                o.texcoord5.xzw = tmp1.xzw;
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
                tmp0.x = inp.texcoord5.z * 20.0;
                tmp0.yz = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp0.y = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.y = tmp0.y - inp.texcoord4.z;
                tmp0.yzw = saturate(tmp0.yyy * _InvRanges.xyz);
                tmp0.x = tmp0.y * tmp0.x;
                tmp1.x = inp.texcoord.w;
                tmp1.z = inp.texcoord2.w;
                tmp2.xy = tmp1.xz * _Tiling.xx;
                tmp2.z = -tmp2.y;
                tmp2.xy = -_Time.xx * float2(0.5, 0.5) + tmp2.zx;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp1.w = _Time.x * 0.5;
                tmp3.xy = tmp1.xz * _Tiling.xx + tmp1.ww;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp2 = tmp2 + tmp3;
                tmp3.xyz = tmp2.xyz - float3(1.0, 1.0, 1.0);
                tmp1.w = tmp2.w * 0.5;
                tmp2.xy = tmp3.xy * _GrabTexture_TexelSize.xy;
                tmp2.xy = tmp2.xy * tmp0.xx + inp.texcoord5.xy;
                tmp2.xy = tmp2.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_GrabTexture, tmp2.xy);
                tmp0.x = 1.0 - tmp0.z;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.z = tmp0.z * tmp0.x + -tmp0.x;
                tmp0.x = tmp0.z * 0.5 + tmp0.x;
                tmp4.xyz = _Color0.xyz - _Color1.xyz;
                tmp4.xyz = tmp0.xxx * tmp4.xyz + _Color1.xyz;
                tmp5.xyz = tmp2.xyz * tmp4.xyz + -tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp5.xyz + tmp2.xyz;
                tmp5.xyz = tmp4.xyz * tmp2.xyz + -tmp4.xyz;
                tmp4.xyz = tmp0.xxx * tmp5.xyz + tmp4.xyz;
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp0.xzw = tmp0.xxx * tmp2.xyz + tmp4.xyz;
                tmp1.y = inp.texcoord1.w;
                tmp1.xyz = tmp1.xyz - _WorldSpaceCameraPos;
                tmp3.w = -tmp3.y;
                tmp2.x = dot(tmp1.xyz, tmp3.xyz);
                tmp2.x = tmp2.x + tmp2.x;
                tmp2.xyz = tmp3.xzw * -tmp2.xxx + tmp1.xyz;
                tmp2 = texCUBE(_Cube, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * _ReflectionTint.xxx + -tmp0.xzw;
                tmp2.w = dot(tmp1.xyz, tmp1.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp1.xyz = tmp1.xyz * tmp2.www;
                tmp1.x = dot(-tmp1.xyz, tmp3.xyz);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = sqrt(tmp1.x);
                tmp1.y = tmp1.x * tmp1.x;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.x = tmp1.x * 0.8 + 0.2;
                tmp1.x = tmp0.y * tmp1.x;
                tmp0.y = tmp0.y * 2.0 + -1.0;
                tmp0.y = 1.0 - abs(tmp0.y);
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.xzw = tmp1.xxx * tmp2.xyz + tmp0.xzw;
                tmp1.x = tmp0.y * 0.175 + tmp1.x;
                tmp0.xyz = tmp0.yyy * float3(0.35, 0.35, 0.35) + tmp0.xzw;
                tmp0.w = min(tmp1.x, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0103093, 0.0103093, 0.0103093);
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.02);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp1.w = tmp0.w * 0.0039216;
                tmp1.xyz = tmp0.xyz / tmp1.www;
                tmp0.xyz = min(unity_MaxOutputValue.xxx, float3(1.0, 1.0, 1.0));
                tmp0.w = 1.0;
                tmp0 = unity_MetaFragmentControl ? tmp0 : float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target = unity_MetaFragmentControl ? tmp1 : tmp0;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		LOD 200
		Tags { "QUEUE" = "Transparent-10" }
		Pass {
			Name "FORWARD"
			LOD 200
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-10" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			GpuProgramID 415373
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
				float3 texcoord5 : TEXCOORD5;
				float2 texcoord6 : TEXCOORD6;
				float4 texcoord8 : TEXCOORD8;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color0;
			float4 _Color1;
			float4 _Specular;
			float _Tiling;
			float _ReflectionTint;
			float4 _InvRanges;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			samplerCUBE _Cube;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp2;
                o.texcoord.w = tmp0.x;
                tmp3.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp4.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp4.xyz;
                tmp4.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp4.xyz;
                tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                tmp5.xyz = tmp3.xyz * tmp4.xyz;
                tmp5.xyz = tmp3.zxy * tmp4.yzx + -tmp5.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp5.xyz = tmp0.xxx * tmp5.xyz;
                o.texcoord.y = tmp5.x;
                o.texcoord.x = tmp4.z;
                o.texcoord.z = tmp3.y;
                o.texcoord1.x = tmp4.x;
                o.texcoord2.x = tmp4.y;
                o.texcoord1.z = tmp3.z;
                o.texcoord2.z = tmp3.x;
                o.texcoord1.w = tmp0.y;
                o.texcoord2.w = tmp0.z;
                o.texcoord1.y = tmp5.y;
                o.texcoord2.y = tmp5.z;
                o.texcoord3 = tmp2;
                tmp0.x = tmp1.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp1.x + tmp0.x;
                tmp0.x = unity_MatrixV._m22 * tmp1.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp1.w + tmp0.x;
                o.texcoord4.z = -tmp0.x;
                tmp0.x = tmp2.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp2.xw * float2(0.5, 0.5);
                o.texcoord4.w = tmp2.w;
                o.texcoord4.xy = tmp0.zz + tmp0.xw;
                o.texcoord5.xyz = float3(0.0, 0.0, 0.0);
                o.texcoord6.xy = float2(0.0, 0.0);
                o.texcoord8 = float4(0.0, 0.0, 0.0, 0.0);
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
                float4 tmp7;
                tmp0.y = inp.texcoord.w;
                tmp0.z = inp.texcoord1.w;
                tmp0.w = inp.texcoord2.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.yzw;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp0.x = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - inp.texcoord4.z;
                tmp1.w = _Time.x * 0.5;
                tmp2.xy = tmp0.yw * _Tiling.xx;
                tmp3.xy = tmp0.yw * _Tiling.xx + tmp1.ww;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp2.z = -tmp2.y;
                tmp2.xy = -_Time.xx * float2(0.5, 0.5) + tmp2.zx;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp2 = tmp2 + tmp3;
                tmp3.xyz = tmp2.xyz - float3(1.0, 1.0, 1.0);
                tmp2.xyz = saturate(tmp0.xxx * _InvRanges.xyz);
                tmp4.xy = float2(1.0, 1.0) - tmp2.yx;
                tmp0.x = tmp4.x * tmp4.x;
                tmp0.x = tmp0.x * tmp4.x + -tmp4.x;
                tmp0.x = tmp0.x * 0.5 + tmp4.x;
                tmp4.xzw = _Color0.xyz - _Color1.xyz;
                tmp4.xzw = tmp0.xxx * tmp4.xzw + _Color1.xyz;
                tmp5.xyz = tmp0.yzw - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp5.xyz, tmp5.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp6.xyz = tmp1.www * tmp5.xyz;
                tmp3.w = -tmp3.y;
                tmp1.w = dot(-tmp6.xyz, tmp3.xyz);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = sqrt(tmp1.w);
                tmp2.y = dot(tmp5.xyz, tmp3.xyz);
                tmp2.y = tmp2.y + tmp2.y;
                tmp5.xyz = tmp3.xzw * -tmp2.yyy + tmp5.xyz;
                tmp5 = texCUBE(_Cube, tmp5.xyz);
                tmp6.xyz = tmp4.xzw * tmp4.xzw + -tmp4.xzw;
                tmp6.xyz = tmp2.zzz * tmp6.xyz + tmp4.xzw;
                tmp7.xyz = tmp4.xzw * tmp6.xyz + -tmp4.xzw;
                tmp4.xzw = tmp0.xxx * tmp7.xyz + tmp4.xzw;
                tmp6.xyz = tmp6.xyz - tmp4.xzw;
                tmp4.xzw = tmp0.xxx * tmp6.xyz + tmp4.xzw;
                tmp0.x = tmp2.x * 2.0 + -1.0;
                tmp0.x = 1.0 - abs(tmp0.x);
                tmp2.y = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.y;
                tmp1.w = tmp1.w * tmp2.x;
                tmp1.w = tmp1.w * 0.8;
                tmp5.xyz = tmp5.xyz * _ReflectionTint.xxx + -tmp4.xzw;
                tmp4.xzw = tmp1.www * tmp5.xyz + tmp4.xzw;
                tmp2.y = tmp2.w * 0.5;
                tmp2.z = tmp2.w * 0.25 + 0.5;
                tmp4.xzw = tmp4.xzw - tmp2.zzz;
                tmp4.xzw = tmp2.xxx * tmp4.xzw + tmp2.zzz;
                tmp2.yzw = tmp2.yyy * tmp4.yyy + tmp4.xzw;
                tmp0.x = tmp0.x * 0.5 + tmp1.w;
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.w = 1.0 - tmp0.x;
                tmp4.xyz = tmp0.xxx * tmp2.yzw;
                tmp0.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.x) {
                    tmp0.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord1.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord.www + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.www + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp0.xyz = tmp0.xxx ? tmp5.xyz : tmp0.yzw;
                    tmp0.xyz = tmp0.xyz - unity_ProbeVolumeMin;
                    tmp0.yzw = tmp0.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.y = tmp0.y * 0.25 + 0.75;
                    tmp3.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp0.x = max(tmp0.y, tmp3.w);
                    tmp0 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp0.xzw);
                } else {
                    tmp0 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.x = saturate(dot(tmp0, unity_OcclusionMaskSelector));
                tmp5.x = dot(inp.texcoord.xyz, tmp3.xyz);
                tmp5.y = dot(inp.texcoord1.xyz, tmp3.xyz);
                tmp5.z = dot(inp.texcoord2.xyz, tmp3.xyz);
                tmp0.y = dot(tmp5.xyz, tmp5.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp5.xyz;
                tmp3.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp3.xyz = tmp3.xxx * _WorldSpaceLightPos0.xyz;
                tmp3.w = dot(tmp3.xyz, tmp0.xyz);
                tmp4.w = tmp3.w + tmp3.w;
                tmp0.yzw = tmp0.yzw * -tmp4.www + tmp3.xyz;
                tmp0.y = saturate(dot(-tmp1.xyz, tmp0.xyz));
                tmp0.z = max(tmp3.w, 0.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 256.0;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp2.x * tmp0.y;
                tmp1.xyz = tmp0.yyy * _Specular.xyz;
                tmp0.yzw = tmp4.xyz * tmp0.zzz + tmp1.xyz;
                tmp0.yzw = tmp0.yzw * _LightColor0.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp4.xyz * inp.texcoord5.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp2.yzw * tmp1.www + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			LOD 200
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent-10" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			GpuProgramID 496958
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float2 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float4 _Specular;
			float _Tiling;
			float4 _InvRanges;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			sampler2D _LightTexture0;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * tmp3.xyz;
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx + -tmp4.xyz;
                tmp2.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp2.www * tmp4.xyz;
                o.texcoord.y = tmp4.x;
                o.texcoord.x = tmp3.z;
                o.texcoord.z = tmp2.y;
                o.texcoord1.x = tmp3.x;
                o.texcoord2.x = tmp3.y;
                o.texcoord1.z = tmp2.z;
                o.texcoord2.z = tmp2.x;
                o.texcoord1.y = tmp4.y;
                o.texcoord2.y = tmp4.z;
                o.texcoord4 = tmp0;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord5.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.w = tmp0.w;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6.xy = float2(0.0, 0.0);
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
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord3.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp0.w = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - inp.texcoord5.z;
                tmp1.w = _Time.x * 0.5;
                tmp2.xy = inp.texcoord3.xz * _Tiling.xx;
                tmp3.xy = inp.texcoord3.xz * _Tiling.xx + tmp1.ww;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp2.z = -tmp2.y;
                tmp2.xy = -_Time.xx * float2(0.5, 0.5) + tmp2.zx;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = saturate(tmp0.w * _InvRanges.x);
                tmp3.xyz = inp.texcoord3.yyy * unity_WorldToLight._m01_m11_m21;
                tmp3.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord3.xxx + tmp3.xyz;
                tmp3.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord3.zzz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToLight._m03_m13_m23;
                tmp1.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.w) {
                    tmp1.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.xyz = inp.texcoord3.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord3.xxx + tmp4.xyz;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp4.xyz;
                    tmp4.xyz = tmp4.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp4.xyz = tmp1.www ? tmp4.xyz : inp.texcoord3.xyz;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.w = tmp4.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp1.w, tmp2.w);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.w = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3 = tex2D(_LightTexture0, tmp2.ww);
                tmp4.x = dot(inp.texcoord.xyz, tmp2.xyz);
                tmp4.y = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp4.z = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp2.x = dot(tmp4.xyz, tmp4.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * tmp4.xyz;
                tmp2.w = dot(tmp0.xyz, tmp2.xyz);
                tmp3.y = tmp2.w + tmp2.w;
                tmp0.xyz = tmp2.xyz * -tmp3.yyy + tmp0.xyz;
                tmp0.x = saturate(dot(-tmp1.xyz, tmp0.xyz));
                tmp0.y = max(tmp2.w, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 256.0;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xyz = _Specular.xyz * tmp0.xxx + tmp0.yyy;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                tmp0.w = dot(tmp3.xy, tmp1.xy);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 200
			Tags { "LIGHTMODE" = "META" "QUEUE" = "Transparent-10" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 577747
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color0;
			float4 _Color1;
			float _Tiling;
			float _ReflectionTint;
			float4 _InvRanges;
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
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
			sampler2D _CameraDepthTexture;
			sampler2D _WaterTex;
			samplerCUBE _Cube;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
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
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp1.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx + -tmp2.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord.y = tmp2.x;
                o.texcoord.x = tmp1.z;
                o.texcoord.z = tmp0.y;
                tmp3 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp3;
                tmp3 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp3.xyz;
                tmp3 = tmp3 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord.w = tmp4.x;
                o.texcoord1.x = tmp1.x;
                o.texcoord2.x = tmp1.y;
                o.texcoord1.z = tmp0.z;
                o.texcoord2.z = tmp0.x;
                o.texcoord1.w = tmp4.y;
                o.texcoord2.w = tmp4.z;
                o.texcoord1.y = tmp2.y;
                o.texcoord2.y = tmp2.z;
                tmp0 = tmp3.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp3.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp3.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp3.wwww + tmp0;
                o.texcoord3 = tmp0;
                tmp0.z = tmp3.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp3.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp3.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp3.w + tmp0.z;
                o.texcoord4.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord4.w = tmp0.w;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
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
                tmp0.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp0 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - inp.texcoord4.z;
                tmp0.xyz = saturate(tmp0.xxx * _InvRanges.xyz);
                tmp1.xyz = _Color0.xyz - _Color1.xyz;
                tmp0.yw = float2(1.0, 1.0) - tmp0.yx;
                tmp1.w = tmp0.y * tmp0.y;
                tmp1.w = tmp1.w * tmp0.y + -tmp0.y;
                tmp0.y = tmp1.w * 0.5 + tmp0.y;
                tmp1.xyz = tmp0.yyy * tmp1.xyz + _Color1.xyz;
                tmp2.xyz = tmp1.xyz * tmp1.xyz + -tmp1.xyz;
                tmp2.xyz = tmp0.zzz * tmp2.xyz + tmp1.xyz;
                tmp3.xyz = tmp1.xyz * tmp2.xyz + -tmp1.xyz;
                tmp1.xyz = tmp0.yyy * tmp3.xyz + tmp1.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp1.xyz = tmp0.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.x = inp.texcoord.w;
                tmp2.z = inp.texcoord2.w;
                tmp3.xy = tmp2.xz * _Tiling.xx;
                tmp3.z = -tmp3.y;
                tmp0.yz = -_Time.xx * float2(0.5, 0.5) + tmp3.zx;
                tmp3 = tex2D(_WaterTex, tmp0.yz);
                tmp0.y = _Time.x * 0.5;
                tmp0.yz = tmp2.xz * _Tiling.xx + tmp0.yy;
                tmp4 = tex2D(_WaterTex, tmp0.yz);
                tmp3 = tmp3 + tmp4;
                tmp4.xyz = tmp3.xyz - float3(1.0, 1.0, 1.0);
                tmp4.w = -tmp4.y;
                tmp2.y = inp.texcoord1.w;
                tmp2.xyz = tmp2.xyz - _WorldSpaceCameraPos;
                tmp0.y = dot(tmp2.xyz, tmp4.xyz);
                tmp0.y = tmp0.y + tmp0.y;
                tmp3.xyz = tmp4.xzw * -tmp0.yyy + tmp2.xyz;
                tmp5 = texCUBE(_Cube, tmp3.xyz);
                tmp3.xyz = tmp5.xyz * _ReflectionTint.xxx + -tmp1.xyz;
                tmp0.y = dot(tmp2.xyz, tmp2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp2.xyz = tmp0.yyy * tmp2.xyz;
                tmp0.y = dot(-tmp2.xyz, tmp4.xyz);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = tmp0.y * tmp0.x;
                tmp0.y = tmp0.y * 0.8;
                tmp1.xyz = tmp0.yyy * tmp3.xyz + tmp1.xyz;
                tmp0.z = tmp3.w * 0.25 + 0.5;
                tmp1.w = tmp3.w * 0.5;
                tmp1.xyz = tmp1.xyz - tmp0.zzz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + tmp0.zzz;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = 1.0 - abs(tmp0.x);
                tmp0.x = tmp0.x * 0.5 + tmp0.y;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yzw = tmp1.www * tmp0.www + tmp1.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0103093, 0.0103093, 0.0103093);
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.02);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp1.w = tmp0.w * 0.0039216;
                tmp1.xyz = tmp0.xyz / tmp1.www;
                tmp0.xyz = min(unity_MaxOutputValue.xxx, float3(1.0, 1.0, 1.0));
                tmp0.w = 1.0;
                tmp0 = unity_MetaFragmentControl ? tmp0 : float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target = unity_MetaFragmentControl ? tmp1 : tmp0;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		LOD 100
		Tags { "QUEUE" = "Transparent-10" }
		Pass {
			Name "FORWARD"
			LOD 100
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-10" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			GpuProgramID 649184
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
				float3 texcoord4 : TEXCOORD4;
				float2 texcoord5 : TEXCOORD5;
				float4 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color0;
			float4 _Color1;
			float4 _Specular;
			float _Tiling;
			float _ReflectionTint;
			float4 _InvRanges;
			float _InvScale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DepthTex;
			sampler2D _WaterTex;
			samplerCUBE _Cube;
			
			// Keywords: DIRECTIONAL
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
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord3 = tmp1;
                o.texcoord.w = tmp0.x;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp1.xyz * tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx + -tmp3.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord.y = tmp3.x;
                o.texcoord.x = tmp2.z;
                o.texcoord.z = tmp1.y;
                o.texcoord1.x = tmp2.x;
                o.texcoord2.x = tmp2.y;
                o.texcoord1.z = tmp1.z;
                o.texcoord2.z = tmp1.x;
                o.texcoord1.w = tmp0.y;
                o.texcoord2.w = tmp0.z;
                o.texcoord1.y = tmp3.y;
                o.texcoord2.y = tmp3.z;
                o.texcoord4.xyz = float3(0.0, 0.0, 0.0);
                o.texcoord5.xy = float2(0.0, 0.0);
                o.texcoord7 = float4(0.0, 0.0, 0.0, 0.0);
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
                float4 tmp7;
                tmp0.y = inp.texcoord.w;
                tmp0.z = inp.texcoord1.w;
                tmp0.w = inp.texcoord2.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.yzw;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xy = tmp0.yw * _InvScale.xx + float2(0.5, 0.5);
                tmp2 = tex2D(_DepthTex, tmp2.xy);
                tmp0.x = tmp2.w * 8.0;
                tmp1.w = _Time.x * 0.5;
                tmp2.xy = tmp0.yw * _Tiling.xx;
                tmp3.xy = tmp0.yw * _Tiling.xx + tmp1.ww;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp2.z = -tmp2.y;
                tmp2.xy = -_Time.xx * float2(0.5, 0.5) + tmp2.zx;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp2 = tmp2 + tmp3;
                tmp3.xyz = tmp2.xyz - float3(1.0, 1.0, 1.0);
                tmp2.xyz = saturate(tmp0.xxx * _InvRanges.xyz);
                tmp4.xy = float2(1.0, 1.0) - tmp2.yx;
                tmp0.x = tmp4.x * tmp4.x;
                tmp0.x = tmp0.x * tmp4.x + -tmp4.x;
                tmp0.x = tmp0.x * 0.5 + tmp4.x;
                tmp4.xzw = _Color0.xyz - _Color1.xyz;
                tmp4.xzw = tmp0.xxx * tmp4.xzw + _Color1.xyz;
                tmp5.xyz = tmp0.yzw - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp5.xyz, tmp5.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp6.xyz = tmp1.www * tmp5.xyz;
                tmp3.w = -tmp3.y;
                tmp1.w = dot(-tmp6.xyz, tmp3.xyz);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = sqrt(tmp1.w);
                tmp2.y = dot(tmp5.xyz, tmp3.xyz);
                tmp2.y = tmp2.y + tmp2.y;
                tmp5.xyz = tmp3.xzw * -tmp2.yyy + tmp5.xyz;
                tmp5 = texCUBE(_Cube, tmp5.xyz);
                tmp6.xyz = tmp4.xzw * tmp4.xzw + -tmp4.xzw;
                tmp6.xyz = tmp2.zzz * tmp6.xyz + tmp4.xzw;
                tmp7.xyz = tmp4.xzw * tmp6.xyz + -tmp4.xzw;
                tmp4.xzw = tmp0.xxx * tmp7.xyz + tmp4.xzw;
                tmp6.xyz = tmp6.xyz - tmp4.xzw;
                tmp4.xzw = tmp0.xxx * tmp6.xyz + tmp4.xzw;
                tmp0.x = tmp2.x * 2.0 + -1.0;
                tmp0.x = 1.0 - abs(tmp0.x);
                tmp2.y = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.y;
                tmp1.w = tmp1.w * tmp2.x;
                tmp1.w = tmp1.w * 0.8;
                tmp5.xyz = tmp5.xyz * _ReflectionTint.xxx + -tmp4.xzw;
                tmp4.xzw = tmp1.www * tmp5.xyz + tmp4.xzw;
                tmp2.y = tmp2.w * 0.5;
                tmp2.z = tmp2.w * 0.25 + 0.5;
                tmp4.xzw = tmp4.xzw - tmp2.zzz;
                tmp4.xzw = tmp2.xxx * tmp4.xzw + tmp2.zzz;
                tmp2.yzw = tmp2.yyy * tmp4.yyy + tmp4.xzw;
                tmp0.x = tmp0.x * 0.5 + tmp1.w;
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.w = 1.0 - tmp0.x;
                tmp4.xyz = tmp0.xxx * tmp2.yzw;
                tmp0.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.x) {
                    tmp0.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord1.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord.www + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.www + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp0.xyz = tmp0.xxx ? tmp5.xyz : tmp0.yzw;
                    tmp0.xyz = tmp0.xyz - unity_ProbeVolumeMin;
                    tmp0.yzw = tmp0.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.y = tmp0.y * 0.25 + 0.75;
                    tmp3.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp0.x = max(tmp0.y, tmp3.w);
                    tmp0 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp0.xzw);
                } else {
                    tmp0 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.x = saturate(dot(tmp0, unity_OcclusionMaskSelector));
                tmp5.x = dot(inp.texcoord.xyz, tmp3.xyz);
                tmp5.y = dot(inp.texcoord1.xyz, tmp3.xyz);
                tmp5.z = dot(inp.texcoord2.xyz, tmp3.xyz);
                tmp0.y = dot(tmp5.xyz, tmp5.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp5.xyz;
                tmp3.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp3.xyz = tmp3.xxx * _WorldSpaceLightPos0.xyz;
                tmp3.w = dot(tmp3.xyz, tmp0.xyz);
                tmp4.w = tmp3.w + tmp3.w;
                tmp0.yzw = tmp0.yzw * -tmp4.www + tmp3.xyz;
                tmp0.y = saturate(dot(-tmp1.xyz, tmp0.xyz));
                tmp0.z = max(tmp3.w, 0.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 256.0;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp2.x * tmp0.y;
                tmp1.xyz = tmp0.yyy * _Specular.xyz;
                tmp0.yzw = tmp4.xyz * tmp0.zzz + tmp1.xyz;
                tmp0.yzw = tmp0.yzw * _LightColor0.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp4.xyz * inp.texcoord4.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp2.yzw * tmp1.www + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			LOD 100
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent-10" }
			Blend One One, One One
			ZClip Off
			ZWrite Off
			GpuProgramID 702490
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float2 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 unity_WorldToLight;
			float4 _LightColor0;
			float4 _Specular;
			float _Tiling;
			float4 _InvRanges;
			float _InvScale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DepthTex;
			sampler2D _WaterTex;
			sampler2D _LightTexture0;
			
			// Keywords: POINT
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
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord4 = tmp0;
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp1.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx + -tmp2.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord.y = tmp2.x;
                o.texcoord.x = tmp1.z;
                o.texcoord.z = tmp0.y;
                o.texcoord1.x = tmp1.x;
                o.texcoord2.x = tmp1.y;
                o.texcoord1.z = tmp0.z;
                o.texcoord2.z = tmp0.x;
                o.texcoord1.y = tmp2.y;
                o.texcoord2.y = tmp2.z;
                o.texcoord5.xy = float2(0.0, 0.0);
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
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord3.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = inp.texcoord3.xz * _InvScale.xx + float2(0.5, 0.5);
                tmp2 = tex2D(_DepthTex, tmp2.xy);
                tmp0.w = tmp2.w * 8.0;
                tmp1.w = _Time.x * 0.5;
                tmp2.xy = inp.texcoord3.xz * _Tiling.xx;
                tmp3.xy = inp.texcoord3.xz * _Tiling.xx + tmp1.ww;
                tmp3 = tex2D(_WaterTex, tmp3.xy);
                tmp2.z = -tmp2.y;
                tmp2.xy = -_Time.xx * float2(0.5, 0.5) + tmp2.zx;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = saturate(tmp0.w * _InvRanges.x);
                tmp3.xyz = inp.texcoord3.yyy * unity_WorldToLight._m01_m11_m21;
                tmp3.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord3.xxx + tmp3.xyz;
                tmp3.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord3.zzz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToLight._m03_m13_m23;
                tmp1.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.w) {
                    tmp1.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.xyz = inp.texcoord3.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord3.xxx + tmp4.xyz;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp4.xyz;
                    tmp4.xyz = tmp4.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp4.xyz = tmp1.www ? tmp4.xyz : inp.texcoord3.xyz;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.w = tmp4.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp1.w, tmp2.w);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.w = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3 = tex2D(_LightTexture0, tmp2.ww);
                tmp4.x = dot(inp.texcoord.xyz, tmp2.xyz);
                tmp4.y = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp4.z = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp2.x = dot(tmp4.xyz, tmp4.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * tmp4.xyz;
                tmp2.w = dot(tmp0.xyz, tmp2.xyz);
                tmp3.y = tmp2.w + tmp2.w;
                tmp0.xyz = tmp2.xyz * -tmp3.yyy + tmp0.xyz;
                tmp0.x = saturate(dot(-tmp1.xyz, tmp0.xyz));
                tmp0.y = max(tmp2.w, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 256.0;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xyz = _Specular.xyz * tmp0.xxx + tmp0.yyy;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                tmp0.w = dot(tmp3.xy, tmp1.xy);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "META"
			LOD 100
			Tags { "LIGHTMODE" = "META" "QUEUE" = "Transparent-10" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 754882
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color0;
			float4 _Color1;
			float _Tiling;
			float _ReflectionTint;
			float4 _InvRanges;
			float _InvScale;
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
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
			sampler2D _DepthTex;
			sampler2D _WaterTex;
			samplerCUBE _Cube;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
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
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp1.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx + -tmp2.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord.y = tmp2.x;
                o.texcoord.x = tmp1.z;
                o.texcoord.z = tmp0.y;
                tmp3 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp3;
                tmp3 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp3.xyz;
                tmp3 = tmp3 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord.w = tmp4.x;
                o.texcoord1.x = tmp1.x;
                o.texcoord2.x = tmp1.y;
                o.texcoord1.z = tmp0.z;
                o.texcoord2.z = tmp0.x;
                o.texcoord1.w = tmp4.y;
                o.texcoord2.w = tmp4.z;
                o.texcoord1.y = tmp2.y;
                o.texcoord2.y = tmp2.z;
                tmp0 = tmp3.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp3.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp3.zzzz + tmp0;
                o.texcoord3 = unity_MatrixVP._m03_m13_m23_m33 * tmp3.wwww + tmp0;
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
                tmp0.x = inp.texcoord.w;
                tmp0.z = inp.texcoord2.w;
                tmp1.xy = tmp0.xz * _Tiling.xx;
                tmp1.z = -tmp1.y;
                tmp1.xy = -_Time.xx * float2(0.5, 0.5) + tmp1.zx;
                tmp1 = tex2D(_WaterTex, tmp1.xy);
                tmp0.w = _Time.x * 0.5;
                tmp2.xy = tmp0.xz * _Tiling.xx + tmp0.ww;
                tmp2 = tex2D(_WaterTex, tmp2.xy);
                tmp1 = tmp1 + tmp2;
                tmp2.xyz = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp2.w = -tmp2.y;
                tmp0.y = inp.texcoord1.w;
                tmp1.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.xy = tmp0.xz * _InvScale.xx + float2(0.5, 0.5);
                tmp0 = tex2D(_DepthTex, tmp0.xy);
                tmp0.x = tmp0.w * 8.0;
                tmp0.xyz = saturate(tmp0.xxx * _InvRanges.xyz);
                tmp0.w = dot(tmp1.xyz, tmp2.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp3.xyz = tmp2.xzw * -tmp0.www + tmp1.xyz;
                tmp3 = texCUBE(_Cube, tmp3.xyz);
                tmp4.xyz = _Color0.xyz - _Color1.xyz;
                tmp0.yw = float2(1.0, 1.0) - tmp0.yx;
                tmp2.y = tmp0.y * tmp0.y;
                tmp2.y = tmp2.y * tmp0.y + -tmp0.y;
                tmp0.y = tmp2.y * 0.5 + tmp0.y;
                tmp4.xyz = tmp0.yyy * tmp4.xyz + _Color1.xyz;
                tmp5.xyz = tmp4.xyz * tmp4.xyz + -tmp4.xyz;
                tmp5.xyz = tmp0.zzz * tmp5.xyz + tmp4.xyz;
                tmp6.xyz = tmp4.xyz * tmp5.xyz + -tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp6.xyz + tmp4.xyz;
                tmp5.xyz = tmp5.xyz - tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp5.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz * _ReflectionTint.xxx + -tmp4.xyz;
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp1.xyz = tmp0.yyy * tmp1.xyz;
                tmp0.y = dot(-tmp1.xyz, tmp2.xyz);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = sqrt(tmp0.y);
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = tmp0.y * tmp0.x;
                tmp0.y = tmp0.y * 0.8;
                tmp1.xyz = tmp0.yyy * tmp3.xyz + tmp4.xyz;
                tmp0.z = tmp1.w * 0.25 + 0.5;
                tmp1.w = tmp1.w * 0.5;
                tmp1.xyz = tmp1.xyz - tmp0.zzz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + tmp0.zzz;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = 1.0 - abs(tmp0.x);
                tmp0.x = tmp0.x * 0.5 + tmp0.y;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yzw = tmp1.www * tmp0.www + tmp1.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0103093, 0.0103093, 0.0103093);
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.02);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp1.w = tmp0.w * 0.0039216;
                tmp1.xyz = tmp0.xyz / tmp1.www;
                tmp0.xyz = min(unity_MaxOutputValue.xxx, float3(1.0, 1.0, 1.0));
                tmp0.w = 1.0;
                tmp0 = unity_MetaFragmentControl ? tmp0 : float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target = unity_MetaFragmentControl ? tmp1 : tmp0;
                return o;
			}
			ENDCG
		}
	}
}