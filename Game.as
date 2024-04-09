package {
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
		
		public static var bread: MovieClip
		public static var toaster: MovieClip
		public static var level: MovieClip
		public static var bars: MovieClip
		public static var audios: MovieClip
		
		
		public function Game() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame)
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed)
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseReleased)
		}
		
		public function onEnterFrame(e: Event) {
			var delta = 1 / 60
			sinceSpacePressed += delta
			processCamera(delta)
			bread.update()
			toaster.update()
			keySpaceJustReleased = false
			mouseJustPressed = false
			mouseJustReleased = false
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

	}
}