using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[ExecuteInEditMode]
public class CurvedUIInputModule : StandaloneInputModule
{
	public enum CUIControlMethod
	{
		MOUSE = 0,
		GAZE = 1,
		WORLD_MOUSE = 2,
		CUSTOM_RAY = 3,
		VIVE = 4,
		OCULUS_TOUCH = 5,
		GOOGLEVR = 7
	}

	public enum Hand
	{
		Both = 0,
		Right = 1,
		Left = 2
	}

	[SerializeField]
	private CUIControlMethod controlMethod;

	[SerializeField]
	private string submitButtonName = "Fire1";

	[SerializeField]
	private bool gazeUseTimedClick;

	[SerializeField]
	private float gazeClickTimer = 2f;

	[SerializeField]
	private float gazeClickTimerDelay = 1f;

	[SerializeField]
	private Image gazeTimedClickProgressImage;

	[SerializeField]
	private float worldSpaceMouseSensitivity = 1f;

	[SerializeField]
	private Hand usedHand = Hand.Right;

	private static bool disableOtherInputModulesOnStart = true;

	private static CurvedUIInputModule instance;

	private GameObject currentDragging;

	private GameObject currentPointedAt;

	private float gazeTimerProgress;

	private Ray customControllerRay;

	private float dragThreshold = 10f;

	private bool pressedDown;

	private bool pressedLastFrame;

	private Vector3 lastMouseOnScreenPos = Vector2.zero;

	private Vector2 worldSpaceMouseInCanvasSpace = Vector2.zero;

	private Vector2 lastWorldSpaceMouseOnCanvas = Vector2.zero;

	private Vector2 worldSpaceMouseOnCanvasDelta = Vector2.zero;

	public static CurvedUIInputModule Instance
	{
		get
		{
			if (instance == null)
			{
				instance = EnableInputModule<CurvedUIInputModule>();
			}
			return instance;
		}
		private set
		{
			instance = value;
		}
	}

	public static Ray CustomControllerRay
	{
		get
		{
			return Instance.customControllerRay;
		}
		set
		{
			Instance.customControllerRay = value;
		}
	}

	[Obsolete("Misspelled. Use CustomControllerButtonDown instead.")]
	public static bool CustromControllerButtonDown
	{
		get
		{
			return Instance.pressedDown;
		}
		set
		{
			Instance.pressedDown = value;
		}
	}

	public static bool CustomControllerButtonDown
	{
		get
		{
			return Instance.pressedDown;
		}
		set
		{
			Instance.pressedDown = value;
		}
	}

	public Vector2 WorldSpaceMouseInCanvasSpace
	{
		get
		{
			return worldSpaceMouseInCanvasSpace;
		}
		set
		{
			worldSpaceMouseInCanvasSpace = value;
			lastWorldSpaceMouseOnCanvas = value;
		}
	}

	public Vector2 WorldSpaceMouseInCanvasSpaceDelta
	{
		get
		{
			return worldSpaceMouseInCanvasSpace - lastWorldSpaceMouseOnCanvas;
		}
	}

	public float WorldSpaceMouseSensitivity
	{
		get
		{
			return worldSpaceMouseSensitivity;
		}
		set
		{
			worldSpaceMouseSensitivity = value;
		}
	}

	public static CUIControlMethod ControlMethod
	{
		get
		{
			return Instance.controlMethod;
		}
		set
		{
			if (Instance.controlMethod != value)
			{
				Instance.controlMethod = value;
			}
		}
	}

	public GameObject CurrentPointedAt
	{
		get
		{
			return currentPointedAt;
		}
	}

	public Hand UsedHand
	{
		get
		{
			return usedHand;
		}
		set
		{
			usedHand = value;
		}
	}

	public bool GazeUseTimedClick
	{
		get
		{
			return gazeUseTimedClick;
		}
		set
		{
			gazeUseTimedClick = value;
		}
	}

