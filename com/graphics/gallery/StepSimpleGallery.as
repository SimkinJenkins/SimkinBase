package com.graphics.gallery {

	import com.core.system.System;
	import com.utils.graphics.DisplayContainer;
	import com.utils.graphics.MainDisplayController;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class StepSimpleGallery extends SimpleGallery {

		protected var _buttonIndent:uint = 4;
		protected var _scroll:MovieClip;
		protected var _left:SimpleButton;
		protected var _right:SimpleButton;
		protected var _visibleArea:Number = 400;
		protected var _selectorColor:uint = 0xCC7B22;
		protected var _selectorContainer:Sprite;
		protected var _selector:DisplayObject;

		public function set visibleArea($value:Number):void {
			_visibleArea = $value;
		}

		public function set graphicScroll($value:MovieClip):void {
			_scroll = $value;
			parseScroll();
		}

		public function set left($button:SimpleButton):void {
			_left = $button;
			_left.visible = false;
		}
		
		public function set right($button:SimpleButton):void {
			_right = $button;
			_right.visible = false;
		}

		protected function get scrollButton():MovieClip {
			if(_scroll) {
				return _scroll.scroll;
			}
			return null;
		}

		protected function get bar():MovieClip {
			return _scroll.bar;
		}

		public function StepSimpleGallery($rows:int=-1, $columns:int=-1) {
			super($rows, $columns);
		}

		override public function destructor():void {
			addScrollListeners(false, false, true);
			showArrows(false, false);
			super.destructor();
		}

		public function addData($thumbsData:Array, $i:uint = 0):void {
			doCreateThumbs($thumbsData, _thumbs.length);
		}

		override protected function createThumbnails():void {
			super.createThumbnails();
			thumbsContainer.y = 0;
			parseScroll();
		}

		override protected function onThumbnailReady($event:Event):void {
			super.onThumbnailReady($event);
			dispatchEvent(new Event($event.type));
			parseScroll();
		}

		override protected function setSelectedThumb($thumb:IThumbnail):void {
			super.setSelectedThumb($thumb);
			showSelectedGraphic(true, $thumb.x, $thumb.y);
		}

		override protected function init():void {
			_selectorContainer = new Sprite();
			super.init();
			addElement(_selectorContainer, true, _thumbsContainer);
		}

		protected function showSelectedGraphic($add:Boolean, $x:Number, $y:Number):void {
			if(!_selector) {
				_selector = selectedThumbGraphic(_thumbs[0]);
			}
			_selector.x = $x - 4;
			_selector.y = $y - 4;
			addElement(_selector, $add, _selectorContainer);
		}

		protected function selectedThumbGraphic($thumb:DisplayObject):Sprite {
			var selected:Sprite = new Sprite();
			selected.graphics.beginFill(_selectorColor);
			selected.graphics.drawRect(0, 0, $thumb.width + 8, $thumb.height + 8);
			selected.graphics.endFill();
			return selected;
		}

		protected function parseScroll():void {
			if(thumbsContainer && _scroll) {
				if(thumbsContainer.height < bar.height) {
					addScrollListeners(false, false, true);
					scrollButton.y = bar.y + (_buttonIndent / 2);
					scrollButton.height = bar.height - _buttonIndent;
					thumbsContainer.y = 0;
				} else {
					if(!scrollButton.hasEventListener(Event.ENTER_FRAME)) {
						addScrollListeners(true, true, false);
					}
					scrollButton.height = bar.height / (thumbsContainer.height / bar.height);
				}
			}
			if(_left && _right) {
				parseArrows();
			}
		}

		protected function parseArrows():void {
			trace("parseArrows ... " + thumbsContainer.x + " ::: " + thumbsContainer.width + " ::: " + _visibleArea);
			if(thumbsContainer.width > _visibleArea) {
				if(thumbsContainer.x > -5) {
					showArrows(false);
				} else if(thumbsContainer.x + 5 < _visibleArea - thumbsContainer.width) {
					showArrows(true, false);
				} else {
					showArrows();
				}
			} else {
				showArrows(false, false);
			}
		}

		protected function showArrows($left:Boolean = true, $right:Boolean = true):void {
			_left.visible = $left;
			_right.visible = $right;
			addButtonListener(_left, $left);
			addButtonListener(_right, $right);
		}

		protected function addButtonListener($button:SimpleButton, $add:Boolean = true):void {
			addListener($button, MouseEvent.CLICK, onButtonClick, $add);
		}

		protected function onButtonClick($event:MouseEvent):void {
			if($event.currentTarget == _left) {
				moveThumbsContainer(80);
			} else {
				moveThumbsContainer(-80);
			}
			parseArrows();
		}

		protected function moveThumbsContainer($x:Number):void {
			thumbsContainer.x = Math.max(_visibleArea - thumbsContainer.width - 10, Math.min(thumbsContainer.x + $x, 0));
		}

		protected function onMouseAction($event:MouseEvent):void {
			var mDown:Boolean = $event.type == MouseEvent.MOUSE_DOWN;
			if(mDown) {
				scrollButton.startDrag(false, new Rectangle(scrollButton.x, bar.y, 0, bar.height - scrollButton.height));
				addScrollListeners(true, false, false);
			} else {
				scrollButton.stopDrag();
				addScrollListeners(true, true, false);
			}
		}

		protected function addScrollListeners($add:Boolean = true, $down:Boolean = true, $destruct:Boolean = false):void {
			if(scrollButton) {
				scrollButton.useHandCursor = $add;
				scrollButton.buttonMode = $add;
				scrollButton.alpha = $add ? 1 : .5;
			}
			addListener(scrollButton, MouseEvent.MOUSE_DOWN, onMouseAction, $down && !$destruct);
			showMouseUpCatcher(!$down && !$destruct);
			addListener(_mouseUpCatcher, MouseEvent.MOUSE_UP, onMouseAction, !$down && !$destruct, true);
			addListener(System.stageRoot.root, MouseEvent.MOUSE_UP, onMouseAction, !$down && !$destruct, true);
			addListener(scrollButton, Event.ENTER_FRAME, onScrollMoving, !$down && !$destruct, true);
		}

		protected function onScrollMoving($event:Event):void {
			if(thumbsContainer.height < bar.height) {
				thumbsContainer.y = 0;
			} else {
				var factor:Number = Math.abs(((scrollButton.y - bar.y) / (scrollButton.height - bar.height)));
				thumbsContainer.y = -(thumbsContainer.height - bar.height + 20) * Math.min(Math.max(0, factor), 1);
			}
		}

		protected var _mouseUpCatcher:Sprite;

		protected function showMouseUpCatcher($add:Boolean = true):void {
			if(!_mouseUpCatcher) {
				_mouseUpCatcher = new Sprite();
				_mouseUpCatcher.graphics.beginFill(0, 0);
				_mouseUpCatcher.graphics.drawRect(0, 0, System.stageRoot.stageWidth, System.stageRoot.stageHeight);
				_mouseUpCatcher.graphics.endFill();
			}
			addElement(_mouseUpCatcher, $add, alertsContainer);
		}

		protected function get alertsContainer():DisplayContainer {
			return MainDisplayController.getInstance().displayContainer.getStoredContainer("alertsContainer");
		}

	}
}