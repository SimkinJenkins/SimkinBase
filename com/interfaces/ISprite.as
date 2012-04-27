package com.interfaces {

	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	public interface ISprite extends IDisplayObject, IEventDispatcher {

		function addChild(child:DisplayObject):DisplayObject;
		function removeChild(child:DisplayObject):DisplayObject;

	}
}