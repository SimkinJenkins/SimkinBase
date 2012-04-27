package com.net {

//	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	public class DataSender extends EventDispatcher{
		public static const DEFULT_INITIAL_TAG: String = "xmlData";
		// *****
		// - Variables internas
		// *****
		private var _loader: BasicLoader = new BasicLoader();
		private var _urlRequest:BasicURLRequest
		private var _serverResponse:ServerResponse;
		// *****
		// - Variables externas
		// *****
		private var _method: String = URLRequestMethod.POST;
		private var _variables: Dictionary;
		private var _data:ServerResponse;
		private var _autocast: Boolean;
		private var _omitList: Array;
		private var _retry: uint;
		private var _dataFormat: String;
		private var _initialTag: String;
		private var _url: String;
		protected var _headers:URLRequestHeader;
		// *****
		// - Métodos get y set
		// *****
		/**
		 * Selecciona el método que se utilizará para la petición de datos ("GET" ó "POST"), por default es POST.
		 * @param $method
		 */		

		public function set headers($value:URLRequestHeader):void {
			_headers = $value;
		}

		public function set method($method: String): void{
			_method = ($method == URLRequestMethod.GET || $method == URLRequestMethod.POST) ? $method : URLRequestMethod.POST;
		}
		public function get method(): String{
			return _method;
		}
		public function get variables(): Dictionary{
			return this._variables;
		}
		/**
		 * Selecciona si se configura o no el autocast.
		 * @param $value
		 */		
		public function set autocast($value: Boolean): void{
			_autocast = $value;
		}
		public function get autocast(): Boolean{
			return _autocast;
		}
		/**
		 * Selecciona de la lista pasada, cuales elementos no serán incluidos en el objeto de salida. 
		 * @param $list
		 */		
		public function set castOmitList($list: Array): void{
			_omitList = $list;
		}
		public function get castOmitList(): Array{
			return _omitList.concat();
		}
		/**
		 * Seleciona cuantas veces se hará el reimtento de la lectura.
		 * @param $value
		 */		
		public function set retry($value: uint): void{
			_retry = $value;
		}
		public function get retry(): uint{
			return _retry;
		}
		/**
		 * Selecciona el formato en el cual se encuentra el texto de salida.
		 * @param $format
		 */		
		public function set dataFormat($format: String): void{
			_dataFormat = $format;
		}
		public function get dataFormat(): String{
			return _dataFormat;
		}
		/**
		 * Selecciona el tag dentro de un xml, a partir del cual se creará el objeto.
		 * @param $initialTag
		 */		
		public function set initialTag($initialTag:String):void{
			_initialTag = $initialTag;
		}
		public function get initialTag():String{
			return _initialTag;
		}
		/**
		 * Constructor
		 * @param $variables
		 */		
		public function DataSender($variables: Dictionary){
			initClass($variables);
		}
		/**
		 * Solicita los datos al servidor, con los elementos ingresados como variables en el constructor.
		 * @param $url 
		 */		
		public function send($url: String): void{
			_url = $url;
			_urlRequest = new BasicURLRequest($url, _retry);
			_urlRequest.method = _method;
			if(_headers) {
				_urlRequest.requestHeaders.push(_headers);
			}
			//trace("send :: " + $url);
			//if(_method == URLRequestMethod.POST)	{
				_urlRequest.data = _data;
			//}
			if(_dataFormat == DataSenderFormat.TEXT_VARIABLES){
				_loader.dataFormat = URLLoaderDataFormat.TEXT;
			}
			createLoaderListeners(true);
			try{
				_loader.load(_urlRequest, "logic");
			}catch($error: SecurityError){
				createLoaderListeners(false);
				var event: BasicLoaderEvent = new BasicLoaderEvent(BasicLoaderEvent.SECURITY_ERROR, _url, _retry);
				dispatchEvent(event);
			}
		}

		public static function getServerResponse($unparsedXML:String, $dataFormat:String, $initialTag:String):ServerResponse {
			var data:Object = new Object();
			var xmlData:XML = XML($unparsedXML);
			var xmlDataManager: XMLDataManager = new XMLDataManager();
			var serverResponse:ServerResponse = new ServerResponse();
			xmlDataManager.xmlDocument = xmlData;
			if($dataFormat == DataSenderFormat.XML_DATA_MANAGER) {
				data = xmlDataManager.getData($initialTag);
			}else{
				data = xmlDataManager.getAttributeData($initialTag);
			}
			for(var name:String in data) {
				serverResponse[name] = data[name];
			}
			return serverResponse;
		}

		public static function getJSONServerResponse($unparsedJSON:String):ServerResponse {
			var serverResponse:ServerResponse = new ServerResponse();
//			var data:Object = (new JSONDecoder($unparsedJSON)).getValue();
//			for(var name:String in data) {
//				serverResponse[name] = data[name];
//			} 
			return serverResponse;
		}

		/**
		 * @private Inicializa los elementos de la clase.
		 * @param $variables
		 */		
		protected function initClass($variables:Dictionary):void {
			this._variables = $variables;
			this._data = new ServerResponse();
			for (var name:String in $variables){
				_data[name] = $variables[name];
			}
			this._autocast = true;
			this._omitList = new Array();
			this._retry = 5;
			this._dataFormat = DataSenderFormat.XML_DATA_MANAGER;
			this._initialTag = DEFULT_INITIAL_TAG;
			
		}
		/**
		 * @private Crea los listeners de la lectira del archivo.
		 * @param $create
		 * 
		 */		
		protected function createLoaderListeners($create: Boolean): void{
			if($create){
				_loader.addEventListener(BasicLoaderEvent.COMPLETE, complete);
				_loader.addEventListener(BasicLoaderEvent.IO_ERROR, sendError);
				_loader.addEventListener(BasicLoaderEvent.SECURITY_ERROR, securityError);
			}else{
				if(_loader != null){
					_loader.removeEventListener(BasicLoaderEvent.COMPLETE, complete);
					_loader.removeEventListener(BasicLoaderEvent.IO_ERROR, sendError);
					_loader.removeEventListener(BasicLoaderEvent.SECURITY_ERROR, securityError);
				}
			}
		}
		
		protected function complete($event:BasicLoaderEvent):void {
			createLoaderListeners(false);
			var event:BasicLoaderEvent = $event.clone() as BasicLoaderEvent;
			var response:URLLoader = _loader.loader as URLLoader;
			if(_dataFormat == DataSenderFormat.TEXT_VARIABLES){
				_serverResponse = new ServerResponse(response.data);
				if(_autocast){
					_serverResponse.autocast(_omitList);
				}
			} else if(_dataFormat == DataSenderFormat.XML){
				var xmlNotParsed:XML = XML(response.data);
				_serverResponse = new ServerResponse();
				_serverResponse["XML"] = xmlNotParsed;
			} else if(_dataFormat == DataSenderFormat.XML_DATA_MANAGER){
				_serverResponse = getServerResponse(response.data, _dataFormat, _initialTag);
			} else if(_dataFormat == DataSenderFormat.JSON) {
				_serverResponse = getJSONServerResponse(response.data);
			} else {
				_serverResponse = new ServerResponse();
			}
			event.serverResponse = _serverResponse;
			event.data = _variables;
			dispatchEvent(event);
		}

		protected function sendError($event:BasicLoaderEvent):void{
			createLoaderListeners(false);
			dispatchEvent($event);
		}
		protected function securityError($event: BasicLoaderEvent): void{
			createLoaderListeners(false);
			dispatchEvent($event);
		}
		
		
	}
}