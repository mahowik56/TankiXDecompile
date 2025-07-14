using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientControls.API
{
	[AddComponentMenu("Layout/Simple Layout Element", 141)]
	[RequireComponent(typeof(RectTransform))]
	[ExecuteInEditMode]
	public class SimpleLayoutElement : UIBehaviour, ISimpleLayoutElement, ILayoutIgnorer
	{
		[SerializeField]
		private bool m_IgnoreLayout;

		[SerializeField]
		private float m_FlexibleWidth = -1f;

		[SerializeField]
		private float m_FlexibleHeight = -1f;

		[SerializeField]
		private float m_MinWidth = -1f;

		[SerializeField]
		private float m_MinHeight = -1f;

		[SerializeField]
		private float m_MaxWidth = -1f;

		[SerializeField]
		private float m_MaxHeight = -1f;

		public virtual bool ignoreLayout
		{
			get
			{
				return m_IgnoreLayout;
			}
			set
			{
				if (SetStruct(ref m_IgnoreLayout, value))
				{
					SetDirty();
				}
			}
		}

		public virtual float flexibleWidth
		{
			get
			{
				if (m_FlexibleWidth > 0f && (m_MaxWidth <= 0f || m_MaxWidth > m_MinWidth))
				{
					return m_FlexibleWidth;
				}
				return 0f;
			}
			set
			{
				if (SetStruct(ref m_FlexibleWidth, value))
				{
					SetDirty();
				}
			}
		}

		public virtual float flexibleHeight
		{
			get
			{
				if (m_FlexibleHeight > 0f && (m_MaxHeight <= 0f || m_MaxHeight > m_MinHeight))
				{
					return m_FlexibleHeight;
				}
				return 0f;
			}
			set
			{
				if (SetStruct(ref m_FlexibleHeight, value))
				{
					SetDirty();
				}
			}
		}

		public virtual float minWidth
		{
			get
			{
				return m_MinWidth;
			}
			set
			{
				if (SetStruct(ref m_MinWidth, value))
				{
					SetDirty();
				}
			}
		}

		public virtual float minHeight
		{
			get
			{
				return m_MinHeight;
			}
			set
			{
				if (SetStruct(ref m_MinHeight, value))
				{
					SetDirty();
				}
			}
		}

		public virtual float maxWidth
		{
			get
			{
				if ((m_MaxWidth <= m_MinWidth && m_MaxWidth > 0f) || m_FlexibleWidth <= 0f)
				{
					return m_MinWidth;
				}
				return m_MaxWidth;
			}
			set
			{
				if (SetStruct(ref m_MaxWidth, value))
				{
					SetDirty();
				}
			}
		}

		public virtual float maxHeight
		{
			get
			{
				if ((m_MaxHeight <= m_MinHeight && m_MaxHeight > 0f) || m_FlexibleHeight <= 0f)
				{
					return m_MinHeight;
				}
				return m_MaxHeight;
			}
			set
			{
				if (SetStruct(ref m_MaxHeight, value))
				{
					SetDirty();
				}
			}
		}

		public virtual int layoutPriority
		{
			get
			{
				return 1;
			}
		}

		protected SimpleLayoutElement()
		{
		}

		protected override void OnEnable()
		{
			base.OnEnable();
			SetDirty();
		}

		protected override void OnTransformParentChanged()
		{
			SetDirty();
		}

		protected override void OnDisable()
		{
			SetDirty();
			base.OnDisable();
		}

		protected override void OnDidApplyAnimationProperties()
		{
			SetDirty();
		}

		protected override void OnBeforeTransformParentChanged()
		{
			SetDirty();
		}

		protected void SetDirty()
		{
			if (IsActive())
			{
				LayoutRebuilder.MarkLayoutForRebuild(base.transform as RectTransform);
			}
		}

		public static bool SetStruct<T>(ref T currentValue, T newValue) where T : struct
		{
			if (currentValue.Equals(newValue))
			{
				return false;
			}
			currentValue = newValue;
			return true;
		}
	}
}
