package com.net {

	import flash.net.URLRequest;

	public class BasicURLRequest {

		private var _urlRequest:URLRequest;
		private var _retry:uint;
		
		/**
		 * Constructor
		 * @param $url Direccion url que se solicitara
		 * @param $retry Numero de reintentos que se podran realizar para solicitar la url.
		 * 
		 */
		public function BasicURLRequest($url:String, $retry:uint = 5)
		{
			_retry = $retry;
			_urlRequest = new URLRequest($url);
		}

		/**
		 * El contenido MIME de cualquier dato POST
		 * @param $content Contenido
		 * 
		 */

		public function set contentType($content:String):void
		{
			_urlRequest.contentType = $content;
		}
		public function get contentType():String
		{
			return _urlRequest.contentType;
		}
		
		/**
		 * Objeto que contiene informacion que sera enviada junto con la peticion de url. Esta propiedad se usa en 
		 * conjunto con la propiedad method.
		 * <br><br>
		 * Si el valor de EtniaURLRequest.method es POST los datos son enviados mediante el metodo HTTP POST.
		 * Si el valor de EtniaURLRequest.method es GET los datos son enviados mediante el metodo HTTP GET.
		 * <br><br>
		 * <li type="disc">Si el objeto es un ByteArray, los datos bianrios del objeto son usados como datos POST. 
		 * Para GET no se soporta datos tipo ByteArray.</li>
		 * <li type="disc">Si el objeto es de tipo URLVariables y el metodo es POST,la variables son codificadas usando 
		 * x-www-form-urlencoded y el string resultante es usado como datos POST.</li>
		 * <li type="disc">Si el objeto es de tipo URLVariables y el metodo es GET, la variables son enviadas con la peticion</li>
		 * 
		 * @param $data
		 * 
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/utils/ByteArray.html flash.utils.ByteArray
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/URLVariables.html flash.net.URLVariables
		 */
		public function set data($data:Object):void
		{
			_urlRequest.data = $data;
		}
		public function get data():Object
		{
			return _urlRequest.data;
		}
		
		/**
		 * Controla el metodo de envio de la solicitud. Los valores aceptados son URLRequestMethod.GET y URLRequestMethod.POST.
		 * El valor por default es URLRequestMethod.GET.
		 * 
		 * @param $method Metodo
		 * 
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/URLRequestMethod.html flash.net.URLRequestMethod
		 */
		public function set method($method:String):void
		{
			_urlRequest.method = $method;
		}
		public function get method():String
		{
			return _urlRequest.method;
		}
		
		/**
		 * Array de cabeceras de HTTP que son indexadas a la solicitud. Cada objeto en el array debe ser un URLRequestHeader
		 * 
		 * @param $headers Cabeceras
		 * 
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/URLRequestHeader.html flash.net.URLRequestHeader
		 */
		public function set requestHeaders($headers:Array):void
		{
			_urlRequest.requestHeaders = $headers;
		}
		public function get requestHeaders():Array
		{
			return _urlRequest.requestHeaders;
		}
		
		/**
		 * La url que se solicitara.
		 * @param $url
		 * 
		 */
		public function set url($url:String):void
		{
			_urlRequest.url = $url;
		}
		public function get url():String
		{
			return _urlRequest.url;
		}
		
		/**
		 * Numero de reintentos que se podra hacer por cada solicitud.
		 * @param $retry
		 * 
		 */
		public function set retry($retry:uint):void
		{
			_retry = $retry;
		}
		public function get retry():uint
		{
			return _retry;
		}
		
		/**
		 * Obtiene la peticion de url.
		 * @return 
		 * 
		 */
		public function get request():URLRequest {
			return _urlRequest;
		}

	}
}