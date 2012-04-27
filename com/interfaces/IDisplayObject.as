package com.interfaces {
	
	import flash.display.DisplayObjectContainer;
	
	public interface IDisplayObject {
		
		function get height():Number;
		function set height($value:Number):void;
		function get width():Number;
		function set width($value:Number):void;
		function get x():Number;
		function set x($value:Number):void;
		function get y():Number;
		function set y($value:Number):void;
		function set rotation($value:Number):void;
		function get rotation():Number;
		function get scaleX():Number;
		function set scaleX($value:Number):void;
		function get scaleY():Number;
		function set scaleY($value:Number):void;
		function get parent():DisplayObjectContainer;
		function set alpha($alpha: Number): void
		function get alpha(): Number;
		
	}
}