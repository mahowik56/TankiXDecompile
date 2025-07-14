Shader "Hidden/BloomFinal" {
	Properties {
		_LensDirt ("Lens Dirt Texture", 2D) = "black" {}
		_LensStarburst ("Lens Starburst Texture", 2D) = "black" {}
		_MainTex (" ", 2D) = "black" {}
		_LensFlare (" ", 2D) = "black" {}
		_LensGlare (" ", 2D) = "black" {}
		_MipResultsRTS0 (" ", 2D) = "black" {}
		_MipResultsRTS1 (" ", 2D) = "black" {}
		_MipResultsRTS2 (" ", 2D) = "black" {}
		_MipResultsRTS3 (" ", 2D) = "black" {}
		_MipResultsRTS4 (" ", 2D) = "black" {}
		_MipResultsRTS5 (" ", 2D) = "black" {}
	}
	SubShader {
		Tags { "Mode" = "Full" }
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11263
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 125881
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 136851
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 223224
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp2.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights0.xxx;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 292548
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 335557
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 408510
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 484842
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights0.xxx;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 586923
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 650063
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 678187
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 744754
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights0.xxx;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 809950
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 891640
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 953336
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1043823
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights0.xxx;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1071466
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1120881
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1207867
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1295259
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1342807
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1415476
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1496687
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1555086
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp3 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp3.xyz;
                tmp3.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1620900
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1650430
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1727030
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1800297
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp3 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp3.xyz;
                tmp3.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1840854
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1957986
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2023132
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2097102
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp3 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp3.xyz;
                tmp3 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp3.xyz;
                tmp3.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2132242
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2206940
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2266686
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2298000
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp4 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2378061
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2452625
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2515374
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2595956
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2626051
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2692721
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2799473
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2882210
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2948418
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2957660
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3060106
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3127525
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3146354
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3262630
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3321053
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3365619
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp5 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3439292
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3506980
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3564428
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3647284
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3721684
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3785591
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3827116
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3912645
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 3943870
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4050369
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4065658
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4151355
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4243445
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4284132
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4355326
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4418168
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp6 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp6.xyz;
                tmp6.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp6.xyz;
                tmp2.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4483412
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4548780
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4648216
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4698827
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp6 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp6.xyz;
                tmp6.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp6.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4744551
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4826188
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4903892
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 4936410
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp6 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp6.xyz;
                tmp6.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp6.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5008696
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5089854
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5145580
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5223853
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp6 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp6.xyz;
                tmp6 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp6.xyz;
                tmp6.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp6.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5296689
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5372362
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights5.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5425609
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights5.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5456176
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp6 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp6.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp1.xyz = _LensDirtWeights5.xxx * tmp6.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp7 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp7.xyz;
                tmp7.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp7.xyz;
                tmp2.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights5.xxx * tmp6.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights5.xxx * tmp6.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5556919
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5572788
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights5.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5684495
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights5.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5730026
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp6 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp6.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp6.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp7 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp7.xyz;
                tmp7.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp7.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights5.xxx * tmp6.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights5.xxx * tmp6.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5780756
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5890037
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights5.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5921452
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights5.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 5980399
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp6 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp6.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp6.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp7 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp7.xyz;
                tmp7.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp7.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights5.xxx * tmp6.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights5.xxx * tmp6.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6072723
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6132630
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights5.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6174577
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights5.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Full" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6266331
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp6 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp6.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp6.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp7 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp7.xyz;
                tmp7 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp7.xyz;
                tmp7.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp7.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights5.xxx * tmp6.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights5.xxx * tmp6.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		Tags { "Mode" = "Half" }
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6318281
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6381817
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6464095
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6510950
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp2.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights0.xxx;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6561155
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6630650
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6691044
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6762725
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights0.xxx;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6867439
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6937441
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 6986329
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7030227
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights0.xxx;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7124355
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7208373
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7257446
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7276283
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _LensStarburstWeights0;
			float _LensDirtWeights0;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights0.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * _LensDirtWeights0.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights0.xxx;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7371772
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7417083
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7529288
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7572175
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7622760
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7682501
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7781483
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7819289
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp3 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp3.xyz;
                tmp3.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7925451
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 7970923
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8058779
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8062229
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp3 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp3.xyz;
                tmp3.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8152891
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8225733
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8271360
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8386618
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp3 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp3.xyz;
                tmp3 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp3.xyz;
                tmp3.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8435261
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8476265
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8559598
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8626800
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp4 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8671715
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8762536
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8838743
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8895549
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 8916326
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9005228
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9050673
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9126926
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9181973
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9292977
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9332979
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9419717
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9497518
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9558408
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9610009
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9679339
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp5 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9762100
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9783616
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9843116
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 9899860
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10006656
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10073967
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10154421
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10178799
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10267106
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10301173
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10390170
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10475111
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10504018
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10566738
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10657722
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10720086
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp6 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp6.xyz;
                tmp6.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp6.xyz;
                tmp2.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10768564
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10823704
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10885168
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 10957648
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11045747
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11106917
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11152442
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11219571
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11335579
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11364033
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11406317
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11529456
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11546297
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp1 = tmp1 * _SourceContribution.xxxx;
                o.sv_target.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11618277
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensStarburstWeights5;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights5.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights5.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx;
                tmp0.xyz = tmp1.xyz * _BloomParams.xxx + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11674064
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtWeights5;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights5.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11747798
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp5 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp1.xyz = _LensDirtWeights4.xxx * tmp5.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensDirtStrength.xxx;
                tmp6 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp1.xyz * tmp6.xyz;
                tmp6.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp6.xyz;
                tmp2.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = _UpscaleWeights4.xxx * tmp5.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights4.xxx * tmp5.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _UpscaleContribution.xxx;
                tmp1.xyz = tmp2.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11813734
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11870279
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11953415
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12057626
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12061152
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _UpscaleWeights5;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MipResultsRTS5;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS5, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights5.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12167638
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensStarburstWeights4;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights4.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12196646
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtWeights4;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights4.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights4.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12276345
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp4 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp4.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp5 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp5.xyz;
                tmp5.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp5.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp0.xyz = _LensStarburstWeights3.xxx * tmp4.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights3.xxx * tmp4.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12383037
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _UpscaleWeights4;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MipResultsRTS4;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp1 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights0.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights2.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1 = tex2D(_MipResultsRTS4, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = _UpscaleWeights4.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _UpscaleContribution.xxx;
                tmp1 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomParams.xxx + tmp1.xyz;
                tmp1 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12448993
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensStarburstWeights3;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.yz = tmp0.yy * _LensFlareStarMatrix._m01_m11;
                tmp0.xy = _LensFlareStarMatrix._m00_m10 * tmp0.xx + tmp0.yz;
                tmp0.xy = tmp0.xy + _LensFlareStarMatrix._m03_m13;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_LensStarburst, tmp0.xy);
                tmp1 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * _LensStarburstWeights1.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleWeights1.xxx;
                tmp3 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights0.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp2.xyz = _LensStarburstWeights3.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12463739
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _UpscaleWeights3;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtWeights3;
			float _LensDirtStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MipResultsRTS3;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights2.xxx * tmp2.xyz + tmp0.xyz;
                tmp2 = tex2D(_MipResultsRTS3, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights3.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = _LensDirtWeights3.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensDirtStrength.xxx;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp2 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp2.xyz;
                tmp2 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp2.xyz + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "Mode" = "Half" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12535213
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4x4 _LensFlareStarMatrix;
			float4 _BloomRange;
			float _UpscaleWeights0;
			float _UpscaleWeights1;
			float _UpscaleWeights2;
			float _LensStarburstWeights0;
			float _LensStarburstWeights1;
			float _LensStarburstWeights2;
			float _LensDirtWeights0;
			float _LensDirtWeights1;
			float _LensDirtWeights2;
			float _LensDirtStrength;
			float _LensFlareStarburstStrength;
			float _SourceContribution;
			float _UpscaleContribution;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MipResultsRTS0;
			sampler2D _MipResultsRTS1;
			sampler2D _MipResultsRTS2;
			sampler2D _MainTex;
			sampler2D _LensFlare;
			sampler2D _LensGlare;
			sampler2D _LensDirt;
			sampler2D _LensStarburst;
			
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
                tmp0.y = tmp0.x ? tmp0.y : v.texcoord.y;
                tmp0.x = v.texcoord.x;
                o.texcoord2.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = tmp0.xy;
                o.texcoord1.xy = v.texcoord.xy;
                o.texcoord1.zw = float2(1.0, 1.0);
                o.texcoord3.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.zw = _MainTex_ST.zw + _MainTex_ST.xy;
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
                tmp0 = tex2D(_MipResultsRTS1, inp.texcoord2.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _UpscaleWeights1.xxx;
                tmp2 = tex2D(_MipResultsRTS0, inp.texcoord2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _UpscaleWeights0.xxx * tmp2.xyz + tmp1.xyz;
                tmp3 = tex2D(_MipResultsRTS2, inp.texcoord2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = _UpscaleWeights2.xxx * tmp3.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _UpscaleContribution.xxx;
                tmp4 = tex2D(_LensFlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz * _BloomParams.xxx + tmp4.xyz;
                tmp4 = tex2D(_LensGlare, inp.texcoord2.xy);
                tmp1.xyz = tmp1.xyz + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * _LensDirtWeights1.xxx;
                tmp0.xyz = tmp0.xyz * _LensStarburstWeights1.xxx;
                tmp0.xyz = _LensStarburstWeights0.xxx * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = _LensDirtWeights0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = _LensDirtWeights2.xxx * tmp3.xyz + tmp2.xyz;
                tmp0.xyz = _LensStarburstWeights2.xxx * tmp3.xyz + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _LensDirtStrength.xxx;
                tmp3 = tex2D(_LensDirt, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.yz = tmp2.yy * _LensFlareStarMatrix._m01_m11;
                tmp2.xy = _LensFlareStarMatrix._m00_m10 * tmp2.xx + tmp2.yz;
                tmp2.xy = tmp2.xy + _LensFlareStarMatrix._m03_m13;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_LensStarburst, tmp2.xy);
                tmp3 = tex2D(_LensStarburst, inp.texcoord.xy);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareStarburstStrength.xxx + tmp1.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target.xyz = _SourceContribution.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.x = tmp1.w * _SourceContribution;
                o.sv_target.w = tmp0.x;
                return o;
			}
			ENDCG
		}
	}
}