package com.core.system {

	import com.core.config.SystemConfig;
	import com.core.config.SystemConfigurationManager;
	import com.core.config.URLManager;
	import com.core.config.URLManagerConfig;
	import com.display.SpriteContainer;
	import com.interfaces.IClient;
	
	import flash.events.Event;

	public class SimpleSystemLoader extends SpriteContainer implements IClient {
		// *****
		// Constantes para los eventos lanzados por la clase.
		// *****
		public static const ON_CLIENT_READY: String = "on_client_ready";
		public static const ON_CONFIG_LOADED: String = "on_config_loaded";
		public static const ON_FAILED_CONFIG_LOAD: String = "on_failed_config_load";
		public static const ON_URLS_LOADED: String = "on_urls_loaded";
		public static const ON_FAILED_URLS_LOAD: String = "on_urls_fail";
		public static const ON_LOCAL_URLS_LOADED: String = "on_local_urls_loaded";
		public static const ON_FAILED_LOCAL_URLS_LOAD: String = "on_failed_local_urls_load";
		public static const ON_BRAND_URLS_LOADED: String = "on_brand_urls_data_loaded";
		public static const ON_FAILED_BRAND_URLS_LOAD: String = "on_brand_urls_data_fail";
		public static const ON_BRAND_CONFIG_LOADED: String = "on_brand_config_loaded";
		public static const ON_FAILED_BRAND_CONFIG_LOAD: String = "on_brand_config_fails";		
		public static const ON_LANGUAGE_LOAD: String = "on_language_load";
		public static const ON_LANGUAGE_CHANGE: String = "on_language_change";
		public static const ON_FAILED_LANGUAGE_LOAD: String = "on_fail_language_load";
		// *****
		// Variables para los eventos lanzados por la clase.
		// *****
		protected var _configurationManager: SystemConfigurationManager;
		protected var _urlManager:URLManager;
		protected var _clientReady: Boolean = false;
		protected var _urlsDataPath: String = "config/localURLSData.xml";
		protected var _flashVarsList: Array = ["brand", "defaultLanguage"];
		/**
		 * Constructor
		 */		
		public function SimpleSystemLoader($urlsDataPath: String = null){
			super();
			if($urlsDataPath != null) {
				_urlsDataPath = $urlsDataPath;
			}
		}
		/**
		 * Configura la lista de variables que seran aceptadas en el flashvars
		 * @return Array
		 */
		public function get flashVarsList ():Array{
			return _flashVarsList;
		}
		public function set flashVarsList ($list:Array):void{
			_flashVarsList = $list;
		}
		/**
		 * Método que inicia el proceso de configuración con la ruta pasada en el contructor
		 */		 
		public function initialize(): void {
			this._urlManager = URLManager.getInstance();
			this.loadURLList(_urlsDataPath);
		}

		public function restart():void {}

		public function destruct():void {}

		/**
		 * Inicia la lectura de los paths principales
		 */
		protected function loadURLList($config_path: String): void{
			var urlManagerConfigurator: URLManagerConfig = new URLManagerConfig();
			configureLoadURLListListeners(urlManagerConfigurator, true);
			urlManagerConfigurator.load($config_path);
		}
		
		protected function configureLoadURLListListeners($instance: URLManagerConfig, $create: Boolean): void{
			if($create){
				$instance.addEventListener(URLManagerConfig.ON_LOAD, dispatchOnURLsLoad);
				$instance.addEventListener(URLManagerConfig.ON_FAIL, dispatchOnFailedURLsLoad);
			}else{
				$instance.removeEventListener(URLManagerConfig.ON_LOAD, dispatchOnURLsLoad);
				$instance.removeEventListener(URLManagerConfig.ON_FAIL, dispatchOnFailedURLsLoad);
			}
		}
		private function dispatchOnURLsLoad($event: Event): void{
			configureLoadURLListListeners($event.target as URLManagerConfig, false);
			//Ordena y administra la informacion de URLs cargada.
			handleURLManagerData();
			//llama manejar interno.
			onURLSLoad();
			//Despacha evento.
			var event: Event = new Event (SimpleSystemLoader.ON_URLS_LOADED, true);
			dispatchEvent(event);
		}
		
		private function dispatchOnFailedURLsLoad($event: Event): void{
			configureLoadURLListListeners($event.target as URLManagerConfig, false);
			onFailedURLSLoad();
			var event: Event = new Event (SimpleSystemLoader.ON_FAILED_URLS_LOAD, true);
			dispatchEvent(event);
		}
		///////////////////////////////////////////////////////////////////////////////////////////
		//*****************************************************************************************
		//ADMINISTRA DIVERSAS TABLAS DE URLS
		//*****************************************************************************************
		///////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * Establece el estado "principal" para URLManager tomando la informacion externa.
		 * Una vez terminado la creacion de la tabla principal de URL, se procede a llamar la carga del config genérico.
		 */
		protected function handleURLManagerData():void {
			try {
				_urlManager.getState("principal");
			} catch($error:Error) {
				//se crea el state principal
				_urlManager.addState("principal");
				//se establece como estado activo
				_urlManager.setState("principal");
				//Se llena principal con el default para poder conservar este ultimo integro si se desea en algun momento (por defecto default será borrado, en esta misma funcion)
				_urlManager.mergeState("local", "principal");
			}
		}
		/**
		 * Evento lanzado cuando la tabla GENERICA de URLs es cargada.
		 * @param $event 
		 */
		protected function onURLSLoad():void {
			//Llama siguiente proceso.
			loadLocalURLsList();
		}
		/**
		 *  Evento lanzado cuando FALLA la carga de tabla GENERICA de URLs.
		 *  @param $event
		 */
		protected function onFailedURLSLoad ():void{
			//Error al leer 
		}
		/**
		 * Lectura del archivo de configuracion de url secundarios.
		 */		
		public function loadLocalURLsList(): void{
			var urlManagerInstance: URLManager = URLManager.getInstance();
			var path: String = urlManagerInstance.getPath("URLSFile");
			var urlManagerConfigurator: URLManagerConfig = new URLManagerConfig();
			configureLoadLocalURLsListListeners(urlManagerConfigurator, true);
			urlManagerConfigurator.load(path);
		}
		
		protected function configureLoadLocalURLsListListeners($instance: URLManagerConfig, $create: Boolean): void{
			if($create){
				$instance.addEventListener(URLManagerConfig.ON_LOAD, dispatchOnLocalURLSLoads);
				$instance.addEventListener(URLManagerConfig.ON_FAIL, dispatchOnFailedLocalURLSLoad);
			}else{
				$instance.removeEventListener(URLManagerConfig.ON_LOAD, dispatchOnLocalURLSLoads);
				$instance.removeEventListener(URLManagerConfig.ON_FAIL, dispatchOnFailedLocalURLSLoad);
			}
		}
		private function dispatchOnLocalURLSLoads($event: Event): void{
			configureLoadLocalURLsListListeners($event.target as URLManagerConfig, false);
			try {
				_urlManager.mergeState("default", "principal");
			} catch ($error:Error) {
				
			}
			deleteURLManagerStates();
			onLocalURLSLoad();
			var event:Event = new Event(SimpleSystemLoader.ON_LOCAL_URLS_LOADED, true);
			dispatchEvent(event);
		}
		private function dispatchOnFailedLocalURLSLoad($event: Event): void{
			configureLoadLocalURLsListListeners($event.target as URLManagerConfig, false);
			onFailedLocalURLSLoad();
			var event: Event = new Event(SimpleSystemLoader.ON_FAILED_LOCAL_URLS_LOAD, true);
			dispatchEvent(event);
		}
		protected function deleteURLManagerStates(): void{
			try {
				_urlManager.deleteState("default");
				_urlManager.deleteState("local");
			} catch ($error:Error) {
				
			}
		}

		protected function onLocalURLSLoad():void{
			loadConfig();
		}

		protected function onFailedLocalURLSLoad():void{
			
		}
		///////////////////////////////////////////////////////////////////////////////////////////
		//*****************************************************************************************
		//CARGA CONFIG GENERICO
		//*****************************************************************************************
		///////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * Carga archivo de configuracion
		 */
		public function loadConfig(): void{
			var path: String = this._urlManager.getPath("configFile");
			setConfigHandler();
			_configurationManager = SystemConfigurationManager.getInstance();
			//trace("Config Manager:: " + this._configurationManager + " path:: " + path);
			configureLoadConfigListeners(_configurationManager.configurationData, true);
			_configurationManager.configurationData.load(path);
		}
		protected function configureLoadConfigListeners($instance: SystemConfig, $create: Boolean): void{
			if($create){
				$instance.addEventListener(SystemConfig.ON_LOAD, dispatchOnConfigLoad);
				$instance.addEventListener(SystemConfig.ON_FAIL, dispatchOnFailedConfigLoad);
			}else{
				$instance.removeEventListener(SystemConfig.ON_LOAD, dispatchOnConfigLoad);
				$instance.removeEventListener(SystemConfig.ON_FAIL, dispatchOnFailedConfigLoad);
			}
		}
		
		protected function setConfigHandler(): SystemConfig{
			var configurationManager: SystemConfigurationManager = SystemConfigurationManager.getInstance();
			var handler: SystemConfig = new SystemConfig();
			configurationManager.setConfigurationHandler(handler);
			return handler;
		}
		private function dispatchOnConfigLoad($event: Event): void{
			configureLoadConfigListeners(_configurationManager.configurationData, false);
			var flashVarsList:Array = _flashVarsList;
			_configurationManager.configurationData.mergeApplicationParams (flashVarsList, true, true);
			onConfigLoad();
			var event: Event = new Event(SimpleSystemLoader.ON_CONFIG_LOADED, true);
			dispatchEvent(event);
		}
		
		private function dispatchOnFailedConfigLoad($event: Event): void{
			configureLoadConfigListeners(_configurationManager.configurationData, false);
			this.onFailedConfigLoad();
			var event: Event = new Event(SimpleSystemLoader.ON_FAILED_CONFIG_LOAD, true);
			this.dispatchEvent(event);
		}
		/**
		 * Método disparado cuando la carga del archivo de configuracion genérica es cargado.
		 * @param $event
		 * 
		 */
		protected function onConfigLoad(): void{
			if(!_clientReady) {
				dispatchOnClientReady();
				_clientReady = true;
			}
		}
		/**
		 * Método disparado cuando la carga del archivo de configuracion genérica falla.
		 */
		protected function onFailedConfigLoad(): void{
			//
		}

		protected function dispatchOnClientReady ():void{
			this.onClientReady();
			var event: Event = new Event(SimpleSystemLoader.ON_CLIENT_READY, true);
			this.dispatchEvent(event);
		}
		/**
		 * Se ejecuta cuando el cliente possee todos los datos de configuracion y gráficos escenciales para inciar
		 * @return 
		 */
		protected function onClientReady ():void{
			trace("Cliente listo");
		}
	}
}