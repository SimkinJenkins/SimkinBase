package com.graphics.gallery {

	import com.interfaces.ISprite;

	/**
	 * IThumbnail
	 * 
	 * Interfaz que se debe de implementar en todos los thumbnails para su uso en una Gallery.
	 *  
	 * @author Simkin
	 * 
	 */
	public interface IThumbnail extends ISprite {

		function isSelected(): Boolean;
		function set index($index:Number):void;
		function get index():Number;
		function set enabled($value: Boolean): void;
		function get enabled(): Boolean;
		function set data($value:IThumbnailData):void;
		function get data():IThumbnailData;
		function set buttonEnabled($enabled:Boolean):void;
		function get adjustImage(): Boolean;
		function set adjustImage($value: Boolean): void;
		function get loaderClass(): Class;
		function set loaderClass($value:Class): void;
	}
}