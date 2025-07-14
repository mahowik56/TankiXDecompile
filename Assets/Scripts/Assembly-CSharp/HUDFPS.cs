using UnityEngine;

public class HUDFPS : MonoBehaviour
{
	public KeyCode toggleKey = KeyCode.F8;

	public bool show = true;

	public Rect startRect = new Rect(10f, 10f, 75f, 50f);

	public bool updateColor = true;

	public bool allowDrag = true;

	public float frequency = 0.5f;

	public int nbDecimal = 1;

	public bool limitFrameRate;

	public int frameRate = 60;

	private float accum;

	private int frames;

	private Color color = Color.white;

	private string sFPS = string.Empty;

	private GUIStyle style;

	private float updateTimer;

	private void Start()
	{
		if (limitFrameRate)
		{
			Application.targetFrameRate = frameRate;
		}
		updateTimer = frequency;
	}

	private void Update()
	{
		if (Input.GetKeyUp(toggleKey))
		{
			show = !show;
			accum = 0f;
			frames = 0;
			updateTimer = frequency;
		}
		if (show)
		{
			accum += Time.timeScale / Time.deltaTime;
			frames++;
			updateTimer -= Time.deltaTime;
			if (updateTimer <= 0f)
			{
				CalcCurrentFPS();
				updateTimer = frequency;
			}
		}
	}

	private void CalcCurrentFPS()
	{
		float num = accum / (float)frames;
		sFPS = num.ToString("f" + Mathf.Clamp(nbDecimal, 0, 10)) + " FPS";
		color = ((num >= 30f) ? Color.green : ((!(num > 10f)) ? Color.yellow : Color.red));
		accum = 0f;
		frames = 0;
	}

	private void OnGUI()
	{
		if (show)
		{
			if (style == null)
			{
				style = new GUIStyle(GUI.skin.label);
				style.normal.textColor = Color.white;
				style.alignment = TextAnchor.MiddleCenter;
			}
			GUI.color = ((!updateColor) ? Color.white : color);
			startRect = GUI.Window(0, startRect, DoMyWindow, string.Empty);
		}
	}

	private void DoMyWindow(int windowID)
	{
		GUI.Label(new Rect(0f, 0f, startRect.width, startRect.height), sFPS, style);
		if (allowDrag)
		{
			GUI.DragWindow(new Rect(0f, 0f, Screen.width, Screen.height));
		}
	}
}
