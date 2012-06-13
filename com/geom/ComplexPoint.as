package com.geom {

	import com.adobe.protocols.dict.events.MatchEvent;
	import com.utils.MathUtils;
	
	import flash.geom.Point;

	/**
	 * Clase que añade algunas funciones a la clase Point
	 * 
	 * @author Simkin
	 */

	public class ComplexPoint extends Point {

		public function ComplexPoint($x:Number = 0, $y:Number = 0) {
			super($x, $y);
		}

		/** toString de X */
		public function xToString():String {
			return "[x = " + x + "]"; 
		}

		/** toString de Y */
		public function yToString():String {
			return "[y = " + y + "]";
		}

		/** Realiza la suma de dos puntos, entre este punto y el punto dado */
		public function sum($parameters:ComplexPoint):ComplexPoint {
			if($parameters.x != 0) {
				x += $parameters.x;
			}
			if($parameters.y != 0) {
				y += $parameters.y;
			}
			return this;
		}

		public function minus($parameters:ComplexPoint):ComplexPoint {
			if($parameters.x != 0) {
				x -= $parameters.x;
			}
			if($parameters.y != 0) {
				y -= $parameters.y;
			}
			return this;
		}

		/** Realiza una multiplicación del _x y _y por el parametro dado */
		public function multiplication($parameter:Number):ComplexPoint {
			return new ComplexPoint(x * $parameter, y * $parameter);
		}

		/** Regresa un clon de este punto */
		public function clonePoint():ComplexPoint {
			return new ComplexPoint(x, y);
		}

		/** Regresa este punto con el ejeY invertido */
		public function getInvertY():ComplexPoint {
			return new ComplexPoint(x, -y);
		}

		/** Regresa este punto con el ejeX invertido */
		public function getInvertX():ComplexPoint {
			return new ComplexPoint(-x, y);
		}

		/** Regresa este punto con ambos ejes invertidos */
		public function getInvertXY():ComplexPoint {
			return new ComplexPoint(-x, -y);
		}

		/** Obtiene el angulo entre este punto y el punto dado, de acuerdo
		 * 	al ejeX
		 */
		public function getAngle($point:ComplexPoint = null):Number {
			$point = $point ? $point : new ComplexPoint
			var b:Number = $point.x - this.x;
			var c:Number = $point.y - this.y;
			var a:Number = Math.sqrt(Math.pow(b, 2) + Math.pow(c, 2));
			var opositeAngleRad:Number = Math.atan2(c, b);
			var angle:Number = ((opositeAngleRad * 180) / Math.PI)
			return angle;
		}

		public function getInvertYAngle($point:ComplexPoint = null):Number {
			$point = $point ? $point : new ComplexPoint
			var b:Number = $point.x - this.x;
			var c:Number = $point.y - this.getInvertY().y;
			var a:Number = Math.sqrt(Math.pow(b, 2) + Math.pow(c, 2));
			var opositeAngleRad:Number = Math.atan2(c, b);
			var angle:Number = ((opositeAngleRad * 180) / Math.PI)
			return angle;
		}

		public function getInvertXAngle($point:ComplexPoint = null):Number {
			$point = $point ? $point : new ComplexPoint
			var b:Number = $point.x - this.getInvertX().x;
			var c:Number = $point.y - this.y;
			var a:Number = Math.sqrt(Math.pow(b, 2) + Math.pow(c, 2));
			var opositeAngleRad:Number = Math.atan2(c, b);
			var angle:Number = ((opositeAngleRad * 180) / Math.PI)
			return angle;
		}

		/** Obtiene la distancia entre este punto y el punto dado */
		public function getDistance($point:ComplexPoint):Number {
			var dX:Number = Math.pow($point.x - this.x, 2);
			var dY:Number = Math.pow($point.y - this.y, 2);
			return Math.sqrt(dX + dY);
		}

		public function rotateAxisPoint($angle:Number, $control:ComplexPoint = null):ComplexPoint {
			var tempPoint:ComplexPoint = $control ? this.clonePoint().minus($control) : this.clonePoint();
			var angle:Number = MathUtils.degreesToRadians($angle);
			var nX:Number = (tempPoint.x * Math.cos(angle)) + (tempPoint.y * Math.sin(angle));
			var nY:Number = -(tempPoint.x * Math.sin(angle)) + (tempPoint.y * Math.cos(angle));
			tempPoint = new ComplexPoint(nX, nY);
			return $control ? tempPoint.sum($control) : tempPoint;
		}

		public function moveToPolar($distance:Number, $angle:Number):ComplexPoint {
			var newX:Number = $distance * Math.cos(MathUtils.degreesToRadians($angle));
			var newY:Number = $distance * Math.sin(MathUtils.degreesToRadians($angle));
			return new ComplexPoint(this.x + newX, this.y + newY);
		}

	}
}