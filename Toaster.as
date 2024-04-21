package {

	import flash.display.MovieClip;

	import flash.geom.Point;

	public class Toaster extends GuyClip {


		var velocityTo: Point = new Point()


		var sinceLaunched = 0.0

		var isOnFloor = false

		var dashT = 0
		var dashDirectionX = 0
		var dashDirectionY = 0


		var _rotation: Number = 0.0;

		public function Toaster() {
			Game.toaster = this
			super()
		}

		public function update() {
			var delta = 1 / 60
			delta *= Game.speed
			velocityTo.x = 0

			var accelDuration = 0.5

			var speed: Number = 800
			
			if (y > 50 && Game.hearts > 0){
				
						Game.removeHeart()
			}
			if ((Game.bread.launched && Game.bread.jumpHolding) || (Game.cameraTargetFreeze > 0)) {
				sinceLaunched += delta
				velocity.x -= velocity.x * 0.1
			} else {
				if (Game.keyAPressed) {
					velocityTo.x -= 1
				}
				if (Game.keyDPressed) {
					velocityTo.x += 1
				}
				if (x > Game.level.end.x - 550) {
					if (Game.banditsKilled >= Game.banditsTotal) {
						velocityTo.x = 1

						Game.bars_closed = true
						Game.sinceSpacePressed = 99
						if (x > Game.level.end.x) {
							Game.nextLevel()
						}
					} else {
						Game.game.HUD.banditsLeft.gotoAndPlay(2)
					}
				}
				velocityTo.x *= speed

				if (Math.abs(velocityTo.x) > 0) {
					if (Math.abs(velocity.x) < speed * 0.3) {
						accelDuration = 0.1
					} else {
						accelDuration = 1.0
					}
				}

				velocity.x = moveToward(velocity.x, velocityTo.x, speed / accelDuration * delta)
			}

			x += velocity.x * delta
			x += Math.abs(velocity.x) * rotation * delta * 0.01

			var floorLeft = rayFloor(-40)
			var floorRight = rayFloor(40)

			if (Math.abs(floorLeft - floorRight) > 60) {
				floorLeft = Math.min(floorLeft, floorRight)
				floorRight = floorLeft
			}
			var floorY = (floorLeft + floorRight) / 2
			shadow.y = -(y - floorY)

			if (!isOnFloor && y > floorY) {
				isOnFloor = true
			}
			if (isOnFloor && floorY > y + 30) {
				isOnFloor = false
			}

			if (isOnFloor) {
				velocity.y = 0
				y = floorY //lerp(y, floorY, 0.8)


				_rotation = pointsAngle(-40, floorLeft, 40, floorRight) * toDegrees * 0.8
				rotation = Math.round(_rotation / 10) * 10
				model.rotation = 0

				if (Game.sinceSpacePressed < 0.3) {
					Game.sinceSpacePressed = 999
					launch()
				}
			} else {

				if (Game.sinceSpacePressed < 0.1 && y < floorY - 100) {
					Game.sinceSpacePressed = 999
					launch()
				}
				velocity.y += delta * 2500.0
				y += velocity.y * delta
				_rotation -= _rotation * delta * 5.0
				model.rotation = velocity.y * 0.02 * model.scaleX
				rotation = 0
			}

			if (velocity.x > 10) {
				model.scaleX = 1
			} else if (velocity.x < -10) {
				model.scaleX = -1
			}

			if (isOnFloor) {
				if (Game.bread.launched) {

					if (Math.abs(velocity.x) > 10) {
						playAnimation("runNude")
					} else {
						playAnimation("idle_solo")
						var angle = pointsAngle(x, y, Game.bread.x, Game.bread.y)
						model.eyeL.rotation = angle * toDegrees - rotation
						model.eyeR.rotation = angle * toDegrees - rotation
						if (model.scaleX < 0) {
							model.eyeL.rotation *= -1
							model.eyeR.rotation *= -1
							model.eyeL.rotation += 180
							model.eyeR.rotation += 180
						}
					}
				} else
				if (Math.abs(velocity.x) > 10) {
					if (velocity.x * velocityTo.x < 0) {
						playAnimation("turn")
					} else {
						playAnimation("run")
					}
				} else {
					playAnimation("idle")
				}
			} else {
				if (Game.bread.launched) {
					if (velocity.y < 0) {
						playAnimation("jump_up_solo")
					} else {
						playAnimation("jump_down_solo")
					}
				} else {
					if (velocity.y < 0) {
						playAnimation("jump_up")
					} else {
						playAnimation("jump_down")
					}
				}
			}
			if (checkCollision(-60, -70) || checkCollision(60, -70)) {
				velocity.y = 0
				y += 15
			}
			if (checkCollision(70, -40) || checkCollision(70, -60)) {
				velocity.x = 0
				x -= 15
			}
			if (checkCollision(-70, -40) || checkCollision(-70, -60)) {
				velocity.x = 0
				x += 15
			}

			if (x < Game.level.start.x) {
				x = Game.level.start.x
			}
			if (Game.banditsKilled < Game.banditsTotal && x > Game.level.end.x) {
				x = Game.level.end.x
			}
		}
		function jump() {
			isOnFloor = false
			y -= 10
			velocity.y = -2000
			Game.audios.jump.play()
		}

		function playAnimation(animation) {
			if (model.currentLabel != animation) {
				model.gotoAndPlay(animation)
			}
		}

		function launch() {
			if (Game.bread.launched)
				return
			Game.bread.launch()
			Game.bread.velocity.x += velocity.x
			sinceLaunched = 0
			velocity.y += 500.0
			Game.audios.launch.play()
		}

		var checking = new Point();

		function rayFloor(offset) {
			checking.x = x + offset
			checking.y = y - 20

			checking = Game.level.localToGlobal(checking)

			//checking = level.ground.globalToLocal(checking)
			var checkingDistance = 30
			var spotted = false
			for (var i = 0; i < 1000; i += 1) {
				if (Game.level.ground.hitTestPoint(checking.x, checking.y, true)) {
					spotted = true
					checkingDistance *= 0.5
					checking.y -= checkingDistance
					if (checkingDistance < 0.25) {
						return Game.level.globalToLocal(checking).y
					}
				} else {
					if (spotted) {
						checkingDistance *= 0.5
					}
					checking.y += checkingDistance
				}
			}
			return Game.level.globalToLocal(checking).y
		}

		function checkCollision(offX, offY) {
			checking.x = x + offX
			checking.y = y + offY

			checking = Game.level.localToGlobal(checking)
			return Game.level.ground.hitTestPoint(checking.x, checking.y, true)
		}

	}

}