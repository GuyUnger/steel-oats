package  {
	
	import flash.display.MovieClip;
	
	
	public class BushEnemy extends GuyClip {


		var revealed = false
		var hit = false
		
		var reloadT = 1.5
		var aimX = 1
		var aimY = 0
		var aimAngle
		

		public function BushEnemy() {
			super()
			gun.visible = false
			Game.banditsTotal += 1
		}

		public function update() {
			var delta = 1 / 60 * Game.speed
			if (hit ) {
				if (falling.y < 1000){
					delta *= 1.5
					falling.x += velocity.x * delta * 4
					falling.y += velocity.y * delta * 4
					velocity.y += 400 * delta
					falling.rotation += velocity.x * delta * 4
				}
			}
			else if (revealed) {
				aimAngle = pointsAngle(x, y, Game.bread.x, Game.bread.y)

				reloadT -= delta
				if (reloadT < 0) {
					reloadT = 0.5 + Math.random()
					shoot()
				}
				gun.rotation = aimAngle * toDegrees
				gun.x = aimX * 40
				gun.y = aimY * 40
				gun.scaleY = sign(gun.x)
				aimX = Math.cos(aimAngle)
				aimY = Math.sin(aimAngle)


				for (var i = 0; i < Game.bullets.length; i++) {
					var bullet = Game.bullets[i]
					var dist = pointsDistance(x, y, bullet.x, bullet.y)
					if (dist < 100.0) {
						hit  = true
						bullet.remove()
						gotoAndPlay("killed")
						removeChild(falling)
						parent.addChild(falling)
						falling.x =x
						falling.y =y
						velocity.x = (Math.random()-0.5) * 300
						velocity.y = -(Math.random()+0.7 * 200)
						gun.visible = false
						Game.banditsKilled+= 1
					}
				}

			} else {
				if (pointsDistance(x, y, Game.bread.x, Game.bread.y) < 600) {
					play()
					revealed = true
					gun.visible = true
					for( i=0;i<8;i++){
						var shard = new GlassShard()
						parent.addChild(shard)
						shard.y = y
						shard.x = x
						shard.nextFrame()
					}
				}
			}
		}
		function shoot() {
			var bullet = new BulletEnemy()
			Game.level.addChild(bullet)

			bullet.x = x + aimX * 60
			bullet.y = y + aimY * 60
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
