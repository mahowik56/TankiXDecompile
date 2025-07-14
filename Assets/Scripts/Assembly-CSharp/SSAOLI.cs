using System;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.ImageEffects;

[RequireComponent(typeof(Camera))]
[RequireComponent(typeof(BlurOptimized))]
public class SSAOLI : MonoBehaviour
{
	public float radius = 2f;

	public float maxDistance = 2f;

	public float intensity = 2f;

	private List<Vector4> samples;

	private Texture2D rotationMap;

	private float uvRadiusDepth1;

	public Shader ssaoShader;

	private Material ssaoMaterial;

	private BlurOptimized blur;

	private void Awake()
	{
		ssaoMaterial = new Material(ssaoShader);
		blur = GetComponent<BlurOptimized>();
		blur.enabled = false;
		uvRadiusDepth1 = CalculateUVRadiusDepth1();
		samples = CalculateSamples();
		rotationMap = CreateRotationMap();
	}

	[ImageEffectOpaque]
	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		ssaoMaterial.SetTexture("_RotationMap", rotationMap);
		ssaoMaterial.SetFloat("centerVolume", samples[0].w);
		ssaoMaterial.SetFloat("uvRadiusDepth1", uvRadiusDepth1);
		ssaoMaterial.SetFloat("radius", radius);
		ssaoMaterial.SetFloat("maxDistance", maxDistance);
		ssaoMaterial.SetFloat("intensity", intensity);
		for (int i = 1; i < samples.Count; i++)
		{
			ssaoMaterial.SetVector("sample" + i, samples[i]);
		}
		RenderTexture temporary = RenderTexture.GetTemporary(source.width, source.height, 0);
		Graphics.Blit(source, temporary, ssaoMaterial, 0);
		RenderTexture temporary2 = RenderTexture.GetTemporary(source.width, source.height, 0);
		blur.OnRenderImage(temporary, temporary2);
		RenderTexture.ReleaseTemporary(temporary);
		ssaoMaterial.SetTexture("_SSAO", temporary2);
		Graphics.Blit(source, destination, ssaoMaterial, 1);
		RenderTexture.ReleaseTemporary(temporary2);
	}

	private float CalculateUVRadiusDepth1()
	{
		Camera component = GetComponent<Camera>();
		Vector4 vector = component.transform.localToWorldMatrix.MultiplyPoint(new Vector3(radius, 0f, 1f));
		return component.WorldToViewportPoint(vector).x - 0.5f;
	}

	private Texture2D CreateRotationMap()
	{
		Texture2D texture2D = new Texture2D(4, 4, TextureFormat.RGBA32, false);
		texture2D.wrapMode = TextureWrapMode.Repeat;
		float num = 0f;
		for (int i = 0; i < 4; i++)
		{
			for (int j = 0; j < 4; j++)
			{
				texture2D.SetPixel(i, j, new Color(Mathf.Sin(num), Mathf.Cos(num), 0f));
				num += (float)Math.PI / 16f;
			}
		}
		texture2D.Apply();
		return texture2D;
	}

	private List<Vector4> CalculateSamples()
	{
		List<Vector4> result = CreateSamples();
		CalculateSampleVolumes(result);
		RemovePairSamples(result);
		return result;
	}

	private void RemovePairSamples(List<Vector4> samples)
	{
		for (int num = samples.Count - 1; num > 1; num -= 2)
		{
			samples.RemoveAt(num);
		}
	}

	private void CalculateSampleVolumes(List<Vector4> samples)
	{
		float num = 0f;
		for (int i = 0; i < 256; i++)
		{
			for (int j = 0; j < 256; j++)
			{
				if (IsPointInsideCircle(i, j, 128))
				{
					int index = FindClosestSample(i, j, 128, samples);
					Vector4 value = samples[index];
					float num2 = CalculateLengthInSphere((float)(128 - i) / 128f, (float)(128 - j) / 128f);
					value.w += num2;
					samples[index] = value;
					num += num2;
				}
			}
		}
		for (int k = 0; k < samples.Count; k++)
		{
			Vector4 value2 = samples[k];
			value2.w /= num;
			samples[k] = value2;
		}
	}

	private float CalculateLengthInSphere(float x, float y)
	{
		return 2f * Mathf.Sqrt(1f - (x * x + y * y));
	}

	private static int FindClosestSample(int x, int y, int radius, List<Vector4> samples)
	{
		float num = float.MaxValue;
		int result = -1;
		for (int i = 0; i < samples.Count; i++)
		{
			float num2 = samples[i].x * (float)radius + (float)radius;
			float num3 = samples[i].y * (float)radius + (float)radius;
			float num4 = ((float)x - num2) * ((float)x - num2) + ((float)y - num3) * ((float)y - num3);
			if (num4 < num)
			{
				num = num4;
				result = i;
			}
		}
		return result;
	}

	private static bool IsPointInsideCircle(int i, int j, int radius)
	{
		int num = radius - i;
		int num2 = radius - j;
		double num3 = num * num + num2 * num2;
		return num3 < (double)(radius * radius);
	}

	private List<Vector4> CreateSamples()
	{
		List<Vector4> list = new List<Vector4>();
		Vector4 item = new Vector4
		{
			x = 0f,
			y = 0f,
			z = CalculateLengthInSphere(0f, 0f)
		};
		list.Add(item);
		float num = (float)Math.PI / 3f;
		float num2 = 0f;
		for (int i = 1; i <= 3; i++)
		{
			float num3 = (float)i / 3.5f;
			Vector4 item2 = default(Vector4);
			item2.x = (0f - num3) * Mathf.Sin(0f - num2);
			item2.y = num3 * Mathf.Cos(0f - num2);
			item2.z = CalculateLengthInSphere(item2.x, item2.y);
			Vector4 item3 = new Vector4
			{
				x = 0f - item2.x,
				y = 0f - item2.y,
				z = item2.z
			};
			list.Add(item2);
			list.Add(item3);
			num2 += num;
		}
		return list;
	}
}
