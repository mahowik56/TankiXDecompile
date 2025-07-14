using System;
using System.Collections;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Renderer))]
[AddComponentMenu("Tasharen/Water")]
public class TasharenWater : MonoBehaviour
{
	public enum Quality
	{
		Fastest = 0,
		Low = 1,
		Medium = 2,
		High = 3,
		Uber = 4
	}

	public static TasharenWater instance;

	public Quality quality = Quality.High;

	public LayerMask highReflectionMask = -1;

	public LayerMask mediumReflectionMask = -1;

	public bool keepUnderCamera = true;

	public bool automaticQuality = true;

	private Transform mTrans;

	private Hashtable mCameras = new Hashtable();

	private RenderTexture mTex;

	private int mTexSize;

	private Renderer mRen;

	private Color mSpecular;

	private bool mDepthTexSupport;

	private bool mStreamingWater;

	private static bool mIsRendering = false;

	private static Vector3 mTemp = Vector4.one;

	[NonSerialized]
	private Vector4 mReflectionPlane;

	[NonSerialized]
	private Texture2D mDepthTex;

	[NonSerialized]
	private bool mDepthTexIsValid;

	public bool depthTextureSupport
	{
		get
		{
			return mDepthTexSupport;
		}
	}

	public int reflectionTextureSize
	{
		get
		{
			switch (quality)
			{
			case Quality.Uber:
				return 1024;
			case Quality.Medium:
			case Quality.High:
				return 512;
			default:
				return 0;
			}
		}
	}

	public LayerMask reflectionMask
	{
		get
		{
			switch (quality)
			{
			case Quality.High:
			case Quality.Uber:
				return highReflectionMask;
			case Quality.Medium:
				return mediumReflectionMask;
			default:
				return 0;
			}
		}
	}

	public bool useRefraction
	{
		get
		{
			return quality > Quality.Fastest;
		}
	}

	private static float SignExt(float a)
	{
		if (a > 0f)
		{
			return 1f;
		}
		if (a < 0f)
		{
			return -1f;
		}
		return 0f;
	}

	private static void CalculateObliqueMatrix(ref Matrix4x4 projection, Vector4 clipPlane)
	{
		mTemp.x = SignExt(clipPlane.x);
		mTemp.y = SignExt(clipPlane.y);
		Vector4 b = projection.inverse * mTemp;
		Vector4 vector = clipPlane * (2f / Vector4.Dot(clipPlane, b));
		projection[2] = vector.x - projection[3];
		projection[6] = vector.y - projection[7];
		projection[10] = vector.z - projection[11];
		projection[14] = vector.w - projection[15];
	}

	private static void CalculateReflectionMatrix(ref Matrix4x4 reflectionMat, Vector4 plane)
	{
		reflectionMat.m00 = 1f - 2f * plane[0] * plane[0];
		reflectionMat.m01 = -2f * plane[0] * plane[1];
		reflectionMat.m02 = -2f * plane[0] * plane[2];
		reflectionMat.m03 = -2f * plane[3] * plane[0];
		reflectionMat.m10 = -2f * plane[1] * plane[0];
		reflectionMat.m11 = 1f - 2f * plane[1] * plane[1];
		reflectionMat.m12 = -2f * plane[1] * plane[2];
		reflectionMat.m13 = -2f * plane[3] * plane[1];
		reflectionMat.m20 = -2f * plane[2] * plane[0];
		reflectionMat.m21 = -2f * plane[2] * plane[1];
		reflectionMat.m22 = 1f - 2f * plane[2] * plane[2];
		reflectionMat.m23 = -2f * plane[3] * plane[2];
		reflectionMat.m30 = 0f;
		reflectionMat.m31 = 0f;
		reflectionMat.m32 = 0f;
		reflectionMat.m33 = 1f;
	}

	public static Quality GetQuality()
	{
		return (Quality)PlayerPrefs.GetInt("Water", 3);
	}

	public static void SetQuality(Quality q)
	{
		TasharenWater[] array = UnityEngine.Object.FindObjectsOfType(typeof(TasharenWater)) as TasharenWater[];
		if (array.Length > 0)
		{
			TasharenWater[] array2 = array;
			foreach (TasharenWater tasharenWater in array2)
			{
				tasharenWater.quality = q;
			}
		}
		else
		{
			PlayerPrefs.SetInt("Water", (int)q);
		}
	}

