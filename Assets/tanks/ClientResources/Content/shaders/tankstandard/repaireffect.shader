Shader "Alternativa/RepairEffect" {
	Properties {
		_RepairStubColor ("Repair Stub Color", Color) = (1,1,1,1)
		_RepairFrontCoeff ("Repair Front Coeff", Range(0, 1)) = 0
		_RepairMovementDirection ("Repair Movement Direction", Range(0, 1)) = 1
		_RepairBackCoeff ("Repair back coeff", Range(0, 1)) = 0.78
		_RepairAdditionalLengthExtension ("Repair Length extension", Float) = 10
		_RepairVolume ("Repair volume", Vector) = (1.502808,0.778753,2.34775,0)
		_RepairCenter ("Repair Center", Vector) = (0,-0.02930036,0.60568,0)
		_RepairTex ("Repair Effect Texture", 2D) = "white" {}
		_RepairFadeAlphaRange ("Repair Fade alpha range", Range(0, 1)) = 0.92
		_RepairAlpha ("Repair alpha", Range(0, 1)) = 1
		_RepairRotationAngle ("Repair Rotation Angle", Range(-10, 10)) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			ColorMask RGB
			ZClip Off
			GpuProgramID 30308
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _RepairStubColor;
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.x = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0 = glstate_lightmodel_ambient * float4(2.0, 2.0, 2.0, 2.0) + tmp0.xxxx;
                o.sv_target = tmp0 * _RepairStubColor;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "REPAIR_EFFECT_PASS"
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZClip Off
			Offset 0, -2
			GpuProgramID 87879
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
			float4 _RepairTex_ST;
			float _RepairFrontCoeff;
			float _RepairBackCoeff;
			float _RepairMovementDirection;
			float _RepairFadeAlphaRange;
			float _RepairAlpha;
			float _RepairAdditionalLengthExtension;
			float _RepairRotationAngle;
			float4 _RepairCenter;
			float4 _RepairVolume;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RepairTex;
			
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
                o.texcoord = v.vertex;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = sin(_RepairRotationAngle);
                tmp1.x = cos(_RepairRotationAngle);
                tmp0.yz = abs(tmp1.xx) * _RepairVolume.xz;
                tmp0.yz = _RepairVolume.zx * abs(tmp0.xx) + tmp0.yz;
                tmp0.z = tmp0.z + _RepairAdditionalLengthExtension;
                tmp0.w = tmp0.z * _RepairMovementDirection;
                tmp1.y = tmp0.w * -2.0 + -tmp0.z;
                tmp0.w = tmp0.w * -2.0;
                tmp0.w = tmp0.z * 3.0 + tmp0.w;
                tmp0.z = tmp0.z + tmp0.z;
                tmp2.xyz = inp.texcoord.xyz - _RepairCenter.xyz;
                tmp1.zw = tmp0.xx * tmp2.zx;
                tmp0.x = tmp2.z * tmp1.x + tmp1.w;
                tmp1.x = tmp2.x * tmp1.x + -tmp1.z;
                tmp1.z = tmp2.y / _RepairVolume.y;
                tmp1.z = min(tmp1.z, 1.0);
                tmp2.y = max(tmp1.z, -1.0);
                tmp0.y = tmp1.x / tmp0.y;
                tmp0.y = min(tmp0.y, 1.0);
                tmp2.x = max(tmp0.y, -1.0);
                tmp0.y = tmp0.x - tmp1.y;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = tmp0.w - tmp0.x;
                tmp0.w = tmp0.w - tmp1.y;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = _RepairFrontCoeff * -2.0 + 1.0;
                tmp0.y = _RepairMovementDirection * tmp0.y + _RepairFrontCoeff;
                tmp0.y = tmp0.y * tmp0.w + tmp1.y;
                tmp0.w = tmp2.x * tmp2.y + _Time.y;
                tmp1.xy = tmp2.xy + float2(-0.0, 2.0);
                tmp2.xyz = _RepairCenter.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * _RepairCenter.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * _RepairCenter.zzz + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m03_m13_m23 * _RepairCenter.www + tmp2.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - tmp2.xyz;
                tmp1.z = dot(tmp2.xyz, tmp2.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp1.z = tmp1.z * tmp2.x;
                tmp1.w = sqrt(abs(tmp0.x));
                tmp0.w = tmp1.w * tmp1.z + tmp0.w;
                tmp0.w = tmp0.w * 10.0;
                tmp0.w = sin(tmp0.w);
                tmp0.y = tmp0.w * 0.1 + tmp0.y;
                tmp0.w = tmp0.x - tmp0.y;
                tmp1.z = tmp0.y - tmp0.x;
                tmp0.w = tmp0.w - tmp1.z;
                tmp0.w = _RepairMovementDirection * tmp0.w + tmp1.z;
                tmp1.z = tmp0.w - 0.005;
                tmp0.w = tmp0.w / tmp0.z;
                tmp2.y = saturate(1.0 - tmp0.w);
                tmp0.w = tmp1.z < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = _RepairBackCoeff * tmp0.z + tmp0.y;
                tmp0.z = -_RepairBackCoeff * tmp0.z + tmp0.y;
                tmp0.w = tmp0.w - tmp0.z;
                tmp0.z = _RepairMovementDirection * tmp0.w + tmp0.z;
                tmp0.w = tmp0.z - tmp0.x;
                tmp0.xy = tmp0.xy - tmp0.zz;
                tmp0.y = abs(tmp0.y) * _RepairFadeAlphaRange;
                tmp0.z = tmp0.w - tmp0.x;
                tmp0.x = _RepairMovementDirection * tmp0.z + tmp0.x;
                tmp0.z = tmp0.x - 0.005;
                tmp0.x = saturate(tmp0.x / tmp0.y);
                tmp0.y = tmp0.z < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = dot(tmp1.xy, tmp1.xy);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.z = tmp0.y * tmp1.y;
                tmp0.y = -tmp1.y * tmp0.y + 1.0;
                tmp0.y = sqrt(tmp0.y);
                tmp0.w = tmp0.z * -0.0187293 + 0.074261;
                tmp0.w = tmp0.w * tmp0.z + -0.2121144;
                tmp0.z = tmp0.w * tmp0.z + 1.570729;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.y * _RepairMovementDirection;
                tmp0.z = tmp0.z * -0.6366197;
                tmp2.x = tmp0.y * 0.3183099 + tmp0.z;
                tmp0.yz = tmp2.xy * _RepairTex_ST.xy + _RepairTex_ST.zw;
                tmp1.xy = ddx(tmp0.yz);
                tmp1.zw = ddy(tmp0.yz);
                tmp1 = tex2Dgrad(_RepairTex, tmp0.yz, tmp1.xyxx, tmp1.zwzz);
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                o.sv_target.w = tmp0.x * _RepairAlpha;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}