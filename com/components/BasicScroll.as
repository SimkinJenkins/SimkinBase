package com.components {

	import com.core.system.System;
	import com.display.SpriteContainer;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BasicScroll extends SpriteContainer {

		protected var _graphic:Sprite;
		protected var _graphicMinValue:Number;
		protected var _graphicMaxValue:Number;
		protected var _minValue:Number = 0;
		protected var _maxValue:Number = 1;
		protected var _deltaScroll:Number = 0;

		public function get graphic():Sprite {
			return _graphic;
		}

		protected function get graphicMC():MovieClip {
			return _graphic as MovieClip;
		}

		public function get scroll():MovieClip {
			return graphicMC.scroll;
		}

		public function get currentValue():Number {
			return getCurrentValue();
		}

		protected function get bar():MovieClip {
			return graphicMC.bar;
		}

		public function BasicScroll($graphic:MovieClip) {
			super();
			_graphic = $graphic;
			initialize();
		}

		public function setMinMaxValues($min:Number, $max:Number):void {
			_minValue = $min;
			_maxValue = $max;
		}

		public function initialPosition($value:Number):void {
			var factor:Number = ($value - _minValue) / (_maxValue - _minValue);
			scroll.x = _graphicMinValue + ((_graphicMaxValue - _graphicMinValue) * factor);
		}

		public function destructor():void {
			addElement(_graphic, false, this);
		}

		protected function initialize():void {
			addElement(_graphic, true, this);
			scroll.useHandCursor = true;
			scroll.buttonMode = true;
			_graphicMinValue = bar.x + (scroll.width / 2);
			_graphicMaxValue = bar.x + bar.width - (scroll.width / 2);
			addDragListeners(scroll);
		}

		protected function addDragListeners($element:InteractiveObject, $down:Boolean = true, $destruct:Boolean = false):void {
			addListener($element, MouseEvent.MOUSE_DOWN, onButtonMouseDown, $down && !$destruct);
			addListener(_graphic, Event.ENTER_FRAME, whileDragging, !$down && !$destruct, true);
			addListener($element, MouseEvent.MOUSE_UP, onButtonMouseUp, !$down && !$destruct, true);
			addListener(System.stageRoot.root, MouseEvent.MOUSE_UP, onButtonMouseUp, !$down && !$destruct, true);
		}

		protected function onButtonMouseDown($event:MouseEvent):void {
			var scroll:InteractiveObject = $event.currentTarget as InteractiveObject;
			trace(scroll.x + " :: " + scroll.mouseX + " ::: " + _graphic.mouseX);
			_deltaScroll = scroll.mouseX;
			addDragListeners(scroll, false);
			updateCurrentValue();
		}

		protected function whileDragging($event:Event):void {
			scroll.x = Math.min(Math.max(_graphicMinValue, _graphic.mouseX - _deltaScroll), _graphicMaxValue);
			updateCurrentValue();
		}

		protected function onButtonMouseUp($event:MouseEvent):void {
			addDragListeners(scroll);
			updateCurrentValue();
		}

		protected function updateCurrentValue():void {
			dispatchEvent(new BasicScrollEvent(BasicScrollEvent.ON_SCROLL_CHANGE, getCurrentValue()));
		}

		protected function getCurrentValue():Number {
			var factor:Number = Math.round(((scroll.x - _graphicMinValue) / (_graphicMaxValue - _graphicMinValue)) * 100) / 100;
			return _minValue + ((_maxValue - _minValue) * factor);
		}

	}
}