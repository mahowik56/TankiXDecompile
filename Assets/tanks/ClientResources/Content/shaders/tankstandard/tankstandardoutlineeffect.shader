Shader "Alternativa/TankStandardOutlineEffect" {
	Properties {
		_OutlineColor ("Outline color", Color) = (1,1,1,1)
		_Alpha ("Alpha", Range(0, 1)) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
		GrabPass {
			"_TankPartOutlineEffectGrabTexture"
		}
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			Stencil {
				Ref 11
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 41580
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _TankPartOutlineEffectGrabTexture;
			
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.xyz = tmp0.xwy * float3(0.5, 0.5, -0.5);
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp1.yy + tmp1.xz;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.xy = inp.texcoord.xy / inp.texcoord.ww;
                o.sv_target = tex2D(_TankPartOutlineEffectGrabTexture, tmp0.xy);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "OUTLINE_EFFECT_PASS"
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			Offset 0, -1
			Stencil {
				Ref 11
				Comp NotEqual
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 123811
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _GlobalTankOutlineScaleMultiplier;
			float _WorkingOutlineCoeff;
			// $Globals ConstantBuffers for Fragment Shader
			float _GlobalTankOutlineEffectAlpha;
			float4 _WorldSpaceEffectCenter;
			float _TankOutlineEffectRadius;
			float4 _OutlineColor;
			float _Alpha;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xyz = _WorldSpaceCameraPos - unity_ObjectToWorld._m03_m13_m23;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x - 8.0;
                tmp0.x = saturate(tmp0.x * 0.0083333);
                tmp0.x = tmp0.x * 0.28 + 1.02;
                tmp0.y = tmp0.x * _GlobalTankOutlineScaleMultiplier + -tmp0.x;
                tmp0.x = _WorkingOutlineCoeff * tmp0.y + tmp0.x;
                tmp0.xyz = tmp0.xxx * v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.xyz = inp.texcoord.xyz - _WorldSpaceEffectCenter.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.y = _TankOutlineEffectRadius - 10.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.y = _TankOutlineEffectRadius - tmp0.y;
                tmp0.x = saturate(tmp0.x / tmp0.y);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = _GlobalTankOutlineEffectAlpha * _Alpha;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.w = tmp0.x * _OutlineColor.w;
                o.sv_target.xyz = _OutlineColor.xyz;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}