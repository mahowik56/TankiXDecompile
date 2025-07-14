using System;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientGarage.Impl.DragAndDrop;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class TankPartModeController
	{
		private TankPartCollectionView turretCollectionView;

		private TankPartCollectionView hullCollectionView;

		private CollectionView collectionView;

		private TankPartModuleType currentMode;

		public Action onModeChange;

		public TankPartModeController(TankPartCollectionView turretCollectionView, TankPartCollectionView hullCollectionView, CollectionView collectionView)
		{
			this.turretCollectionView = turretCollectionView;
			this.hullCollectionView = hullCollectionView;
			this.collectionView = collectionView;
			turretCollectionView.GetComponent<SimpleClickHandler>().onClick = OnTurretClick;
			hullCollectionView.GetComponent<SimpleClickHandler>().onClick = OnHullClick;
			collectionView.turretToggle.onValueChanged.AddListener(OnTurretToggleValueChanged);
			collectionView.hullToggle.onValueChanged.AddListener(OnHullToggleValueChanged);
			collectionView.turretToggle.isOn = true;
			collectionView.hullToggle.isOn = false;
			currentMode = TankPartModuleType.WEAPON;
			UpdateView();
		}

		public void SetMode(TankPartModuleType tankPartMode)
		{
			if (tankPartMode != currentMode)
			{
				currentMode = tankPartMode;
				UpdateView();
				if (onModeChange != null)
				{
					onModeChange();
				}
			}
		}

		public TankPartModuleType GetMode()
		{
			return currentMode;
		}

		public void UpdateView()
		{
			collectionView.SwitchMode(currentMode);
			if (currentMode == TankPartModuleType.WEAPON)
			{
				turretCollectionView.GetComponent<Animator>().SetBool("highlighted", true);
				turretCollectionView.slotContainer.blocksRaycasts = true;
				turretCollectionView.GetComponent<CanvasGroup>().interactable = false;
				hullCollectionView.GetComponent<Animator>().SetBool("highlighted", false);
				hullCollectionView.slotContainer.blocksRaycasts = false;
				hullCollectionView.GetComponent<CanvasGroup>().interactable = true;
			}
			else
			{
				turretCollectionView.GetComponent<Animator>().SetBool("highlighted", false);
				turretCollectionView.slotContainer.blocksRaycasts = false;
				turretCollectionView.GetComponent<CanvasGroup>().interactable = true;
				hullCollectionView.GetComponent<Animator>().SetBool("highlighted", true);
				hullCollectionView.slotContainer.blocksRaycasts = true;
				hullCollectionView.GetComponent<CanvasGroup>().interactable = false;
			}
			Cursors.SwitchToDefaultCursor();
		}

		private void OnTurretClick(GameObject gameObject)
		{
			SetMode(TankPartModuleType.WEAPON);
		}

		private void OnHullClick(GameObject gameObject)
		{
			SetMode(TankPartModuleType.TANK);
		}

		private void OnTurretToggleValueChanged(bool isOn)
		{
			if (isOn)
			{
				SetMode(TankPartModuleType.WEAPON);
			}
		}

		private void OnHullToggleValueChanged(bool isOn)
		{
			if (isOn)
			{
				SetMode(TankPartModuleType.TANK);
			}
		}
	}
}
