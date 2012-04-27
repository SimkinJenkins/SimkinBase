package com.core.system {

	import com.display.SpriteContainer;
	import com.interfaces.IClient;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.registerClassAlias;

	public class SimpleEnvironmentLoader extends SpriteContainer {

		public function get client():IClient {
			return _mainClient;
		}

		protected var _environment: SimpleEnvironmentHandler;
		protected var _mainClient: IClient;
		
		public function get URLsDataPath(): String{
			return _environment.initConfigPath + _environment.URLSData;
		}
		
		public function SimpleEnvironmentLoader(){
			super();
			registerClassAlias("com.core.system.System", System);
			if(System.topRoot == null){
				System.topRoot = this;
			}
			if(System.stageRoot == null){
				System.stageRoot  = this.stage;
			}
			if(System.loaderInfoRoot == null){
				System.loaderInfoRoot = System.topRoot.loaderInfo;
			}
		}

		public function init():void {
			loadEnvironment((System.parametersRoot == null || System.loaderInfoRoot.parameters["environmentURL"] == null)? "./environmentConfig.xml" : System.loaderInfoRoot.parameters["environmentURL"]);
		}

		protected function loadEnvironment($url: String): void{
			_environment = new SimpleEnvironmentHandler();
			addLoadEnvironmentListeners();
			_environment.loadConfiguration($url);
		}

		protected function addLoadEnvironmentListeners($add:Boolean = true):void {
			addListener(_environment, SimpleEnvironmentHandler.ON_LOAD, onLoadEnvironmentComplete, $add);
			addListener(_environment, SimpleEnvironmentHandler.ON_FAIL, onLoadEnvironmentFail, $add);
		}

		protected function onLoadEnvironmentComplete($event:Event):void {
			addLoadEnvironmentListeners(false);
			createMain();
		}

		protected function onLoadEnvironmentFail($event:Event):void {
			addLoadEnvironmentListeners(false);
		}
		/**
		 * Crea el main
		 * 
		 */		
		protected function createMain(): void {
			
		}
	}
}