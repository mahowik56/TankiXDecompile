Shader "Hidden/Post FX/Motion Blur" {
	Properties {
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 40117
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _CameraMotionVectorsTexture_TexelSize;
			float _VelocityScale;
			float _RcpMaxBlurRadius;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraMotionVectorsTexture;
			sampler2D _CameraDepthTexture;
			
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _VelocityScale * 0.5;
                tmp0.xy = tmp0.xx * _CameraMotionVectorsTexture_TexelSize.zw;
                tmp1 = tex2D(_CameraMotionVectorsTexture, inp.texcoord.xy);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = tmp0.z * _RcpMaxBlurRadius;
                tmp0.z = max(tmp0.z, 1.0);
                tmp0.xy = tmp0.xy / tmp0.zz;
                tmp0.xy = tmp0.xy * _RcpMaxBlurRadius.xx + float2(1.0, 1.0);
                o.sv_target.xy = tmp0.xy * float2(0.5, 0.5);
                tmp0.x = 1.0 - unity_OrthoParams.w;
                tmp1 = tex2D(_CameraDepthTexture, inp.texcoord.xy);
                tmp0.y = tmp1.x * _ZBufferParams.x;
                tmp0.x = tmp0.x * tmp0.y + _ZBufferParams.y;
                tmp0.y = -unity_OrthoParams.w * tmp0.y + 1.0;
                o.sv_target.z = tmp0.y / tmp0.x;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 101704
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_TexelSize;
			float _MaxBlurRadius;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = _MainTex_TexelSize * float4(-0.5, -0.5, 0.5, -0.5) + inp.texcoord.xyxy;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0 = tmp0 * _MaxBlurRadius.xxxx;
                tmp1.x = dot(tmp0.xy, tmp0.xy);
                tmp1.y = dot(tmp0.xy, tmp0.xy);
                tmp1.x = tmp1.x < tmp1.y;
                tmp0.xy = tmp1.xx ? tmp0.xy : tmp0.zw;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp1 = _MainTex_TexelSize * float4(-0.5, 0.5, 0.5, 0.5) + inp.texcoord.xyxy;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.zw = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1 = tmp1 * _MaxBlurRadius.xxxx;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.z = tmp0.z < tmp0.w;
                tmp0.xy = tmp0.zz ? tmp1.zw : tmp0.xy;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.z = tmp0.z < tmp0.w;
                o.sv_target.xy = tmp0.zz ? tmp1.xy : tmp0.xy;
                o.sv_target.zw = float2(0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 165701
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = _MainTex_TexelSize * float4(-0.5, -0.5, 0.5, -0.5) + inp.texcoord.xyxy;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = dot(tmp1.xy, tmp1.xy);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z < tmp0.w;
                tmp0.xy = tmp0.zz ? tmp0.xy : tmp1.xy;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp1 = _MainTex_TexelSize * float4(-0.5, 0.5, 0.5, 0.5) + inp.texcoord.xyxy;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.z = tmp0.z < tmp0.w;
                tmp0.xy = tmp0.zz ? tmp2.xy : tmp0.xy;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.z = tmp0.z < tmp0.w;
                o.sv_target.xy = tmp0.zz ? tmp1.xy : tmp0.xy;
                o.sv_target.zw = float2(0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 233014
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_TexelSize;
			int _TileMaxLoop;
			float2 _TileMaxOffs;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
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
                tmp0.xy = _MainTex_TexelSize.xy * _TileMaxOffs + inp.texcoord.xy;
                tmp1.yz = float2(0.0, 0.0);
                tmp1.xw = _MainTex_TexelSize.xy;
                tmp0.zw = float2(0.0, 0.0);
                tmp2.x = 0.0;
                while (true) {
                    tmp2.y = i >= _TileMaxLoop;
                    if (tmp2.y) {
                        break;
                    }
                    tmp2.y = floor(i);
                    tmp2.yz = tmp1.xy * tmp2.yy + tmp0.xy;
                    tmp3.xy = tmp0.zw;
                    tmp2.w = 0.0;
                    for (int j = tmp2.w; j < _TileMaxLoop; j += 1) {
                        tmp3.z = floor(j);
                        tmp3.zw = tmp1.zw * tmp3.zz + tmp2.yz;
                        tmp4 = tex2D(_MainTex, tmp3.zw);
                        tmp3.z = dot(tmp3.xy, tmp3.xy);
                        tmp3.w = dot(tmp4.xy, tmp4.xy);
                        tmp3.z = tmp3.z < tmp3.w;
                        tmp3.xy = tmp3.zz ? tmp4.xy : tmp3.xy;
                    }
                    tmp0.zw = tmp3.xy;
                    tmp2.x = tmp2.x + 1;
                }
                o.sv_target.xy = tmp0.zw;
                o.sv_target.zw = float2(0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 316790
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
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
                tmp0 = _MainTex_TexelSize * float4(0.0, 1.0, 1.0, 1.0) + inp.texcoord.xyxy;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = dot(tmp1.xy, tmp1.xy);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z < tmp0.w;
                tmp0.xy = tmp0.zz ? tmp0.xy : tmp1.xy;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp1 = _MainTex_TexelSize * float4(1.0, 0.0, -1.0, 1.0) + inp.texcoord.xyxy;
                tmp2 = tex2D(_MainTex, tmp1.zw);
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.z = tmp0.w < tmp0.z;
                tmp0.xy = tmp0.zz ? tmp0.xy : tmp2.xy;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.zw = tmp2.xy * float2(1.01, 1.01);
                tmp2.x = dot(tmp1.xy, tmp1.xy);
                tmp0.w = tmp2.x < tmp0.w;
                tmp1.xy = tmp0.ww ? tmp1.xy : tmp1.zw;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp2 = -_MainTex_TexelSize * float4(-1.0, 1.0, 1.0, 0.0) + inp.texcoord.xyxy;
                tmp3 = tex2D(_MainTex, tmp2.zw);
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp1.z = dot(tmp3.xy, tmp3.xy);
                tmp0.w = tmp1.z < tmp0.w;
                tmp1.xy = tmp0.ww ? tmp1.xy : tmp3.xy;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.z = tmp0.w < tmp0.z;
                tmp0.xy = tmp0.zz ? tmp0.xy : tmp1.xy;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp1 = -_MainTex_TexelSize * float4(1.0, 1.0, 0.0, 1.0) + inp.texcoord.xyxy;
                tmp3 = tex2D(_MainTex, tmp1.zw);
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.z = dot(tmp3.xy, tmp3.xy);
                tmp0.w = tmp1.z < tmp0.w;
                tmp1.zw = tmp0.ww ? tmp2.xy : tmp3.xy;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp2.x = dot(tmp1.xy, tmp1.xy);
                tmp0.w = tmp2.x < tmp0.w;
                tmp1.xy = tmp0.ww ? tmp1.zw : tmp1.xy;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.z = tmp0.w < tmp0.z;
                tmp0.xy = tmp0.zz ? tmp0.xy : tmp1.xy;
                o.sv_target.xy = tmp0.xy * float2(0.990099, 0.990099);
                o.sv_target.zw = float2(0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 350698
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float2 _VelocityTex_TexelSize;
			float2 _NeighborMaxTex_TexelSize;
			float _MaxBlurRadius;
			float _LoopCount;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _VelocityTex;
			sampler2D _NeighborMaxTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
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
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xy = inp.texcoord1.xy + float2(2.0, 0.0);
                tmp1.xy = tmp1.xy * _ScreenParams.xy;
                tmp1.xy = floor(tmp1.xy);
                tmp1.x = dot(float2(0.0671106, 0.0058372), tmp1.xy);
                tmp1.x = frac(tmp1.x);
                tmp1.x = tmp1.x * 52.98292;
                tmp1.x = frac(tmp1.x);
                tmp1.x = tmp1.x * 6.283185;
                tmp1.x = sin(tmp1.x);
                tmp2.x = cos(tmp1.x);
                tmp2.y = tmp1.x;
                tmp1.xy = tmp2.xy * _NeighborMaxTex_TexelSize;
                tmp1.xy = tmp1.xy * float2(0.25, 0.25) + inp.texcoord1.xy;
                tmp1 = tex2D(_NeighborMaxTex, tmp1.xy);
                tmp1.z = dot(tmp1.xy, tmp1.xy);
                tmp1.z = sqrt(tmp1.z);
                tmp1.w = tmp1.z < 2.0;
                if (tmp1.w) {
                    o.sv_target = tmp0;
                    return o;
                }
                tmp2 = tex2Dlod(_VelocityTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xy = tmp2.xy * _MaxBlurRadius.xx;
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = sqrt(tmp1.w);
                tmp3.xy = max(tmp1.ww, float2(0.5, 1.0));
                tmp1.w = 1.0 / tmp2.z;
                tmp2.w = tmp3.x + tmp3.x;
                tmp2.w = tmp1.z < tmp2.w;
                tmp3.x = tmp1.z / tmp3.x;
                tmp2.xy = tmp2.xy * tmp3.xx;
                tmp2.xy = tmp2.ww ? tmp2.xy : tmp1.xy;
                tmp2.w = tmp1.z * 0.5;
                tmp2.w = min(tmp2.w, _LoopCount);
                tmp2.w = floor(tmp2.w);
                tmp3.x = 1.0 / tmp2.w;
                tmp3.zw = inp.texcoord.xy * _ScreenParams.xy;
                tmp3.zw = floor(tmp3.zw);
                tmp3.z = dot(float2(0.0671106, 0.0058372), tmp3.xy);
                tmp3.z = frac(tmp3.z);
                tmp3.zw = tmp3.zx * float2(52.98292, 0.25);
                tmp3.z = frac(tmp3.z);
                tmp3.z = tmp3.z - 0.5;
                tmp4.x = -tmp3.x * 0.5 + 1.0;
                tmp5.w = 1.0;
                tmp6 = float4(0.0, 0.0, 0.0, 0.0);
                tmp4.y = tmp4.x;
                tmp4.z = 0.0;
                tmp4.w = tmp3.y;
                for (float i = tmp3.w; i < tmp4.y; i += 1) {
                    tmp7.xy = tmp4.zz * float2(0.25, 0.5);
                    tmp7.xy = frac(tmp7.xy);
                    tmp7.xy = tmp7.xy > float2(0.499, 0.499);
                    tmp7.xz = tmp7.xx ? tmp2.xy : tmp1.xy;
                    tmp7.w = tmp7.y ? -tmp4.y : tmp4.y;
                    tmp7.w = tmp3.z * tmp3.x + tmp7.w;
                    tmp7.xz = tmp7.ww * tmp7.xz;
                    tmp8.xy = tmp7.xz * _MainTex_TexelSize.xy + inp.texcoord.xy;
                    tmp7.xz = tmp7.xz * _VelocityTex_TexelSize + inp.texcoord1.xy;
                    tmp8 = tex2Dlod(_MainTex, float4(tmp8.xy, 0, 0.0));
                    tmp9 = tex2Dlod(_VelocityTex, float4(tmp7.xz, 0, 0.0));
                    tmp7.xz = tmp9.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                    tmp7.xz = tmp7.xz * _MaxBlurRadius.xx;
                    tmp8.w = tmp2.z - tmp9.z;
                    tmp8.w = tmp1.w * tmp8.w;
                    tmp8.w = saturate(tmp8.w * 20.0);
                    tmp7.x = dot(tmp7.xy, tmp7.xy);
                    tmp7.x = sqrt(tmp7.x);
                    tmp7.x = tmp7.x - tmp4.w;
                    tmp7.x = tmp8.w * tmp7.x + tmp4.w;
                    tmp7.z = saturate(-tmp1.z * abs(tmp7.w) + tmp7.x);
                    tmp7.z = tmp7.z / tmp7.x;
                    tmp7.w = 1.2 - tmp4.y;
                    tmp7.z = tmp7.w * tmp7.z;
                    tmp5.xyz = tmp8.xyz;
                    tmp6 = tmp5 * tmp7.zzzz + tmp6;
                    tmp4.w = max(tmp4.w, tmp7.x);
                    tmp5.x = tmp4.y - tmp3.x;
                    tmp4.y = tmp7.y ? tmp5.x : tmp4.y;
                }
                tmp1.x = dot(tmp4.xy, tmp2.xy);
                tmp1.x = 1.2 / tmp1.x;
                tmp2.xyz = tmp0.xyz;
                tmp2.w = 1.0;
                tmp1 = tmp2 * tmp1.xxxx + tmp6;
                o.sv_target.xyz = tmp1.xyz / tmp1.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 408844
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
				float4 sv_target1 : SV_Target1;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                o.position = v.vertex;
                o.texcoord.xy = v.texcoord.xy * float2(1.0, -1.0) + float2(0.0, 1.0);
                o.texcoord1.xy = float2(0.0, 0.0);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = exp(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                o.sv_target = dot(float3(0.299, 0.587, 0.114), tmp0.xyz);
                tmp0.x = inp.texcoord.x * _ScreenParams.x;
                tmp0.x = tmp0.x * 0.5;
                tmp0.y = floor(tmp0.x);
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x > 0.5;
                tmp0.xzw = tmp0.xxx ? float3(0.5, -0.418688, -0.081312) : float3(-0.168736, -0.331264, 0.5);
                tmp0.y = tmp0.y * 2.0 + 1.0;
                tmp1.x = _ScreenParams.z - 1.0;
                tmp1.x = tmp0.y * tmp1.x;
                tmp1.y = inp.texcoord.y;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp1.xyz = log(tmp1.xyz);
                tmp1.xyz = tmp1.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp1.xyz = exp(tmp1.xyz);
                tmp1.xyz = tmp1.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                o.sv_target1 = tmp0.xxxx + float4(0.5, 0.5, 0.5, 0.5);
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 511937
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _History1Weight;
			float _History2Weight;
			float _History3Weight;
			float _History4Weight;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _History1LumaTex;
			sampler2D _History1ChromaTex;
			sampler2D _History2LumaTex;
			sampler2D _History2ChromaTex;
			sampler2D _History3LumaTex;
			sampler2D _History3ChromaTex;
			sampler2D _History4LumaTex;
			sampler2D _History4ChromaTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                o.sv_target.w = tmp0.w;
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = exp(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp1 = tex2D(_History1LumaTex, inp.texcoord1.xy);
                tmp0.w = inp.texcoord1.x * _MainTex_TexelSize.z;
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = floor(tmp0.w);
                tmp0.w = tmp0.w * 2.0 + 0.5;
                tmp2.z = tmp0.w * _MainTex_TexelSize.x + _MainTex_TexelSize.x;
                tmp2.x = tmp0.w * _MainTex_TexelSize.x;
                tmp2.yw = inp.texcoord1.yy;
                tmp3 = tex2D(_History1ChromaTex, tmp2.zw);
                tmp0.w = tmp3.x - 0.5;
                tmp3.xy = tmp0.ww * float2(1.402, 0.71414);
                tmp4 = tex2D(_History1ChromaTex, tmp2.xy);
                tmp0.w = tmp4.x - 0.5;
                tmp3.z = tmp0.w * -0.34414 + -tmp3.y;
                tmp3.w = tmp0.w * 1.772;
                tmp1.xyz = tmp1.xxx + tmp3.xzw;
                tmp0.xyz = tmp1.xyz * _History1Weight.xxx + tmp0.xyz;
                tmp1 = tex2D(_History2LumaTex, inp.texcoord1.xy);
                tmp3 = tex2D(_History2ChromaTex, tmp2.zw);
                tmp0.w = tmp3.x - 0.5;
                tmp3.xy = tmp0.ww * float2(1.402, 0.71414);
                tmp4 = tex2D(_History2ChromaTex, tmp2.xy);
                tmp0.w = tmp4.x - 0.5;
                tmp3.z = tmp0.w * -0.34414 + -tmp3.y;
                tmp3.w = tmp0.w * 1.772;
                tmp1.xyz = tmp1.xxx + tmp3.xzw;
                tmp0.xyz = tmp1.xyz * _History2Weight.xxx + tmp0.xyz;
                tmp1 = tex2D(_History3ChromaTex, tmp2.zw);
                tmp3 = tex2D(_History4ChromaTex, tmp2.zw);
                tmp0.w = tmp3.x - 0.5;
                tmp3.xy = tmp0.ww * float2(1.402, 0.71414);
                tmp0.w = tmp1.x - 0.5;
                tmp1.xy = tmp0.ww * float2(1.402, 0.71414);
                tmp4 = tex2D(_History3ChromaTex, tmp2.xy);
                tmp2 = tex2D(_History4ChromaTex, tmp2.xy);
                tmp0.w = tmp2.x - 0.5;
                tmp2.x = tmp4.x - 0.5;
                tmp1.z = tmp2.x * -0.34414 + -tmp1.y;
                tmp1.w = tmp2.x * 1.772;
                tmp2 = tex2D(_History3LumaTex, inp.texcoord1.xy);
                tmp1.xyz = tmp1.xzw + tmp2.xxx;
                tmp0.xyz = tmp1.xyz * _History3Weight.xxx + tmp0.xyz;
                tmp3.z = tmp0.w * -0.34414 + -tmp3.y;
                tmp3.w = tmp0.w * 1.772;
                tmp1 = tex2D(_History4LumaTex, inp.texcoord1.xy);
                tmp1.xyz = tmp3.xzw + tmp1.xxx;
                tmp0.xyz = tmp1.xyz * _History4Weight.xxx + tmp0.xyz;
                tmp0.w = _History1Weight + _History2Weight;
                tmp0.w = tmp0.w + _History3Weight;
                tmp0.w = tmp0.w + _History4Weight;
                tmp0.w = tmp0.w + 1.0;
                tmp0.xyz = tmp0.xyz / tmp0.www;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 587953
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float _History1Weight;
			float _History2Weight;
			float _History3Weight;
			float _History4Weight;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _History1LumaTex;
			sampler2D _History2LumaTex;
			sampler2D _History3LumaTex;
			sampler2D _History4LumaTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord1.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = v.texcoord.xyx;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_History1LumaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * _History1Weight.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                tmp1 = tex2D(_History2LumaTex, inp.texcoord.xy);
                tmp0.xyz = tmp1.xyz * _History2Weight.xxx + tmp0.xyz;
                tmp1 = tex2D(_History3LumaTex, inp.texcoord.xy);
                tmp0.xyz = tmp1.xyz * _History3Weight.xxx + tmp0.xyz;
                tmp1 = tex2D(_History4LumaTex, inp.texcoord.xy);
                tmp0.xyz = tmp1.xyz * _History4Weight.xxx + tmp0.xyz;
                tmp0.w = _History1Weight + _History2Weight;
                tmp0.w = tmp0.w + _History3Weight;
                tmp0.w = tmp0.w + _History4Weight;
                tmp0.w = tmp0.w + 1.0;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                return o;
			}
			ENDCG
		}
	}
}