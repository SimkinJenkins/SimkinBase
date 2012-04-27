package com.net {

	import com.utils.BasicQueue;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	public class GraphicLoadManager extends EventDispatcher {

		protected var _etniaLoader:BasicLoader;
		protected var _library:Dictionary;
		protected var _queue:com.utils.BasicQueue;
		protected var _onRequest:Boolean = false;
		protected var _graphicsDirPath:String = "";
		protected var _graphicsLoaded:uint = 0;
		protected var _lastLoaded:DisplayObject;
		
		protected var _retries: uint;
		protected var _currentRetries: uint;
		protected var _currentGraphicRequest: GraphicLoadRequest;
		
		public function get retries():uint{
			return _retries;
		}
		public function set retries($value:uint):void{
			_retries = ($value == 0) ? 1 : $value;
		}

		public function set graphicsDirPath($path:String):void {
			_graphicsDirPath = $path;
		}
		public function get graphicsDirPath():String{
			return _graphicsDirPath;
		}
		
		public function get lastLoaded(): DisplayObject {
			return _lastLoaded;
		}
		
		public function GraphicLoadManager():void {
			init();
		}

		public function loadRequest($id:String, $graphic:String, $x:Number = 0, $y:Number = 0, $visible:Boolean = true):void {
			trace(arguments);
			var graphicRequest: GraphicLoadRequest = new GraphicLoadRequest(_graphicsDirPath + $graphic,	$id, $x, $y, $visible);
			_queue.push(graphicRequest);
		}
		
		public function isFileLoaded($id: String):Boolean {
			return _library[$id] != null;
		}
		
		public function get library():Dictionary {
			return _library;
		}
		
		public function getLibraryItem($id:String):DisplayObject {
			return _library[$id] as DisplayObject;
		}
		
		public function startLoad():void {
			if(!_onRequest) {
				_graphicsLoaded = 0;
				handleQueue();
			}
		}
		
		protected function init():void {
			_library = new Dictionary();
			_queue = new BasicQueue();
			resetCurrentRetries();
			_retries = 3;
		}
		
		private function resetCurrentRetries(): void{
			_currentRetries = 0;
		}
		
		private function loadGraphic($graphicRequest: GraphicLoadRequest):void {
			_currentGraphicRequest = $graphicRequest;
			_etniaLoader = new BasicLoader();
			createLoaderListeners(true);
			_etniaLoader.load(_currentGraphicRequest, BasicLoaderType.GRAPHIC);
		}

		private function createLoaderListeners($create:Boolean):void {
			addListener(_etniaLoader, BasicLoaderEvent.COMPLETE, graphicLoaded   , $create);
			addListener(_etniaLoader, BasicLoaderEvent.IO_ERROR, loadError       , $create);
			addListener(_etniaLoader, BasicLoaderEvent.PROGRESS, onProgressLoader, $create);
		}

		private function onProgressLoader($event:BasicLoaderEvent):void {
			dispatchEvent(new BasicLoaderEvent($event.type, $event.url, $event.retry, $event.bytesLoaded, $event.bytesTotal));
		}

		private function loadError($event:BasicLoaderEvent):void {
			trace("Error :: : " + $event.url);
			createLoaderListeners(false);
			if(_currentRetries++ < _retries){
				loadGraphic(_currentGraphicRequest);
			}else{
				dispatchEvent(new Event(GraphicLoadManagerEventType.ON_GRAPHICS_ERROR));
				handleQueue();
			}
		}

		private function graphicLoaded($event:BasicLoaderEvent):void {
			trace("load :: " + $event.url);
			createLoaderListeners(false);
			var graphic:DisplayObject = $event.item as DisplayObject;
			var graphicRequest:GraphicLoadRequest = _etniaLoader.request as GraphicLoadRequest;
			graphic.x = graphicRequest.x;
			graphic.y = graphicRequest.y;
			graphic.visible = graphicRequest.visible;
			_library[graphicRequest.id] = graphic;
			_lastLoaded = graphic;
			_graphicsLoaded++;
			handleQueue();
		}

		private function handleQueue():void {
			trace("queue.length::"+_queue.length);
			if(_queue.length == 0) {
				_onRequest = false;
				dispatchEvent(new Event(GraphicLoadManagerEventType.ON_GRAPHICS_LOADED));
				return;
			} else {
				if(_graphicsLoaded != 0){
					dispatchEvent(new Event(GraphicLoadManagerEventType.ON_GRAPHIC_LOADED));
				}
			}
			var graphicRequest:GraphicLoadRequest = _queue.shift();
			_onRequest = true;
			resetCurrentRetries();
			loadGraphic(graphicRequest);
		}
		
		private function addListener($instance: IEventDispatcher, $type: String, $callback: Function, $create: Boolean): void{
			if($create){
				if(!$instance.hasEventListener($type)){
					$instance.addEventListener($type, $callback);
				}
			}else{
				if($instance.hasEventListener($type)){
					$instance.removeEventListener($type, $callback);
				}
			}
		}
	}
}