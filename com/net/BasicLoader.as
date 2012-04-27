package com.net {

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.LoaderContext;
	
	public class BasicLoader extends EventDispatcher {
		private var _url: String;
		private var _request:BasicURLRequest;
		private var _loader: EventDispatcher;
		private var _counter: uint = 0;
		private var _type: String;
		private var _context: LoaderContext = null;
		private var _soundContext: SoundLoaderContext = null;
		private var _dataFormat: String = URLLoaderDataFormat.TEXT;
		
		/**
		 * Constructor.
		 * 
		 */
		public function BasicLoader()
		{
			/**/
		}

		public function get request():BasicURLRequest {
			return _request;
		}

		public function get loader():EventDispatcher
		{
			return _loader;
		}
		
		/**
		 * Contexto para la carga de un sonido.
		 * @param $context
		 * 
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/SoundLoaderContext.html flash.media.SoundLoaderContext
		 */
		public function set soundContext($context:SoundLoaderContext):void
		{
			_soundContext = $context;
		}
		public function get soundContext():SoundLoaderContext
		{
			return _soundContext;
		}
		
		/**
		 * Contexto para la carga de un objeto grafico.
		 * @param $context
		 * 
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/system/LoaderContext.html flash.system.LoaderContext
		 */
		public function set context($context:LoaderContext):void
		{
			_context = $context;
		}
		public function get context():LoaderContext
		{
			return _context;
		}
		
		public function set dataFormat($format:String):void
		{
			_dataFormat = $format;
		}
		public function get dataFormat():String
		{
			return _dataFormat;
		}
		
		/**
		 * Inicia la carga de un objeto.
		 * @param $request Peticion url
		 * @param $type Tipo de carga. Definido por EtniaLoaderType. Si se envia un valor no valido lanza un excepcion
		 * 
		 */
		public function load($request:BasicURLRequest, $type:String):void
		{
			_request = $request;
			_type = $type;
			var request:URLRequest = _request.request;
			_url = request.url;
			if(_type == BasicLoaderType.GRAPHIC)
			{
				var loader:Loader = new Loader();
				loader.name = _request.url;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedHandler);
				//loader.contentLoaderInfo.addEventListener(Event.UNLOAD, unloadHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.contentLoaderInfo.addEventListener(Event.INIT, readyHandler);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(request, _context);
			}
			else if(_type == BasicLoaderType.LOGIC)
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, loadedHandler);
				urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				urlLoader.addEventListener(Event.INIT, readyHandler);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				if(_request.method == URLRequestMethod.POST)
				{
					urlLoader.dataFormat = _dataFormat;
				}
				urlLoader.load(request);
			}
			else if(_type == BasicLoaderType.SOUND)
			{
				var soundLoader:Sound = new Sound();
				soundLoader.addEventListener(Event.COMPLETE, loadedHandler);
				soundLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				soundLoader.addEventListener(Event.INIT, readyHandler);
				soundLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				soundLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				soundLoader.load(request, _soundContext);
			}
			else
			{
				trace("LoaderTypeException");
				//throw new LoaderTypeException();
			}
		}

		/**
		 * Quita un objeto previamente cargado.
		 * @param $item
		 * 
		 */
		/*public function unload($url:String, $item:Object):void
		{
			var loader:Loader = Loader($item);
			loader.unload();
			this.dispatchEvent(new EtniaLoaderEvent(EtniaLoaderEvent.UNLOAD, $url, 0));
		}*/
		
		/**
		 * Manejador de eventos de carga exitosa
		 * @private
		 */
		protected function loadedHandler($event:Event):void
		{
			var retry:uint = _counter;
			_counter = 0;
			var content:Object = null
			if(_type == BasicLoaderType.GRAPHIC)
			{
				content = $event.target.content;
			}
			else if(_type == BasicLoaderType.LOGIC)
			{
				content = $event.target.data;
			}
			else if(_type == BasicLoaderType.SOUND)
			{
				content = $event.target;
			}
			_loader = $event.target as EventDispatcher;
			removeListeners(_loader);
			this.dispatchEvent(new BasicLoaderEvent(BasicLoaderEvent.COMPLETE, _url,retry,0,0, content));
		}
		
		/*protected function unloadHandler($event:Event):void
		{
			dispatchEvent(new EtniaLoaderEvent(EtniaLoaderEvent.UNLOAD, null, 0));
		}*/

		/**
		 * Manejador de eventos de progreso de carga
		 * @private
		 */
		protected function progressHandler($event:ProgressEvent):void
		{
			this.dispatchEvent(new BasicLoaderEvent(BasicLoaderEvent.PROGRESS, _url,_counter, $event.bytesLoaded, $event.bytesTotal));
		}
		
		/**
		 * Manejador de eventos de carga lista
		 * @private
		 */
		protected function readyHandler($event:Event):void
		{
			this.dispatchEvent(new BasicLoaderEvent(BasicLoaderEvent.READY, _url,_counter));
		}

		/**
		 * Manejador de eventos de carga fallida por dominio no valido
		 * @private
		 */
		protected function securityErrorHandler($event:Event):void
		{
			removeListeners($event.target as EventDispatcher);
			if(_counter < _request.retry)
			{
				_counter += 1;
				load(_request, _type);
			}
			else
			{
				this.dispatchEvent(new BasicLoaderEvent(BasicLoaderEvent.SECURITY_ERROR, _url,_counter));
			}
		}
		
		/**
		 * Manejador de eventos de carga fallida por url erronea
		 * @private
		 */
		protected function ioErrorHandler($event:IOErrorEvent):void
		{
			//trace("ERROR DE CARGA::"+$event.text)
			removeListeners($event.target as EventDispatcher);
			if(_counter < _request.retry)
			{
				_counter += 1;
				load(_request, _type);
			}
			else
			{
				this.dispatchEvent(new BasicLoaderEvent(BasicLoaderEvent.IO_ERROR, _url,_counter));
			}
		}
		
		protected function removeListeners($dispatcher:EventDispatcher):void
		{
			$dispatcher.removeEventListener(Event.COMPLETE, loadedHandler);
			$dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			$dispatcher.removeEventListener(Event.INIT, readyHandler);
			$dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			$dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
	}
}