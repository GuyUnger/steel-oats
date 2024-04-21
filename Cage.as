package  {
	
	import flash.display.MovieClip;
	
	
	public class Cage extends GuyClip {
		var hit=false
		
		public function Cage() {
			super()
		}
		
		public function update(){
			if(hit){
				
			}else{
			for (var i = 0; i < Game.bullets.length; i++) {
				var bullet = Game.bullets[i]
				var dist = pointsDistance(x, y, bullet.x, bullet.y)
				if (dist < 80.0) {
					hit  = true
					bullet.remove()
					gotoAndPlay("opened")
				Game.addCereal(name)
				}
			}
		}
		}
	}
	
}
