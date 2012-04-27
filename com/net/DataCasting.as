package com.etnia.net{
	
	import flash.net.getClassByAlias;
	import flash.utils.Dictionary;
	
	public class DataCasting{
		
		public function DataCasting(){
			//trace("DataCasting");
		}
		
		public function castData($data: *, $dataCastType: String): Object{
			var castData: Object;
			var isXml: Boolean = false
			var nodeType: String = $dataCastType;
			var haveChilds: Boolean = false;
			var nodeValue: String = String($data);
			if($data is XML){
				nodeType = $data.@varType;
				haveChilds = $data.children().length() > 1 ? true : false;
				nodeValue = String($data.child(0));
				isXml = true;
			}
			var className:String = nodeType;
			if(nodeType == null || nodeType == ""){
				var nodeTypeIsPrimitive:Boolean = this.isPrimitive (nodeType);
				var isNotTypedBoolean:Boolean = !nodeTypeIsPrimitive && (nodeValue == "true" || nodeValue == "false");
				var isNotTypedNumber:Boolean = !nodeTypeIsPrimitive && (!isNaN(Number(nodeValue))) ;
				var isNotTypedString:Boolean =  !nodeTypeIsPrimitive  && !isNotTypedBoolean && !isNotTypedNumber && !haveChilds;
				var isNotTypedObject:Boolean =  !nodeTypeIsPrimitive && haveChilds;
			}
			if(nodeType != null)var normalizedNodeType:String = nodeType.toLowerCase();
			if(normalizedNodeType == "array")
			{
				castData = castDataAsArray($data, isXml);
			}
			else if(normalizedNodeType == "object")
			{
				castData = castDataAsObject($data, isXml);
			}
			else if(normalizedNodeType == "dictionary")
			{
				castData = castDataAsObject($data, true);
			}			
			else if(normalizedNodeType == "string" || isNotTypedString)
			{
				castData = castDataAsString($data, isXml);
			}
			else if(normalizedNodeType == "boolean" || isNotTypedBoolean )
			{
				castData = castDataAsBoolean($data, isXml);
			}
			else if(normalizedNodeType == "number"  || isNotTypedNumber )
			{
				castData = castDataAsNumber($data, isXml);
			}
			else if(normalizedNodeType == "uint")
			{
				castData = castDataAsNumber($data, isXml,"uint");
			}
			else if(normalizedNodeType == "int")
			{
				castData = castDataAsNumber($data,isXml,"int");
			}			
			else if(nodeType != null && nodeType != "")
			{
				castData = castDataAsCustomObject (className, isXml, $data)
			}
			return castData;
		}
		
		private function isPrimitive ($type:String):Boolean{
			if($type == null || $type == "" )return false;
			var primitiveValues:Array = new Array ("boolean","array","number","string","object","dictionary","int","uint")	
			for (var i:uint = 0; i< primitiveValues.length;i++){
				var currentValue:String = primitiveValues[i];
				if ($type.toLowerCase() == currentValue){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * @private
		 * Castea los datos como Array
		 */
		protected function castDataAsArray($data:*, $isXml:Boolean):Array
		{
			var finalArray:Array = new Array();
			if($isXml)
			{
				var totalNodes:uint = $data.children().length();
				for(var i:uint = 0; i < totalNodes; i++)
				{
					finalArray[i] = castData(new XML($data.child(i)), null);
				}
			}
			else
			{
				var data:Array = String($data).split(",");
				for(var j:uint = 0; j < data.length; j++)
				{
					finalArray[i] = castData(data[i], null)
				}
			}
			return finalArray;
		}
		
		
		/**
		 * @private
		 * Castea los datos como Object
		 */
		protected function castDataAsObject($data:*, isXml:Boolean, $dictionary:Boolean = false):Object
		{
			var finalObject:Object;
			if($dictionary){
				finalObject = new Dictionary ();
			}else{
				finalObject = new Object();
			}
			if(isXml)
			{
				var totalNodes:uint = $data.children().length();
				for(var i:uint = 0; i < totalNodes; i++)
				{
					var currentNode:XML = new XML($data.child(i));
					var currentNodeName:String = currentNode.@varName;
					finalObject[currentNodeName] = castData(currentNode, null);
				}
			}
			else
			{
				var data:Array = String($data).split(",");
				for(var j:uint = 0; j < data.length; j++)
				{
					var object:Array = String(data[j]).split("=");
					finalObject[object[0]] = castData(object[1], null)
				}
			}
			return finalObject;
		}
		protected function castDataAsCustomObject ($className:String, $data:*, $isXml:Boolean):Object {
			var classReference:Class = getClassByAlias ($className);
			var finalObject:Object = new classReference ();
			if($isXml &&  $data is XML){
				var totalNodes:uint = $data.children().length();
				for(var i:uint = 0; i < totalNodes; i++){
					var currentNode:XML = new XML($data.child(i));
					var currentNodeName:String = currentNode.@varName;
					finalObject[currentNodeName] = castData(currentNode, null);
				}
			}else{
				var data:Array = String($data).split(",");
				for(var j:uint = 0; j < data.length; j++){
					var object:Array = String(data[j]).split("=");
					finalObject[object[0]] = castData(object[1], null)
				}
			}
			return finalObject;
		}
		
		/**
		 * @private
		 * Castea los datos como String
		 */
		protected function castDataAsString($data:*, $isXml:Boolean): String{
			var finalString:String;
			if($isXml){
				finalString = String($data.child(0));
			}else{
				finalString = String($data);
			}
			return finalString;
		}
		
		
		/**
		 * @private
		 * Castea los datos como Booleano
		 */
		protected function castDataAsBoolean($data:*, $isXml:Boolean): Boolean{
			var finalBoolean:Boolean;
			var castData:String;
			if($isXml)
			{
				castData = String($data.child(0));
			}
			else
			{
				castData = String($data);
			}
			castData = castData.toLowerCase();
			if(castData == "true")
			{
				finalBoolean = true;
			}
			else if(castData == "false")
			{
				finalBoolean = false;
			}
			else if(!isNaN(parseInt(castData)))
			{
				var numberData:Number = Number(castData);
				finalBoolean = Boolean(numberData);
			}
			else
			{
				trace(castData + " not expected, returning false by default");
				finalBoolean = false;
			}
			return finalBoolean;
		}
		
		
		/**
		 * @private
		 * Castea los datos como Int
		 */
		protected function castDataAsNumber($data:*, $isXml:Boolean, $type:String = "number"):Object
		{
			var finalNumber:Object;
			var castData:Object;
			if($isXml)
			{
				castData = $data.child(0);
			}
			else
			{
				castData = $data;
			}
			if($type == "int"){
				finalNumber = new int(castData);
			}else if($type == "uint"){
				finalNumber = new uint(castData);
			}else{
				finalNumber = new Number (castData)
			}
			return finalNumber;
		}
	}
}