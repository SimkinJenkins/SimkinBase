package com.net {

	import flash.events.EventDispatcher;
	import flash.net.getClassByAlias;
	import flash.utils.Dictionary;

	public class XMLDataManager extends EventDispatcher {

		public static const ON_LOAD:String = "Xml load complete";
		public static const ON_FAIL:String = "Cannot load xml file";
		private var _xmlFile:String;
		private var _initialTag:String;
		private var _xmlDocument:XML = null;
		private var _xml:Object;
		
		/**
		 * Constructor. Crea una nueva instancis de XMLDataManager. Recibe como parametro el ID del archivo
		 * XML del cual se van a obtener los datos.
		 * 
		 * @param $xmlFileID
		 * 
		 */
		public function XMLDataManager()
		{
			/**/
		}
		
		public function set xmlDocument($document:XML):void
		{
			if($document != null && $document != ""){
				_xmlDocument = $document;
			}else{
				//throw new DataTransmitionException(DataTransmitionException.XML_EMPTY,"\n\tXMLDataManager:\tDocument: \""+$document+"\".");
			}
		}
		public function get xmlDocument():XML
		{
			return _xmlDocument;
		}
		
		
		/**
		 * Obtiene los datos del archivo XML. El parametro $initialTag indica a partir de que etiqueta
		 * del documento XML se comenzara a obtener los datos. Puede parsear datos de tipo Object,
		 * Array, int, Boolean y String. El tipo se especifica dentro de las etiquetas mediante el
		 * atributo varType.
		 * 
		 * @param $initialTag
		 * @return Datos dentro del xml parseado de acuerdo al tipo.
		 * 
		 */
		public function getData($initialTag:String = "xmlData"):Object
		{
			_initialTag = $initialTag;
			var xmlDocument:XML = getXMLFile();
			var xmlData:Object = getParseData(xmlDocument);
			return xmlData;
		}
		
		public function getAttributeData($initialTag:String):Object
		{
			_initialTag = $initialTag;
			var xmlDocument:XML = getXMLFile();
			var xmlAttributeData:Object = getParseAttributeData(xmlDocument);
			return xmlAttributeData;
		}
		
		
		public function load($xmlFileURL:String, $cache:Boolean = true):void
		{
			////trace ("datamanager load")
			_xmlFile = $xmlFileURL;
			//_library.load(_xmlFile, _libraryTicket, 5/*, $cache*/);
		}
		
		/**
		 * @private
		 * Obtiene la referencia del archivo xml para poder extraer los datos.
		 */
		protected function getXMLFile():XML
		{
			if(_xmlDocument == null) {
				var xmlDocument:XML = new XML(_xml);
				XML.ignoreComments = true;
				XML.ignoreWhitespace = true;
				return xmlDocument;
			}
			else
			{
				return _xmlDocument;
			}
		}
		
		
		/**
		 * @private
		 * Parsea los datos de acuerdo a su tipo
		 */
		protected function getParseData($xmlNode:XML):Object
		{
			var data:Object;
			var initialNode:XML = searchNode($xmlNode);
			if(initialNode == null)
			{
				//throw new XMLTagException(_initialTag);
			}
			data = createDataObject(initialNode);
			return data;
		}
		
		
		protected function getParseAttributeData($xmlNode:XML):Object
		{
			var attributeData:Object
			var initialNode:XML = searchNode($xmlNode);
			if(initialNode == null)
			{
				//throw new XMLTagException(_initialTag);
				//Tracer.warn(new Warning("El xmldata está mal formado","XMLDataManager::getParseAttributeData"));
				return null
			}
			attributeData = createAttributeDataObject(initialNode);
			return attributeData;
		}
		
		
		/**
		 * @private
		 * Busca el nodo a partir del cual se extraeran los datos. 
		 */
		protected function searchNode($xmlNode:XML):XML
		{
			var currentNode:XML;
			var totalChildNodes:uint = $xmlNode.children().length();
			if($xmlNode.name()) {
				//trace($xmlNode);
			}
			if($xmlNode.name() && $xmlNode.name().localName == _initialTag || $xmlNode.name() && $xmlNode.name().localName == "XMLData")
			{
				return $xmlNode;
			}
			else
			{
				if(totalChildNodes != 0)
				{
					for(var i:uint = 0; i < totalChildNodes; i++)
					{
						currentNode = new XML($xmlNode.child(i));
						if(currentNode.name().localName == _initialTag)
						{
							return currentNode;
						}
					}
				}
			}
			return null;
		}

		/**
		 * @private
		 * Crea el nuevo objeto con los datos parseados.
		 */
		protected function createDataObject($xmlNode:XML):Object {
			var data:Object = new Object();
			var totalNodes:uint = $xmlNode.children().length();
			for(var i:uint = 0; i < totalNodes; i++) {
				var currentNode:XML = $xmlNode.children()[i];
				var currentNodeName:String = currentNode.@varName;
				var currentNodeData:Object = getNodeData(currentNode);
				data[currentNodeName] = currentNodeData;
			}
			return data;
		}

		protected function createAttributeDataObject($xmlNode:XML):Object {
			var attributeData:Array = new Array();
			var totalNodes:uint = $xmlNode.children().length();
			for(var i:uint = 0; i < totalNodes; i++)
			{
				var currentNode:XML = new XML($xmlNode.child(i));
				var attributesList:XMLList = currentNode.@*; 
				var totalAttributes:uint = attributesList.length();
				attributeData[i] = new Object();
				for(var j:uint = 0; j < totalAttributes; j++)
				{
					var currentAttributeName:String = attributesList[j].name();
					attributeData[i][currentAttributeName] = attributesList[j];
				}
			}
			return attributeData;
		}

		/**
		 * @private
		 * Obtiene los datos del nodo. De acuerdo al tipo se hara el cast. Si el tipo de variable no
		 * se especifica el cast se hace automatico para object, boolean, number y string.
		 */
		protected function getNodeData($xmlNode:XML):Object
		{
			var nodeData:Object;
			var nodeName:String = $xmlNode.@varName;
			var nodeType:String = $xmlNode.@varType;
			var className:String = nodeType;
			nodeType = nodeType.toLowerCase();
			//untyped Values -------------------------->
			/////////////////////////////////////////////////////////////////////////////////////////////
			if(nodeType == null || nodeType == ""){
				var nodeTypeIsPrimitive:Boolean = this.isPrimitive (nodeType);
				var nodeValue:String = String($xmlNode.child(0));
				var haveChilds:Boolean = $xmlNode.children().length() > 1 ? true : false;
				var isNotTypedBoolean:Boolean = !nodeTypeIsPrimitive && (nodeValue == "true" || nodeValue == "false");
				var isNotTypedNumber:Boolean = !nodeTypeIsPrimitive && (!isNaN(Number(nodeValue))) ;
				var isNotTypedString:Boolean =  !nodeTypeIsPrimitive  && !isNotTypedBoolean && !isNotTypedNumber && !haveChilds;
				var isNotTypedObject:Boolean =  !nodeTypeIsPrimitive && haveChilds;
			}
			/////////////////////////////////////////////////////////////////////////////////////////////
			if(nodeType == "array")
			{
				nodeData = castNodeAsArray($xmlNode);
			}
			else if(nodeType == "object")
			{
				nodeData = castNodeAsObject($xmlNode);
			}
			else if(nodeType == "dictionary")
			{
				nodeData = castNodeAsObject($xmlNode, true);
			}			
			else if(nodeType == "string" || isNotTypedString)
			{
				nodeData = castNodeAsString($xmlNode);
			}
			else if(nodeType == "boolean" || isNotTypedBoolean )
			{
				nodeData = castNodeAsBoolean($xmlNode);
			}
			else if(nodeType == "number"  || isNotTypedNumber )
			{
				nodeData = castNodeAsNumber($xmlNode);
			}
			else if(nodeType == "uint")
			{
				nodeData = castNodeAsNumber($xmlNode,"uint");
			}
			else if(nodeType == "class")
			{
				nodeData = castNodeAsClass($xmlNode);
			}
			else if(nodeType == "int")
			{
				nodeData = castNodeAsNumber($xmlNode,"int");
			}			
			else if(nodeType != null && nodeType != "")
			{
				////trace ("className: "+className);
				nodeData = castNodeAsCustomObject (className, $xmlNode)
				/*var noTypeValue:String = String($xmlNode.child(0))
				if(noTypeValue == "true" || noTypeValue == "false")
				{
					nodeData = castNodeAsBoolean($xmlNode);
				}
				else if(!isNaN(parseInt(noTypeValue)))
				{
					nodeData = castNodeAsNumber($xmlNode);
				}
				else
				{
					var numberOfChilds:uint = $xmlNode.children().length();
					var objectNodeInside:Boolean = false;
					for(var i:uint = 0; i < numberOfChilds; i++)
					{
						var currentChild:XML = new XML($xmlNode.child(0));
						var currentChildType:String = currentChild.@varType;
						currentChildType = currentChildType.toLowerCase();
						if(currentChildType == "array" || currentChildType == "object")
						{
							objectNodeInside = true;
							break;
						}
					}
					if(objectNodeInside == true)
					{
						nodeData = castNodeAsObject($xmlNode);
					}
					else
					{
						nodeData = castNodeAsString($xmlNode);
					}
				}*/
			}
			return nodeData;
		}
		private function isPrimitive ($type:String):Boolean{
			if($type == null || $type == "" )return false;
			var primitiveValues:Array = new Array ("boolean","array","number","string","object","dictionary","int","uint")	
			for (var i:uint = 0; i< primitiveValues.length;i++){
				var currentValue:String = primitiveValues[i];
				if ($type == currentValue){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * @private
		 * Castea los datos como Array
		 */
		protected function castNodeAsArray($xmlNode:XML):Array
		{
			var finalArray:Array = new Array();
			var totalNodes:uint = $xmlNode.children().length();
			for(var i:uint = 0; i < totalNodes; i++)
			{
				finalArray[i] = getNodeData(new XML($xmlNode.child(i)));
			}
			return finalArray;
		}
		
		
		/**
		 * @private
		 * Castea los datos como Object
		 */
		protected function castNodeAsObject($xmlNode:XML,$dictionary:Boolean = false):Object
		{
			var finalObject:Object;
			if($dictionary){
				finalObject = new Dictionary ();
			}else{
				finalObject = new Object();
			}
			var totalNodes:uint = $xmlNode.children().length();
			for(var i:uint = 0; i < totalNodes; i++)
			{
				var currentNode:XML = new XML($xmlNode.child(i));
				var currentNodeName:String = currentNode.@varName;
				finalObject[currentNodeName] = getNodeData(currentNode);
			}
			return finalObject;
		}
		protected function castNodeAsCustomObject ($className:String, $xmlNode:XML):Object {
			var classReference:Class = getClassByAlias ($className);
			// classReference:Class = getDefinitionByName($className) as Class;
			var finalObject:Object = new classReference ();
			var totalNodes:uint = $xmlNode.children().length();
			for(var i:uint = 0; i < totalNodes; i++){
				var currentNode:XML = new XML($xmlNode.child(i));
				var currentNodeName:String = currentNode.@varName;
				try{
					finalObject[currentNodeName] = getNodeData(currentNode);
				} catch($error: Error){
					trace($error);
				}
			}
			return finalObject;
		}
		
		/**
		 * @private
		 * Castea los datos como String
		 */
		public static function castNodeAsString($xmlNode:XML):String {
			return String($xmlNode.child(0));
		}
		
		
		/**
		 * @private
		 * Castea los datos como Booleano
		 */
		protected function castNodeAsBoolean($xmlNode:XML):Boolean
		{
			var finalBoolean:Boolean;
			var nodeData:String = String($xmlNode.child(0));
			nodeData = nodeData.toLowerCase();
			if(nodeData == "true")
			{
				finalBoolean = true;
			}
			else if(nodeData == "false")
			{
				finalBoolean = false;
			}
			else if(!isNaN(parseInt(nodeData)))
			{
				var numberData:Number = Number(nodeData);
				finalBoolean = Boolean(numberData);
			}
			else
			{
				//Tracer.send(nodeData + " not expected, returning false by default");
				finalBoolean = false;
			}
			return finalBoolean;
		}
		
		
		/**
		 * @private
		 * Castea los datos como Int
		 */
		protected function castNodeAsNumber($xmlNode:XML,$type:String = "number"):Object
		{
			var finalNumber:Object;
			if($type == "int"){
				finalNumber = new int($xmlNode.child(0));
			}else if($type == "uint"){
				finalNumber = new uint($xmlNode.child(0));
			}else{
				finalNumber = new Number ($xmlNode.child(0))
			}
			return finalNumber;
		}
		
		/**
		 * @private
		 * Castea los datos como class
		 */
		protected function castNodeAsClass($xmlNode:XML):Class{
			var classReference:Class = getClassByAlias (String($xmlNode.child(0)));
			return classReference;
		}
		
		/*
		protected override function onItemLoaded($event:LibraryEvent):void
		{
			try {
				_xml = new XML($event.item);
				dispatchEvent(new Event(ON_LOAD));
			} catch($exception:Error) {
				_library.load(_xmlFile, _libraryTicket, 5/*, true* /);
			}
		}
		
		protected override function onItemFail($event:LibraryEvent):void
		{
			dispatchEvent(new Event(ON_FAIL));
		}
		*/
	}
}