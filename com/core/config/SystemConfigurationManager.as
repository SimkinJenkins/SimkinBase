package com.core.config {

	public class SystemConfigurationManager {

		private static var _instance: SystemConfigurationManager;
		private var _configurationData: SystemConfig;
		
		public function get configurationData(): SystemConfig{
			return this._configurationData;	
		}
		
		public function SystemConfigurationManager ($newCall:Function = null){
			if ($newCall != SystemConfigurationManager.getInstance )			{
				//throw new SingletonException("SystemConfigurationManager");
				throw new Error("SystemConfigurationManager");
			}
			if (_instance != null)			{
				//throw new SingletonException("SystemConfigurationManager");
				throw new Error("SystemConfigurationManager");
			}			
		}
		
		/**
		 * Método para obtener la instacia del singleton.
		 * @return 
		 * 
		 */
		public static function getInstance ():SystemConfigurationManager{
			if (_instance == null )	{
				_instance = new SystemConfigurationManager (arguments.callee);
			}
			return _instance;
		}
		
		public function setConfigurationHandler ($configurationHandler: SystemConfig): void{
			this._configurationData = $configurationHandler;
		}
	}
}