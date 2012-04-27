package com.net {
	
	import flash.net.URLVariables;
	
	public dynamic class ServerResponse extends URLVariables{
		
		public function ServerResponse($source:String = null){
			if($source != null){
				var variables:String = normalize($source);
				super(variables);
			}
		}
		
		protected function normalize($source:String):String{
			var normalSource:String;
			var pattern:RegExp = /&\W|&\s/;
			while(($source.charAt(0) == "\t") || ($source.charAt(0) == "\n") || ($source.charAt(0) == "&") || ($source.charAt(0) == " ")){
				$source = $source.substr(1);
			}
			$source = $source.replace(pattern,"");
			if($source.charAt($source.length-1) == "&"){
				$source = $source.slice(0,$source.length-1);
			}
			normalSource = $source;
			return normalSource;
		}
	}
}