	public float GazeClickTimer
	{
		get
		{
			return gazeClickTimer;
		}
		set
		{
			gazeClickTimer = Mathf.Max(value, 0f);
		}
	}

	public float GazeClickTimerDelay
	{
		get
		{
			return gazeClickTimerDelay;
		}
		set
		{
			gazeClickTimerDelay = Mathf.Max(value, 0f);
		}
	}

	public float GazeTimerProgress
	{
		get
		{
			return gazeTimerProgress;
		}
	}

	public Image GazeTimedClickProgressImage
	{
		get
		{
			return gazeTimedClickProgressImage;
		}
		set
		{
			gazeTimedClickProgressImage = value;
		}
	}

	protected override void Awake()
	{
		if (Application.isPlaying)
		{
			Instance = this;
			base.Awake();
		}
	}

	protected override void Start()
	{
		if (Application.isPlaying)
		{
			base.Start();
		}
	}

	public override void Process()
	{
		switch (controlMethod)
		{
		default:
			base.Process();
			break;
		case CUIControlMethod.GAZE:
			ProcessGaze();
			break;
		case CUIControlMethod.VIVE:
			ProcessViveControllers();
			break;
		case CUIControlMethod.OCULUS_TOUCH:
			ProcessOculusTouchController();
			break;
		case CUIControlMethod.WORLD_MOUSE:
			if (Input.touchCount > 0)
			{
				worldSpaceMouseOnCanvasDelta = Input.GetTouch(0).deltaPosition * worldSpaceMouseSensitivity;
			}
			else
			{
				worldSpaceMouseOnCanvasDelta = new Vector2((Input.mousePosition - lastMouseOnScreenPos).x, (Input.mousePosition - lastMouseOnScreenPos).y) * worldSpaceMouseSensitivity;
				lastMouseOnScreenPos = Input.mousePosition;
			}
			lastWorldSpaceMouseOnCanvas = worldSpaceMouseInCanvasSpace;
			worldSpaceMouseInCanvasSpace += worldSpaceMouseOnCanvasDelta;
			base.Process();
			break;
		case CUIControlMethod.CUSTOM_RAY:
			ProcessCustomRayController();
			break;
		}
	}

	protected virtual void ProcessGaze()
	{
		bool flag = SendUpdateEventToSelectedObject();
		if (base.eventSystem.sendNavigationEvents)
		{
			if (!flag)
			{
				flag |= SendMoveEventToSelectedObject();
			}
			if (!flag)
			{
				SendSubmitEventToSelectedObject();
			}
		}
		ProcessMouseEvent();
	}

	protected virtual void ProcessCustomRayController()
	{
		MouseState mousePointerEventData = GetMousePointerEventData(0);
		PointerEventData buttonData = mousePointerEventData.GetButtonState(PointerEventData.InputButton.Left).eventData.buttonData;
		SendUpdateEventToSelectedObject();
		PointerEventData pointerEventData = buttonData;
		currentPointedAt = pointerEventData.pointerCurrentRaycast.gameObject;
		ProcessDownRelease(pointerEventData, pressedDown && !pressedLastFrame, !pressedDown && pressedLastFrame);
		ProcessMove(pointerEventData);
		if (pressedDown)
		{
			ProcessDrag(pointerEventData);
			if (!Mathf.Approximately(pointerEventData.scrollDelta.sqrMagnitude, 0f))
			{
				GameObject eventHandler = ExecuteEvents.GetEventHandler<IScrollHandler>(pointerEventData.pointerCurrentRaycast.gameObject);
				ExecuteEvents.ExecuteHierarchy(eventHandler, pointerEventData, ExecuteEvents.scrollHandler);
			}
		}
		pressedLastFrame = pressedDown;
	}

