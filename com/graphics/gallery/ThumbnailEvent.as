package com.graphics.gallery {

	import flash.events.Event;
	
	public class ThumbnailEvent extends Event{
		
		protected var _ID: String;
		protected var _data:IThumbnailData;
		protected var _thumb:IThumbnail;

		public function get ID(): String{
			return _ID;
		}

		public function set ID($ID: String): void{
			_ID = $ID;
		}

		public function get data():IThumbnailData {
			return _data;
		}

		public function get thumb():IThumbnail {
			return _thumb;
		}

		public function ThumbnailEvent($ID: String, $type:String, $data:IThumbnailData = null, $thumb:IThumbnail = null, $bubbles:Boolean=false, $cancelable:Boolean=false){
			super($type, $bubbles, $cancelable);
			_ID = $ID;
			_data = $data;
			_thumb = $thumb;
		}

	}
}