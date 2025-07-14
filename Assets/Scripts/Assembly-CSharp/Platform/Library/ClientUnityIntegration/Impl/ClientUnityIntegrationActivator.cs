using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientProtocol.API;
using Platform.Library.ClientUnityIntegration.API;
using Platform.System.Data.Statics.ClientYaml.API;
using UnityEngine;

namespace Platform.Library.ClientUnityIntegration.Impl
{
	public class ClientUnityIntegrationActivator : DefaultActivator<AutoCompleting>, ECSActivator, Activator
	{
		[Inject]
		public static Protocol Protocol { get; set; }

		[Inject]
		public static EngineService EngineService { get; set; }

		[Inject]
		public static TemplateRegistry TemplateRegistry { get; set; }

		[Inject]
		public static YamlService YamlService { get; set; }

		public void RegisterSystemsAndTemplates()
		{
			EngineService.RegisterSystem(new ECSToLoggerSystem());
			EngineService.RegisterSystem(new ConfigEntityLoaderSystem());
			TemplateRegistry.Register<ConfigPathCollectionTemplate>();
		}

		protected override void Activate()
		{
			ServiceRegistry.Current.RegisterService((UnityTime)new UnityTimeImpl());
			Protocol.RegisterCodecForType<Vector3>(new Vector3Codec());
			YamlService.RegisterConverter(new Vector3YamlConverter());
		}
	}
}
