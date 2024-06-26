﻿package {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class Game extends GuyClip {
		
		public static var speed = 1.0
		
		public static var keyLeftPressed = false
		public static var keyRightPressed = false
		public static var keyUpPressed = false
		public static var keyDownPressed = false
		public static var keyAPressed = false
		public static var keyDPressed = false
		public static var keyWPressed = false
		public static var keySPressed = false
		public static var keySpacePressed = false
		public static var keySpaceJustReleased = false
		public static var sinceSpacePressed = 999
		public static var mousePressed = false
		public static var mouseJustPressed = false
		public static var mouseJustReleased = false
		
		public static var game: MovieClip
		public static var bread: MovieClip
		public static var toaster: MovieClip
		public static var level: MovieClip
		public static var bars: MovieClip
		public static var audios: MovieClip
		public static var cameraTarget
		public static var cameraTargetFreeze:Number = 0.0
		
		public static var bullets = []
		public static var bulletsEnemy = []
		
		public static var bars_closed = false
		
		public static var banditsTotal = 0
		public static var banditsKilled = 0
		
		public static var show_cereal_t = 0
		public static var cereals: Array = []
		
		public function Game() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
			stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame)
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed)
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseReleased)
			game = this
		}
		
		public function _onEnterFrame(e: Event) {
			var delta = 1 / 60
			sinceSpacePressed += delta
			processCamera(delta)
			if (bread) {
				bread.updated()
			}
			keySpaceJustReleased = false
			mouseJustPressed = false
			mouseJustReleased = false
			
			cameraTargetFreeze -= delta
			
			if (bars_closed) {
				if (bars.currentFrame == 1)
					bars.play()
			} else {				
				if (bars.currentFrame == 6)
					bars.play()
			}
			
			HUD.banTot.text = banditsTotal
			HUD.banKill.text = banditsKilled
			
			if (show_cereal_t > 0) {
				show_cereal_t -= delta
				HUD.cereal.x = lerp(HUD.cereal.x, 0, delta *10)
			} else {
				if (HUD.cereal.x > -200) {
					HUD.cereal.x -= delta * 200.0
				}
			}
			HUD.hearts.gotoAndStop(4-hearts)
			stage.focus = stage
		}
		
		static public function addCereal(name) {
			if (cereals.indexOf(name) == -1){
				cereals.push(name)
			}
			var count = cereals.length
			show_cereal_t = 3
			game.HUD.cereal.counter.text = count
		}
		
		static public function showHud(value) {
			game.HUD.visible = value
		}
		
		function keyDown(e: KeyboardEvent) {
			switch(e.keyCode) {
				case 37:
					keyLeftPressed = true
					break
				case 39:
					keyRightPressed = true
					break
				case 38:
					keyUpPressed = true
					break
				case 40:
					keyDownPressed = true
					break
				case 65:
					keyAPressed = true
					break
				case 68:
					keyDPressed = true
					break
				case 87:
					keyWPressed = true
					break
				case 83:
					keySPressed = true
					break
				case 32:
					if (!keySpacePressed) {
						sinceSpacePressed = 0.0
						keySpacePressed = true
					}
					break
			}
		}

		function keyUp(e: KeyboardEvent) {
			switch(e.keyCode) {
				case 37:
					keyLeftPressed = false
					break
				case 39:
					keyRightPressed = false
					break
				case 38:
					keyUpPressed = false
					break
				case 40:
					keyDownPressed = false
					break
				case 65:
					keyAPressed = false
					break
				case 68:
					keyDPressed = false
					break
				case 87:
					keyWPressed = false
					break
				case 83:
					keySPressed = false
					break
				case 32:
					keySpacePressed = false
					keySpaceJustReleased = true
					break
			}
		}
		
		function onMousePressed(e: MouseEvent) {
			mousePressed = true
			mouseJustPressed = true
		}
		
		function onMouseReleased(e: MouseEvent) {
			mousePressed = false
			mouseJustReleased = true
		}
		static public var targets: MovieClip = new MovieClip()
		public static function targetsDone(name, isTarget = false) {
			if (isTarget) {
				name = name.slice(0,name.length-1)
			}
			var ts = targets[name]
			for (var i =0; i<ts.length;i++){
				if(!ts[i].hit){
					return false
				}
			}
			return true
		}
		
		static public function addTarget(target) {
			var name1:String = target.name.slice(0,target.name.length-1)
			if (!targets[name1]) {
				targets[name1] = []
			}
			targets[name1].push(target)
		}
		static var levels = [Level1, Level2, Level3, Level4, Level5]
		static var levelNum = 0
		static var exiting = false
		static public function loadLevel(num) {
			if (level) {
				level.parent.removeChild(level)
				bullets = []
				bulletsEnemy = []
				targets = new MovieClip()
			}
			if (num == 5) {
				Game.game.nextFrame()
				var frame = 2
				if (cereals.length == 0)
					frame = 4
				if (cereals.length == 8)
					frame = 3
				game.outro.gotoAndStop(frame)
				game.outro.visible = true
				game.playSong(game.musicCredits)
				return
			}
			banditsTotal = 0
			banditsKilled = 0
			level = new levels[num]()
			game.levelContainer.addChild(level)
			levelNum = num
			exiting = false
			hearts =3
			bars_closed = false
			
		}
		
		static public var hearts = 3
		
		static public function removeHeart() {
			hearts -= 1
			if (hearts<=0){
				game.stageInfo.setup(levelNum)
			}
		}
		
		static public function nextLevel() {
			
			game.stageInfo.setup(levelNum+1)
			exiting = true
		}
		static public function resett() {
			hearts = 3
			cereals = []
			Game.game.stageInfo.setup(0)
			game.outro.visible = false
			game.bossHealth.visible = false
			game.gotoAndStop(2)
		}
	}
}