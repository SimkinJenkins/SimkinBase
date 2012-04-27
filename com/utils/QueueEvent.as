package com.utils {

	import flash.events.Event;

	/**
	 * Evento de Queue.
	 * 
	 * @author Pérez Rivera Adrián Alfonso
	 * 
	 */

	public class QueueEvent extends Event {

		/**
		 * Evento que se lanza cuando sale un elemento de la cola
		 */
		public static const ON_SHIFT:String = "on shift";
		/**
		 * Evento que se lanza cuando entra un elemento a la cola
		 */
		public static const ON_PUSH:String = "on push";
		/**
		 * Evento para escuchar todos los eventos de Queue. <b>Este evento es unicamente para Debuggeo, su utilizacion 
		 * implica el uso de recursos que podria causar un mal funcionamiento.
		 * 
		 */
		public static const ON_ALL_EVENTS:String = "*+*+//*+All queue events+*+//*+*+";
		private var _other:*;
		
		/**
		 * Constructor
		 * 
		 * @param $type Tipo de evento
		 * @param $otherParams Parametros extras del evento. Su uso mas comun es para almacenar elementos que salen de
		 * la cola.
		 * 
		 */
		public function QueueEvent($type:String, $otherParams:* = null)
		{
			super($type);
			_other = $otherParams;
		}
		
		/**
		 * Obtiene otros parametros del evento
		 * @return 
		 * 
		 */
		public function get otherParams():*
		{
			return _other;
		}
		
		/**
		 * Clona el evento.
		 * @return 
		 * 
		 */
		override public function clone():Event
		{
			return new QueueEvent(this.type, _other);
		}
		
		/**
		 * Representacion en string del evento.
		 * 
		 * @return 
		 * 
		 */
		override public function toString():String
		{
			return "[QueueEvent type="+this.type+" item="+_other+"]";
		}
	}
}