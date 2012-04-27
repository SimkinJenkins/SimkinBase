package com.core.system {

	import com.net.BasicLoaderEvent;
	import com.net.DataSender;
	import com.net.DataSenderFormat;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	import org.osmf.events.LoaderEvent;
	
	public class SimpleEnvironmentHandler extends EventDispatcher{
		
		public static const ON_LOAD: String = "on load";
		public static const ON_FAIL: String = "on fail";
		
		//private var _configuration: Array;
		protected var _id: String;
		protected var _domain: String;
		protected var _URLSData: String;
		protected var _configPath: String;
		protected var _initConfigPath: String;
		
		public function SimpleEnvironmentHandler($url: String = null){
			super();
			if($url != null)
				loadConfiguration($url);
		}
		
		public function get id(): String{
			return _id;
		}
		public function get domain(): String{
			return _domain;
		}
		public function get URLSData(): String{
			return _URLSData;
		}
		public function get configPath(): String{
			return _configPath;
		}
		public function get initConfigPath(): String{
			return _initConfigPath;
		}
		
		public function loadConfiguration($url: String): void{
			var dataSender:DataSender = new DataSender(new Dictionary());
			dataSender.autocast = false;
			dataSender.dataFormat = DataSenderFormat.XML_DATA_MANAGER;
			dataSender.method = URLRequestMethod.GET;
			createDataSenderListeners(dataSender, true);
			dataSender.send($url);
		}
		
		protected function createDataSenderListeners($instance:DataSender, $create: Boolean): void{
			if($create){
				$instance.addEventListener(BasicLoaderEvent.COMPLETE, onLoadConfiguration, false, 0, true);
				$instance.addEventListener(BasicLoaderEvent.IO_ERROR, onLoadConfigurationFail, false, 0, true);
			}else{
				if($instance != null){
					$instance.removeEventListener(BasicLoaderEvent.COMPLETE, onLoadConfiguration);
					$instance.removeEventListener(BasicLoaderEvent.IO_ERROR, onLoadConfigurationFail);
				}
			}
		}
		
		protected function onLoadConfiguration($event:BasicLoaderEvent): void{
			createDataSenderListeners($event.target as DataSender, false);
			_initConfigPath = $event.serverResponse.initConfigPath;
			getCurrentEnvironment($event.serverResponse.environments);
			dispatchEvent(new Event(ON_LOAD));
		}
		
		protected function getCurrentEnvironment($list: Array): void{
			var domain: String = new LocalConnection().domain;
			for(var index: uint = 0; index < $list.length; index++){
				if(domain.indexOf($list[index].domain) >= 0){
					_id = new String($list[index].id);
					_domain = new String($list[index].domain);
					if($list[index].configPath != null)
						_configPath = new String($list[index].configPath);
					_URLSData = new String($list[index].URLSData);
					break;
				}	
			}
			if(_id == null){
				_id = new String($list[$list.length - 1].id);
				_domain = new String($list[$list.length - 1].domain);
				_configPath = new String($list[index - 1].configPath);
				_URLSData = new String($list[$list.length - 1].URLSData);
			}
		}
		
		protected function onLoadConfigurationFail($event:BasicLoaderEvent): void{
			createDataSenderListeners($event.target as DataSender, false);
			dispatchEvent(new Event(ON_FAIL));
		}
		
	}
}