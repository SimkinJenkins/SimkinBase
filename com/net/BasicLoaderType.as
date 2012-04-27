package com.net {

	public class BasicLoaderType {
		/**
		* Define una carga de un objeto grafico, como imagenes, swf, etc.
		*/
		public static const GRAPHIC:String = "graphic";
		/**
		* Define una carga de un objeto logico, como archivos txt, xml, etc.
		*/		
		public static const LOGIC:String = "logic"		
		/**
		* Define una carga de un objeto de sonido, como archivos mp3.
		*/
		public static const SOUND:String = "sound";
		
		public static function getLoaderType ($fileExtension:String):String{
			var type:String;
			if($fileExtension == "txt" || $fileExtension == "xml" || $fileExtension == "alia"){
				type = BasicLoaderType.LOGIC;
			}
			else if($fileExtension == "mp3" || $fileExtension == "wav"){
				type = BasicLoaderType.SOUND
			}
			else{
				type = BasicLoaderType.GRAPHIC;
			}
			return type;
		}
	}
}