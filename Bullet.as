package  {
	
	import flash.geom.Point;
	
	
	public class Bullet extends GuyClip {
		var t= 0

		function Bullet() {
			super()
			
			Game.bullets.push(this)
		}
		
		function init(velocityX, velocityY) {
			velocity = new Point(velocityX, velocityY)
		}

		public function update() {
			var delta = 1 / 60
			x += velocity.x * delta
			y += velocity.y * delta
			t += delta
			if (t>1.0)
				remove()
		}
		
		override function remove() {
			super.remove()
			Game.bullets.removeAt(Game.bullets.indexOf(this))
		}
		
	}
}