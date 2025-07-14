using System;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

public class ConfirmationCodeSendAgainComponent : MonoBehaviour
{
	public LayoutElement buttonLayoutElement;

	public TextMeshProUGUI timerLabel;

	public Button sendAgainButton;

	private long lastRequestTicks;

	private long timer;

	private long emailSendThresholdInSeconds = 60L;

	public long Timer
	{
		get
		{
			return timer;
		}
		set
		{
			timer = value;
			string text = LocalizationUtils.Localize("ec7ff56e-6fba-4947-87d0-a2a753c0974a");
			text = text.Replace("%seconds%", timer.ToString());
			if (timerLabel.text != text)
			{
				timerLabel.text = text;
			}
		}
	}

	public void ShowTimer(long emailSendThreshold)
	{
		sendAgainButton.interactable = false;
		lastRequestTicks = DateTime.Now.Ticks;
		emailSendThresholdInSeconds = emailSendThreshold;
		buttonLayoutElement.preferredHeight = 80f;
		timerLabel.gameObject.SetActive(true);
	}

	public void HideTimer()
	{
		sendAgainButton.interactable = true;
		buttonLayoutElement.preferredHeight = 50f;
		timerLabel.gameObject.SetActive(false);
	}

	private void Update()
	{
		long ticks = DateTime.Now.Ticks - lastRequestTicks;
		long num = (long)new TimeSpan(ticks).TotalSeconds;
		long num2 = emailSendThresholdInSeconds - num;
		if (num2 > 0)
		{
			Timer = num2;
		}
		else if (timerLabel.gameObject.activeSelf)
		{
			HideTimer();
		}
	}
}
