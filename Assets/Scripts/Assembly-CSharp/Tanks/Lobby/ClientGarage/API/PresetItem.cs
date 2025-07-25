using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientGarage.Impl;

namespace Tanks.Lobby.ClientGarage.API
{
	public class PresetItem
	{
		public string Name;

		public int level;

		public bool isSelected;

		public string hullName;

		public string turretName;

		public long hullId;

		public long weaponId;

		public Entity presetEntity;

		public PresetItem(string name, int level, string hullName, string turretName, long hullId, long weaponId, Entity presetEntity)
		{
			Name = name;
			this.level = level;
			this.presetEntity = presetEntity;
			this.hullName = hullName;
			this.turretName = turretName;
			this.hullId = hullId;
			this.weaponId = weaponId;
			isSelected = presetEntity.HasComponent<SelectedPresetComponent>();
		}
	}
}
