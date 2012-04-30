package com.core.config {

	import flash.utils.Dictionary;	
	/**
	 * Estado para administración de URLs indexadas dentro de URLManager, administra, crea y busca ID's de URLs (IndexedURL) para concatenarlas y retornarlas a solicitud del usuario (getPath(ID)). El diseño no prohibe la creación directa de URLManagerState, este modo puede usarse para administrar una concentración pequeña de URL's; sin embargo, la creación de states está destinada a URLManager.
	 * @author jgomez
	 * @see com.etnia.core.config.URLManager
	 * @see com.etnia.core.config.URLManagerState
	 * @see com.etnia.core.config.IndexedURL
	 */
	public class URLManagerState{	
		private var _ID:String;
		private var _urlDictionary:Dictionary
		/**
		 * Constructor.
		 * @param $ID
		 * 
		 */
		public function URLManagerState ($ID:String):void {
				this._ID = $ID;	
				this._urlDictionary = new Dictionary ();
		}
		/**
		 * Retorna ID del estado.
		 * @return 
		 * 
		 */
		public function get ID ():String{
			return this._ID;			
		}
		/**
		 * Retorna Dictionary donde se administran las todas las URLs manejadas por el estado, cada IndexedURL es indexada por su ID (IndexedURL.ID)
		 * @return
		 * @see flash.utils.Dictionary
		 * @see com.etnia.core.config.IndexedURL
		 */
		public function get urlDictionary ():Dictionary{
			return this._urlDictionary;
		}
		public function addPath ($ID:String,$URL:String,$host:String = null):void{
			if(IDExist ($ID))return;
			this._urlDictionary[$ID]= new IndexedURL ($ID,$URL,$host)
			//this._urlDictionary[$ID]=$URL;
		}
		internal function updatePath ($indexedURL:IndexedURL):void{
			var ID:String = $indexedURL.ID;
			this._urlDictionary[ID]= $indexedURL;
		}
		public function deletePath ($ID:String):void{
			if(!IDExist ($ID))return;
			delete this._urlDictionary[$ID];
		}
		public function getPath ($urlID:String):String{
			if (!IDExist($urlID)) {
				throw new Error("urlID "+ this.ID + " : " + $urlID);
				return null;
			}
			var path:String = this.getURLHeritage (this._urlDictionary[$urlID])
			return path;
			
		}

		public function IDExist ($ID:String):Boolean {
			var currentPath:String = this._urlDictionary[$ID];
			if (currentPath == null) {
					return false;
			} else {
					return true;
			}
		}

		private function getURLHeritage ($indexedURL:IndexedURL):String {
			var finalURL:String = new String ();
			var heritageList:Array = new Array ($indexedURL.URL);
			var currentIndexedURL:IndexedURL = $indexedURL;
			var invertedSlashExist:Boolean = false;
			while (currentIndexedURL.haveHost){
					if(!this.IDExist(currentIndexedURL.hostID)){
						throw new Error ("urlID"+this.ID,currentIndexedURL.hostID+" (["+currentIndexedURL.hostID+"]was typed as parent of ["+currentIndexedURL.ID+"] ID)")
						return;
					}				
					var currentHost:IndexedURL = this._urlDictionary[currentIndexedURL.hostID];
					var currentHostURL:String = currentHost.URL;
					if(currentHostURL.indexOf("\\") != -1){
						invertedSlashExist = true;
					}
					heritageList.push (currentHostURL);
					currentIndexedURL = currentHost;
			}
			for (var i:Number = heritageList.length-1;i>=0;i--){
				var currentURL:String =  heritageList[i];
				var nextURL:String = heritageList[i-1]
				var nextURLFirstChar:String = finalURL.substr (0,1)
				var lastChar:String = currentURL.substr (currentURL.length-1)
				var lastAppendedChar:String = finalURL.substr (finalURL.length-1)
				finalURL += currentURL
				////trace ("last char:: "+lastChar+"\tde:\t"+finalURL+"\t se concateno:"+currentURL+" caracter inicial siguiente: "+nextURLFirstChar);
				if (i>0 &&  lastChar != "/" && lastChar != "\\" && finalURL != "" && nextURLFirstChar != "/" && nextURLFirstChar != "\\" && currentURL != "" ){
					if(invertedSlashExist){
						finalURL += "\\";
					}else{
						finalURL += "/";
					}
				}
			}	
			return finalURL;
		}
		
	}	
}