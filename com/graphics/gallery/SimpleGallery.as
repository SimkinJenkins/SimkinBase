package com.graphics.gallery {

	import com.display.SpriteContainer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Thumbnail Gallery
	 * 
	 * Clase que quiere ser una base para todas las galerias de cualquier tipo.
	 *  
	 * 
	 * @example:
	 * 		Para una galeria vertical de 10 elementos.
	 * 		creada a partir de un responseArray de un servicio.
	 * 		que ya contiene los datos de IThumbnailData.
	 * 
	 * 		var gallery:SimpleGallery = new SimpleGallery(10, -1);
			gallery.thumbClass = TweetThumbnail;
			gallery.backgroundClass = SWCTweetBackgroundThumb;
			var thumbsArr:Array = new Array();
			for(var i:uint = 0; i < $event.responseArray.length; i++) {
				var data:TweetThumbnailData = new TweetThumbnailData("_" + i, "_" + i);
				data.statusData = $event.responseArray[i];
				thumbsArr.push(data);
			}
			gallery.initializeGallery(thumbsArr);
			addChild(gallery);
	 * 
	 * 
	 * 
	 * @author Simkin
	 */
	public class SimpleGallery extends SpriteContainer implements IGallery {

		public static const ON_GALLERY_RENDER:String = "galleryRender";
		public static const ON_GALLERY_FULL_LOADED:String = "galleryFullLoaded";

		protected var _thumbs:Array;
		protected var _rows:int;
		protected var _columns:int;
		protected var _thumbClass:Class;
		protected var _backgroundClass:Class;
		protected var _thumbsContainer:Sprite;
		protected var _selectedThumb:IThumbnail;
		protected var _mouseEnabled:Boolean = true;
		protected var _thumbsLoaded:uint = 0;
		protected var _adjustImage: Boolean = false;
		protected var _paddingX:int = 5;
		protected var _paddingY:int = 5;
		protected var _thumbsRender:uint = 0;
		protected var _minThumbsRender:int = -1;
		protected var _loaderClass:Class;
		protected var _thumbH:Number;

		public function get thumbsContainer():Sprite {
			return _thumbsContainer;
		}

		public function set loaderClass($class:Class):void {
			_loaderClass = $class;
		}

		public function set minThumbsRender($value:int):void {
			_minThumbsRender = $value;
		}

		/**
		 * Se utiliza para hacer el ajuste de la imagen leida al background que se paso.
		 * @return
		 * 
		 */		
		public function get adjustImage():Boolean {
			return _adjustImage;
		}
		public function set adjustImage($value:Boolean):void {
			_adjustImage = $value;
		}
		/**
		 * @param paddingX / paddingY distancia entre los thumbs de manera horizontal y vertical 
		 * 
		 **/
		public function get paddingX():int {
			return _paddingX;
		}
		public function get paddingY():int {
			return _paddingY;
		}
		public function set paddingX($value:int):void {
			_paddingX = $value;
		}
		public function set paddingY($value:int):void {
			_paddingY = $value;
		}
		/**
		 * Retorna el width real de la galleria
		 * @return 
		 * 
		 */
		override public function get width(): Number{
			return _thumbsContainer.width;
		}
		/**
		 * Retorna el height real de la galleria
		 * @return 
		 * 
		 */
		override public function get height(): Number{
			return _thumbsContainer.height;
		}
		/**
		 * 
		 * @param $class Opcional. Clase, que representa graficamente el thumbnail (Cualquier valor tiene que ser
		 * 						 forzosamente IThubmnail) que se creará para representar cada ThumbnailData, pasado
		 * 						 en el array para inicializar la galeria. 
		 */
		public function set thumbClass($class:Class):void {
			if(!$class is IThumbnail) {
				throw new Error("Esta clase no es IThumbail");
			} 
			_thumbClass = $class;
		}

		/**
		 * 
		 * @param $class Opcional. Clase que crea el background del Thumbnail, debe extender de DisplayObject.
		 * 
		 */
		public function set backgroundClass($class:Class):void {
			_backgroundClass = $class;
		}

		/**
		 * 
		 * @param $enabled Opcional. Habilita la funcionalidad de mouse para cada Thumbnail.
		 * 
		 */
		public function set buttonEnabled($enabled:Boolean):void {
			_mouseEnabled = $enabled;
		}

		/**
		 * Clase que sirve para armar una galeria simple por medio de un arreglo de IThumbnailData,
		 * en caso de que se quiera n elementos tanto en columnas como en renglones, se tendría que poner
		 * según sea el caso, en -1 el campo de renglon o de columna
		 * EJ:
		 * var gallery: SimpleGallery = new SimpleGallery(-1, 3); //Crea 3 columnas con un n-números de renglones
		 * var gallery: SimpleGallery = new SimpleGallery(3, -1); //Crea 3 renglones con un n-números de columnas
		 * @param $rows
		 * @param $columns
		 * 
		 */
		public function SimpleGallery($rows:int = -1, $columns:int = -1) {
			super();
			_rows = $rows;
			_columns = $columns;
			init();
		}

		/**
		 *	Con esta función se crea la galleria.
		 *  
		 * @param $thumbsData Obligatorio. Es un arreglo de IThumbnailData, que trae la información necesaria
		 * 					para crear cada thumbnail.
		 * 
		 */
		public function initializeGallery($thumbsData:Array):void {
			removeThumbnails();
			_thumbsLoaded = 0;
			_thumbsRender = 0;
			if($thumbsData.length == 0) {
				return;
			}
			createThumbnails($thumbsData);
		}
		
		/**
		 * Selecciona un thumbnail a través del indice
		 * @param $index
		 * 
		 */		
		public function selectThumbnailAt($index:uint):void {
			if($index < _thumbs.length) {
				var thumb:IThumbnail = _thumbs[$index];
				setSelectedThumb(thumb);
			}
		}

		public function move($x:Number, $y:Number):void {
			x = $x;
			y = $y;
		}

		public function destructor():void {
			removeThumbnails();
		}

		public function setDimensions($rows:int = -1, $columns:int = -1):void {
			_rows = $rows;
			_columns = $columns;
		}

		/**
		 * Inicializa los contenedores y variables iniciales 
		 * 
		 */
		protected function init():void {
			_thumbsContainer = new Sprite();
			addChild(_thumbsContainer);
		}
		
		/**
		 * Destruye todos los thumbnails de la galeria.
		 * 
		 */
		protected function removeThumbnails():void {
			if(!_thumbs) {
				return;
			}
			for(var i:uint = 0; i < _thumbs.length; i++) {
				var thumb:DisplayObject = _thumbs[i];
				addThumbListeners(thumb as IThumbnail, false);
				addLoadThumbListeners(thumb as IThumbnail, false);
				addElement(thumb, false, _thumbsContainer);
				thumb = null;
			}
			_thumbs = new Array();
		}

		/**
		 * Crea los Thumbnails, por medio de un array de datos. 
		 * @param $thumbsData Obligatorio. Arreglo de IThumbnailData.
		 * 
		 */
		protected function createThumbnails($thumbsData:Array):void {
			addChild(_thumbsContainer);
			_thumbs = new Array();
			var lastThumb:IThumbnail;
			for(var i:uint = 0; i < $thumbsData.length; i++) {
				createThumb(i, $thumbsData[i]).addEventListener(Event.ADDED, onRender);
			}
		}

		protected function onRender($event:Event):void {
			var thumb:IThumbnail = $event.currentTarget as IThumbnail;
			if(thumb) {
				addListener(thumb, Event.ADDED, onRender, false);
			}
			_thumbsRender++;
			if(_thumbsRender == _thumbs.length || (_minThumbsRender != -1 && _minThumbsRender == _thumbsRender)) {
				dispatchEvent(new Event(ON_GALLERY_RENDER));
			}
		}

		protected function createThumb($index:uint, $data:IThumbnailData):IThumbnail {
			var thumb:IThumbnail = getThumbnail($index.toString(), $index, $data);
			if(_mouseEnabled) {
				addThumbListeners(thumb);
			}
			thumb.buttonEnabled = _mouseEnabled;
			_thumbs.push(thumb);
			_thumbsContainer.addChild(thumb as DisplayObject);
			return thumb;
		}

		/**
		 * Crea y configura el thumbnail
		 * @param $ID
		 * @param $index
		 * @param $data
		 * @return 
		 * 
		 */		
		protected function getThumbnail($ID:String, $index:uint, $data:IThumbnailData):IThumbnail {
			var thumb:IThumbnail = getThumbnailInstance($ID);
			thumb.adjustImage = _adjustImage;
			(_loaderClass) ? thumb.loaderClass = _loaderClass : "";
			addLoadThumbListeners(thumb);
			thumb.data = $data;
			thumb.index = $index;
			posThumb($index, thumb);
			return thumb;
		}

		protected function addLoadThumbListeners($thumb:IThumbnail, $add:Boolean = true):void {
			addListener($thumb, ThumbnailEventType.ON_THUMBNAIL_READY, onThumbnailReady, $add);
			addListener($thumb, ThumbnailEventType.ON_THUMBNAIL_LOAD_ERROR, onThumbnailReady, $add);
		}

		/**
		 * Agrega el listener de ON_PRESS a cada unos de los thumbnails
		 * @param $thumb
		 * 
		 */		
		protected function addThumbListeners($thumb:IThumbnail, $add:Boolean = true):void {
			addListener($thumb, ThumbnailEventType.ON_PRESS, onThumbnailPress, $add);
			addListener($thumb, ThumbnailEventType.ON_THUMB_REQUEST, onThumbRequest, $add);
			addListener($thumb, ThumbnailEventType.ON_THUMB_MOUSE_EVENT, onThumbRequest, $add);
		}

		/**
		 * Función que detona un evento cuando se han terminado de cargar todos los thumbnails
		 * @param $event
		 * 
		 */		
		protected function onThumbnailReady($event:Event):void {
			var thumb:IThumbnail = $event.target as IThumbnail;
			addLoadThumbListeners(thumb, false);
			_thumbsLoaded++;
			if(_thumbsLoaded >= _thumbs.length) {
				dispatchEvent(new Event(ON_GALLERY_FULL_LOADED));
			}
		}

		/**
		 * Calcula la posición del thumbnail
		 * @param $index
		 * @param $thumb
		 * 
		 */		
		protected function posThumb($index:uint, $thumb:IThumbnail):void {
			if(!_thumbH) {
				_thumbH = $thumb.height;
			}
			$thumb.x = getXFactor($index) * ($thumb.width + _paddingX);
			$thumb.y = getYFactor($index) * (_thumbH + _paddingY);
			trace("posThumb :: " + $thumb.x + ", " + $thumb.y + " ::: " + $thumb.height + " ::: " + _paddingY);
		}

		/**
		 *	Define la posición en X de un Thumbnail de acuerdo a (_rows, _columns, $index) 
		 * @param $index Indice del thumbnail la que se le va a dar la posición.
		 * @return Regresa la posición en X.
		 * 
		 */
		protected function getXFactor($index:uint):int {
			if(_rows == -1) {
				return $index % Math.max(0, _columns);
			}
			return int($index / Math.max(0, _rows));
		}

		/**
		 *	Define la posición en Y de un Thumbnail de acuerdo a (_rows, _columns, $index) 
		 * @param $index Indice del thumbnail la que se le va a dar la posición.
		 * @return Regresa la posición en Y.
		 * 
		 */
		protected function getYFactor($index:uint):int {
			if(_columns == -1) {
				return $index % Math.max(0, _rows);
			}
			return int($index / Math.max(0, _columns));
		}

		/**
		 *  Settea el thumb seleccionado y pasa el evento.
		 * @param $event
		 * 
		 */
		protected function onThumbnailPress($event:ThumbnailEvent):void {
			setSelectedThumb($event.target as IThumbnail);
		}

		protected function onThumbRequest($event:ThumbnailEvent):void {
			dispatchEvent(new ThumbnailEvent($event.ID, $event.type, $event.data, $event.thumb, $event.bubbles, $event.cancelable));
		}

		/**
		 *  Guarda el thumbnail de la galeria que esta actualmente seleccionado. 
		 * @param $thumb Obligatorio. Thumbnail selecionado.
		 * 
		 */
		protected function setSelectedThumb($thumb:IThumbnail):void {
			$thumb.enabled = false;
			if(_selectedThumb) {
				_selectedThumb.enabled = true;
			}
			_selectedThumb = $thumb;
			dispatchEvent(new ThumbnailEvent($thumb.data.ID, ThumbnailEventType.ON_PRESS, $thumb.data, $thumb));
		}

		/**
		 *  Crea y regresa el Background de cada Thumb. 
		 * @return 
		 * 
		 */
		protected function getThumbnailBackground():DisplayObject {
			return _backgroundClass != null ? new _backgroundClass() : new Sprite();
		}

		/**
		 *  Crea y regresa la instancia del Thumbnail. 
		 * @param $ID
		 * @return 
		 * 
		 */
		protected function getThumbnailInstance($ID:String):IThumbnail {
			return _thumbClass != null ? new _thumbClass($ID, getThumbnailBackground()) : new Thumbnail($ID, getThumbnailBackground()); 
		}

	}
}