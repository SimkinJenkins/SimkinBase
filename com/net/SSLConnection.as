package com.etnia.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.system.Security;
	
	public class SSLConnection extends EventDispatcher{
		
		public static const TIME_OUT: String = "SSLConnection_time_out";
		public static const RETRY_READING: String = "SSLConnection_retry_reading";
		
		private const MAX_CONNECTION_TRIES:Number = 30;
		private const SEARCH_RATE:Number = 60;
		private var _host: String;
		private var _policyFile: String;
		private var _sessionExist:Boolean = false;
		private var _connectionTries:uint;
		
		public function SSLConnection($host: String, $policyFile: String= ""){
			this._host = $host;//"https://jserver47.interalia/FreeTime/ssldocs/ws/"; //
			this._policyFile = $policyFile;//"crossdomain.xml";//
		}
		public function loadSSLSession(): void{
			this._connectionTries = 0;
			listenSSLSession();
			var SSLImagePath: String = this._host + this._policyFile;
			var url:URLRequest = new URLRequest("javascript:loadSSLImage('"+SSLImagePath+"')");
			navigateToURL(url, "_self");
		}
		protected function listenSSLSession(): void{
			var path: String = this._host + this._policyFile + "?rand=" + Math.round((Math.random() * 10000));/*this.randomRange(0, 99999);*/
			
			if (this._connectionTries > this.MAX_CONNECTION_TRIES) {
				//trace ("time out");
				this.onTimeOut();
				return;
			}
            if(this._connectionTries != 0) this.dispatchEvent(new Event(RETRY_READING));
			this._connectionTries++;
			Security.loadPolicyFile(this._host + this._policyFile + "?policy=1");
			var loader:URLLoader = new URLLoader();
            configureListeners(loader, true);
            var request:URLRequest = new URLRequest(path);
            request.method = URLRequestMethod.POST;
            loader.load(request);
			return;
		}
		protected function configureListeners($instance: URLLoader, $enabled: Boolean): void{
			if($enabled){
				$instance.addEventListener(Event.COMPLETE, completeHandler);
	            $instance.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	            $instance.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
   			}else{
   				$instance.removeEventListener(Event.COMPLETE, completeHandler);
   				$instance.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
   				$instance.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
   			}
		}
		protected function completeHandler($event: Event): void{
			var loader: URLLoader = $event.target as URLLoader;
			this.configureListeners(loader, false);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		protected function securityErrorHandler($event: SecurityErrorEvent): void{
			var loader: URLLoader = $event.target as URLLoader;
			this.configureListeners(loader, false);
			this.listenSSLSession();
		}
		protected function ioErrorHandler($event: IOErrorEvent): void{
			var loader: URLLoader = $event.target as URLLoader;
			this.configureListeners(loader, false);
			this.listenSSLSession();
		}
		protected function onTimeOut(): void{
			this.dispatchEvent(new Event(TIME_OUT));
		}
	}
}