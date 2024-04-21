package {

	import flash.display.MovieClip;
	import flash.geom.Point;


	public class BulletEnemy extends GuyClip {


		public function BulletEnemy() {
			super()

			Game.bulletsEnemy.push(this)
		}

		function init(velocityX, velocityY) {
			velocity = new Point(velocityX, velocityY)
		}

		public function update() {
			var delta = 1 / 60
			x += velocity.x * delta
			y += velocity.y * delta
		}

		override function remove() {
			super.remove()
			Game.bulletsEnemy.removeAt(Game.bulletsEnemy.indexOf(this))
		}
	}
}