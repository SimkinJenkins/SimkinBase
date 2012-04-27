package com.net {

	import flash.events.Event;
	import flash.utils.Dictionary;

	public class BasicLoaderEvent extends Event	{
		/**
		* Evento de carga completa.
		*/
		public static const COMPLETE:String = "load complete";
		/**
		* Evento de carga en progreso.
		*/
		public static const PROGRESS:String = "load in progress";
		/**
		* Evento de error de carga desde un dominio no permitido.
		*/
		public static const SECURITY_ERROR:String = "security error";
		/**
		* Evento de error de carga por url no existente.
		*/
		public static const IO_ERROR:String = "io error";
		/**
		* Evento de carga lista. Se despacha justo antes del evento de carga completa.
		*/
		public static const READY:String = "item ready";
		/**
		* Evento de unload.
		*/
		public static const UNLOAD:String = "unload item";
		/**
		* Evento de contenido no válido.
		*/		
		public static const INVALID_CONTENT: String = "invelid content";
		
		private var _type:String;
		private var _url:String;
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		private var _retry:uint;
		//private var _cache:Boolean;
		private var _serverResponse:ServerResponse;
		private var _data:Dictionary;
		private var _item:Object;
		/**
		 * Constructor
		 * @param $type Tipo de evento
		 * @param $retry Numero de reintentos realizados
		 * @param $bytesLoaded Bytes cargados.
		 * @param $bytesTotal Numero de bytes a cargar.
		 * @param $serverResponse Respuesta recibida del server.
		 * 
		 */
		public function BasicLoaderEvent($type:String, $url:String ,$retry:uint, $bytesLoaded:uint = 0, $bytesTotal:uint = 0, $item:Object = null, $serverResponse:ServerResponse = null, $data:Dictionary = null) {
			super($type);
			_type = $type;
			_item = $item;
			_bytesTotal = $bytesTotal;
			_bytesLoaded = $bytesLoaded;
			_retry = $retry;
			_url = $url;
			_serverResponse = $serverResponse;
			_data = $data;
			//_cache = $cache;
		}
		
		/**
		 * Obtiene el numero de bytes a cargar.
		 * @return 
		 * 
		 */
		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}
		public function set bytesTotal($value:uint):void
		{
			_bytesTotal = $value;
		}
		
		/**
		 * Obtiene el numero de bytes cargados al momento que se despacho el evento.
		 * @return 
		 * 
		 */
		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}
		public function set bytesLoaded($value:uint):void
		{
			_bytesLoaded = $value;
		}
		
		/**
		 * Obtiene el numero de reintentos realizados.
		 * @return 
		 * 
		 */
		public function get retry():uint
		{
			return _retry;
		}
		public function set retry($value:uint):void
		{
			_retry = $value;
		}
		
		/**
		 * Obtiene la url del elemento que se esta cargando
		 * @return 
		 * 
		 */
		public function get url():String
		{
			return _url;
		}
		public function set url($value:String):void
		{
			_url = $value;
		}
		
		/**
		 * Obtiene la respuesta enviada por el server.
		 * @return 
		 * 
		 */
		public function get serverResponse():ServerResponse {
			return _serverResponse;
		}
		public function set serverResponse($value:ServerResponse):void
		{
			_serverResponse = $value;
		}
		
		public function get data ():Dictionary
		{
			return _data;	
		}
		public function set data ($data:Dictionary):void
		{
			_data = $data;	
		}
		
		public function get item():Object
		{
			return _item
		}
		public function set item($item:Object):void
		{
			_item = $item;
		}
		
		override public function clone():Event
		{
			return new BasicLoaderEvent(_type, _url, _retry, _bytesLoaded, _bytesTotal, _item,_serverResponse, _data/*, _cache*/);
		}
	}
}