package com.utils {

	import flash.events.IEventDispatcher;

	public interface IQueue extends IEventDispatcher {

		function shift():*;
		function push($item:*):void;

	}
}