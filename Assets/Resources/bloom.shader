Shader "Hidden/AmplifyBloom" {
	Properties {
		_MainTex (" ", 2D) = "black" {}
		_AnamorphicRTS0 (" ", 2D) = "black" {}
		_AnamorphicRTS1 (" ", 2D) = "black" {}
		_AnamorphicRTS2 (" ", 2D) = "black" {}
		_AnamorphicRTS3 (" ", 2D) = "black" {}
		_AnamorphicRTS4 (" ", 2D) = "black" {}
		_AnamorphicRTS5 (" ", 2D) = "black" {}
		_AnamorphicRTS6 (" ", 2D) = "black" {}
		_AnamorphicRTS7 (" ", 2D) = "black" {}
		_LensFlareLUT (" ", 2D) = "black" {}
	}
	SubShader {
		Pass {
			Name "FRAG_THRESHOLD"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 35244
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
			float4 _BloomRange;
			float4 _BloomParams;
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
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz - _BloomParams.yyy;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = min(tmp0.xyz, _BloomRange.xxx);
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_THRESHOLDMASK"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 96972
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
			float4 _BloomRange;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _MaskTex;
			
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
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp1 = tex2D(_MaskTex, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * tmp1.xyz + -_BloomParams.yyy;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = min(tmp0.xyz, _BloomRange.xxx);
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_ANAMORPHICGLARE"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 177597
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
			float4x4 _AnamorphicGlareOffsetsMat0;
			float4x4 _AnamorphicGlareOffsetsMat1;
			float4x4 _AnamorphicGlareOffsetsMat2;
			float4x4 _AnamorphicGlareOffsetsMat3;
			float4x4 _AnamorphicGlareWeightsMat0;
			float4x4 _AnamorphicGlareWeightsMat1;
			float4x4 _AnamorphicGlareWeightsMat2;
			float4x4 _AnamorphicGlareWeightsMat3;
			float4 _MainTex_ST;
			float4 _BloomRange;
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
                tmp0.xz = inp.texcoord.xx + _AnamorphicGlareOffsetsMat0._m00_m10;
                tmp0.yw = inp.texcoord.yy + _AnamorphicGlareOffsetsMat0._m01_m11;
                tmp0 = tmp0 * _MainTex_ST + _MainTex_ST;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = tmp1.x * _AnamorphicGlareWeightsMat0._m00;
                tmp2.y = tmp1.y * _AnamorphicGlareWeightsMat0._m01;
                tmp2.z = tmp1.z * _AnamorphicGlareWeightsMat0._m02;
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = tmp0.x * _AnamorphicGlareWeightsMat0._m10;
                tmp1.y = tmp0.y * _AnamorphicGlareWeightsMat0._m11;
                tmp1.z = tmp0.z * _AnamorphicGlareWeightsMat0._m12;
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp1.xz = inp.texcoord.xx + _AnamorphicGlareOffsetsMat0._m20_m30;
                tmp1.yw = inp.texcoord.yy + _AnamorphicGlareOffsetsMat0._m21_m31;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.x = tmp2.x * _AnamorphicGlareWeightsMat0._m20;
                tmp3.y = tmp2.y * _AnamorphicGlareWeightsMat0._m21;
                tmp3.z = tmp2.z * _AnamorphicGlareWeightsMat0._m22;
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = tmp1.x * _AnamorphicGlareWeightsMat0._m30;
                tmp2.y = tmp1.y * _AnamorphicGlareWeightsMat0._m31;
                tmp2.z = tmp1.z * _AnamorphicGlareWeightsMat0._m32;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp1.xz = inp.texcoord.xx + _AnamorphicGlareOffsetsMat1._m00_m10;
                tmp1.yw = inp.texcoord.yy + _AnamorphicGlareOffsetsMat1._m01_m11;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.x = tmp2.x * _AnamorphicGlareWeightsMat1._m00;
                tmp3.y = tmp2.y * _AnamorphicGlareWeightsMat1._m01;
                tmp3.z = tmp2.z * _AnamorphicGlareWeightsMat1._m02;
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = tmp1.x * _AnamorphicGlareWeightsMat1._m10;
                tmp2.y = tmp1.y * _AnamorphicGlareWeightsMat1._m11;
                tmp2.z = tmp1.z * _AnamorphicGlareWeightsMat1._m12;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp1.xz = inp.texcoord.xx + _AnamorphicGlareOffsetsMat1._m20_m30;
                tmp1.yw = inp.texcoord.yy + _AnamorphicGlareOffsetsMat1._m21_m31;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.x = tmp2.x * _AnamorphicGlareWeightsMat1._m20;
                tmp3.y = tmp2.y * _AnamorphicGlareWeightsMat1._m21;
                tmp3.z = tmp2.z * _AnamorphicGlareWeightsMat1._m22;
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = tmp1.x * _AnamorphicGlareWeightsMat1._m30;
                tmp2.y = tmp1.y * _AnamorphicGlareWeightsMat1._m31;
                tmp2.z = tmp1.z * _AnamorphicGlareWeightsMat1._m32;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp1.xz = inp.texcoord.xx + _AnamorphicGlareOffsetsMat2._m00_m10;
                tmp1.yw = inp.texcoord.yy + _AnamorphicGlareOffsetsMat2._m01_m11;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.x = tmp2.x * _AnamorphicGlareWeightsMat2._m00;
                tmp3.y = tmp2.y * _AnamorphicGlareWeightsMat2._m01;
                tmp3.z = tmp2.z * _AnamorphicGlareWeightsMat2._m02;
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = tmp1.x * _AnamorphicGlareWeightsMat2._m10;
                tmp2.y = tmp1.y * _AnamorphicGlareWeightsMat2._m11;
                tmp2.z = tmp1.z * _AnamorphicGlareWeightsMat2._m12;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp1.xz = inp.texcoord.xx + _AnamorphicGlareOffsetsMat2._m20_m30;
                tmp1.yw = inp.texcoord.yy + _AnamorphicGlareOffsetsMat2._m21_m31;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.x = tmp2.x * _AnamorphicGlareWeightsMat2._m20;
                tmp3.y = tmp2.y * _AnamorphicGlareWeightsMat2._m21;
                tmp3.z = tmp2.z * _AnamorphicGlareWeightsMat2._m22;
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = tmp1.x * _AnamorphicGlareWeightsMat2._m30;
                tmp2.y = tmp1.y * _AnamorphicGlareWeightsMat2._m31;
                tmp2.z = tmp1.z * _AnamorphicGlareWeightsMat2._m32;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp1.xz = inp.texcoord.xx + _AnamorphicGlareOffsetsMat3._m00_m10;
                tmp1.yw = inp.texcoord.yy + _AnamorphicGlareOffsetsMat3._m01_m11;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.x = tmp2.x * _AnamorphicGlareWeightsMat3._m00;
                tmp3.y = tmp2.y * _AnamorphicGlareWeightsMat3._m01;
                tmp3.z = tmp2.z * _AnamorphicGlareWeightsMat3._m02;
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = tmp1.x * _AnamorphicGlareWeightsMat3._m10;
                tmp2.y = tmp1.y * _AnamorphicGlareWeightsMat3._m11;
                tmp2.z = tmp1.z * _AnamorphicGlareWeightsMat3._m12;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp1.xz = inp.texcoord.xx + _AnamorphicGlareOffsetsMat3._m20_m30;
                tmp1.yw = inp.texcoord.yy + _AnamorphicGlareOffsetsMat3._m21_m31;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.x = tmp2.x * _AnamorphicGlareWeightsMat3._m20;
                tmp3.y = tmp2.y * _AnamorphicGlareWeightsMat3._m21;
                tmp3.z = tmp2.z * _AnamorphicGlareWeightsMat3._m22;
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = tmp1.x * _AnamorphicGlareWeightsMat3._m30;
                tmp2.y = tmp1.y * _AnamorphicGlareWeightsMat3._m31;
                tmp2.z = tmp1.z * _AnamorphicGlareWeightsMat3._m32;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_LENSFLARE0"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 230496
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
			float4 _LensFlareGhostsParams;
			float4 _LensFlareHaloParams;
			float _LensFlareHaloChrDistortion;
			float4 _MainTex_ST;
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LensFlareLUT;
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
                tmp0.x = _LensFlareHaloChrDistortion * -_MainTex_TexelSize.x;
                tmp0.yz = float2(0.5, 0.5) - inp.texcoord.xy;
                tmp1.xy = tmp0.yz * _LensFlareGhostsParams.yy;
                tmp0.y = dot(tmp0.xy, tmp0.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y * 1.4142;
                tmp2.x = frac(tmp0.y);
                tmp0.y = dot(tmp1.xy, tmp1.xy);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yz = tmp0.yy * tmp1.xy;
                tmp1.xy = tmp0.yz * _LensFlareHaloParams.yy + inp.texcoord.xy;
                tmp1.xy = frac(tmp1.xy);
                tmp0.xw = tmp0.yz * tmp0.xx + tmp1.xy;
                tmp0.xw = tmp0.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp0.xw);
                tmp0.x = tmp3.x * _BloomRange.x;
                tmp3.x = tmp3.w * tmp0.x;
                tmp0.x = _LensFlareHaloChrDistortion * _MainTex_TexelSize.x;
                tmp0.xy = tmp0.yz * tmp0.xx + tmp1.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.x = tmp0.z * _BloomRange.x;
                tmp3.z = tmp0.w * tmp0.x;
                tmp0.xy = float2(0.5, 0.5) - tmp1.xy;
                tmp0.zw = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.zw);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = -tmp0.x * 1.4142 + 1.0;
                tmp0.x = tmp0.x * _LensFlareHaloParams.z;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _LensFlareHaloParams.w;
                tmp0.x = exp(tmp0.x);
                tmp0.y = tmp1.y * _BloomRange.x;
                tmp3.y = tmp1.w * tmp0.y;
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareHaloParams.xxx;
                tmp2.y = 0.0;
                tmp1 = tex2D(_LensFlareLUT, tmp2.xy);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_LENSFLARE1"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 291257
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
			float4 _LensFlareGhostsParams;
			float4 _LensFlareHaloParams;
			float _LensFlareGhostChrDistortion;
			float _LensFlareHaloChrDistortion;
			float4 _MainTex_ST;
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LensFlareLUT;
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
                float4 tmp5;
                float4 tmp6;
                tmp0.xy = float2(0.5, 0.5) - inp.texcoord.xy;
                tmp0.zw = tmp0.xy * _LensFlareGhostsParams.yy;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 1.4142;
                tmp0.x = frac(tmp0.x);
                tmp1.x = dot(tmp0.xy, tmp0.xy);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.zw = tmp0.zw * tmp1.xx;
                tmp1.xy = tmp0.zw * _LensFlareHaloParams.yy + inp.texcoord.xy;
                tmp1.xy = frac(tmp1.xy);
                tmp1.zw = float2(0.5, 0.5) - tmp1.xy;
                tmp1.z = dot(tmp1.xy, tmp1.xy);
                tmp1.z = sqrt(tmp1.z);
                tmp1.z = -tmp1.z * 1.4142 + 1.0;
                tmp1.z = tmp1.z * _LensFlareHaloParams.z;
                tmp1.z = log(tmp1.z);
                tmp1.z = tmp1.z * _LensFlareHaloParams.w;
                tmp1.z = exp(tmp1.z);
                tmp2 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * -_MainTex_TexelSize;
                tmp2.zw = tmp0.zw * tmp2.zw + tmp1.xy;
                tmp2.zw = tmp2.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.zw);
                tmp1.w = tmp3.x * _BloomRange.x;
                tmp3.x = tmp3.w * tmp1.w;
                tmp4 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * _MainTex_TexelSize;
                tmp2.zw = tmp0.zw * tmp4.zw + tmp1.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp1.xy);
                tmp1.xy = tmp2.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp1.xy);
                tmp1.x = tmp6.z * _BloomRange.x;
                tmp3.z = tmp6.w * tmp1.x;
                tmp1.x = tmp5.y * _BloomRange.x;
                tmp3.y = tmp5.w * tmp1.x;
                tmp1.xyz = tmp1.zzz * tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _LensFlareHaloParams.xxx;
                tmp0.y = 0.0;
                tmp3 = tex2D(_LensFlareLUT, tmp0.xy);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp0.xy = frac(inp.texcoord.xy);
                tmp2.xy = tmp0.zw * tmp2.xy + tmp0.xy;
                tmp0.zw = tmp0.zw * tmp4.xy + tmp0.xy;
                tmp0.zw = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp0.zw);
                tmp0.zw = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = tmp2.x * _BloomRange.x;
                tmp2.x = tmp2.w * tmp0.z;
                tmp0.z = tmp4.z * _BloomRange.x;
                tmp2.z = tmp4.w * tmp0.z;
                tmp0.zw = float2(0.5, 0.5) - tmp0.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp0.xy);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = -tmp0.x * 1.4142 + 1.0;
                tmp0.x = tmp0.x * _LensFlareGhostsParams.z;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _LensFlareGhostsParams.w;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.y = tmp4.y * _BloomRange.x;
                tmp2.y = tmp4.w * tmp0.y;
                tmp0.xyz = tmp0.xxx * tmp2.xyz;
                tmp0.xyz = tmp3.xyz * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _LensFlareGhostsParams.xxx + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_LENSFLARE2"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 372991
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
			float4 _LensFlareGhostsParams;
			float4 _LensFlareHaloParams;
			float _LensFlareGhostChrDistortion;
			float _LensFlareHaloChrDistortion;
			float4 _MainTex_ST;
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LensFlareLUT;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xy = float2(0.5, 0.5) - inp.texcoord.xy;
                tmp0.zw = tmp0.xy * _LensFlareGhostsParams.yy + inp.texcoord.xy;
                tmp0.zw = frac(tmp0.zw);
                tmp1.xy = float2(0.5, 0.5) - tmp0.zw;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = -tmp1.x * 1.4142 + 1.0;
                tmp1.x = tmp1.x * _LensFlareGhostsParams.z;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _LensFlareGhostsParams.w;
                tmp1.x = exp(tmp1.x);
                tmp1.yz = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp1.yz);
                tmp1.y = tmp2.y * _BloomRange.x;
                tmp2.y = tmp2.w * tmp1.y;
                tmp1.yz = tmp0.xy * _LensFlareGhostsParams.yy;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 1.4142;
                tmp0.x = frac(tmp0.x);
                tmp1.w = dot(tmp1.xy, tmp1.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.xww * tmp1.xyz;
                tmp3 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * -_MainTex_TexelSize;
                tmp4.xy = tmp1.yz * tmp3.xy + tmp0.zw;
                tmp4.xy = tmp4.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp4.xy);
                tmp1.w = tmp4.x * _BloomRange.x;
                tmp2.x = tmp4.w * tmp1.w;
                tmp4 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * _MainTex_TexelSize;
                tmp0.zw = tmp1.yz * tmp4.xy + tmp0.zw;
                tmp0.zw = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = tmp5.z * _BloomRange.x;
                tmp2.z = tmp5.w * tmp0.z;
                tmp2.xyz = tmp1.xxx * tmp2.xyz;
                tmp0.y = 0.0;
                tmp0 = tex2D(_LensFlareLUT, tmp0.xy);
                tmp2.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensFlareGhostsParams.xxx;
                tmp1.xw = frac(inp.texcoord.xy);
                tmp5.xy = float2(0.5, 0.5) - tmp1.xw;
                tmp0.w = dot(tmp5.xy, tmp5.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp3.xy = tmp1.yz * tmp3.xy + tmp1.xw;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp3.xy);
                tmp2.w = tmp5.x * _BloomRange.x;
                tmp5.x = tmp5.w * tmp2.w;
                tmp3.xy = tmp1.yz * tmp4.xy + tmp1.xw;
                tmp1.xw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp1.xw);
                tmp1.xw = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp7 = tex2D(_MainTex, tmp1.xw);
                tmp1.x = tmp7.z * _BloomRange.x;
                tmp5.z = tmp7.w * tmp1.x;
                tmp1.x = tmp6.y * _BloomRange.x;
                tmp5.y = tmp6.w * tmp1.x;
                tmp5.xyz = tmp0.www * tmp5.xyz;
                tmp5.xyz = tmp0.xyz * tmp5.xyz;
                tmp2.xyz = tmp5.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp1.xw = tmp1.yz * _LensFlareHaloParams.yy + inp.texcoord.xy;
                tmp1.xw = frac(tmp1.xw);
                tmp3.xy = tmp1.yz * tmp3.zw + tmp1.xw;
                tmp1.yz = tmp1.yz * tmp4.zw + tmp1.xw;
                tmp1.yz = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp1.yz);
                tmp1.yz = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp1.yz);
                tmp0.w = tmp3.x * _BloomRange.x;
                tmp3.x = tmp3.w * tmp0.w;
                tmp0.w = tmp4.z * _BloomRange.x;
                tmp3.z = tmp4.w * tmp0.w;
                tmp1.yz = float2(0.5, 0.5) - tmp1.xw;
                tmp1.xw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp1.xw);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareHaloParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareHaloParams.w;
                tmp0.w = exp(tmp0.w);
                tmp1.x = tmp4.y * _BloomRange.x;
                tmp3.y = tmp4.w * tmp1.x;
                tmp1.xyz = tmp0.www * tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _LensFlareHaloParams.xxx;
                tmp0.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_LENSFLARE3"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 456484
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
			float4 _LensFlareGhostsParams;
			float4 _LensFlareHaloParams;
			float _LensFlareGhostChrDistortion;
			float _LensFlareHaloChrDistortion;
			float4 _MainTex_ST;
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LensFlareLUT;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                tmp0.xy = float2(0.5, 0.5) - inp.texcoord.xy;
                tmp0.zw = tmp0.xy * _LensFlareGhostsParams.yy + inp.texcoord.xy;
                tmp0.zw = frac(tmp0.zw);
                tmp1.xy = float2(0.5, 0.5) - tmp0.zw;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = -tmp1.x * 1.4142 + 1.0;
                tmp1.x = tmp1.x * _LensFlareGhostsParams.z;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _LensFlareGhostsParams.w;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.yz = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp1.yz);
                tmp1.y = tmp2.y * _BloomRange.x;
                tmp2.y = tmp2.w * tmp1.y;
                tmp1.yz = tmp0.xy * _LensFlareGhostsParams.yy;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 1.4142;
                tmp0.x = frac(tmp0.x);
                tmp1.w = dot(tmp1.xy, tmp1.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xy = tmp1.ww * tmp1.yz;
                tmp1.yz = tmp1.yz * float2(2.0, 2.0) + inp.texcoord.xy;
                tmp1.yz = frac(tmp1.yz);
                tmp4 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * -_MainTex_TexelSize;
                tmp3.zw = tmp3.xy * tmp4.xy + tmp0.zw;
                tmp3.zw = tmp3.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp3.zw);
                tmp1.w = tmp5.x * _BloomRange.x;
                tmp2.x = tmp5.w * tmp1.w;
                tmp5 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * _MainTex_TexelSize;
                tmp0.zw = tmp3.xy * tmp5.xy + tmp0.zw;
                tmp0.zw = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = tmp6.z * _BloomRange.x;
                tmp2.z = tmp6.w * tmp0.z;
                tmp2.xyz = tmp1.xxx * tmp2.xyz;
                tmp0.y = 0.0;
                tmp0 = tex2D(_LensFlareLUT, tmp0.xy);
                tmp2.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensFlareGhostsParams.xxx;
                tmp1.xw = frac(inp.texcoord.xy);
                tmp3.zw = float2(0.5, 0.5) - tmp1.xw;
                tmp0.w = dot(tmp3.xy, tmp3.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp3.zw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp3.zw);
                tmp2.w = tmp6.y * _BloomRange.x;
                tmp6.y = tmp6.w * tmp2.w;
                tmp3.zw = tmp3.xy * tmp4.xy + tmp1.xw;
                tmp1.xw = tmp3.xy * tmp5.xy + tmp1.xw;
                tmp1.xw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp7 = tex2D(_MainTex, tmp1.xw);
                tmp1.xw = tmp3.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp8 = tex2D(_MainTex, tmp1.xw);
                tmp1.x = tmp8.x * _BloomRange.x;
                tmp6.x = tmp8.w * tmp1.x;
                tmp1.x = tmp7.z * _BloomRange.x;
                tmp6.z = tmp7.w * tmp1.x;
                tmp6.xyz = tmp0.www * tmp6.xyz;
                tmp6.xyz = tmp0.xyz * tmp6.xyz;
                tmp2.xyz = tmp6.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp1.xw = float2(0.5, 0.5) - tmp1.yz;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.xw = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp1.xw);
                tmp1.x = tmp6.y * _BloomRange.x;
                tmp6.y = tmp6.w * tmp1.x;
                tmp1.xw = tmp3.xy * tmp4.xy + tmp1.yz;
                tmp1.yz = tmp3.xy * tmp5.xy + tmp1.yz;
                tmp1.yz = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp7 = tex2D(_MainTex, tmp1.yz);
                tmp1.xy = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.x = tmp1.x * _BloomRange.x;
                tmp6.x = tmp1.w * tmp1.x;
                tmp1.x = tmp7.z * _BloomRange.x;
                tmp6.z = tmp7.w * tmp1.x;
                tmp1.xyz = tmp0.www * tmp6.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp2.xy = tmp3.xy * _LensFlareHaloParams.yy + inp.texcoord.xy;
                tmp2.xy = frac(tmp2.xy);
                tmp2.zw = tmp3.xy * tmp4.zw + tmp2.xy;
                tmp3.xy = tmp3.xy * tmp5.zw + tmp2.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp2.zw = tmp2.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp2.zw);
                tmp0.w = tmp4.x * _BloomRange.x;
                tmp4.x = tmp4.w * tmp0.w;
                tmp0.w = tmp3.z * _BloomRange.x;
                tmp4.z = tmp3.w * tmp0.w;
                tmp2.zw = float2(0.5, 0.5) - tmp2.xy;
                tmp2.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareHaloParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareHaloParams.w;
                tmp0.w = exp(tmp0.w);
                tmp1.w = tmp3.y * _BloomRange.x;
                tmp4.y = tmp3.w * tmp1.w;
                tmp2.xyz = tmp0.www * tmp4.xyz;
                tmp2.xyz = tmp2.xyz * _LensFlareHaloParams.xxx;
                tmp0.xyz = tmp2.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_LENSFLARE4"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 489551
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
			float4 _LensFlareGhostsParams;
			float4 _LensFlareHaloParams;
			float _LensFlareGhostChrDistortion;
			float _LensFlareHaloChrDistortion;
			float4 _MainTex_ST;
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LensFlareLUT;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                tmp0.xy = float2(0.5, 0.5) - inp.texcoord.xy;
                tmp0.zw = tmp0.xy * _LensFlareGhostsParams.yy + inp.texcoord.xy;
                tmp0.zw = frac(tmp0.zw);
                tmp1.xy = float2(0.5, 0.5) - tmp0.zw;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = -tmp1.x * 1.4142 + 1.0;
                tmp1.x = tmp1.x * _LensFlareGhostsParams.z;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _LensFlareGhostsParams.w;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.yz = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp1.yz);
                tmp1.y = tmp2.y * _BloomRange.x;
                tmp2.y = tmp2.w * tmp1.y;
                tmp1.yz = tmp0.xy * _LensFlareGhostsParams.yy;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 1.4142;
                tmp0.x = frac(tmp0.x);
                tmp1.w = dot(tmp1.xy, tmp1.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xy = tmp1.ww * tmp1.yz;
                tmp4 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * -_MainTex_TexelSize;
                tmp3.zw = tmp3.xy * tmp4.xy + tmp0.zw;
                tmp3.zw = tmp3.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp3.zw);
                tmp1.w = tmp5.x * _BloomRange.x;
                tmp2.x = tmp5.w * tmp1.w;
                tmp5 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * _MainTex_TexelSize;
                tmp0.zw = tmp3.xy * tmp5.xy + tmp0.zw;
                tmp0.zw = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = tmp6.z * _BloomRange.x;
                tmp2.z = tmp6.w * tmp0.z;
                tmp2.xyz = tmp1.xxx * tmp2.xyz;
                tmp0.y = 0.0;
                tmp0 = tex2D(_LensFlareLUT, tmp0.xy);
                tmp2.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensFlareGhostsParams.xxx;
                tmp1.xw = frac(inp.texcoord.xy);
                tmp3.zw = float2(0.5, 0.5) - tmp1.xw;
                tmp0.w = dot(tmp3.xy, tmp3.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp3.zw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp3.zw);
                tmp2.w = tmp6.y * _BloomRange.x;
                tmp6.y = tmp6.w * tmp2.w;
                tmp3.zw = tmp3.xy * tmp4.xy + tmp1.xw;
                tmp1.xw = tmp3.xy * tmp5.xy + tmp1.xw;
                tmp1.xw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp7 = tex2D(_MainTex, tmp1.xw);
                tmp1.xw = tmp3.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp8 = tex2D(_MainTex, tmp1.xw);
                tmp1.x = tmp8.x * _BloomRange.x;
                tmp6.x = tmp8.w * tmp1.x;
                tmp1.x = tmp7.z * _BloomRange.x;
                tmp6.z = tmp7.w * tmp1.x;
                tmp6.xyz = tmp0.www * tmp6.xyz;
                tmp6.xyz = tmp0.xyz * tmp6.xyz;
                tmp2.xyz = tmp6.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp1.xw = tmp1.yz * float2(2.0, 2.0) + inp.texcoord.xy;
                tmp1.yz = tmp1.yz * float2(3.0, 3.0) + inp.texcoord.xy;
                tmp1 = frac(tmp1);
                tmp3.zw = float2(0.5, 0.5) - tmp1.xw;
                tmp0.w = dot(tmp3.xy, tmp3.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp3.zw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp3.zw);
                tmp2.w = tmp6.y * _BloomRange.x;
                tmp6.y = tmp6.w * tmp2.w;
                tmp3.zw = tmp3.xy * tmp4.xy + tmp1.xw;
                tmp1.xw = tmp3.xy * tmp5.xy + tmp1.xw;
                tmp1.xw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp7 = tex2D(_MainTex, tmp1.xw);
                tmp1.xw = tmp3.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp8 = tex2D(_MainTex, tmp1.xw);
                tmp1.x = tmp8.x * _BloomRange.x;
                tmp6.x = tmp8.w * tmp1.x;
                tmp1.x = tmp7.z * _BloomRange.x;
                tmp6.z = tmp7.w * tmp1.x;
                tmp6.xyz = tmp0.www * tmp6.xyz;
                tmp6.xyz = tmp0.xyz * tmp6.xyz;
                tmp2.xyz = tmp6.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp1.xw = float2(0.5, 0.5) - tmp1.yz;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.xw = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp1.xw);
                tmp1.x = tmp6.y * _BloomRange.x;
                tmp6.y = tmp6.w * tmp1.x;
                tmp1.xw = tmp3.xy * tmp4.xy + tmp1.yz;
                tmp1.yz = tmp3.xy * tmp5.xy + tmp1.yz;
                tmp1.yz = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp7 = tex2D(_MainTex, tmp1.yz);
                tmp1.xy = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.x = tmp1.x * _BloomRange.x;
                tmp6.x = tmp1.w * tmp1.x;
                tmp1.x = tmp7.z * _BloomRange.x;
                tmp6.z = tmp7.w * tmp1.x;
                tmp1.xyz = tmp0.www * tmp6.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp2.xy = tmp3.xy * _LensFlareHaloParams.yy + inp.texcoord.xy;
                tmp2.xy = frac(tmp2.xy);
                tmp2.zw = tmp3.xy * tmp4.zw + tmp2.xy;
                tmp3.xy = tmp3.xy * tmp5.zw + tmp2.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp2.zw = tmp2.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp2.zw);
                tmp0.w = tmp4.x * _BloomRange.x;
                tmp4.x = tmp4.w * tmp0.w;
                tmp0.w = tmp3.z * _BloomRange.x;
                tmp4.z = tmp3.w * tmp0.w;
                tmp2.zw = float2(0.5, 0.5) - tmp2.xy;
                tmp2.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareHaloParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareHaloParams.w;
                tmp0.w = exp(tmp0.w);
                tmp1.w = tmp3.y * _BloomRange.x;
                tmp4.y = tmp3.w * tmp1.w;
                tmp2.xyz = tmp0.www * tmp4.xyz;
                tmp2.xyz = tmp2.xyz * _LensFlareHaloParams.xxx;
                tmp0.xyz = tmp2.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_LENSFLARE5"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 551139
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
			float4 _LensFlareGhostsParams;
			float4 _LensFlareHaloParams;
			float _LensFlareGhostChrDistortion;
			float _LensFlareHaloChrDistortion;
			float4 _MainTex_ST;
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LensFlareLUT;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0.xy = float2(0.5, 0.5) - inp.texcoord.xy;
                tmp0.zw = tmp0.xy * _LensFlareGhostsParams.yy + inp.texcoord.xy;
                tmp0.zw = frac(tmp0.zw);
                tmp1.xy = float2(0.5, 0.5) - tmp0.zw;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = -tmp1.x * 1.4142 + 1.0;
                tmp1.x = tmp1.x * _LensFlareGhostsParams.z;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _LensFlareGhostsParams.w;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.yz = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp1.yz);
                tmp1.y = tmp2.y * _BloomRange.x;
                tmp2.y = tmp2.w * tmp1.y;
                tmp3 = tmp0.xyxy * _LensFlareGhostsParams;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 1.4142;
                tmp0.x = frac(tmp0.x);
                tmp1.y = dot(tmp3.xy, tmp3.xy);
                tmp1.y = rsqrt(tmp1.y);
                tmp1.yz = tmp1.yy * tmp3.zw;
                tmp4 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * -_MainTex_TexelSize;
                tmp5.xy = tmp1.yz * tmp4.xy + tmp0.zw;
                tmp5.xy = tmp5.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp5.xy);
                tmp1.w = tmp5.x * _BloomRange.x;
                tmp2.x = tmp5.w * tmp1.w;
                tmp5 = float4(_LensFlareGhostChrDistortion.xx, _LensFlareHaloChrDistortion.xx) * _MainTex_TexelSize;
                tmp0.zw = tmp1.yz * tmp5.xy + tmp0.zw;
                tmp0.zw = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = tmp6.z * _BloomRange.x;
                tmp2.z = tmp6.w * tmp0.z;
                tmp2.xyz = tmp1.xxx * tmp2.xyz;
                tmp0.y = 0.0;
                tmp0 = tex2D(_LensFlareLUT, tmp0.xy);
                tmp2.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _LensFlareGhostsParams.xxx;
                tmp1.xw = frac(inp.texcoord.xy);
                tmp6.xy = float2(0.5, 0.5) - tmp1.xw;
                tmp0.w = dot(tmp6.xy, tmp6.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp6.xy = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp6.xy);
                tmp2.w = tmp6.y * _BloomRange.x;
                tmp6.y = tmp6.w * tmp2.w;
                tmp7.xy = tmp1.yz * tmp4.xy + tmp1.xw;
                tmp1.xw = tmp1.yz * tmp5.xy + tmp1.xw;
                tmp1.xw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp8 = tex2D(_MainTex, tmp1.xw);
                tmp1.xw = tmp7.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp7 = tex2D(_MainTex, tmp1.xw);
                tmp1.x = tmp7.x * _BloomRange.x;
                tmp6.x = tmp7.w * tmp1.x;
                tmp1.x = tmp8.z * _BloomRange.x;
                tmp6.z = tmp8.w * tmp1.x;
                tmp6.xyz = tmp0.www * tmp6.xyz;
                tmp6.xyz = tmp0.xyz * tmp6.xyz;
                tmp2.xyz = tmp6.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp1.xw = tmp3.zw * float2(2.0, 2.0) + inp.texcoord.xy;
                tmp3 = tmp3 * float4(3.0, 3.0, 4.0, 4.0) + inp.texcoord.xyxy;
                tmp3 = frac(tmp3);
                tmp1.xw = frac(tmp1.xw);
                tmp6.xy = float2(0.5, 0.5) - tmp1.xw;
                tmp0.w = dot(tmp6.xy, tmp6.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp6.xy = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp6.xy);
                tmp2.w = tmp6.y * _BloomRange.x;
                tmp6.y = tmp6.w * tmp2.w;
                tmp7.xy = tmp1.yz * tmp4.xy + tmp1.xw;
                tmp1.xw = tmp1.yz * tmp5.xy + tmp1.xw;
                tmp1.xw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp8 = tex2D(_MainTex, tmp1.xw);
                tmp1.xw = tmp7.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp7 = tex2D(_MainTex, tmp1.xw);
                tmp1.x = tmp7.x * _BloomRange.x;
                tmp6.x = tmp7.w * tmp1.x;
                tmp1.x = tmp8.z * _BloomRange.x;
                tmp6.z = tmp8.w * tmp1.x;
                tmp6.xyz = tmp0.www * tmp6.xyz;
                tmp6.xyz = tmp0.xyz * tmp6.xyz;
                tmp2.xyz = tmp6.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp6 = float4(0.5, 0.5, 0.5, 0.5) - tmp3;
                tmp0.w = dot(tmp6.xy, tmp6.xy);
                tmp1.x = dot(tmp6.xy, tmp6.xy);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = -tmp1.x * 1.4142 + 1.0;
                tmp1.x = tmp1.x * _LensFlareGhostsParams.z;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _LensFlareGhostsParams.w;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x * tmp1.x;
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareGhostsParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareGhostsParams.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp6 = tmp3 * _MainTex_ST + _MainTex_ST;
                tmp7 = tex2D(_MainTex, tmp6.xy);
                tmp6 = tex2D(_MainTex, tmp6.zw);
                tmp1.w = tmp7.y * _BloomRange.x;
                tmp7.y = tmp7.w * tmp1.w;
                tmp8 = tmp1.yzyz * tmp4.xyxy + tmp3;
                tmp3 = tmp1.yzyz * tmp5.xyxy + tmp3;
                tmp3 = tmp3 * _MainTex_ST + _MainTex_ST;
                tmp8 = tmp8 * _MainTex_ST + _MainTex_ST;
                tmp9 = tex2D(_MainTex, tmp8.xy);
                tmp8 = tex2D(_MainTex, tmp8.zw);
                tmp1.w = tmp9.x * _BloomRange.x;
                tmp7.x = tmp9.w * tmp1.w;
                tmp9 = tex2D(_MainTex, tmp3.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp1.w = tmp9.z * _BloomRange.x;
                tmp7.z = tmp9.w * tmp1.w;
                tmp7.xyz = tmp0.www * tmp7.xyz;
                tmp7.xyz = tmp0.xyz * tmp7.xyz;
                tmp2.xyz = tmp7.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp0.w = tmp6.y * _BloomRange.x;
                tmp6.y = tmp6.w * tmp0.w;
                tmp0.w = tmp8.x * _BloomRange.x;
                tmp6.x = tmp8.w * tmp0.w;
                tmp0.w = tmp3.z * _BloomRange.x;
                tmp6.z = tmp3.w * tmp0.w;
                tmp3.xyz = tmp1.xxx * tmp6.xyz;
                tmp3.xyz = tmp0.xyz * tmp3.xyz;
                tmp2.xyz = tmp3.xyz * _LensFlareGhostsParams.xxx + tmp2.xyz;
                tmp1.xw = tmp1.yz * _LensFlareHaloParams.yy + inp.texcoord.xy;
                tmp1.xw = frac(tmp1.xw);
                tmp3.xy = tmp1.yz * tmp4.zw + tmp1.xw;
                tmp1.yz = tmp1.yz * tmp5.zw + tmp1.xw;
                tmp1.yz = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp1.yz);
                tmp1.yz = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp1.yz);
                tmp0.w = tmp3.x * _BloomRange.x;
                tmp3.x = tmp3.w * tmp0.w;
                tmp0.w = tmp4.z * _BloomRange.x;
                tmp3.z = tmp4.w * tmp0.w;
                tmp1.yz = float2(0.5, 0.5) - tmp1.xw;
                tmp1.xw = tmp1.xw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp1.xw);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = -tmp0.w * 1.4142 + 1.0;
                tmp0.w = tmp0.w * _LensFlareHaloParams.z;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _LensFlareHaloParams.w;
                tmp0.w = exp(tmp0.w);
                tmp1.x = tmp4.y * _BloomRange.x;
                tmp3.y = tmp4.w * tmp1.x;
                tmp1.xyz = tmp0.www * tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _LensFlareHaloParams.xxx;
                tmp0.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_DOWNSAMPLERNOWEIGHTEDAVG"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 637639
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
			float4 _BloomRange;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xy = _MainTex_TexelSize.xy * float2(2.0, 2.0) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp1.xy = _MainTex_TexelSize.xy * float2(0.0, 2.0) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(2.0, 0.0, -2.0, 2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp3.www * tmp3.xyz;
                tmp5.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp5.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp5.xyz * tmp5.www + tmp4.xyz;
                tmp4.xyz = tmp1.xyz * tmp1.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp5.www * tmp5.xyz;
                tmp6 = _MainTex_TexelSize * float4(2.0, -2.0, -2.0, 0.0) + inp.texcoord.xyxy;
                tmp6 = tmp6 * _MainTex_ST + _MainTex_ST;
                tmp7 = tex2D(_MainTex, tmp6.zw);
                tmp6 = tex2D(_MainTex, tmp6.xy);
                tmp7.xyz = tmp7.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp7.xyz * tmp7.www + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(-2.0, -2.0, 0.0, -2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp4 = tex2D(_MainTex, tmp2.zw);
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp6.www + tmp4.xyz;
                tmp1.xyz = tmp5.xyz * tmp5.www + tmp1.xyz;
                tmp1.xyz = tmp3.xyz * tmp3.www + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp7.xyz * tmp7.www + tmp1.xyz;
                tmp1.xyz = tmp5.xyz * tmp5.www + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.125, 0.125, 0.125);
                tmp1 = _MainTex_TexelSize * float4(1.0, -1.0, -1.0, 1.0) + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xy = inp.texcoord.xy - _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp3.xy = inp.texcoord.xy + _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_DOWNSAMPLER_WITH_KARIS"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 713898
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
			float4 _BloomRange;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xy = _MainTex_TexelSize.xy * float2(2.0, 2.0) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp1.xy = _MainTex_TexelSize.xy * float2(0.0, 2.0) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(2.0, 0.0, -2.0, 2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp3.www * tmp3.xyz;
                tmp5.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp5.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp5.xyz * tmp5.www + tmp4.xyz;
                tmp4.xyz = tmp1.xyz * tmp1.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp0.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp5.www * tmp5.xyz;
                tmp6 = _MainTex_TexelSize * float4(2.0, -2.0, -2.0, 0.0) + inp.texcoord.xyxy;
                tmp6 = tmp6 * _MainTex_ST + _MainTex_ST;
                tmp7 = tex2D(_MainTex, tmp6.zw);
                tmp6 = tex2D(_MainTex, tmp6.xy);
                tmp7.xyz = tmp7.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp7.xyz * tmp7.www + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp1.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp1.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(-2.0, -2.0, 0.0, -2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp4 = tex2D(_MainTex, tmp2.zw);
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp6.www + tmp4.xyz;
                tmp1.xyz = tmp5.xyz * tmp5.www + tmp1.xyz;
                tmp1.xyz = tmp3.xyz * tmp3.www + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp1.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp1.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp7.xyz * tmp7.www + tmp1.xyz;
                tmp1.xyz = tmp5.xyz * tmp5.www + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp1.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.125, 0.125, 0.125);
                tmp1 = _MainTex_TexelSize * float4(1.0, -1.0, -1.0, 1.0) + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xy = inp.texcoord.xy - _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp3.xy = inp.texcoord.xy + _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp1.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_DOWNSAMPLER_WITHOUT_KARIS"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 765159
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
			float4 _BloomRange;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xy = _MainTex_TexelSize.xy * float2(2.0, 2.0) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp1.xy = _MainTex_TexelSize.xy * float2(0.0, 2.0) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(2.0, 0.0, -2.0, 2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp3.www * tmp3.xyz;
                tmp5.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp5.xy);
                tmp5.xyz = tmp5.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp5.xyz * tmp5.www + tmp4.xyz;
                tmp4.xyz = tmp1.xyz * tmp1.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp5.www * tmp5.xyz;
                tmp6 = _MainTex_TexelSize * float4(2.0, -2.0, -2.0, 0.0) + inp.texcoord.xyxy;
                tmp6 = tmp6 * _MainTex_ST + _MainTex_ST;
                tmp7 = tex2D(_MainTex, tmp6.zw);
                tmp6 = tex2D(_MainTex, tmp6.xy);
                tmp7.xyz = tmp7.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp7.xyz * tmp7.www + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(-2.0, -2.0, 0.0, -2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp4 = tex2D(_MainTex, tmp2.zw);
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp6.www + tmp4.xyz;
                tmp1.xyz = tmp5.xyz * tmp5.www + tmp1.xyz;
                tmp1.xyz = tmp3.xyz * tmp3.www + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp7.xyz * tmp7.www + tmp1.xyz;
                tmp1.xyz = tmp5.xyz * tmp5.www + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.125, 0.125, 0.125);
                tmp1 = _MainTex_TexelSize * float4(1.0, -1.0, -1.0, 1.0) + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xy = inp.texcoord.xy - _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp3.xy = inp.texcoord.xy + _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_DOWNSAMPLER_TEMP_FILTER_WITH_KARIS"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 793559
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
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			float _TempFilterValue;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                tmp0.xy = _MainTex_TexelSize.xy * float2(2.0, 2.0) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp1.xy = _MainTex_TexelSize.xy * float2(0.0, 2.0) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(2.0, 0.0, -2.0, 2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp3.www * tmp3.xyz;
                tmp5.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp5.xy);
                tmp5 = tex2D(_AnamorphicRTS0, tmp5.xy);
                tmp6.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp6.xyz * tmp6.www + tmp4.xyz;
                tmp4.xyz = tmp1.xyz * tmp1.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp0.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp6.www * tmp6.xyz;
                tmp7 = _MainTex_TexelSize * float4(2.0, -2.0, -2.0, 0.0) + inp.texcoord.xyxy;
                tmp7 = tmp7 * _MainTex_ST + _MainTex_ST;
                tmp8 = tex2D(_MainTex, tmp7.zw);
                tmp7 = tex2D(_MainTex, tmp7.xy);
                tmp8.xyz = tmp8.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp8.xyz * tmp8.www + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp1.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp1.xyz = tmp7.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(-2.0, -2.0, 0.0, -2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp4 = tex2D(_MainTex, tmp2.zw);
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp7.www + tmp4.xyz;
                tmp1.xyz = tmp6.xyz * tmp6.www + tmp1.xyz;
                tmp1.xyz = tmp3.xyz * tmp3.www + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp1.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp1.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp8.xyz * tmp8.www + tmp1.xyz;
                tmp1.xyz = tmp6.xyz * tmp6.www + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp1.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.125, 0.125, 0.125);
                tmp1 = _MainTex_TexelSize * float4(1.0, -1.0, -1.0, 1.0) + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xy = inp.texcoord.xy - _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp3.xy = inp.texcoord.xy + _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = dot(tmp1.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp1.w = tmp0.w * 0.0039216;
                tmp1.xyz = tmp0.xyz / tmp1.www;
                tmp0 = tmp5 - tmp1;
                o.sv_target = _TempFilterValue.xxxx * tmp0 + tmp1;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_DOWNSAMPLER_TEMP_FILTER_WITHOUT_KARIS"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 859690
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
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			float _TempFilterValue;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                tmp0.xy = _MainTex_TexelSize.xy * float2(2.0, 2.0) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp1.xy = _MainTex_TexelSize.xy * float2(0.0, 2.0) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(2.0, 0.0, -2.0, 2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp3.www * tmp3.xyz;
                tmp5.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp5.xy);
                tmp5 = tex2D(_AnamorphicRTS0, tmp5.xy);
                tmp6.xyz = tmp6.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp6.xyz * tmp6.www + tmp4.xyz;
                tmp4.xyz = tmp1.xyz * tmp1.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp6.www * tmp6.xyz;
                tmp7 = _MainTex_TexelSize * float4(2.0, -2.0, -2.0, 0.0) + inp.texcoord.xyxy;
                tmp7 = tmp7 * _MainTex_ST + _MainTex_ST;
                tmp8 = tex2D(_MainTex, tmp7.zw);
                tmp7 = tex2D(_MainTex, tmp7.xy);
                tmp8.xyz = tmp8.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp8.xyz * tmp8.www + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.xyz = tmp7.xyz * _BloomRange.xxx;
                tmp2 = _MainTex_TexelSize * float4(-2.0, -2.0, 0.0, -2.0) + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp4 = tex2D(_MainTex, tmp2.zw);
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp7.www + tmp4.xyz;
                tmp1.xyz = tmp6.xyz * tmp6.www + tmp1.xyz;
                tmp1.xyz = tmp3.xyz * tmp3.www + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp2.www + tmp4.xyz;
                tmp1.xyz = tmp8.xyz * tmp8.www + tmp1.xyz;
                tmp1.xyz = tmp6.xyz * tmp6.www + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.125, 0.125, 0.125);
                tmp1 = _MainTex_TexelSize * float4(1.0, -1.0, -1.0, 1.0) + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xy = inp.texcoord.xy - _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp3.xy = inp.texcoord.xy + _MainTex_TexelSize.xy;
                tmp3.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp3.xyz * tmp3.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp1.w = tmp0.w * 0.0039216;
                tmp1.xyz = tmp0.xyz / tmp1.www;
                tmp0 = tmp5 - tmp1;
                o.sv_target = _TempFilterValue.xxxx * tmp0 + tmp1;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_HORIZONTAL_GAUSSIAN_BLUR"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 925185
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
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			float _BlurRadius;
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = _MainTex_TexelSize.x * _BlurRadius;
                tmp1.xz = tmp0.ww * float2(1.384615, 3.230769);
                tmp1.yw = float2(0.0, 0.0);
                tmp2 = tmp1 + inp.texcoord.xyxy;
                tmp1 = inp.texcoord.xyxy - tmp1;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * float3(0.3162162, 0.3162162, 0.3162162);
                tmp0.xyz = tmp0.xyz * float3(0.227027, 0.227027, 0.227027) + tmp3.xyz;
                tmp3 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp0.xyz = tmp3.xyz * float3(0.3162162, 0.3162162, 0.3162162) + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp0.xyz = tmp2.xyz * float3(0.0702703, 0.0702703, 0.0702703) + tmp0.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.0702703, 0.0702703, 0.0702703) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_VERTICAL_GAUSSIAN_BLUR"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1030256
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
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			float _BlurRadius;
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = _MainTex_TexelSize.y * _BlurRadius;
                tmp1.yz = float2(1.384615, 3.230769);
                tmp2 = float4(0.0, 1.384615, 0.0, 3.230769) * tmp1.yxzx + inp.texcoord.xyxy;
                tmp1 = float4(-0.0, -1.384615, -0.0, -3.230769) * tmp1.yxzx + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * float3(0.3162162, 0.3162162, 0.3162162);
                tmp0.xyz = tmp0.xyz * float3(0.227027, 0.227027, 0.227027) + tmp3.xyz;
                tmp3 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp0.xyz = tmp3.xyz * float3(0.3162162, 0.3162162, 0.3162162) + tmp0.xyz;
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp0.xyz = tmp2.xyz * float3(0.0702703, 0.0702703, 0.0702703) + tmp0.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.0702703, 0.0702703, 0.0702703) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_VERTICAL_GAUSSIAN_BLUR_TEMP_FILTER"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1082762
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
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			float _BlurRadius;
			float _TempFilterValue;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = _MainTex_TexelSize.y * _BlurRadius;
                tmp2.yz = float2(1.384615, 3.230769);
                tmp3 = float4(0.0, 1.384615, 0.0, 3.230769) * tmp2.yxzx + inp.texcoord.xyxy;
                tmp2 = float4(-0.0, -1.384615, -0.0, -3.230769) * tmp2.yxzx + inp.texcoord.xyxy;
                tmp2 = tmp2 * _MainTex_ST + _MainTex_ST;
                tmp3 = tmp3 * _MainTex_ST + _MainTex_ST;
                tmp4 = tex2D(_MainTex, tmp3.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.3162162, 0.3162162, 0.3162162);
                tmp1.xyz = tmp1.xyz * float3(0.227027, 0.227027, 0.227027) + tmp4.xyz;
                tmp4 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp4.xyz = tmp4.xyz * _BloomRange.xxx;
                tmp4.xyz = tmp4.www * tmp4.xyz;
                tmp1.xyz = tmp4.xyz * float3(0.3162162, 0.3162162, 0.3162162) + tmp1.xyz;
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp1.xyz = tmp3.xyz * float3(0.0702703, 0.0702703, 0.0702703) + tmp1.xyz;
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = tmp2.xyz * float3(0.0702703, 0.0702703, 0.0702703) + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.yyy;
                tmp1.w = max(tmp1.y, tmp1.x);
                tmp2.x = max(tmp1.z, 0.000001);
                tmp1.w = max(tmp1.w, tmp2.x);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = tmp1.w * 255.0;
                tmp1.w = ceil(tmp1.w);
                tmp2.w = tmp1.w * 0.0039216;
                tmp2.xyz = tmp1.xyz / tmp2.www;
                tmp0 = tmp0 - tmp2;
                o.sv_target = _TempFilterValue.xxxx * tmp0 + tmp2;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_UPSCALETENTFIRSTPASS"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1132571
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
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			float4 _BloomParams;
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
                tmp0.xy = -_MainTex_TexelSize.xy * _BloomParams.zz + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = _MainTex_TexelSize * float4(0.0, -1.0, 1.0, -1.0);
                tmp1 = tmp1 * _BloomParams + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.125, 0.125, 0.125);
                tmp0.xyz = tmp0.xyz * float3(0.0625, 0.0625, 0.0625) + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.0625, 0.0625, 0.0625) + tmp0.xyz;
                tmp1 = _MainTex_TexelSize * float4(-1.0, 0.0, 1.0, 0.0);
                tmp1 = tmp1 * _BloomParams + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp0.xyz = tmp2.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp2.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp0.xyz = tmp2.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp1 = _MainTex_TexelSize * float4(-1.0, 1.0, 0.0, 1.0);
                tmp1 = tmp1 * _BloomParams + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp0.xyz = tmp2.xyz * float3(0.0625, 0.0625, 0.0625) + tmp0.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp1.xy = _MainTex_TexelSize.xy * _BloomParams.zz + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.0625, 0.0625, 0.0625) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_UPSCALETENT"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1192903
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
			float4 _BloomRange;
			float4 _MainTex_TexelSize;
			float4 _BloomParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			
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
                tmp0.xy = -_MainTex_TexelSize.xy * _BloomParams.zz + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = _MainTex_TexelSize * float4(0.0, -1.0, 1.0, -1.0);
                tmp1 = tmp1 * _BloomParams + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.125, 0.125, 0.125);
                tmp0.xyz = tmp0.xyz * float3(0.0625, 0.0625, 0.0625) + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.0625, 0.0625, 0.0625) + tmp0.xyz;
                tmp1 = _MainTex_TexelSize * float4(-1.0, 0.0, 1.0, 0.0);
                tmp1 = tmp1 * _BloomParams + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp0.xyz = tmp2.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp2.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp2 = tex2D(_AnamorphicRTS0, tmp2.xy);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp0.xyz = tmp3.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp1 = _MainTex_TexelSize * float4(-1.0, 1.0, 0.0, 1.0);
                tmp1 = tmp1 * _BloomParams + inp.texcoord.xyxy;
                tmp1 = tmp1 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp3.xyz = tmp3.xyz * _BloomRange.xxx;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp0.xyz = tmp3.xyz * float3(0.0625, 0.0625, 0.0625) + tmp0.xyz;
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.125, 0.125, 0.125) + tmp0.xyz;
                tmp1.xy = _MainTex_TexelSize.xy * _BloomParams.zz + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.0625, 0.0625, 0.0625) + tmp0.xyz;
                tmp1.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp1.xyz * tmp2.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_WEIGHTEDADDPS1"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1266557
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
			float4 _AnamorphicGlareWeights0;
			float4 _MainTex_ST;
			float4 _BloomRange;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AnamorphicRTS0;
			
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
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _AnamorphicGlareWeights0.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_WEIGHTEDADDPS2"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1368325
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
			float4 _AnamorphicGlareWeights0;
			float4 _AnamorphicGlareWeights1;
			float4 _MainTex_ST;
			float4 _BloomRange;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			
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
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _AnamorphicGlareWeights1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _AnamorphicGlareWeights0.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_WEIGHTEDADDPS3"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1415447
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
			float4 _AnamorphicGlareWeights0;
			float4 _AnamorphicGlareWeights1;
			float4 _AnamorphicGlareWeights2;
			float4 _MainTex_ST;
			float4 _BloomRange;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _AnamorphicGlareWeights1.xyz;
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights0.xyz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _AnamorphicGlareWeights2.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_WEIGHTEDADDPS4"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1493208
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
			float4 _AnamorphicGlareWeights0;
			float4 _AnamorphicGlareWeights1;
			float4 _AnamorphicGlareWeights2;
			float4 _AnamorphicGlareWeights3;
			float4 _MainTex_ST;
			float4 _BloomRange;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			sampler2D _AnamorphicRTS3;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _AnamorphicGlareWeights1.xyz;
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights0.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS3, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights2.xyz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _AnamorphicGlareWeights3.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_WEIGHTEDADDPS5"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1556122
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
			float4 _AnamorphicGlareWeights0;
			float4 _AnamorphicGlareWeights1;
			float4 _AnamorphicGlareWeights2;
			float4 _AnamorphicGlareWeights3;
			float4 _AnamorphicGlareWeights4;
			float4 _MainTex_ST;
			float4 _BloomRange;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			sampler2D _AnamorphicRTS3;
			sampler2D _AnamorphicRTS4;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _AnamorphicGlareWeights1.xyz;
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights0.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights2.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS3, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS4, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights3.xyz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _AnamorphicGlareWeights4.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_WEIGHTEDADDPS6"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1575873
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
			float4 _AnamorphicGlareWeights0;
			float4 _AnamorphicGlareWeights1;
			float4 _AnamorphicGlareWeights2;
			float4 _AnamorphicGlareWeights3;
			float4 _AnamorphicGlareWeights4;
			float4 _AnamorphicGlareWeights5;
			float4 _MainTex_ST;
			float4 _BloomRange;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			sampler2D _AnamorphicRTS3;
			sampler2D _AnamorphicRTS4;
			sampler2D _AnamorphicRTS5;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _AnamorphicGlareWeights1.xyz;
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights0.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights2.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS3, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights3.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS4, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS5, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights4.xyz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _AnamorphicGlareWeights5.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_WEIGHTEDADDPS7"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1676903
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
			float4 _AnamorphicGlareWeights0;
			float4 _AnamorphicGlareWeights1;
			float4 _AnamorphicGlareWeights2;
			float4 _AnamorphicGlareWeights3;
			float4 _AnamorphicGlareWeights4;
			float4 _AnamorphicGlareWeights5;
			float4 _AnamorphicGlareWeights6;
			float4 _MainTex_ST;
			float4 _BloomRange;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			sampler2D _AnamorphicRTS3;
			sampler2D _AnamorphicRTS4;
			sampler2D _AnamorphicRTS5;
			sampler2D _AnamorphicRTS6;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _AnamorphicGlareWeights1.xyz;
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights0.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights2.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS3, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights3.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS4, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights4.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS5, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS6, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights5.xyz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _AnamorphicGlareWeights6.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_WEIGHTEDADDPS8"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1732158
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
			float4 _AnamorphicGlareWeights0;
			float4 _AnamorphicGlareWeights1;
			float4 _AnamorphicGlareWeights2;
			float4 _AnamorphicGlareWeights3;
			float4 _AnamorphicGlareWeights4;
			float4 _AnamorphicGlareWeights5;
			float4 _AnamorphicGlareWeights6;
			float4 _AnamorphicGlareWeights7;
			float4 _MainTex_ST;
			float4 _BloomRange;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			sampler2D _AnamorphicRTS3;
			sampler2D _AnamorphicRTS4;
			sampler2D _AnamorphicRTS5;
			sampler2D _AnamorphicRTS6;
			sampler2D _AnamorphicRTS7;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1.xyz = tmp1.xyz * _BloomRange.xxx;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _AnamorphicGlareWeights1.xyz;
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights0.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights2.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS3, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights3.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS4, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights4.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS5, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights5.xyz * tmp2.xyz + tmp1.xyz;
                tmp2 = tex2D(_AnamorphicRTS6, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS7, tmp0.xy);
                tmp2.xyz = tmp2.xyz * _BloomRange.xxx;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.xyz = _AnamorphicGlareWeights6.xyz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _AnamorphicGlareWeights7.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _BloomRange.yyy;
                tmp0.w = max(tmp0.y, tmp0.x);
                tmp1.x = max(tmp0.z, 0.000001);
                tmp0.w = max(tmp0.w, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 255.0;
                tmp0.w = ceil(tmp0.w);
                tmp0.w = tmp0.w * 0.0039216;
                o.sv_target.xyz = tmp0.xyz / tmp0.www;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_BOKEHFILTERING"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1798795
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
			float4 _AnamorphicGlareWeights0;
			float4 _AnamorphicGlareWeights1;
			float4 _AnamorphicGlareWeights2;
			float4 _AnamorphicGlareWeights3;
			float4 _AnamorphicGlareWeights4;
			float4 _AnamorphicGlareWeights5;
			float4 _AnamorphicGlareWeights6;
			float4 _AnamorphicGlareWeights7;
			float4 _MainTex_ST;
			float4 _BokehParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
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
                tmp0.x = _BokehParams.z - _BokehParams.y;
                tmp0.x = _BokehParams.y / tmp0.x;
                tmp0.yz = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp0.y = tmp1.x * _ProjectionParams.z;
                tmp0.z = tmp1.x * _ProjectionParams.z + -_BokehParams.z;
                tmp0.y = abs(tmp0.z) / tmp0.y;
                tmp0.y = tmp0.y * _BokehParams.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 41.667;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = min(tmp0.x, _BokehParams.w);
                tmp0.yz = _AnamorphicGlareWeights1.xy * tmp0.xx + inp.texcoord.xy;
                tmp1.yz = tmp0.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp0.y = tmp2.x < tmp1.x;
                tmp2 = tex2D(_MainTex, tmp1.yz);
                tmp0.z = tmp2.w + 0.02;
                tmp0.z = tmp0.z < tmp0.x;
                tmp0.w = saturate(tmp0.x * 30.0);
                tmp0.y = tmp0.y ? tmp0.w : 1.0;
                tmp0.y = tmp0.z ? tmp0.y : 1.0;
                tmp2 = tmp0.yyyy * tmp2;
                tmp1.yz = _AnamorphicGlareWeights0.xy * tmp0.xx + inp.texcoord.xy;
                tmp3.xy = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp0.z = tmp4.x < tmp1.x;
                tmp0.z = tmp0.z ? tmp0.w : 1.0;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp1.y = tmp3.w + 0.02;
                tmp1.y = tmp1.y < tmp0.x;
                tmp0.z = tmp1.y ? tmp0.z : 1.0;
                tmp2 = tmp3 * tmp0.zzzz + tmp2;
                tmp0.y = tmp0.y + tmp0.z;
                tmp1.yz = _AnamorphicGlareWeights2.xy * tmp0.xx + inp.texcoord.xy;
                tmp3.xy = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp0.z = tmp4.x < tmp1.x;
                tmp0.z = tmp0.z ? tmp0.w : 1.0;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp1.y = tmp3.w + 0.02;
                tmp1.y = tmp1.y < tmp0.x;
                tmp0.z = tmp1.y ? tmp0.z : 1.0;
                tmp2 = tmp3 * tmp0.zzzz + tmp2;
                tmp0.y = tmp0.z + tmp0.y;
                tmp1.yz = _AnamorphicGlareWeights3.xy * tmp0.xx + inp.texcoord.xy;
                tmp3.xy = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp0.z = tmp4.x < tmp1.x;
                tmp0.z = tmp0.z ? tmp0.w : 1.0;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp1.y = tmp3.w + 0.02;
                tmp1.y = tmp1.y < tmp0.x;
                tmp0.z = tmp1.y ? tmp0.z : 1.0;
                tmp2 = tmp3 * tmp0.zzzz + tmp2;
                tmp0.y = tmp0.z + tmp0.y;
                tmp1.yz = _AnamorphicGlareWeights4.xy * tmp0.xx + inp.texcoord.xy;
                tmp3.xy = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp0.z = tmp4.x < tmp1.x;
                tmp0.z = tmp0.z ? tmp0.w : 1.0;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp1.y = tmp3.w + 0.02;
                tmp1.y = tmp1.y < tmp0.x;
                tmp0.z = tmp1.y ? tmp0.z : 1.0;
                tmp2 = tmp3 * tmp0.zzzz + tmp2;
                tmp0.y = tmp0.z + tmp0.y;
                tmp1.yz = _AnamorphicGlareWeights5.xy * tmp0.xx + inp.texcoord.xy;
                tmp3.xy = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp0.z = tmp4.x < tmp1.x;
                tmp0.z = tmp0.z ? tmp0.w : 1.0;
                tmp3 = tex2D(_MainTex, tmp3.xy);
                tmp1.y = tmp3.w + 0.02;
                tmp1.y = tmp1.y < tmp0.x;
                tmp0.z = tmp1.y ? tmp0.z : 1.0;
                tmp2 = tmp3 * tmp0.zzzz + tmp2;
                tmp0.y = tmp0.z + tmp0.y;
                tmp1.yz = _AnamorphicGlareWeights6.xy * tmp0.xx + inp.texcoord.xy;
                tmp3 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp1.yz = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp1.yz);
                tmp0.z = tmp3.x < tmp1.x;
                tmp0.z = tmp0.z ? tmp0.w : 1.0;
                tmp1.y = tmp4.w + 0.02;
                tmp1.y = tmp1.y < tmp0.x;
                tmp0.z = tmp1.y ? tmp0.z : 1.0;
                tmp2 = tmp4 * tmp0.zzzz + tmp2;
                tmp0.y = tmp0.z + tmp0.y;
                tmp1.yz = _AnamorphicGlareWeights7.xy * tmp0.xx + inp.texcoord.xy;
                tmp3 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp1.yz = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp1.yz);
                tmp0.z = tmp3.x < tmp1.x;
                tmp0.z = tmp0.z ? tmp0.w : 1.0;
                tmp0.w = tmp4.w + 0.02;
                tmp0.x = tmp0.w < tmp0.x;
                tmp0.x = tmp0.x ? tmp0.z : 1.0;
                tmp1 = tmp4 * tmp0.xxxx + tmp2;
                tmp0.x = tmp0.x + tmp0.y;
                o.sv_target = tmp1 / tmp0.xxxx;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_BOKEHCOMPOSITION2S"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1896548
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			
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
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS0, tmp0.xy);
                o.sv_target = min(tmp0, tmp1);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_BOKEHCOMPOSITION3S"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1928692
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                o.sv_target = min(tmp0, tmp1);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_BOKEHCOMPOSITION4S"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 1970973
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                tmp2 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                o.sv_target = min(tmp0, tmp1);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_BOKEHCOMPOSITION5S"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2037649
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			sampler2D _AnamorphicRTS3;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                tmp2 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                tmp2 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS3, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                o.sv_target = min(tmp0, tmp1);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_BOKEHCOMPOSITION6S"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2146305
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _AnamorphicRTS0;
			sampler2D _AnamorphicRTS1;
			sampler2D _AnamorphicRTS2;
			sampler2D _AnamorphicRTS3;
			sampler2D _AnamorphicRTS4;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.xy);
                tmp2 = tex2D(_AnamorphicRTS0, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                tmp2 = tex2D(_AnamorphicRTS1, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                tmp2 = tex2D(_AnamorphicRTS2, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                tmp2 = tex2D(_AnamorphicRTS3, tmp0.xy);
                tmp0 = tex2D(_AnamorphicRTS4, tmp0.xy);
                tmp1 = min(tmp1, tmp2);
                o.sv_target = min(tmp0, tmp1);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FRAG_DECODE"
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 2201580
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
			float4 _BloomRange;
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
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * _BloomRange.xxx;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
}