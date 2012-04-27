package com.interfaces {

	import flash.events.IEventDispatcher;

	public interface IClient extends ISprite {

		function initialize():void;
		function restart():void;
		function destruct():void;

	}
}