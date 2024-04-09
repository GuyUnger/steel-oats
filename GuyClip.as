package {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	
	public class GuyClip extends MovieClip {
		
		var toDegrees = 180 / Math.PI

		function lerp(from, to, t) {
			return from + (to - from) * t
		}

		function moveToward(from, to, delta) {
			if (from < to) {
				return Math.min(from + delta, to)
			} else {
				return Math.max(from - delta, to)
			}
		}

		function pointAngle(x, y) {
			return Math.atan2(y, x)
		}
		
		function pointsAngle(fromX, fromY, toX = 0, toY = 0) {
			return Math.atan2(toY - fromY, toX - fromX)
		}

		function pointsDistance(fromX, fromY, toX, toY) {
			var dx:Number = toX - fromX;
			var dy:Number = toY - fromY;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		function sign(value) {
			return value < 0 ? -1 : 1
		}
	}
}