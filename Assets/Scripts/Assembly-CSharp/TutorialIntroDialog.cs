using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.Impl;
using UnityEngine;
using UnityEngine.UI;

public class TutorialIntroDialog : MonoBehaviour
{
	[SerializeField]
	protected AnimatedText animatedText;

	[SerializeField]
	private Button yesButton;

	[SerializeField]
	private Button noButton;

	[SerializeField]
	private Button sarcasmButton;

	[SerializeField]
	private Button startTutorial;

	[SerializeField]
	private Button skipTutorial;

	private float showTimer;

	[SerializeField]
	private LocalizedField yesText;

	[SerializeField]
	private LocalizedField introText;

	[SerializeField]
	private LocalizedField introWithoutQuestionText;

	[SerializeField]
	private LocalizedField confirmText;

	[SerializeField]
	private LocalizedField tipText;

	[SerializeField]
	private LocalizedField sarcasmText;

	private Entity tutorialStep;

	private bool canSkipTutorial;

	[Inject]
	public static EngineServiceInternal EngineService { get; set; }

	public void Show(Entity tutorialStep, bool canSkipTutorial)
	{
		this.tutorialStep = tutorialStep;
		this.canSkipTutorial = canSkipTutorial;
		animatedText.ResultText = ((!canSkipTutorial) ? introWithoutQuestionText.Value : introText.Value);
		animatedText.Animate();
		showTimer = 0f;
		base.gameObject.SetActive(true);
		yesButton.gameObject.SetActive(true);
		yesButton.GetComponentInChildren<TextMeshProUGUI>().text = ((!canSkipTutorial) ? "ok" : yesText.Value);
		noButton.gameObject.SetActive(canSkipTutorial);
		sarcasmButton.gameObject.SetActive(true);
		startTutorial.gameObject.SetActive(false);
		skipTutorial.gameObject.SetActive(false);
		yesButton.onClick.RemoveAllListeners();
		yesButton.onClick.AddListener(ContinueTutorial);
		noButton.onClick.RemoveAllListeners();
		noButton.onClick.AddListener(ShowConfirmText);
		sarcasmButton.onClick.RemoveAllListeners();
		sarcasmButton.onClick.AddListener(ShowSarcasm);
		startTutorial.onClick.RemoveAllListeners();
		startTutorial.onClick.AddListener(ContinueTutorial);
		skipTutorial.onClick.RemoveAllListeners();
		skipTutorial.onClick.AddListener(DisableTutorials);
		yesButton.interactable = true;
		noButton.interactable = true;
		sarcasmButton.interactable = true;
		sarcasmButton.interactable = true;
		startTutorial.interactable = true;
		skipTutorial.interactable = true;
	}

	private void ShowConfirmText()
	{
		if (canSkipTutorial)
		{
			yesButton.gameObject.SetActive(false);
			noButton.gameObject.SetActive(false);
			sarcasmButton.gameObject.SetActive(false);
			animatedText.ResultText = confirmText.Value + "\n\n<color=#A0A0A0>" + tipText.Value;
			animatedText.Animate();
			startTutorial.gameObject.SetActive(true);
			skipTutorial.gameObject.SetActive(true);
		}
	}

	private void ShowSarcasm()
	{
		sarcasmButton.gameObject.SetActive(false);
		animatedText.ResultText = sarcasmText.Value;
		animatedText.Animate();
	}

	private void DisableTutorials()
	{
		if (tutorialStep != null)
		{
			EngineService.Engine.ScheduleEvent<SkipAllTutorialsEvent>(tutorialStep);
			tutorialStep = null;
			TutorialCanvas.Instance.Hide();
		}
	}

	private void ContinueTutorial()
	{
		TutorialCanvas.Instance.Hide();
	}

	public void TutorialHidden()
	{
		base.gameObject.SetActive(false);
		Entity entity = tutorialStep;
		tutorialStep = null;
		if (entity != null)
		{
			EngineService.Engine.ScheduleEvent<TutorialStepCompleteEvent>(entity);
		}
	}
}
