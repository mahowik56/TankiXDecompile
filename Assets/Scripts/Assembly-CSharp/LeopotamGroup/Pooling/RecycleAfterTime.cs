using UnityEngine;

namespace LeopotamGroup.Pooling
{
	public sealed class RecycleAfterTime : MonoBehaviour
	{
		[SerializeField]
		private float _timeout = 1f;

		private float _endTime;

		public float Timeout
		{
			get
			{
				return _timeout;
			}
			set
			{
				_timeout = value;
			}
		}

		private void OnEnable()
		{
			_endTime = Time.time + _timeout;
		}

		private void LateUpdate()
		{
			if (Time.time >= _endTime)
			{
				OnRecycle();
			}
		}

		private void OnRecycle()
		{
			IPoolObject component = GetComponent<IPoolObject>();
			if (component != null)
			{
				component.PoolRecycle();
			}
			else
			{
				base.gameObject.SetActive(false);
			}
		}
	}
}
