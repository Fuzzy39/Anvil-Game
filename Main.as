package 
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.display.FrameLabel;
	
	public class Main extends flash.display.MovieClip
	{
		
		//COOKIES!! (naturaly, for the cookie monster.)
		var cookie:SharedObject = SharedObject.getLocal("masonGameCookie2");

		var score:int = 0; //score!
		var health:int = 1;//max 4, if it hits 0, you lose.
		
		var HP1OFF=new healthLow();
		var HP2OFF=new healthLow();
		var HP3OFF=new healthLow();
		
		
		var HP1ON=new healthHigh();
		var HP2ON=new healthHigh();
		var HP3ON=new healthHigh();
		

		var Player=new playerBody();
		
		
		var moveLeft:Boolean=false; // check if the player is trying to move left or right.
		var moveRight:Boolean=false;		
		
		var timer:Timer = new Timer(25);
						
		public function Main()
		{
			
			
			stop(); // keeps everything under control.
			frameControl(1); // initiate everything and get it under control.
			
		}
		
		
		
		public function frameControl(frame)
		{
			gotoAndStop(frame);
			if(this.currentFrame==1)
			{
				
				// add event listeners
				playButton.addEventListener(MouseEvent.CLICK, startGame);
				
			}
			
			if(this.currentFrame==2)
			{
			
				addChild(HP1OFF);
				addChild(HP2OFF);
				addChild(HP3OFF);
				
				this.HP1OFF.y=210;
				this.HP2OFF.y=130;
				this.HP3OFF.y=50;
				
				this.HP1ON.y=210;
				this.HP2ON.y=130;
				this.HP3ON.y=50;
				
				this.Player.x=150;
				this.Player.y=240;
				
				if(! stage.contains(Player))
				{
					addChild(Player);
				}
				
				if(cookie.data.highScore==undefined)
				{
					cookie.data.highScore=0;
				}
				
				stage.stageFocusRect = false;
				stage.focus= Player;

				var moveLeft:Boolean=false; // check if the player is trying to move left or right.
				var moveRight:Boolean=false;

				
				highScoreText.text="High Score: "+cookie.data.highScore;
				
				
				

				timer.addEventListener("timer", playerMovement); //test...
				timer.start();
				
				stage.addEventListener ( KeyboardEvent.KEY_DOWN, reportKeyDown ); //let the player move.
				stage.addEventListener ( KeyboardEvent.KEY_UP, reportKeyUp ); 
			}
			
			if(this.currentFrame==3)
			{
				
				scoreOut.text="Your final score was: "+score.toString();
				highScoreOut.text="High Score: "+cookie.data.highScore;
				playButton.addEventListener(MouseEvent.CLICK, Replay);
				
				
			}
		}
		
		
		function startGame(e:MouseEvent) // this brings you to the actual game.
		{
			//goto game
			frameControl(2);
		
		}
		
		
		
		
		
		
		
		function detectCollision()
		{
			HB1.x=anvilone.x+11;
			HB1.y=anvilone.y;
			HB2.x=anviltwo.x+11;
			HB2.y=anviltwo.y;
			HB3.x=anvilthree.x+11;
			HB3.y=anvilthree.y;
			HB4.x=anvilGold.x+11;
			HB4.y=anvilGold.y;
	
			if(PlayerHead.hitTestObject(HB1))
			{
				health--;
				
				anvilone.y=-50;
				anviltwo.y=-50;
				anvilthree.y=-50;
				
			}
			
			if(PlayerHead.hitTestObject(HB2))
			{
				health--;
				
				anvilone.y=-50;
				anviltwo.y=-50;
				anvilthree.y=-50;
				
			}
			
			if(PlayerHead.hitTestObject(HB3))
			{
				health--;
			
				anvilone.y=-50;
				anviltwo.y=-50;
				anvilthree.y=-50;
				
			}
			if(PlayerHead.hitTestObject(HB4))
			{
				health++;
				anvilGold.x=((Math.floor(Math.random() * 6))*50)+150;
				anvilGold.y=(Math.floor(Math.random()*-100))-350;
			}
			
			
			if(score<6)
			{
				if(anvilone.y>=273)
				{
				
				score++;
				scoreText.text="Score: "+score;
					
				}
				
			}
			
			else if (score<25)
			{
				
				if(anvilone.y>=271)
				{
				
					score++;
					scoreText.text="Score: "+score;
					
				}
				
			}
			else
			{
				if(anvilone.y>=267)
				{
				
					score++;
					scoreText.text="Score: "+score;
				}
			}
			
			if(cookie.data.highScore<score) // increases high score count.
			{
				cookie.data.highScore=score;
				cookie.flush();
				highScoreText.text="High Score: "+cookie.data.highScore;
			}
			
			if(health<=0)
			{
				
				timer.stop();
				removeChild(Player);
				cookie.flush();
				anvilone.timer.stop()
				anviltwo.timer.stop()
				anvilthree.timer.stop()
				if(stage.contains(HP1OFF))
				{
					removeChild(HP1OFF);
				}
				if(stage.contains(HP2OFF))
				{
						removeChild(HP2OFF);
				}
				if(stage.contains(HP3OFF))
				{
						removeChild(HP3OFF);
				}
				
				if(stage.contains(HP1ON))
				{
					removeChild(HP1ON);
				}
				if(stage.contains(HP2ON))
				{
						removeChild(HP2ON);
				}
				if(stage.contains(HP3ON))
				{
						removeChild(HP3ON);
				}
				
				gotoAndStop(3);
			}
			
			if(health==4)
			{
				healthText.text="Health: MAX";
			}
			else
			{
				healthText.text="Health: "+health;
			}
			
			
			if(health>4) //limit health
			{
				health=4;
			}
			
			
			if(health>=2)
			{
				
				if(stage.contains(HP1OFF))
				{
					addChild(HP1ON);
					removeChild(HP1OFF);
				}
			}
			if(health>=3)
			{
				if(stage.contains(HP2OFF))
				{
					addChild(HP2ON);
					removeChild(HP2OFF);
				}
			}
			if(health==4)
			{
				if(stage.contains(HP3OFF))
				{
			
					addChild(HP3ON);
					removeChild(HP3OFF);
				}
			}
			
			if(health<2)
			{
				
				if(stage.contains(HP1ON))
				{
					addChild(HP1OFF);
					removeChild(HP1ON);
				}
			}
			if(health<3)
			{
				if(stage.contains(HP2ON))
				{
					addChild(HP2OFF);
					removeChild(HP2ON);
				}
			}
			if(health<4)
			{
				if(stage.contains(HP3ON))
				{
			
					addChild(HP3OFF);
					removeChild(HP3ON);
				}
			}
		}
		
		
		
		
		
		
		function playerMovement( event:TimerEvent)
		{
			
			// Move the player each tick.
			if(moveLeft)
			{
				Player.x=Player.x-6;
			}
			if(moveRight)
			{
				Player.x=Player.x+6;
			}
			
			// manage boundries
			if(Player.x<150)
			{
				Player.x=150;
			}
			if(Player.x>400)
			{
				Player.x=400;
			}
			
			PlayerHead.x=Player.x+5;
			PlayerHead.y=Player.y-40;
			
			// find various objects that hit the players head.
			detectCollision();
		}
		

		function reportKeyDown( event:KeyboardEvent )
		{

			if ( event.keyCode == Keyboard.LEFT ) // 
			{
			
				moveLeft=true;
				
			}
			if ( event.keyCode == Keyboard.RIGHT ) // Move the player right
			{
				
				moveRight=true;
				
			}
			
			
		}

		
		
		function reportKeyUp( event:KeyboardEvent )
		{
			
			if ( event.keyCode == Keyboard.LEFT ) // 
			{
			
				moveLeft=false;
				
			}
			if ( event.keyCode == Keyboard.RIGHT ) // Move the player right
			{
				
				moveRight=false;
				
			}
			
		}
		
		
		
		function Replay(e:MouseEvent) 
		{
			cookie.flush();
			frameControl(2);
			
		}

	}
}
