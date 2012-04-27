package com.net {

	public class GraphicLoadRequest extends BasicURLRequest {

		private var _x:Number;
		private var _y:Number;
		private var _id:String;
		private var _visible:Boolean

		public function GraphicLoadRequest($url:String, $id:String, $x:Number = 0, $y:Number = 0,
											$visible:Boolean = true):void {
			super($url);
			_id = $id;
			_x = $x;
			_y = $y;
			_visible = $visible;
		}

		public function get x():Number {
			return _x;
		}

		public function get y():Number {
			return _y;
		}

		public function get id():String {
			return _id;
		}

		public function get visible():Boolean {
			return _visible;
		}

	}
}