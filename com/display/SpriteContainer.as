package com.display {

	import com.interfaces.ISprite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;

	/**
	 *
	 * Clase que se puede usar en vez de Sprite, puede remplazar cualquier Sprite que vaya a contener otros objetos graficos.
	 *  
	 * @author Simkin
	 * 
	 */
	public class SpriteContainer extends Sprite implements com.interfaces.ISprite {

		public function SpriteContainer() {
			super();
		}

		/**
		 * 
		 * @param $element		Elemento gráfico que se va a añadir al $container.
		 * @param $add			Dice si $element será agregado o removido del $container. Por default se agrega.
		 * @param $container	Contenedoren el cual se agrega el $element. Por default es this.
		 * 
		 */
		protected function addElement($element:DisplayObject, $add:Boolean = true, $container:DisplayObjectContainer = null):void {
			$container = $container == null ? this : $container;
			if(!$element) {
				return;
			}
			if($add) {
				$container.addChild($element);
			} else {
				if($element.parent == $container) {
					$container.removeChild($element);
				}
			}
		}

		protected function addListener($instance:IEventDispatcher, $type:String, $callback:Function, $add:Boolean = true, $force:Boolean = false):void {
			if(!$instance) {
				return;
			}
			if($add) {
				if(!$instance.hasEventListener($type) || $force) {
					$instance.addEventListener($type, $callback);
				}
			} else {
				if($instance.hasEventListener($type)) {
					$instance.removeEventListener($type, $callback);
				}
			}
		}

	}
}