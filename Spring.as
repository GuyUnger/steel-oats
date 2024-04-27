package  {
	
	import flash.display.MovieClip;
	
	
	public class Spring extends GuyClip {
		
		
		public function Spring() {
			super()
		}
		
		public function update() {
			if (Game.toaster.isOnFloor && Game.toaster.x > x -100 && Game.toaster.x < x + 100 && Game.toaster.y < y + 200) {
				Game.toaster.jump()
				play()
			}
		}
	}
	
}
