package com.graphics.gallery {

	import flash.display.DisplayObject;

	public interface IThumbnailData {

		function set ID($ID:String):void;
		function get ID():String;
		function set imageName($imageName:String):void;
		function get imageName():String;
		function set thumbnailURL($value:String):void;
		function get thumbnailURL():String;
		function set URL($value:String):void;
		function get URL():String;
		function set data($data:Object):void;
		function set thumbnail($value:DisplayObject):void;
		function get thumbnail():DisplayObject;

	}
}