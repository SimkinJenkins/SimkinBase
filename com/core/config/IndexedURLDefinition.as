package com.core.config {

	internal class IndexedURLDefinition extends IndexedURL {

		protected var _stateID:String;

		public function IndexedURLDefinition ($ID:String = "",$URL:String = "",$hostID:String = "", $stateID:String = ""){
			this.hostID = $hostID;
			this.ID = $ID;
			this.URL = $URL;
			this.stateID = $stateID;
		}

		public function get stateID ():String{
			return this._stateID;
		}

		public function set stateID ($stateID:String):void{
			this._stateID = $stateID;
		}

		public override function clone ():IndexedURL{
				var newIndexedURL:IndexedURL = new IndexedURLDefinition (this.ID,this.URL,this.hostID, this.stateID)
				return newIndexedURL;
		}
	}	
}