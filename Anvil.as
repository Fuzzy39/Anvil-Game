package 
{
	
	import flash.display.SimpleButton;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	
	
	public class Anvil extends flash.display.MovieClip
	{
		
		//Set Varibles
		public var timer:Timer = new Timer(25);
		
		var scoring:Boolean = false;
		public var Active:Boolean = true;
		
		public function Anvil()
		{
			

			timer.addEventListener("timer", controlFall); //controls the falling.
			timer.start();
		}
		
		
		
		function controlFall(event:TimerEvent)
		{
			if(Active)
			{
				if(Main.mode==0) //rules for normal
				{
					this.y=this.y+(2+(Main.score*0.18)); // multiplier is lower in normal mode.
				}
				else //hard mode rules
				{
					this.y=this.y+(2+(Main.score*0.23)); 
				}
			}
			
			if(this.y>275)
			{
				if(scoring)
				{
					Main.score++;
				}
				reroll();
				
			}
			
		}
		
		
		
		function reroll()
		{
			this.y=-50;
			if(Math.floor(Math.random() * 8)==1)
			{
				this.x=Main.goldx;
			}
			else
			{
				this.x= ((Math.floor(Math.random() * 6))*50)+150;
			}
		}
	}
}
