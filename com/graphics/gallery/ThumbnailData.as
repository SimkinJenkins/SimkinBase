package com.graphics.gallery {

	import flash.display.DisplayObject;

	public class ThumbnailData implements IThumbnailData {

		protected var _ID:String;
		protected var _imageName:String;
		protected var _thumbnailURL:String;
		protected var _URL:String;
		protected var _thumbnail:DisplayObject;

		public function set id($ID:String):void {ID = $ID}
		public function set ID($ID:String):void {
			_ID = $ID;
		}

		public function get ID():String {
			return _ID;
		}

		public function set imageName($imageName:String):void {
			_imageName = $imageName;
		}

		public function get imageName():String {
			return _imageName;
		}

		public function set thumbnailURL($value:String):void {
			_thumbnailURL = $value;
		}

		public function get thumbnailURL():String {
			return _thumbnailURL;
		}

		public function set thumbnail($value:DisplayObject):void {
			_thumbnail = $value;
		}

		public function get thumbnail():DisplayObject {
			return _thumbnail;
		}

		public function set URL($value:String):void {
			_URL = $value;
		}

		public function get URL():String {
			return _URL;
		}

		public function set data($value:Object):void {}

		public function ThumbnailData($ID:String = "", $imageName:String = "") {
			initialize($ID, $imageName);
		}

		protected function initialize($ID: String, $imageName: String = ""):void {
			_ID = $ID;
			_imageName = $imageName;
		}
	}
}