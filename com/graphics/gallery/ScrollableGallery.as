package com.graphics.gallery {

	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ScrollableGallery extends SimpleGallery implements IGallery {

		protected var _arrows:MovieClip;
		protected var _visibleWidth:Number = 100;
		protected var _visibleHeight:Number = 100;
		protected var _offset:Number = 0;
		protected var _left:SimpleButton;
		protected var _right:SimpleButton;
		protected var _automaticSelect:Boolean = false;
		protected var _min:Number = 0;
		protected var _max:Number = 0;
		protected var _mask:DisplayObject;
		protected var _type:String;
		protected var _dynamicMask:Sprite;
		protected var _selectedGraphic:Sprite;
		protected var _posArrows:Boolean = false;
		protected var _selectorColor:uint = 0xFFCC00;

		public function set selectorColor($value:uint):void {
			_selectorColor = $value;
		}

		public function set posArrows($value:Boolean):void {
			_posArrows = $value;
		}

		public function get length():uint {
			return _thumbs ? _thumbs.length : 0;
		}
		
		public function set automaticSelect($value:Boolean):void {
			_automaticSelect = $value;
		}
		
		public function set offset($value:Number):void {
			_offset = $value;
		}
		
		public function set visibleWidth($value:Number):void {
			_visibleWidth = $value;
		}
		
		public function set visibleHeight($value:Number):void {
			_visibleHeight = $value;
		}

		public function set left($button:SimpleButton): void{
			_left = $button;
		}
		
		public function set right($button:SimpleButton): void{
			_right = $button;
		}
		
		protected function get left():SimpleButton {
			return _left;
		}
		
		protected function get right():SimpleButton {
			return _right;
		}
		
		protected function get padding():Number {
			return _type == StackGalleryTypes.HORIZONTAL_GALLERY ? _paddingX : _paddingY;
		}
		
		protected function get workableArea():Number {
			return _type == StackGalleryTypes.HORIZONTAL_GALLERY ? _thumbsContainer.width : _thumbsContainer.height;
		}
		
		public function ScrollableGallery($type:String = "vertical", $rows:int=-1, $columns:int=-1)
		{
			super($rows, $columns);
			_type = $type;
		}
		override public function initializeGallery($thumbsData:Array):void {
			super.initializeGallery($thumbsData);
			_thumbsContainer.x = 40; //0;
			_thumbsContainer.y = 0;
			addEventListener(ON_GALLERY_RENDER, onGalleryRendered);
			addEventListener(ON_GALLERY_FULL_LOADED, onGalleryRendered);
		}

		override protected function setSelectedThumb($thumb:IThumbnail):void {
			super.setSelectedThumb($thumb);
			if(!_selectedGraphic) {
				_selectedGraphic = selectedThumbGraphic($thumb as DisplayObject);
				($thumb as DisplayObjectContainer).addChildAt(_selectedGraphic, 0);
				_selectedGraphic.x = - 4;
				_selectedGraphic.y = - 4;
			} else {
				($thumb as DisplayObjectContainer).addChildAt(_selectedGraphic, 0);
				_selectedGraphic.x = - 4;
				_selectedGraphic.y = - 4;
			}
			_left.visible = !($thumb.index == 0) && workableArea > _visibleWidth;
			_right.visible = !($thumb.index == _thumbs.length - 1) && workableArea > _visibleWidth;
			var nextPos:Number = $thumb.x + ($thumb.width / 2);
			if(nextPos > _visibleWidth / 2 || _thumbsContainer.x != _left.width + padding) {
				moveContainer(-nextPos + (_visibleWidth / 2) + _offset);
			}
		}
		
		protected function moveContainer($nextPos:Number):void {
			var horizontal:Boolean = _type == StackGalleryTypes.HORIZONTAL_GALLERY;
			var min:Number = _left.width + padding;
			var max:Number = - workableArea + _visibleWidth - min;
			_left.visible = $nextPos <= min;
			_right.visible = $nextPos >= max;
			new Tween(_thumbsContainer, horizontal ? "x" : "y", Strong.easeOut, horizontal ? _thumbsContainer.x : _thumbsContainer.y,
				horizontal ? Math.min(min, Math.max($nextPos, max)) : Math.min(min, Math.max($nextPos, max)), 10);
		}
		
		protected function onGalleryRendered($event:Event):void {
			addEventListener(ON_GALLERY_RENDER, onGalleryRendered, false);
			addEventListener(ON_GALLERY_FULL_LOADED, onGalleryRendered, false);
			if(_posArrows) {
				addChild(_left);
				addChild(_right);
			}
			configureDirectionalButtons(_type == StackGalleryTypes.HORIZONTAL_GALLERY ? _thumbsContainer.width : _thumbsContainer.height);
		}

		protected function configureDirectionalButtons($finalPos:Number):void {
			if(workableArea > _visibleWidth) {
				_left.addEventListener(MouseEvent.CLICK, onDirectionalButtonClick);
				_right.addEventListener(MouseEvent.CLICK, onDirectionalButtonClick);

				if(_posArrows) {
					if(_type == StackGalleryTypes.HORIZONTAL_GALLERY) {
						_left.x = 0;
						_left.y = (_thumbsContainer.height - _left.height) / 2;
					}else{
						_left.x = (_thumbsContainer.width - _left.width) / 2;
						_left.y = 0;
					}
					if(_type == StackGalleryTypes.HORIZONTAL_GALLERY) {
						_right.x = $finalPos;
						_right.y = (_thumbsContainer.height - _right.height) / 2;
					} else {
						_right.x = (_thumbsContainer.width - _right.width )/ 2;
						_right.y = $finalPos;
					}
				}
				if($finalPos > _visibleWidth) {
					_mask = getMask();
					addChild(_mask);
					_thumbsContainer.mask = _mask;
					if(_posArrows) {
						if(_type == StackGalleryTypes.HORIZONTAL_GALLERY) {
							_right.x = _visibleWidth - _right.width;
							_right.y = (_thumbsContainer.height - _right.height) / 2;
						} else {
							_right.x = (_thumbsContainer.width - _right.width )/ 2;
							_right.y = _visibleWidth - _right.height;
						}
					}
				}
			} else {
				_right.visible = false;
			}
			_left.visible = false;
		}
		
		protected function onDirectionalButtonClick($event:MouseEvent):void {
			var button:SimpleButton = $event.currentTarget as SimpleButton;
			if(_automaticSelect) {
				var index:uint = Math.min(Math.max(0, button == _left ? _selectedThumb.index - 1 : _selectedThumb.index + 1), _thumbs.length);
				selectThumbnailAt(index);
			} else {
				moveContainer(_thumbsContainer.x + (_thumbs[0].width * (button == _left ? 1 : -1)));
			}
		}
		
		protected function getMask():DisplayObject {
			if(!_dynamicMask) {
				_dynamicMask = new Sprite();
				_dynamicMask.graphics.beginFill(0);
				_dynamicMask.graphics.drawRect(0, 0, _visibleWidth - (_left.width + _right.width) - (padding * 2), _visibleHeight);
				_dynamicMask.graphics.endFill();
				_dynamicMask.x = _left.width + padding;
				_dynamicMask.y = 0; 
			}
			return _dynamicMask;
		}
		public function addThumb($thumbData:IThumbnailData):void {
			var thumb:IThumbnail = createThumb(_thumbs.length, $thumbData);
			thumb.addEventListener(Event.ADDED, onAddRender);
		}
		
		public function removeThumb():void {
			var thumb:IThumbnail = _thumbs.pop();
			_thumbsContainer.removeChild(thumb as DisplayObject);
			addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected function onAddRender($event:Event):void {
			var thumb:IThumbnail = $event.currentTarget as IThumbnail;
			thumb.removeEventListener(Event.ADDED, onAddRender);
			dispatchEvent(new Event(ON_GALLERY_RENDER));
		}
		public function destroyGallery():void {
			removeThumbnails();
		}
		protected function selectedThumbGraphic($thumb:DisplayObject):Sprite
		{
			var selected:Sprite = new Sprite();
			selected.graphics.beginFill(_selectorColor);
			selected.graphics.drawRect(0, 0, $thumb.width + 8, $thumb.height + 8);
			selected.graphics.endFill();
			return selected;
		}

	}
}