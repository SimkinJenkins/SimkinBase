package com.core.config {

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * Singleton administrador de URLs. Cada URL debe ser asiganda con ID sobre un estado, y cada ID es único sobre determinado estado, esto quiere decir que cada estado es independiente y
	 * puede poseer los mismos estados que otro, sin mezclarse, solo se puede establecer el estado activo una vez, una vez establecido, los demás serán considerados secundarios y se requerira de su ID unico para acceder a ellos.<BR>
	 * A modo de ahorrar datos, cada ID puede ser designado como host de otro ID de modo que pueden irse anidando diversas rutas, es muy recomendable que las carpetas contenedoras de multiples documentos contengan su propio id de modo puedan ayudar cuando se trate de solicitar rutas adento de ellas, facilitando tambien asi el cambio de alguna ruta.
	 * @example Usos comunes de URLManager:<BR><BR>
	 * 		var myUrlManager:URLManager = URLManager.getInstance ();<BR>
			//Se Crea el estado "global"<BR>
			myUrlManager.addState("global");<BR>
			//Se Crea el estado "gameServers"<BR>
			myUrlManager.addState("gameServers");<BR>
			//Se agrega el path con ID "server1" dentro del state "gameServers"<BR>
			myUrlManager.getState("gameServers").addPath("server1","130.60.160.32")<BR>
			//Se agrega el path con ID "server2" dentro del state "gameServers"<BR>
			myUrlManager.getState("gameServers").addPath("server2","190.64.70.81")<BR>
			//SE ESTABLECE EL ESTADO ACTIVO; ESTE NO PODRA CAMBIAR.<BR>
			myUrlManager.setState("global");<BR>
			//las llamadas directas como addPath y getPath a URLManager responden al estado activo.<BR>
			//agregando paths al estado "Principal";<BR>
			myUrlManager.addPath("root","http://www.interalia.net/");<BR>
			myUrlManager.addPath("second","movies/","root");<BR>
			myUrlManager.addPath("third","config/","second");<BR>
			myUrlManager.addPath("final","finalFile.swf","third");<BR>
			//Solicito un path indexado.<BR>
			//trace ("El path obtenido desde url manager para el ID [final] es:: "+myUrlManager.getPath("final"))<BR>
			//output: El path obtenido desde url manager para el ID [final] es:: http://www.interalia.net/movies/config/finalFile.swf<BR>
			//trace("path para el server de juegos [server1] es:: "+myUrlManager.getState("gameServers").getPath("server1"));<BR>
			//Se muestra como crear un state secundario mezclando los anteriores<BR>
			//si existen coincidencias de urlID's en los states, serán guardadas las del último estado mergido<BR>
			//Una vez fusionados, "Mixed" poseera una copia de todos los datos de los estados mezclados.<BR>
			myUrlManager.addState("mixed");<BR>
			myUrlManager.mergeState("global","mixed")<BR>
			myUrlManager.mergeState("gameServers","mixed")<BR>
			<BR>
	 * 
	 * @see com.etnia.net.XMLDataManager
	 * @see com.etnia.core.config.URLManagerConfig
	 * @see com.etnia.core.config.URLManagerState
	 * @see com.etnia.core.config.IndexedURL
	 * @author jgomez
	 * 
	 */
	public class URLManager extends EventDispatcher {
		private var _statesDictionary:Dictionary;
		private var _currentState:URLManagerState;
		private var _currentStateID:String;
		private static var _instance:URLManager;
		/**
		 * Contructor del Singleton, no se debe invocar directametne.
		 * @see com.etnia.core.config.URLManager#getInstance
		 * @param $newCall
		 * @return 
		 * 
		 */
		public function URLManager ($newCall:Function = null){
			if ($newCall != URLManager.getInstance )			{
				throw new Error("URLManager");
			}
			if (_instance != null)			{
				throw new Error("URLManager");
			}			
			this._statesDictionary = new Dictionary ();
		}
		/**
		 * Método para obtener la instacia del singleton.
		 * @return 
		 * 
		 */
		public static function getInstance ():URLManager{
			if (_instance == null )	{
				_instance = new URLManager (arguments.callee);
			}
			return _instance;
		}
		/**
		 * Retorna el path del ID solicitado. El ID será buscado únicamente sobre el estado activo.
		 * @param $ID
		 * @return 
		 * 
		 */
		public function getPath ($ID:String):String{
			if (this._currentState == null){
				throw new Error ("return path ["+$ID+"] in getPath method");
			}
			return this._currentState.getPath($ID);
		}
		/**
		 * Agrega un nuevo path sobre el estado actvo.
		 * @param $ID
		 * @param $URL
		 * @param $hostID
		 * 
		 */		
		public function addPath ($ID:String, $URL:String, $hostID:String = null):void{
			if (this._currentState == null){
				throw new Error ("add path ["+$ID+"] in addPath method")
			}
			this._currentState.addPath ($ID, $URL,$hostID);
		}
		/**
		 * Actualiza un path ya indexado.
		 * @param $indexedURL
		 * 
		 */
		public function updatePath ($indexedURL: IndexedURL):void{
			if (this._currentState == null){
				throw new Error ("update indexedURL ["+$indexedURL.ID+"] in updatePath method")
			}
			this._currentState.updatePath($indexedURL);
		}
		/**
		 * Borra la url indexada que corresponde al ID enviado.
		 * @param $ID
		 * 
		 */
		public function deletePath ($ID:String):void{
			if (this._currentState == null){
				throw new Error ("delete path ["+$ID+"] in deletePath method")
			}
			return this._currentState.deletePath($ID);
		}
		/**
		 * Retorna un state previamente registrado.
		 * @param $stateID
		 * @return 
		 * @example Obteniendo un path de un state secundario:<BR><BR>
		 * 
		 * 
		 * var path:String = myUrlManager.getState("gameServers").getPath ("pathID")<BR>
		 * 
		 */
		public function getState ($stateID:String):URLManagerState{
			if (!stateExists($stateID)){
				throw new Error ("stateID"+$stateID)
				return null;
			}else{
				var selectedState:URLManagerState = this._statesDictionary [$stateID];
				return selectedState;
			}
			
		}
		/**
		 * Mezcla la informacion de 2 states.
		 * @param $stateID Estado del cual se copiara la información.
		 * @param $stateDestiny Estado receptor de la nueva información.
		 * 
		 */
		public function mergeState ($stateID:String, $stateDestiny:String):void{
			if (!this.stateExists($stateID)){
				throw new Error ("stateID"+$stateID)
			}
			if (!this.stateExists($stateDestiny)){
				throw new Error ("stateID"+$stateDestiny)
			}
			var state:URLManagerState = this.getState($stateID);
			var stateDestiny:URLManagerState = this.getState($stateDestiny);
			for (var name:String in state.urlDictionary){
				var currentIndexedURL:IndexedURL =  state.urlDictionary[name];
				var newIndexedURL:IndexedURL = cloneIndexedURL (currentIndexedURL);
				stateDestiny.updatePath(newIndexedURL)
			}
		}
		/**
		 * Se clona y obtiene la copia de un objeto IndexedURL
		 * @param $currentIndexedURL
		 * @return 
		 * @see com.etnia.core.config.IndexedURL
		 */
		public function cloneIndexedURL ($currentIndexedURL:IndexedURL):IndexedURL{
			//var indexedURL:IndexedURL = new IndexedURL ($currentIndexedURL.ID,$currentIndexedURL.URL,$currentIndexedURL.hostID)
			var indexedURL:IndexedURL = $currentIndexedURL.clone ();
			return indexedURL;
		}
		/**
		 * SE establece copmo activo un nuevo estado.
		 * @param $stateID
		 * @return 
		 * 
		 */
		public function setState  ($stateID:String):Boolean{
			////trace ("setting state:: "+arguments);
			//si no existe
			if (!stateExists($stateID)){
				throw new Error("stateID" + $stateID)
				return false;
			//si ya esta establecido
			}else if (this._currentStateID == $stateID){
				//var notice:Notice = new Notice ("State ["+ this._currentStateID +"] already established in URLManager","com.etnia.core.config.URLManager.setState ()");
				//Tracer.notify (notice);
				return false
			}
			if (this._currentStateID != null){
				throw new Error ("rejecting : ["+$stateID+"] state.");
				return false;
			//si existe y SI se establece
			}else{
				this._currentStateID = $stateID;
				this._currentState = _statesDictionary[$stateID];
				return true;
			}
		}
		/**
		 * Se agrega un nuevo estado vacio.
		 * @param $stateID
		 * 
		 */
		public function addState ($stateID:String):void{
			if (stateExists($stateID)){
				throw new Error ("stateID ["+$stateID+"] is already created");
			}
			this._statesDictionary[$stateID] = new URLManagerState($stateID)
		}
		/**
		 * Elimina el state seleccionado.
		 * @param $stateID
		 * 
		 */
		public function deleteState ($stateID:String):void{
			if (!stateExists($stateID)){
				throw new Error ("stateID"+$stateID)
				return false;
			}
			delete this._statesDictionary[$stateID]
		}
		/**
		 * Retorna true si el estado existe.
		 * @param $ID
		 * @return 
		 * 
		 */
		public function stateExists ($ID:String):Boolean{
			var currentState:URLManagerState = this._statesDictionary[$ID]
			if (currentState == null){
				return false;
			}else{
				return true;
			}
		}
		
		
		
		
		
		
		
	}	
	
	
}