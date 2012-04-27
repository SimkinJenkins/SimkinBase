package com.core.config {

	import com.net.ExternallyControlledObject;
	
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;

	//import com.etnia.exceptions.URLManagerMisuseException;
	/**
	 * Carga tabla de URLs externa (IndexedURL's externas vía XMLDatamanager) y las deposita sobre URLManager.
	 * @author jgomez
	 * @example Ejemplo de formato de archivo xml externo:<BR><BR>
	 * <listing version="3.0" >
	 * &lt;?xml version="1.0" encoding="UTF-8" ?&gt;   
		&lt;configurationFile&gt;  
		&lt;!-- VARIABLES GLOBALES DEL MUNDO VIRTUAL --&gt;  
			&lt;xmlData format="xmlDataManager" version="1.0"&gt;  
			&lt;!-- CONTROL DE URLS --&gt;  
				&lt;var varName="_urlsList" varType="Array"&gt;  
					&lt;!-- URL Dominio default --&gt;  
					&lt;var varType="com.etnia.core.config.IndexedURLDefinition"&gt;  
						&lt;var varName="ID" varType="String"&gt; base&lt;/var&gt;  
						&lt;var varName="stateID" varType="String"&gt; default&lt;/var&gt;  
						&lt;var varName="URL" varType="String"&gt; http://coca-cola.interalia.net/&lt;/var&gt;  
						&lt;var varName="hostID" varType="String"&gt; &lt;/var&gt;  
					&lt;/var&gt;  
					&lt;!-- URL Carpeta general de la aplicacion --&gt;  
					&lt;var varType="com.etnia.core.config.IndexedURLDefinition"&gt;  
						&lt;var varName="ID" varType="String"&gt; appDir&lt;/var&gt;  
						&lt;var varName="stateID" varType="String"&gt; default&lt;/var&gt;  
						&lt;var varName="URL" varType="String"&gt; &lt;/var&gt;  
						&lt;var varName="hostID" varType="String"&gt; base&lt;/var&gt;  
					&lt;/var&gt;  
					&lt;!-- URL Carpeta de configuracion --&gt;  
					&lt;var varType="com.etnia.core.config.IndexedURLDefinition"&gt;  
						&lt;var varName="ID" varType="String"&gt; configDir&lt;/var&gt;  
						&lt;var varName="stateID" varType="String"&gt; default&lt;/var&gt;  
						&lt;var varName="URL" varType="String"&gt; config/&lt;/var&gt;  
						&lt;var varName="hostID" varType="String"&gt; base&lt;/var&gt;  
					&lt;/var&gt; 			 
				&lt;/var&gt;  
				&lt;/xmlData&gt;  
			&lt;/configurationFile&gt;  
	 * </listing>
	 * <BR><BR>
	 * @see com.etnia.net.XMLDataManager
	 * @see com.etnia.core.config.URLManager
	 * @see com.etnia.core.config.URLManagerState
	 * @see com.etnia.core.config.IndexedURL
	 * 
	 * 
	 */
	public dynamic class URLManagerConfig extends ExternallyControlledObject {

		public static const ON_LOAD:String = "on_load";
		public static const ON_FAIL:String = "on_fail";
		private var _urlManager:URLManager;
		private var _urlsList:Array;
		///////////////////////////////////////		
		 /**
		  * Constructor
		  * @return 
		  * 
		  */
		 public function URLManagerConfig (){
			this._urlManager = URLManager.getInstance();
			registerClassAlias ("com.etnia.core.config.IndexedURLDefinition", IndexedURLDefinition);
			
		}
		/**
		 * Retorna la lista de urls recopiladas en el archivo externo.
		 * @return 
		 * 
		 */
		public function get urlsList ():Array{
			return this._urlsList;
		}
		/**
		 * Detona evento ON_LOAD
		 * 
		 */		
		protected override function dispatchOnLoad():void{
			this.fillURLManager(this.urlsList);
			//Despache de evento
			var event:Event = new Event (URLManagerConfig.ON_LOAD);
			dispatchEvent (event);	
		}
		/**
		 * Llena la informacion recibida sobre URLManager
		 * @param $data
		 * 
		 */
		protected function fillURLManager ($data:Array):void{			
			var ID:String;
			var hostID:String;
			var URL:String;
			var stateID:String;
			if ($data == null){
				//throw new URLManagerMisuseException ("URLManagerConfig: unexpected format in "+this._configurationFilePath+". You need define a var _urlsList:Array in there.");
				throw new Error ("URLManagerConfig: unexpected format in "+this._configurationFilePath+". You need define a var _urlsList:Array in there.");
				return;			
			}
			////trace ("data length :: "+$data.length);
			for (var i:int = 0;i<$data.length;i++){
				var currentURL:IndexedURLDefinition = $data[i]
				ID = currentURL.ID;
				hostID = currentURL.hostID;
				URL = currentURL.URL;
				////trace ("probando info recibida:: "+ID+" , "+hostID+" , "+URL+" :: "+currentURL)
				stateID = currentURL.stateID == null || currentURL.stateID == "" ? stateID : currentURL.stateID;
				if (!this._urlManager.stateExists(stateID)){
					this._urlManager.addState(stateID);
				}
				this._urlManager.getState(stateID).addPath(ID,URL,hostID);
			}
			
			
		}
		/**
		 * Se sobreescribe el metodo para tener permisos para escribir sobre esta subclase de Config.
		 * @param $name
		 * @param $value
		 * 
		 */
		protected override function createProperty ($name:String, $value:*):void{
			this[$name]= $value;
		}
		
		
	}
	
	
	
	
	
	
	
	
	
}