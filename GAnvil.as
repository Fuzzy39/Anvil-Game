package  
{
	import flash.display.SimpleButton;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	
	public class GAnvil extends flash.display.MovieClip 
	{
		//Set variables.
		public var timer:Timer = new Timer(25);
		public var Active:Boolean =true;
		
		public function GAnvil() 
		{
			timer.addEventListener("timer", controlFall); //controls the falling.
			timer.start();
		}
		
		
		function controlFall(event:TimerEvent)
		{
			if(Active) //Fall.
			{
				this.y=this.y+1;
			}
			
			if(this.y>275) //reset at the bottom of the screen.
			{
				
				reroll();
			}

		}
		
		public function reroll() // Reset the anvil.
		{
			this.y=(Math.floor(Math.random()*-100))-350;
			this.x= ((Math.floor(Math.random() * 6))*50)+150;
		}
	}
}