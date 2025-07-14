using System.Collections.Generic;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class KeyboardNavigation : MonoBehaviour
{
	private HashSet<Selectable> traversed = new HashSet<Selectable>();

	private void Update()
	{
		Selectable selectable = null;
		if (EventSystem.current == null)
		{
			return;
		}
		GameObject currentSelectedGameObject = EventSystem.current.currentSelectedGameObject;
		if (currentSelectedGameObject == null)
		{
			return;
		}
		Selectable component = currentSelectedGameObject.GetComponent<Selectable>();
		if (component == null)
		{
			return;
		}
		if (Input.GetKeyDown(KeyCode.Tab))
		{
			traversed.Clear();
			selectable = ((!Input.GetKey(KeyCode.LeftShift) && !Input.GetKey(KeyCode.RightShift)) ? FindDown(component) : FindUp(component));
		}
		else if (Input.GetKeyDown(KeyCode.Return))
		{
			traversed.Clear();
			if (component is InputField && !HasCustomNavigation(component))
			{
				selectable = FindDown(component);
			}
		}
		if (selectable != null)
		{
			selectable.Select();
		}
	}

	private bool HasCustomNavigation(Selectable current)
	{
		InputFieldReturnSelector component = current.gameObject.GetComponent<InputFieldReturnSelector>();
		return component != null && component.CanNavigateToSelectable();
	}

	private Selectable FindUp(Selectable current)
	{
		if (traversed.Contains(current))
		{
			return null;
		}
		traversed.Add(current);
		Selectable selectable = current.FindSelectableOnUp();
		if (IsValidSelectable(selectable))
		{
			return selectable;
		}
		return FindUp(selectable);
	}

	private Selectable FindDown(Selectable current)
	{
		if (traversed.Contains(current))
		{
			return null;
		}
		traversed.Add(current);
		Selectable selectable = current.FindSelectableOnDown();
		if (IsValidSelectable(selectable))
		{
			return selectable;
		}
		return FindDown(selectable);
	}

	private bool IsValidSelectable(Selectable selectable)
	{
		return selectable == null || (selectable.interactable && selectable.gameObject.activeSelf);
	}
}
