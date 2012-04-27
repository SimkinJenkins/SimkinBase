package com.etnia.graphics.gallery {

	import com.display.SpriteContainer;
	import com.graphics.gallery.IThumbnail;
	import com.graphics.gallery.IThumbnailData;
	import com.graphics.gallery.ThumbnailEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;

	/**
	 * Thumbnail
	 * 
	 * Clase base para cualquier thumbnail
	 *  
	 * @author Simkin, JDD
	 * 
	 */
	public class Thumbnail extends SpriteContainer implements IThumbnail {

		protected var _background: DisplayObject;
		protected var _title: TextField;
		protected var _image: DisplayObject;
		protected var _imageLoader: Loader;
		protected var _button: InteractiveObject;
		protected var _data:IThumbnailData;
		protected var _mouseEnabled:Boolean = true;
		protected var _selected:Boolean = false;
		protected var _index:Number;
		protected var _adjustImage: Boolean = false;
		protected var _defaultWidth:Number = 50;
		protected var _defaultHeight:Number = 50;
		
		/**
		 * Se utiliza para hacer el ajuste de la imagen leida al background que se paso.
		 * @return
		 * 
		 */		
		public function get adjustImage(): Boolean{
			return _adjustImage;
		}
		public function set adjustImage($value: Boolean): void{
			_adjustImage = $value;
		}
		
		override public function get width():Number {
			if(_background && _background.width != 0) {
				return _background.width;
			}
			return _defaultWidth;
			return super.width;
		}

		override public function get height():Number {
			if(_background && _title) {
				return _background.height + _title.height;
			} else if(_background && _background.height != 0) {
				return _background.height;
			}
			return _defaultHeight;
			return super.height;
		}

		public function get data():IThumbnailData {
			return _data;
		}

		public function set data($value:IThumbnailData):void {
			_data = $value;
			if(_data.thumbnailURL != "" && _data.thumbnailURL != null) {
				loadImage(_data.thumbnailURL);
			} else if(_data.thumbnail) {
				setImage(_data.thumbnail);
			} 
		}

		public function get buttonEnabled():Boolean {
			return _mouseEnabled;
		}

		public function set buttonEnabled($enabled:Boolean):void {
			_mouseEnabled = $enabled;
			setInvisibleButton();
			createThumbnailListeners($enabled);
		}

		public function set index($index:Number):void {
			_index = $index;
		}

		public function get index():Number {
			return _index;
		}

		public function Thumbnail($ID:String, $background:DisplayObject, $imageUrl:String = "", $title:TextField = null) {
			initialize($ID, $background, $imageUrl, $title);
		}

		public function _Thumbnail(): void{
			createThumbnailListeners(false);
			addContainer(false);
			_button = null;
			_title = null;
			_background = null;
			_data = null;
		}

		public function isSelected(): Boolean{
			return _selected;
		}

		public function set enabled($value: Boolean): void{
			createThumbnailListeners($value);
		}

		public function get enabled(): Boolean{
			return _button != null ? _button.mouseEnabled : false;
		}

		protected function initialize($ID: String, $background: DisplayObject, $imageUrl: String, $title: TextField): void {
			_data = new ThumbnailData($ID);
			_background = $background;
			_title = $title;
			setInvisibleButton();
			arrangeElements();
			if($imageUrl != "") {
				loadImage($imageUrl);
			}
		}

		protected function setInvisibleButton():void {
			if(_mouseEnabled && !_button) {
				_button = createInvisibleButton();
			}
			_button.mouseEnabled = _mouseEnabled;
		}

		protected function arrangeElements(): void {
			arrangeBackground();
			arrangeTitle();
			arrangeButton();
		}

		protected function arrangeBackground():void {
			if(_background) {
				_background.x = 0;
				_background.y = 0;
			}
		}

		protected function arrangeTitle():void {
			if(_title != null) {
				_title.x = _background.x;
				_title.y = _background.y + _background.height;
			}
		}

		protected function arrangeButton():void {
			if(_background && _button) {
				_button.x = _background.x;
				_button.y = _background.y;
			}
		}

		protected function loadImage($imageURL:String):void {
			if(!$imageURL) {
				return;
				throw new Error("Thumbnail: No se puede cargar un $imageURL nulo");
			}
			trace("load image ::: " + $imageURL);
			if(_image) {
				addContainer(false);
				_image = null;
			}
			var urlReq:URLRequest = new URLRequest($imageURL);
			var context: LoaderContext = new LoaderContext(true);
			_imageLoader = new Loader();
			createLoadImageListeners();
			_imageLoader.load(urlReq, context);
		}

		protected function createLoadImageListeners($create:Boolean = true):void {
			if(_imageLoader) {
				addListener(_imageLoader.contentLoaderInfo, Event.INIT, onLoadImage, $create);
				addListener(_imageLoader.contentLoaderInfo, ProgressEvent.PROGRESS, onProgress, $create);
				addListener(_imageLoader.contentLoaderInfo, IOErrorEvent.IO_ERROR, onLoadImageIOError, $create);
			}
		}

		protected function onLoadImage($event:Event):void {
			createLoadImageListeners(false);
			if(_imageLoader.content) {
				if(_imageLoader.content is Bitmap) {
					(_imageLoader.content as Bitmap).smoothing = true;
				}
				setImage(_imageLoader.content);
			}
			dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_READY));
		}

		protected function setImage($image:DisplayObject):void {
			_image = $image;
			if(_background) {
				setPosition();
				setSizeImage();
			}
			showGraphic();
		}

		protected function setPosition():void {
			_image.x = _background.x + 1;
			_image.y = _background.y;
		}
		
		protected function setSizeImage():void {
			if(_adjustImage) {
				_image.width = _background.width != 0 ? _background.width : _defaultWidth;
				_image.height = _background.height != 0 ? _background.height : _defaultHeight;
			}
		}

		protected function onProgress($event: ProgressEvent):void {
//			trace($event.bytesLoaded + " ::: " + $event.bytesTotal);
		}

		protected function onLoadImageIOError($event: IOErrorEvent):void {
			trace("onLoadImageIOError :: " + _data.thumbnailURL);
			createLoadImageListeners(false);
			showGraphic();
			dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_READY));
			dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_LOAD_ERROR));
		}

		protected function showGraphic():void {
			addContainer();
			createThumbnailListeners(true);
		}

		protected function addContainer($add:Boolean = true):void {
			addElement(_background, $add);
			addElement(_title, $add);
			addElement(_image, $add);
			addElement(_button, $add);
		}

		protected function createThumbnailListeners($create:Boolean):void {
			if(!_button) {
				return;
			}
			_selected = $create ? false : _selected;
			_button.mouseEnabled = $create;
			addElement(_button, $create);
			addListener(_button, MouseEvent.CLICK, onPressButton, $create && _mouseEnabled);
			addListener(_button, MouseEvent.MOUSE_OVER, onMouseEvent, $create);
			addListener(_button, MouseEvent.MOUSE_DOWN, onMouseEvent, $create);
			addListener(_button, MouseEvent.MOUSE_OUT, onMouseEvent, false);
			addListener(_button, MouseEvent.CLICK, onMouseEvent, $create && _mouseEnabled, true);
		}

		protected function onMouseEvent($event:MouseEvent):void {
			if($event.type == MouseEvent.MOUSE_OVER) {
				addListener(_button, MouseEvent.MOUSE_OVER, onMouseEvent, false);
				addListener(_button, MouseEvent.MOUSE_OUT, onMouseEvent);
			} else if($event.type == MouseEvent.MOUSE_OUT) {
				addListener(_button, MouseEvent.MOUSE_OUT, onMouseEvent, false);
				addListener(_button, MouseEvent.MOUSE_OVER, onMouseEvent);
			}
			dispatchEvent(new ThumbnailEvent($event.type, ThumbnailEventType.ON_THUMB_MOUSE_EVENT, _data, this));
		}

		protected function onPressButton($event:MouseEvent):void {
			createThumbnailListeners(false);
			_selected = true;
			var event: ThumbnailEvent = new ThumbnailEvent(_data.ID, ThumbnailEventType.ON_PRESS, _data, this);
			dispatchEvent(event);
		}

		protected function createInvisibleButton():InteractiveObject {
			return new SimpleButton(createFaceButton(this.width, this.height, 0x000000, 0),createFaceButton(this.width, this.height, 0x000000, 0),createFaceButton(width, height, 0x000000, 0),createFaceButton(this.width, this.height, 0x000000, 0));
		}

		protected function createFaceButton($width:Number, $height:Number, $color:Number, $alpha:Number = 1):DisplayObject {
			var face: Sprite = new Sprite();
			face.graphics.beginFill($color, $alpha);
			face.graphics.drawRect(0,0,$width, $height);
			face.graphics.endFill();
			return face;
		}
	}
}