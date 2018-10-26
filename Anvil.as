
package 
{
	import flash.display.SimpleButton;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	
	public class Anvil extends flash.display.MovieClip
	{
		
		
		public var timer:Timer = new Timer(25);
		var speedmult:int=0;
		
		public function Anvil()
		{
			

			timer.addEventListener("timer", controlFall); //controls the falling.
			timer.start();
			
		}
		
		
		function controlFall(event:TimerEvent)
		{
			
			this.y=this.y+(2+(speedmult*0.18));

			if(this.y>275)
			{
				speedmult++;
				this.y=-50
				this.x= ((Math.floor(Math.random() * 6))*50)+150;
				
			}
			
		}
	}
}
