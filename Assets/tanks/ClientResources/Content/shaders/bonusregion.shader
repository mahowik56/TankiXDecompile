Shader "TankiOnline/Bonus Region" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		_SideTint ("Side Tint", Color) = (1,1,1,1)
		_FrontTint ("Front Tint", Color) = (1,1,1,1)
		_EmissionIntensity ("Emission Intensity", Float) = 4
		[Space] _HidingCenter ("Hide Center  - XYZ", Vector) = (0,0,0,0)
		_MinHidingRadius ("Min Hiding Radius", Float) = 0
		_MaxHidingRadius ("Max Hiding Radius", Float) = 0
		_HidingSpeed ("HidingSpeed", Float) = 0
		_HidingStartTime ("Hiding Start Time", Float) = 0
	}
	SubShader {
		LOD 400
		Tags { "PreviewType" = "Sphere" "QUEUE" = "Transparent+100" "RenderType" = "Transparent" }
		Pass {
			LOD 400
			Tags { "PreviewType" = "Sphere" "QUEUE" = "Transparent+100" "RenderType" = "Transparent" }
			Blend SrcAlpha One, SrcAlpha One
			ZClip Off
			ZWrite Off
			GpuProgramID 47244
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 texcoord1 : TEXCOORD1;
				float texcoord2 : TEXCOORD2;
				float4 position : SV_POSITION0;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _HidingCenter;
			float _MinHidingRadius;
			float _MaxHidingRadius;
			float _HidingSpeed;
			float _HidingStartTime;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _SideTint;
			float4 _FrontTint;
			float _EmissionIntensity;
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
                o.texcoord1 = v.vertex;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz - _HidingCenter.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.y = _Time.y - _HidingStartTime;
                tmp0.y = saturate(tmp0.y * _HidingSpeed);
                tmp0.z = _MaxHidingRadius - _MinHidingRadius;
                tmp0.y = tmp0.y * tmp0.z + _MinHidingRadius;
                o.texcoord2.x = saturate(tmp0.x / tmp0.y);
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord3 = v.normal;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.y = inp.texcoord1.y - _Time.x;
                tmp0.x = 0.0;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp1 = _FrontTint - _SideTint;
                tmp1 = abs(inp.texcoord3.zzzz) * tmp1 + _SideTint;
                tmp1 = tmp1 * _Color;
                tmp1 = tmp1 * _EmissionIntensity.xxxx;
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                tmp0.x = max(tmp0.x, 0.0);
                o.sv_target.w = min(tmp0.x, inp.texcoord2.x);
                return o;
			}
			ENDCG
		}
	}
}