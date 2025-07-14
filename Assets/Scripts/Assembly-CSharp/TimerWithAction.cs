using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

public class TimerWithAction : MonoBehaviour
{
	[Header("Time To Action")]
	[SerializeField]
	private float _startTime;

	[Header("Action")]
	[SerializeField]
	private Button.ButtonClickedEvent _onTimeEndAction;

	[Header("Description")]
	[SerializeField]
	private LocalizedField _actionDescription;

	[SerializeField]
	private TextMeshProUGUI _descriptionText;

	public float StartTime
	{
		get
		{
			return _startTime;
		}
		set
		{
			_startTime = value;
		}
	}

	public Button.ButtonClickedEvent OnTimeEndAction
	{
		get
		{
			return _onTimeEndAction;
		}
		set
		{
			_onTimeEndAction = value;
		}
	}

	public LocalizedField ActionDescription
	{
		get
		{
			return _actionDescription;
		}
		set
		{
			_actionDescription = value;
		}
	}

	public TextMeshProUGUI DescriptionText
	{
		get
		{
			return _descriptionText;
		}
		set
		{
			_descriptionText = value;
		}
	}

	public float CurrentTime { get; set; }

	private void OnEnable()
	{
		if (CurrentTime <= StartTime)
		{
			CurrentTime = StartTime;
		}
	}

	private void Update()
	{
		if (!(CurrentTime <= 0f))
		{
			if (DescriptionText != null && !string.IsNullOrEmpty(ActionDescription.Value))
			{
				DescriptionText.text = string.Format(ActionDescription, CurrentTime);
			}
			CurrentTime -= Time.deltaTime;
			if (!(CurrentTime > 0f))
			{
				CurrentTime = 0f;
				OnTimeEndAction.Invoke();
			}
		}
	}
}
