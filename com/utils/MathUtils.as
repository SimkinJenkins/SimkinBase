package com.utils {

	import com.geom.ComplexPoint;
	import com.geom.IPoint;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MathUtils {

		public static function randomRange ($min:Number, $max:Number):Number{
			var randomNum:Number = Math.floor(Math.random() * ($max - $min + 1)) + $min;
    		return randomNum;	
		}

		public static function degreesToRadians($degrees:Number):Number{
			return $degrees * Math.PI / 180;
		}	

		public static function  radiansToDegrees($radians:Number):Number{
			return $radians * 180 / Math.PI;
		}

		public static function uintToHexString($number:uint):String {
			var hex:String = $number.toString(16);
			var zeroMissing:uint = 6 - hex.length;
			for(var i:uint = 0; i < zeroMissing; i++) {
				hex = "0" + hex;
			}
			return "0x" + hex;
		}
		
		public static function hexToUint($hex:String):uint {
			var number:uint = parseInt($hex, 16);
			return number;
		}

		public static function getTranspolateBetweenRanges ($currentValueOfRange1:Number, $range1Init:Number, $range1End:Number, $range2Init:Number, $range2End:Number):Number{
			return $range2End - ( ($range1End-$currentValueOfRange1)*($range2End-$range2Init)  ) / ($range1End-$range1Init) ;  
		}	

		public static function hitTest($a:Rectangle, $b:Rectangle):Boolean {
			if(MathUtils.isValueBetween($a.x, $b.left, $b.right) || MathUtils.isValueBetween($a.right, $b.left, $b.right) ||
					$a.left == $b.left && $a.right == $b.right) {
				if(MathUtils.isValueBetween($a.y, $b.top, $b.bottom) || MathUtils.isValueBetween($a.bottom, $b.top, $b.bottom) ||
						$a.bottom == $b.top && $a.bottom == $b.bottom) {
					return true;
				}
			}
			return false;
		}

		public static function pointHitTest($point:ComplexPoint, $b:Rectangle):Boolean {
			if(MathUtils.isValueBetween($point.x, $b.left, $b.right)) {
				if(MathUtils.isValueBetween($point.y, $b.top, $b.bottom)) {
					return true;
				}
			}
			return false;
		}

		public static function isValueBetween($value:Number, $a:Number, $b:Number):Boolean {
			if($value > $a && $value < $b) {
				return true;
			}
			return false;
		}

	}
}