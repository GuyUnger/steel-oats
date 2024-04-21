package {

	import flash.display.MovieClip;


	public class Boss extends GuyClip {

		var points

		var reloadT = 1.5
		var aimX = 1
		var aimY = 0
		var aimAngle

		var moveT = 0

		var shoot_i = 0;
		var health = 20
		public function Boss() {
			super()

			Game.banditsTotal += 1
			Game.game.bossHealth.visible = true
			Game.game.bossHealth.gotoAndStop(20)
		}

		public function update() {
			var delta = 1 / 60 * Game.speed
			if (moveT <= 0) {
				points = [Game.level.a, Game.level.b, Game.level.c, Game.level.d, Game.level.e]
				var point = points[Math.floor(Math.random() * points.length)]
				x = point.x
				y = point.y
				moveT = Math.random() * 1 + 0.2
				reloadT = 0.5
			}
			if (reloadT > 0) {
				reloadT -= delta
				if (reloadT <= 0) {
					shoot_i += 1
					if (shoot_i % 2 == 0) {
						shoot(-70, 30, Game.level.gun1)
					} else {
						shoot(70, 30, Game.level.gun2)
					}
				}
			}
			moveT -= delta

			aimAngle = pointsAngle(x, y, Game.bread.x, Game.bread.y)
			aimX = Math.cos(aimAngle)
			aimY = Math.sin(aimAngle)
			Game.level.gun1.x = x - 70 + aimX * 20
			Game.level.gun1.y = y + 30 + aimY * 10
			Game.level.gun2.x = x + 70 + aimX * 20
			Game.level.gun2.y = y + 30 + aimY * 10
			Game.level.gun1.rotation = aimAngle * toDegrees
			Game.level.gun2.rotation = aimAngle * toDegrees


			Game.level.gun1.scaleY = sign(aimX) * 2.2
			Game.level.gun2.scaleY = sign(aimX) * 2.2

			for (var i = 0; i < Game.bullets.length; i++) {
				var bullet = Game.bullets[i]
				var dist = pointsDistance(x, y, bullet.x, bullet.y)
				if (dist < 100.0) {
					bullet.remove()
					health -= 1
					if (health <= 0) {
						remove()
						Game.level.gun1.visible = false
						Game.level.gun2.visible = false
						Game.banditsKilled += 1

						Game.game.bossHealth.visible = false
						Game.game.playSong(Game.game.music1)
					} else {

						Game.game.bossHealth.gotoAndStop(health)
					}
				}
			}
		}

		function shoot(offX, offY, gun) {
			var bullet = new BulletEnemy()
			Game.level.addChild(bullet)

			bullet.x = x + aimX * 60 + offX
			bullet.y = y + aimY * 60 + offY
			var speed = 1000
			bullet.init(
				aimX * speed,
				aimY * speed
			)
			velocity.x -= aimX * 150
			velocity.y -= aimY * 60
			bullet.rotation = aimAngle * toDegrees
			gun.gotoAndPlay(2)
		}
	}
}