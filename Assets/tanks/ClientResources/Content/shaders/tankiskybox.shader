Shader "TankiOnline/Skybox 6 Sided" {
	Properties {
		_Tint ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_Exposure ("Exposure", Range(0, 8)) = 1
		_Rotation ("Rotation", Range(0, 360)) = 0
		[NoScaleOffset] _FrontTex ("Front [+Z]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _BackTex ("Back [-Z]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _LeftTex ("Left [+X]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _RightTex ("Right [-X]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _UpTex ("Up [+Y]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _DownTex ("Down [-Y]   (HDR)", 2D) = "grey" {}
	}
	SubShader {
		Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 46824
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Exposure;
			float _GLOBAL_FOG_ALPHA;
			float4 _FrontTex_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _FrontTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_FrontTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _FrontTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _FrontTex_HDR.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _FrontTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp1.xyz = tmp0.xyz * _Exposure.xxx;
                tmp0.xyz = -tmp0.xyz * _Exposure.xxx + unity_FogColor.xyz;
                o.sv_target.xyz = _GLOBAL_FOG_ALPHA.xxx * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 107570
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Exposure;
			float _GLOBAL_FOG_ALPHA;
			float4 _BackTex_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BackTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_BackTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _BackTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _BackTex_HDR.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _BackTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp1.xyz = tmp0.xyz * _Exposure.xxx;
                tmp0.xyz = -tmp0.xyz * _Exposure.xxx + unity_FogColor.xyz;
                o.sv_target.xyz = _GLOBAL_FOG_ALPHA.xxx * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 175316
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Exposure;
			float _GLOBAL_FOG_ALPHA;
			float4 _LeftTex_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LeftTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_LeftTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _LeftTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LeftTex_HDR.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _LeftTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp1.xyz = tmp0.xyz * _Exposure.xxx;
                tmp0.xyz = -tmp0.xyz * _Exposure.xxx + unity_FogColor.xyz;
                o.sv_target.xyz = _GLOBAL_FOG_ALPHA.xxx * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 232420
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Exposure;
			float _GLOBAL_FOG_ALPHA;
			float4 _RightTex_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RightTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_RightTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _RightTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _RightTex_HDR.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _RightTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp1.xyz = tmp0.xyz * _Exposure.xxx;
                tmp0.xyz = -tmp0.xyz * _Exposure.xxx + unity_FogColor.xyz;
                o.sv_target.xyz = _GLOBAL_FOG_ALPHA.xxx * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 286206
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Exposure;
			float _GLOBAL_FOG_ALPHA;
			float4 _UpTex_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _UpTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_UpTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _UpTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _UpTex_HDR.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _UpTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp1.xyz = tmp0.xyz * _Exposure.xxx;
                tmp0.xyz = -tmp0.xyz * _Exposure.xxx + unity_FogColor.xyz;
                o.sv_target.xyz = _GLOBAL_FOG_ALPHA.xxx * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZClip Off
			ZWrite Off
			Cull Off
			GpuProgramID 360854
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Exposure;
			float _GLOBAL_FOG_ALPHA;
			float4 _DownTex_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DownTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_DownTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _DownTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _DownTex_HDR.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _DownTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp1.xyz = tmp0.xyz * _Exposure.xxx;
                tmp0.xyz = -tmp0.xyz * _Exposure.xxx + unity_FogColor.xyz;
                o.sv_target.xyz = _GLOBAL_FOG_ALPHA.xxx * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
}