package com.graphics.gallery {

	import com.interfaces.ISprite;

	public interface IGallery extends ISprite {

		function initializeGallery($thumbsData: Array): void;
		function set backgroundClass($class: Class): void;
		function set buttonEnabled($enabled: Boolean): void;
		function set thumbClass($class: Class): void;

		function get paddingX():int;
		function get paddingY():int;
		function set paddingX($value:int): void;
		function set paddingY($value:int): void;

	}
}