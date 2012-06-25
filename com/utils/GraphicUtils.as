package com.utils {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GraphicUtils {

		public static function getBitmapData($do:DisplayObject):BitmapData {
			var rec:Rectangle = new Rectangle(0, 0, $do.width, $do.height);
			var bitmapData:BitmapData = new BitmapData($do.width, $do.height, true, 0x00000000);
			bitmapData.draw($do, null, null, null, rec, true);
			return bitmapData;
		}

		public static function getBitmapDataRect($do:DisplayObject, $width:Number, $height:Number):BitmapData {
			var rec:Rectangle = new Rectangle(0, 0, $width, $height);
			var bitmapData:BitmapData = new BitmapData($width, $height, true, 0x00000000);
			bitmapData.draw($do, null, null, null, rec, true);
			return bitmapData;
		}

		public static function getBitmapDataRectAt($do:DisplayObject, $x:Number, $y:Number, $width:Number, $height:Number):BitmapData {
			var bitmap:Bitmap = getCloneRect($do, $x + $width, $y + $height) as Bitmap;
			bitmap.x = -$x;
			bitmap.y = -$y;
			var container:Sprite = new Sprite();
			container.addChild(bitmap);
			var bitmapData:BitmapData = getBitmapDataRect(container, $width, $height);
			container.removeChild(bitmap);
			return bitmapData;
		}

		public static function getCloneRect($do:DisplayObject, $width:Number, $height:Number):DisplayObject {
			var bitmap:Bitmap = new Bitmap(getBitmapDataRect($do, $width, $height));
			bitmap.smoothing = true;
			return bitmap;
		}

		public static function getCloneRectAt($do:DisplayObject, $x:Number, $y:Number, $width:Number, $height:Number):DisplayObject {
			var bitmap:Bitmap = new Bitmap(getBitmapDataRectAt($do, $x, $y, $width, $height));
			bitmap.smoothing = true;
			return bitmap;
		}

		public static function getInverseClone($do:DisplayObject):DisplayObject {
			$do = GraphicUtils.getClone($do);
			$do.scaleX = -1;
			var sprite:Sprite = new Sprite();
			sprite.addChild($do);
			$do.x = $do.width;
			var inverse:DisplayObject = GraphicUtils.getClone(sprite);
			sprite.removeChild($do);
			return inverse;
		}

		public static function getClone($do:DisplayObject):DisplayObject {
			var bitmap:Bitmap = new Bitmap(getBitmapData($do));
			bitmap.smoothing = true;
			return bitmap;
		}

		public static function getOriginalClone($do:DisplayObject):DisplayObject {
			var mask:DisplayObject = $do.mask;
			var scales:Point = new Point($do.scaleX, $do.scaleY);
			var position:Point = new Point($do.x, $do.y);
			var parent:DisplayObjectContainer = $do.parent;
			$do.mask = null;
			$do.scaleX = 1;
			$do.scaleY = 1;
			$do.x = 0;
			$do.y = 0;
			var sprite:Sprite = new Sprite();
			sprite.addChild($do);
			var clone:DisplayObject = getClone(sprite);
			if(parent && !(parent as Loader)) {
				parent.addChild($do);
			}
			$do.scaleX = scales.x;
			$do.scaleY = scales.y;
			$do.x = position.x;
			$do.y = position.y;
			$do.mask = mask;
			return clone;
		}

		public static function getMaskClone($do:DisplayObject, $mask:Rectangle):DisplayObject {
			var x:Number = $do.x;
			var y:Number = $do.y;
			$do.x = -$mask.x;
			$do.y = -$mask.y;
			var bitmapData:BitmapData = new BitmapData($mask.width - $mask.x, $mask.height - $mask.y, true, 0x00000000);
			bitmapData.draw($do, null, null, null, new Rectangle(0, 0, $mask.width - $mask.x, $mask.height - $mask.y), true);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			$do.x = x;
			$do.y = y;
			return bitmap;
		}

		public static function getCloneMaxParams($rectangle:Rectangle, $image:DisplayObject):DisplayObject {
			var size:Rectangle = GraphicUtils.getSizeParams($rectangle, $image);
			if($image.width > size.width || $image.height > size.height) {
				$image.width = size.width;
				$image.height = size.height;
			}
			var container:Sprite = new Sprite();
			container.addChild($image);
			var clone:DisplayObject = getClone(container);
			return clone;
		}

		public static function getSizeParams($rectangle:Rectangle, $image:DisplayObject):Rectangle {
			if(!$image) {
				return new Rectangle();
			}
			var width:Number;
			var height:Number;
			if($image.width > $image.height) {
				width = $rectangle.width;
				height = $image.height * width / $image.width;
			} else {
				height = $rectangle.height;
				width = $image.width * height / $image.height;
			}
			if(width > $rectangle.width) {
				width = $rectangle.width;
				height = $image.height * width / $image.width;
			}
			if(height > $rectangle.height) {
				height = $rectangle.height;
				width = $image.width * height / $image.height;
			}
			return new Rectangle($rectangle.x, $rectangle.y, width, height);
		}

	}
}