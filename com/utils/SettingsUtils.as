package com.utils {

	import com.core.system.System;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Security;

	public class SettingsUtils extends EventDispatcher {

		public static const ON_PANEL_CLOSE:String = "onPanelClose";

		private static var _instance:SettingsUtils;

		public function SettingsUtils($newCall:Function = null) {
			if($newCall != SettingsUtils.getInstance) {
				throw new Error("SettingsUtils");
			}
			if(_instance != null) {
				throw new Error("SettingsUtils");
			}
		}

		public static function getInstance():SettingsUtils {
			if (_instance == null )	{
				_instance = new SettingsUtils(arguments.callee);
			}
			return _instance;
		}

		public function showSettings($panel:String = "default"):void {
			Security.showSettings($panel);
			System.stageRoot.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame($event:Event):void {
			var dummy:BitmapData;
			dummy = new BitmapData(1, 1);
			try {
				dummy.draw(System.stageRoot);
			} catch (error:Error) {
				System.stageRoot.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				dispatchEvent(new Event(ON_PANEL_CLOSE));
			}
			dummy.dispose();
			dummy = null;
		}

	}
}