	private void Awake()
	{
		mTrans = base.transform;
		mRen = GetComponent<Renderer>();
		mSpecular = new Color32(147, 147, 147, byte.MaxValue);
		mDepthTexSupport = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.Depth);
	}

	private void OnEnable()
	{
		instance = this;
		mStreamingWater = PlayerPrefs.GetInt("Streaming Water", 0) == 1;
		if (automaticQuality)
		{
			quality = GetQuality();
		}
	}

	private void OnDisable()
	{
		Clear();
		foreach (DictionaryEntry mCamera in mCameras)
		{
			UnityEngine.Object.DestroyImmediate(((Camera)mCamera.Value).gameObject);
		}
		mCameras.Clear();
		if (instance == this)
		{
			instance = null;
		}
	}

	private void Clear()
	{
		if ((bool)mTex)
		{
			UnityEngine.Object.DestroyImmediate(mTex);
			mTex = null;
		}
	}

	private void CopyCamera(Camera src, Camera dest)
	{
		dest.clearFlags = src.clearFlags;
		dest.backgroundColor = src.backgroundColor;
		dest.farClipPlane = src.farClipPlane;
		dest.nearClipPlane = src.nearClipPlane;
		dest.orthographic = src.orthographic;
		dest.fieldOfView = src.fieldOfView;
		dest.aspect = src.aspect;
		dest.orthographicSize = src.orthographicSize;
		dest.depthTextureMode = DepthTextureMode.None;
		dest.renderingPath = RenderingPath.Forward;
	}

	private Camera GetReflectionCamera(Camera current, Material mat, int textureSize)
	{
		if (!mTex || mTexSize != textureSize)
		{
			if ((bool)mTex)
			{
				UnityEngine.Object.DestroyImmediate(mTex);
			}
			mTex = new RenderTexture(textureSize, textureSize, 16);
			mTex.name = "__MirrorReflection" + GetInstanceID();
			mTex.isPowerOfTwo = true;
			mTex.hideFlags = HideFlags.DontSave;
			mTexSize = textureSize;
		}
		Camera camera = mCameras[current] as Camera;
		if (!camera)
		{
			GameObject gameObject = new GameObject("Mirror Refl Camera id" + GetInstanceID() + " for " + current.GetInstanceID(), typeof(Camera), typeof(Skybox));
			gameObject.hideFlags = HideFlags.HideAndDontSave;
			camera = gameObject.GetComponent<Camera>();
			camera.enabled = false;
			Transform transform = camera.transform;
			transform.position = mTrans.position;
			transform.rotation = mTrans.rotation;
			camera.gameObject.AddComponent<FlareLayer>();
			mCameras[current] = camera;
		}
		if (mat.HasProperty("_ReflectionTex"))
		{
			mat.SetTexture("_ReflectionTex", mTex);
		}
		return camera;
	}

	private Vector4 CameraSpacePlane(Camera cam, Vector3 pos, Vector3 normal, float sideSign)
	{
		Matrix4x4 worldToCameraMatrix = cam.worldToCameraMatrix;
		Vector3 lhs = worldToCameraMatrix.MultiplyPoint(pos);
		Vector3 rhs = worldToCameraMatrix.MultiplyVector(normal).normalized * sideSign;
		return new Vector4(rhs.x, rhs.y, rhs.z, 0f - Vector3.Dot(lhs, rhs));
	}

	private void LateUpdate()
	{
		if (!keepUnderCamera)
		{
			return;
		}
		Camera main = Camera.main;
		if (!(main == null))
		{
			Transform transform = main.transform;
			Vector3 position = transform.position;
			position.y = mTrans.position.y;
			if (mTrans.position != position)
			{
				mTrans.position = position;
			}
		}
	}

	private void OnWillRenderObject()
	{
		if (mIsRendering)
		{
			return;
		}
		if (!base.enabled || !mRen || !mRen.enabled)
		{
			Clear();
			return;
		}
		Material sharedMaterial = mRen.sharedMaterial;
		if (!sharedMaterial)
		{
			return;
		}
		Camera current = Camera.current;
		if (!current)
		{
			return;
		}
		if (mStreamingWater)
		{
			sharedMaterial.SetColor("_Specular", Color.black);
		}
		else
		{
			sharedMaterial.SetColor("_Specular", mSpecular);
		}
		if (!mDepthTexSupport)
		{
			quality = Quality.Fastest;
		}
		if (quality == Quality.Fastest)
		{
			sharedMaterial.shader.maximumLOD = 100;
			int num = 256;
			float num2 = (float)num * 0.5f;
			sharedMaterial.SetFloat("_InvScale", 1f / (float)num);
			Terrain activeTerrain = Terrain.activeTerrain;
			float num3 = ((!(activeTerrain != null)) ? 0f : activeTerrain.transform.position.y);
			if (activeTerrain != null)
			{
				if (mDepthTex == null)
				{
					mDepthTexIsValid = false;
					mDepthTex = new Texture2D(num, num, TextureFormat.Alpha8, false);
				}
				if (!mDepthTexIsValid)
				{
					mDepthTexIsValid = true;
					Color32[] array = new Color32[num * num];
					float num4 = (float)(num + 1) / (float)num;
					for (int i = 0; i < num; i++)
					{
						float z = 0f - num2 + (float)i * num4;
						for (int j = 0; j < num; j++)
						{
							float x = 0f - num2 + (float)j * num4;
							float num5 = activeTerrain.SampleHeight(new Vector3(x, 0f, z)) + num3;
							if (num5 < 0f)
							{
								array[j + i * num].a = (byte)Mathf.RoundToInt(255f * Mathf.Clamp01((0f - num5) * 0.125f));
							}
							else
							{
								num5 = (int)(array[j + i * num].a = 0);
							}
						}
					}
					mDepthTex.SetPixels32(array);
					mDepthTex.wrapMode = TextureWrapMode.Clamp;
					mDepthTex.Apply();
				}
			}
			sharedMaterial.SetTexture("_DepthTex", mDepthTex);
			return;
		}
		if (quality == Quality.Low)
		{
			sharedMaterial.shader.maximumLOD = 200;
			Clear();
			return;
		}
		current.depthTextureMode |= DepthTextureMode.Depth;
		LayerMask layerMask = reflectionMask;
		int num6 = reflectionTextureSize;
		if ((int)layerMask == 0 || num6 < 512)
		{
			sharedMaterial.shader.maximumLOD = 300;
			Clear();
			return;
		}
		sharedMaterial.shader.maximumLOD = 400;
		mIsRendering = true;
		Camera reflectionCamera = GetReflectionCamera(current, sharedMaterial, num6);
		Vector3 position = mTrans.position;
		Vector3 up = mTrans.up;
		CopyCamera(current, reflectionCamera);
		float w = 0f - Vector3.Dot(up, position);
		mReflectionPlane.x = up.x;
		mReflectionPlane.y = up.y;
		mReflectionPlane.z = up.z;
		mReflectionPlane.w = w;
		Matrix4x4 reflectionMat = Matrix4x4.zero;
		CalculateReflectionMatrix(ref reflectionMat, mReflectionPlane);
		Vector3 position2 = current.transform.position;
		Vector3 position3 = reflectionMat.MultiplyPoint(position2);
		reflectionCamera.worldToCameraMatrix = current.worldToCameraMatrix * reflectionMat;
		Vector4 clipPlane = CameraSpacePlane(reflectionCamera, position, up, 1f);
		Matrix4x4 projection = current.projectionMatrix;
		CalculateObliqueMatrix(ref projection, clipPlane);
		reflectionCamera.projectionMatrix = projection;
		reflectionCamera.cullingMask = -17 & layerMask.value;
		reflectionCamera.targetTexture = mTex;
		GL.SetRevertBackfacing(true);
		reflectionCamera.transform.position = position3;
		Vector3 eulerAngles = current.transform.eulerAngles;
		eulerAngles.x = 0f;
		reflectionCamera.transform.eulerAngles = eulerAngles;
		reflectionCamera.Render();
		reflectionCamera.transform.position = position2;
		GL.SetRevertBackfacing(false);
		mIsRendering = false;
	}
}