	protected virtual void ProcessDownRelease(PointerEventData eventData, bool down, bool released)
	{
		GameObject gameObject = eventData.pointerCurrentRaycast.gameObject;
		if (down)
		{
			eventData.eligibleForClick = true;
			eventData.delta = Vector2.zero;
			eventData.dragging = false;
			eventData.useDragThreshold = true;
			eventData.pressPosition = eventData.position;
			eventData.pointerPressRaycast = eventData.pointerCurrentRaycast;
			DeselectIfSelectionChanged(gameObject, eventData);
			if (eventData.pointerEnter != gameObject)
			{
				HandlePointerExitAndEnter(eventData, gameObject);
				eventData.pointerEnter = gameObject;
			}
			GameObject gameObject2 = ExecuteEvents.ExecuteHierarchy(gameObject, eventData, ExecuteEvents.pointerDownHandler);
			if (gameObject2 == null)
			{
				gameObject2 = ExecuteEvents.GetEventHandler<IPointerClickHandler>(gameObject);
			}
			float unscaledTime = Time.unscaledTime;
			if (gameObject2 == eventData.lastPress)
			{
				float num = unscaledTime - eventData.clickTime;
				if (num < 0.3f)
				{
					eventData.clickCount++;
				}
				else
				{
					eventData.clickCount = 1;
				}
				eventData.clickTime = unscaledTime;
			}
			else
			{
				eventData.clickCount = 1;
			}
			eventData.pointerPress = gameObject2;
			eventData.rawPointerPress = gameObject;
			eventData.clickTime = unscaledTime;
			eventData.pointerDrag = ExecuteEvents.GetEventHandler<IDragHandler>(gameObject);
			if (eventData.pointerDrag != null)
			{
				ExecuteEvents.Execute(eventData.pointerDrag, eventData, ExecuteEvents.initializePotentialDrag);
			}
		}
		if (released)
		{
			ExecuteEvents.Execute(eventData.pointerPress, eventData, ExecuteEvents.pointerUpHandler);
			GameObject eventHandler = ExecuteEvents.GetEventHandler<IPointerClickHandler>(gameObject);
			if (eventData.pointerPress == eventHandler && eventData.eligibleForClick)
			{
				ExecuteEvents.Execute(eventData.pointerPress, eventData, ExecuteEvents.pointerClickHandler);
			}
			else if (eventData.pointerDrag != null && eventData.dragging)
			{
				ExecuteEvents.ExecuteHierarchy(gameObject, eventData, ExecuteEvents.dropHandler);
			}
			eventData.eligibleForClick = false;
			eventData.pointerPress = null;
			eventData.rawPointerPress = null;
			if (eventData.pointerDrag != null && eventData.dragging)
			{
				ExecuteEvents.Execute(eventData.pointerDrag, eventData, ExecuteEvents.endDragHandler);
			}
			eventData.dragging = false;
			eventData.pointerDrag = null;
			ExecuteEvents.ExecuteHierarchy(eventData.pointerEnter, eventData, ExecuteEvents.pointerExitHandler);
			eventData.pointerEnter = null;
		}
	}

	protected virtual void ProcessViveControllers()
	{
	}

	protected virtual void ProcessOculusTouchController()
	{
	}

	private static T EnableInputModule<T>() where T : BaseInputModule
	{
		bool flag = true;
		EventSystem eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>();
		if (eventSystem == null)
		{
			Debug.LogError("CurvedUI: Your EventSystem component is missing from the scene! Unity Canvas will not track interactions without it.");
			return (T)null;
		}
		BaseInputModule[] components = eventSystem.GetComponents<BaseInputModule>();
		foreach (BaseInputModule baseInputModule in components)
		{
			if (baseInputModule is T)
			{
				flag = false;
				baseInputModule.enabled = true;
			}
			else if (disableOtherInputModulesOnStart)
			{
				baseInputModule.enabled = false;
			}
		}
		if (flag)
		{
			eventSystem.gameObject.AddComponent<T>();
		}
		return eventSystem.GetComponent<T>();
	}
}
