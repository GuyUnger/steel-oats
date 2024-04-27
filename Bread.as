package {

	import flash.geom.Point;
	import flash.events.MouseEvent;


	public class Bread extends GuyClip {

		var SPEED: Number = 400

		var shootPressed = false

		var velocityTo: Point = new Point()


		var launched = false

		var shootT = 0.1

		var sinceJump = 99.0

		var jumpHolding = false

		var state = 0
		var attacking = false

		var aimX = 0
		var aimY = 0
		var aimAngle = 0

		var sinceReturning = 0

		var returningSpin = false
		var inv  = 0

		public function Bread() {
			super()
			stop()
			Game.bread = this
		}
		var hitT = 0
		public function updated() {
			if (launched)
				processAir()
			else {

				x = Game.toaster.x + Math.cos(Game.toaster.rotation / toDegrees - Math.PI * 0.5) * 70
				y = Game.toaster.y + Math.sin(Game.toaster.rotation / toDegrees - Math.PI * 0.5) * 70
				bread.scaleX = Game.toaster.model.scaleX
				rotation = Game.toaster.rotation
			}

			if (x < Game.level.start.x) {
				x = Game.level.start.x
			}
			if (x > Game.level.end.x) {
				x = Game.level.end.x
			}
			var delta=1/60*Game.speed
			if (hitT > 0) {
				hitT -= delta
			} else {
				if (inv > 0){
					inv -= 1/60
				} else {
				for (var i = 0; i < Game.bulletsEnemy.length; i++) {
					var bullet = Game.bulletsEnemy[i]
					if (pointsDistance(x, y, bullet.x, bullet.y) < 100) {
						hitT = 1
						Game.removeHeart()
						bullet.remove()
					}
				}
			}
			}
		}


		function processAir() {

			if (!attacking && jumpHolding) {
				setAttacking(true)
			}
			if (attacking && !jumpHolding && sinceJump > 0.5) {
				setAttacking(false)

			}
			if (attacking) {
				Game.speed = moveToward(Game.speed, 0.4, 0.1)
			} else {
				Game.speed = moveToward(Game.speed, 1.0, 0.01)
			}

			var delta = 1 / 60 * Game.speed
			sinceJump += 1 / 60

			if (jumpHolding && velocity.y > 1300) {
				jumpHolding = false
			}


			velocityTo.x = 0

			var accelDuration = 2.0

			if (Game.keyAPressed) {
				velocityTo.x -= 1
			}
			if (Game.keyDPressed) {
				velocityTo.x += 1
			}
			velocityTo.x *= SPEED

			if (Math.abs(velocityTo.x) > 0) {
				accelDuration = 0.2
			}

			if (jumpHolding) {
				if (Game.keySpaceJustReleased) {
					jumpHolding = false
					inv = 1.0
					if (sinceJump > 0.3) {
						returningSpin = true
						gotoAndStop(3)
					}
				}
			} else {
				sinceReturning += delta / 0.2
			}

			aimAngle = pointAngle(mouseX, mouseY)

			if (jumpHolding || attacking) {
				if (Game.mouseJustPressed) {
					shootPressed = true
				}
				velocity.x = moveToward(velocity.x, velocityTo.x, SPEED / accelDuration * delta)
				velocity.y += (Math.abs(velocity.y * 3) + 600) * delta

			} else {
				aimAngle = 0.5
				if (returningSpin) {
					gun.visible = false
					var dir = sign(velocity.x)
					bread.rotation = lerp(bread.rotation, -dir * 20, 0.2)
					if (sinceReturning < 0.6) {
						rotation += 360 * 8 * delta * dir
						delta *= 0.1
					} else {
						if (returningSpin) {
							returningSpin = false
							gotoAndStop(2)
						}
					}
					bread.scaleX = sign(Game.toaster.x - x)
				} else {
					gun.visible = true
					rotation = lerp(rotation, 0, 0.2)
					bread.rotation = lerp(bread.rotation, 0, 0.2)
				}
				var distanceToToaster = pointsDistance(x, y, Game.toaster.x, Game.toaster.y)
				var angleToToaster = pointsAngle(x, y, Game.toaster.x, Game.toaster.y - distanceToToaster * 0.7)
				var speed = 1000 * delta * Math.min(sinceReturning, 4)
				x += Math.cos(angleToToaster) * speed
				y += Math.sin(angleToToaster) * speed

				velocity.x -= velocity.x * delta * 5.0
				velocity.y -= velocity.y * delta * 5.0
				//velocity.y += 4000 * delta
				if (distanceToToaster < 100) {
					unlaunch()
				}
			}

			x += velocity.x * delta
			y += velocity.y * delta

			if (sinceJump > 0.3) {
				bread.rotation += velocity.x * delta * 2.0
			}

			shootT -= 1 / 60
			if (shootT <= 0 && shootPressed) {
				shootT += 0.4
				shootBullet(0)
				shootPressed = false
				Game.speed = 1.0
			}

			aimX = Math.cos(aimAngle)
			aimY = Math.sin(aimAngle)

			gun.x = aimX * 40
			gun.y = aimY * 40
			gun.rotation = aimAngle * toDegrees
			gun.scaleY = aimX < 0 ? -1 : 1
		}

		function setAttacking(value) {
			if (attacking == value)
				return
			attacking = value
		}

		function launch() {
			if (launched) {
				return
			}
			launched = true
			velocity.y = -2000
			velocity.x = rotation * 20
			bread.gotoAndStop(2)
			bread.rotation = 0
			rotation = 0
			shootT = 0.0
			jumpHolding = true
			sinceJump = 0.0
			sinceReturning = 0.0
			shootPressed = false
			visible = true
		}

		function unlaunch() {
			setAttacking(false)
			bread.rotation = 0
			launched = false
			bread.gotoAndStop(1)
			Game.speed = 1
			//returningSpin = false
			//gotoAndStop(2)

			visible = false

			Game.audios.unlaunch.play()

		}

		function shootBullet(angleOffset) {
			var bullet = new Bullet()
			Game.level.addChild(bullet)

			bullet.x = x + aimX * 60
			bullet.y = y + aimY * 60
			var speed = 1500
			bullet.init(
				aimX * speed,
				aimY * speed
			)
			velocity.x -= aimX * 150
			velocity.y -= aimY * 60
			bullet.rotation = aimAngle * toDegrees
			gun.gotoAndPlay(2)
		}
		/*
		function rayFloor(offset) {
			var checkingX = x + offset
			var checkingY = y
			var checkingDistance = 30
			var spotted = false
			for(var i = 0; i < 1000; i += 1) {
				if(Game.level.ground.hitTestPoint(checkingX, checkingY, true)){
					spotted = true
					checkingDistance *= 0.5
					checkingY -= checkingDistance
					if (checkingDistance < 1.0) {
						return checkingY
					}
				} else {
					if (spotted) {
						checkingDistance *= 0.5
					}
					checkingY += checkingDistance
				}
			}
			return checkingY
		}*/

	}

}