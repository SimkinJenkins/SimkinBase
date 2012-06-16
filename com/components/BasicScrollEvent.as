package com.components {

	import flash.events.Event;

	public class BasicScrollEvent extends Event {

		public static const ON_SCROLL_CHANGE:String = "onScrollChange";

		protected var _currentValue:Number;

		public function get currentValue():Number {
			return _currentValue;
		}

		public function BasicScrollEvent($type:String, $value:Number, $bubbles:Boolean = false, $cancelable:Boolean = false) {
			super($type, $bubbles, $cancelable);
			_currentValue = $value;
		}

	}
}