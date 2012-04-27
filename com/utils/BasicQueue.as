package com.utils {

	import flash.events.EventDispatcher;
	
	/**
	 * Clase que define una cola basica. Al agregar o sacar elementos de la cola se despachan los respectivos eventos.
	 * 
	 * @author Pérez Rivera Adrián Alfonso
	 * 
	 */
	public class BasicQueue extends EventDispatcher implements IQueue {
		private var _queue:Array;
		
		/**
		 * Constructor
		 * 
		 */
		public function BasicQueue()
		{
			_queue = new Array();
		}
		
		/**
		 * Saca un elemnto de la cola. Al sacar el elemento despacha un evento de cola.
		 * @return 
		 * 
		 */
		public function shift():*
		{
			var item:* = _queue.shift();
			this.dispatchEvent(new QueueEvent(QueueEvent.ON_SHIFT, item));
			return item;
		}
		
		/**
		 * Agrega un elemento a la cola. Despacha un evento cuando cuando se agrega el elemento
		 * @param $item
		 * 
		 */
		public function push($item:*):void
		{
			_queue.push($item);
			this.dispatchEvent(new QueueEvent(QueueEvent.ON_PUSH));
		}

		public function get length():uint {
			return _queue.length;
		}

	}
}