package com.core.system {
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;

	/**
	 * Proporciona información sobre Etnia Engine.
	 * @author jgomez
	 * 
	 */
	public class System {
		
		private static var _txf:TextField;
		/**
		* Almacena el scope del Main de Etnia.
		*/
		private static var _stageRoot: Stage;
		
		/**
		* Almacena el scope del Main de Etnia.
		*/
		private static var _topRoot:Sprite;
		
		/**
		 * Almacena los parametros del root.
		 */		
		private static var _parametersRoot:Object;
		
		/**
		 *Almacena la coordenada inical del virtualSpace, despues del docker 
		 */
		private static var _sceneXOffset:Number;
		/**
		* Almacena la versión del engine.
		*/
		private static var _version:String;

		/**
		 * Almacena el LoaderInfo.
		 */		
		private static var _loaderInfoRoot: LoaderInfo;

		/**
		* Retorna la coordenada inical del virtualSpace, despues del docker
		*/
		public static function get sceneXOffset():Number{
			return _sceneXOffset;
		}
		/**
		* Escribe la coordenada inical del virtualSpace, despues del docker
		*/
		public static function set sceneXOffset($offset:Number):void{
			_sceneXOffset = $offset;
		}
		
		
		/**
		 * Retorna el scope del Main de Etnia.
		 * @return Sprite
		 * 
		 */
		public static function get topRoot ():Sprite{
				return _topRoot;
			}
		/**
		 * Establece el valor para topRoot, esta propiedad NO es modificable.
		 * @param $topRoot
		 * 
		 */		
		public static function set topRoot ($topRoot:Sprite):void{
				if(_topRoot != null){
					throw new Error(" you can not overwrite [topRoot] property.")
					return	
				}			
				_topRoot = $topRoot;
		}
		/**
		 * Retorna el scope del Stage Container.
		 * @return Sprite
		 * 
		 */
		 public static function get stageRoot ():Stage{
				return _stageRoot;
			}
		/**
		 * Establece el valor para topRoot, esta propiedad NO es modificable.
		 * @param $topRoot
		 * 
		 */		
		public static function set stageRoot ($stageRoot:Stage):void{
				if(_stageRoot != null){
					throw new Error(" you can not overwrite [stageRoot] property.")
					return	
				}			
				_stageRoot = $stageRoot;
		}
		/**
		 * Retorna los paramtros almacenado en el root de la película.
		 * @return Object
		 * 
		 */
		public static function get parametersRoot() :Object{
			if(_parametersRoot == null)
				return new Object();
			else
				return _parametersRoot;
		}
		/**
		 * 
		 * @param $pamaters
		 * 
		 */		
		public static function set parametersRoot($parameters:Object): void{
			if(_parametersRoot != null){
				throw new Error(" you can not overwrite [parametersRoot] property.")
				return
			}
			_parametersRoot = $parameters;
		}

		public static function set version($value:String):void {
			_version = $value;
		}

		/**
		 * Retorna la versión del engine.
		 * @return String
		 * 
		 */
		public static function get version ():String{
				return _version;
		}

		public static function set loaderInfoRoot($loaderInfo:LoaderInfo): void{
			if(_loaderInfoRoot != null){
				//var warning: Warning = new Warning("EtniaSystem: You can not overwrite [loaderInfoRoot] property.");
				//Tracer.warn(warning);
				//return	
			}
			_loaderInfoRoot = $loaderInfo;
		}
		public static function get loaderInfoRoot(): LoaderInfo{
			return _loaderInfoRoot
		}

		public static function initDebbugger():void {
			if(!_txf) {
				_txf = new TextField();
				_txf.text = "Version: " + System.version + "\nDebugger Enabled";
				_txf.width = 300;
				_txf.height = 500;
				_txf.border = true;
				_txf.background = true;
				_txf.mouseEnabled = false;
				_txf.wordWrap = true;
			}
		}

		public static function showDebbuger():void {
			System.initDebbugger();
			System.topRoot.addChild(_txf);
		}

		public static function hideDebbugger():void {
			System.initDebbugger();
			if(_txf.parent == System.topRoot) {
				System.topRoot.removeChild(_txf);
			}
		}

		public static function addDebugMessage($message:String):void {
			System.initDebbugger();
			_txf.text = $message + "\n" + _txf.text;
		}

	}
	
	
	
	
	
	
	
}