package com.net {

	import com.core.system.System;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;

	/**
	 * Objeto Dinámico creado que recibe y/o crea propiedades apartir de un XML cargado con XMLDataManager. Se recomienda hacer una subclase para controlar la lectura/escritura de las propiedades creadas. Tómese en cuenta qeu si se desea por ejemplo protegiendo contra escritura una propiedad omitiendo su setter la propiedad escrita desde el xml debe ser la propiedad privada.
	 * @author jgomez
	 * @see com.etnia.net.XMLDataManager
	 */
	public dynamic class ExternallyControlledObject extends EventDispatcher {
		/**
		* Evento lanzado a la carga exitosa del archivo
		*/
		public static const ON_LOAD:String = "on_load";
		/**
		* Evento lanzado cuano la carga del archivo falla
		*/
		public static const ON_FAIL:String = "on_fail";
		//
		/**
		* Propiedad que almacena los dtos cargados.
		*/
		protected var _data:Object;
		/**
		* Cuando es true, permite escribir una propiedad de entidades externas; es false por default.
		*/
		protected var _allowExternalData:Boolean;
		//
		/**
		* Path del archuvo de configuracion.
		*/
		protected var _configurationFilePath:String;
		//Objeto XMLDataManager hace la gestion y carga.
		
		/**
		* Objeto XMLDataManager que administra el llenado externo
		* @see com.etnia.net.XMLDataManager
		*/
		protected var _xmlDataManager:XMLDataManager;
		protected var _dataSender:DataSender;
		//	
		/**
		 * Constructor.
		 * @return 
		 * 
		 */
		public function ExternallyControlledObject($allowExternalData:Boolean = false){
			this._allowExternalData = $allowExternalData;
			_dataSender = new DataSender(new Dictionary());
			_dataSender.autocast = true;
			_dataSender.method = URLRequestMethod.GET;
			_dataSender.dataFormat = DataSenderFormat.XML_DATA_MANAGER;
		}
		//////////////////////////////////////////////////////////
		/**
		 * Carga el archivo para configurar el objeto.
		 * @param $configurationFilePath
		 * 
		 */
		public function load ($configurationFilePath:String):void{
			trace("Cargando:: " + $configurationFilePath);
			_configurationFilePath = $configurationFilePath;
			//this._xmlDataManager.load(this._configurationFilePath);
			createDataSenderListeners(true);
			_dataSender.send(_configurationFilePath);
		}
		/**
		 * @private
		 * @param $create
		 */			
		protected function createDataSenderListeners($create: Boolean): void{
			if($create){
				_dataSender.addEventListener(BasicLoaderEvent.COMPLETE, onComplete);
				_dataSender.addEventListener(BasicLoaderEvent.IO_ERROR, onError);
				_dataSender.addEventListener(BasicLoaderEvent.SECURITY_ERROR, onSecurityError);
			}else{
				if(_dataSender != null){
					_dataSender.removeEventListener(BasicLoaderEvent.COMPLETE, onComplete);
					_dataSender.removeEventListener(BasicLoaderEvent.IO_ERROR, onError);
					_dataSender.removeEventListener(BasicLoaderEvent.SECURITY_ERROR, onSecurityError);
				}
			}
		}
		/**
		 * Función que se ejecuta cuando la transacción con el servidor tuvo exito.
		 * @param $event
		 */
		protected function onComplete($event:BasicLoaderEvent): void{
			createDataSenderListeners(false);
			copyProperties($event.serverResponse);
			this.dispatchOnLoad ();
		}

		/**
		 * Función que se ejecuta cuando hubo un error en la transacción con el servidor
		 * @param $event
		 */
		protected function onError($event:BasicLoaderEvent): void{
			createDataSenderListeners(false);
			dispatchOnLoadFail ();
		}
		/**
		 * Funcion que se ejecuta cuando hay un error de seguridad
		 * @param $event
		 */		
		protected function onSecurityError($event:BasicLoaderEvent): void{
			createDataSenderListeners(false);
			dispatchOnLoadFail ();
		}
		/**
		 * Obtiene variables del query string de la pelicula, o vía flash vars y las deposita en el objeto.
		 * @param $paramsList
		 * @param $ignoreEmptyParams
		 * 
		 */		
		public function mergeApplicationParams ($paramsList:Array, $ignoreEmptyParams:Boolean = true, $mergeStageParams: Boolean = false):void{
			//if(this.r){
				for (var i:Number = 0;i<$paramsList.length;i++){
					var propertyName: String = $paramsList[i];
					var paramProperty: String = new String();
					if($mergeStageParams && System.parametersRoot){
						trace("Parametros:: " + propertyName + "==" + System.parametersRoot[propertyName]);
						paramProperty = System.parametersRoot[propertyName];
						if(($ignoreEmptyParams && paramProperty != null && paramProperty != "") || (!$ignoreEmptyParams)){
							if(paramProperty.charAt(0) == "[" && paramProperty.charAt(paramProperty.length - 1) == "]")
								createProperty(propertyName, (paramProperty.slice(1, paramProperty.length - 1).split(",")));
							else
								createProperty(propertyName, paramProperty);
						}
						trace("Parametro:: " + propertyName + "--->" + this[propertyName])
					}
					paramProperty = System.topRoot.root.loaderInfo.parameters[propertyName];
					if(($ignoreEmptyParams && paramProperty != null && paramProperty != "") || (!$ignoreEmptyParams)){
						createProperty(propertyName, paramProperty);
						//this[propertyName]= paramProperty;
					}
					//createProperty("_defaultLanguage", "en_us");
				}
			//} 
			
		}
		/**
		 * Evento ejecutado cuando el archvo externo carga
		 * @param $event
		 * 
		 */
		protected function onConfigFileLoad ($event:Event):void {
			////trace ("termino la carga")
			this._data = new Object();
			this._data = this._xmlDataManager.getData("xmlData");
			this.copyProperties (this._data);
			this.dispatchOnLoad ();
		}
		/**
		 * Evento ejecutado cuando la carga del archivo falla.
		 * @param $event
		 * 
		 */
		protected function onFailedConfigFileLoad ($event:Event):void{
			dispatchOnLoadFail ()
		}
		/**
		 * Despacha ON_LOAD
		 * 
		 */
		protected function dispatchOnLoad ():void{
			////trace("despachando on load");
			var event:Event = new Event (ExternallyControlledObject.ON_LOAD,true,true);
			dispatchEvent (event);
		}
		/**
		 * Despacha ON_FAIL
		 * 
		 */
		protected function dispatchOnLoadFail ():void{
			var event:Event = new Event (ExternallyControlledObject.ON_FAIL,true,true);
			dispatchEvent (event);
		}		
		/**
		 * Copia las propiedades cargadas dentro de este objeto.
		 * @param $data
		 * 
		 */
		protected function copyProperties  ($data:Object):void{
			for (var propertyName:String in $data){
					////trace("this."+propertyName+"="+$data[propertyName]+"     en:   "+this);
					//this[propertyName]= $data[propertyName];
					createProperty (propertyName, $data[propertyName])
					////trace ("Tipos: "+typeof this[propertyName]);
			}
		}
		/**
		 * Genera o llena una propiedad dentro de  este scope, es necesario que este método sea sobrecargado si se genera una subclase, pues el diseño de sealed-Classes de as3 no permite la escritura de otro modo.
		 * @param $name
		 * @param $value
		 * 
		 */		
		protected function createProperty ($name:String, $value:*):void{
			this[$name]= $value;
		}
		/**
		 * Genera una propiedad inyectada desde fuera, si _allowExternalData esta establecida como true.
		 * @param $name
		 * @param $value
		 * @param $caller
		 * 
		 */
		public function decorate ($name:String, $value:Object, $caller:ExternallyControlledObject):void{
			if (this._allowExternalData){
				createProperty ($name, $value)
			}
		}
	}
}