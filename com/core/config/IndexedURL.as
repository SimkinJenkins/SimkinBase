package com.core.config {

	/**
	 * Objeto que representa cada una de las URLs indexadas dentro de URLManagerState que a su vez se administran desde URLManager.
	 * @author jgomez
	 * @see com.etnia.core.config.URLManager
	 * @see com.etnia.core.config.URLManagerState
	 * 
	 */
	public class IndexedURL	{
		protected var _URL:String;
		protected var _ID:String;
		protected var _hostID:String;
		protected var _haveHost:Boolean = false;
		/**
		 * Constructor
		 * @param $ID
		 * @param $URL
		 * @param $hostID
		 * @return 
		 * 
		 */
		public function IndexedURL ($ID:String = "",$URL:String = "",$hostID:String = ""){
			this.hostID = $hostID;
			this.ID = $ID;
			this.URL = $URL;
		}		
		//////////////////////////////////////////////////////////////////////////
		/**
		 * Retorna la URL almacenada.
		 * @return 
		 * 
		 */
		public function get URL ():String{
			return this._URL
		}
		/**
		 * Escribe la URL almacenada.
		 * @param $URL
		 * 
		 */
		public function set URL ($URL:String):void{
			this._URL = $URL;
		}
		/**
		 * Retorna el ID único.
		 * @return 
		 * 
		 */
		public function get ID ():String{
			return this._ID;
		}
		/**
		 * Escribe el ID único.
		 * @param $ID
		 * 
		 */
		public function set ID ($ID:String):void{
			this._ID = $ID;
		}
		/**
		 * Retorna el ID de su host, por defecto vacío.
		 * @return 
		 * 
		 */
		public function get hostID ():String{
			return this._hostID;
		}
		/**
		 * Escribe el ID de su host. EL URL contenido por este objeto se concatenará a el URL de su host y asi consecutivamente.
		 * @param $hostID
		 * 
		 */
		public function set hostID ($hostID:String):void{
			if ($hostID == null || $hostID == ""){
				this._haveHost = false
			}else{
				this._haveHost = true;	
			}		
			////trace ("seteando hostID:["+ $hostID+"]"+"  - "+this.haveHost);	 
			this._hostID = $hostID;
		}
		/**
		 * Retorna true si posee host.
		 * @return 
		 * 
		 */
		public function get haveHost ():Boolean{
			return this._haveHost;			
		}
		/**
		 * Retorna una copia idéntico del objeto con todas sus propiedades (copia NO referencia).
		 * @return 
		 * 
		 */
		public function clone ():IndexedURL{
				var newIndexedURL:IndexedURL = new IndexedURL (this.ID,this.URL,this.hostID)
				return newIndexedURL;
		}
	}
}