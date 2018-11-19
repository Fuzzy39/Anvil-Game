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
		var crabMode:Boolean=false;
		public static var goldx:int;
		//COOKIES!! (naturaly, for the cookie monster.)
		var cookie:SharedObject = SharedObject.getLocal("masonGameCookie2");
		
		public static var mode:int = 0; // game difficulty, slightly affects game rules. 0=normal, 1=hard, 2=brutal.
		public static var score:int = 0; //scoring is done by the anvil class.
		var health:int = 1;//max 4, if it hits 0, you lose.
		var debug:Boolean=false; //Cheats!
		
		var moveLeft:Boolean=false; // check if the player is trying to move left or right.
		var moveRight:Boolean=false;	
		
		
		//init the health icons
		var HP1OFF=new healthLow();
		var HP2OFF=new healthLow();
		var HP3OFF=new healthLow();
		
		
		var HP1ON=new healthHigh();
		var HP2ON=new healthHigh();
		var HP3ON=new healthHigh();
		
		//init player
		var Player=new playerBody();
		
		// init timers
		var timer:Timer = new Timer(25);
		var winTimer:Timer = new Timer(5000);
				
		private var _keysPressed:Object = { };
				
				
		public function Main()
		{
			
			
			stop(); // keeps everything under control.
			frameControl(1); // initiate everything and get it under control.
			
		}
		
		
		
		public function frameControl(frame)
		{				
			
			
			gotoAndStop(frame);
			
			
			if(this.currentFrame==1) // init intro frame.
			{
				
				// add event listeners
				playButton.addEventListener(MouseEvent.CLICK, gameMenu);
				
				
			}
			
			if(this.currentFrame==2) // init game.
			{
				
				// define the giblets
				this.HP1OFF.y=210;
				this.HP2OFF.y=130;
				this.HP3OFF.y=50;
				
				this.HP1ON.y=210;
				this.HP2ON.y=130;
				this.HP3ON.y=50;
				
				anvilone.scoring=true;
				anvilGold2.Active=false;
				anvilGold3.Active=false;
				anvilGold4.Active=false;
				anvilGold5.Active=false;
				anvilGold6.Active=false;
				anvilGold7.Active=false;
				
				// Setup health
				health=1;
				
				addChild(HP1OFF);
				addChild(HP2OFF);
				addChild(HP3OFF);
				
				
				// Setup player:
				
				this.Player.x=150;
				this.Player.y=240;
				stage.stageFocusRect = false;
				stage.focus= Player;
				
				if(! stage.contains(Player))
				{
					addChild(Player);
				}
				
				
				//Setup Highscore:
				
				if(mode==0)
				{
					highScoreText.text="Best: "+cookie.data.highScore+"/50";
				}
				else
				{
						highScoreText.text="Best: "+cookie.data.highScoreHard+"/50";
				}
				
				
				//Event listeners:
				timer.addEventListener("timer", playerMovement); //get the player moving.
				winTimer.addEventListener("timer", winEnd);
				stage.addEventListener ( KeyboardEvent.KEY_DOWN, reportKeyDown ); 
				stage.addEventListener ( KeyboardEvent.KEY_UP, reportKeyUp ); 
				
				// get the game running.
				timer.start();
			}
			
			if(this.currentFrame==3)
			{
				//graphic the back button
				backButton.gotoAndStop(2);
				// Write the scores:
				var scoreS:String=score.toString();
				scoreOut.text="Your final score was: "+scoreS+"/50";
				if(mode==0)
				{
					highScoreOut.text="Best: "+cookie.data.highScore+"/50";
				}
				else
				{
					highScoreOut.text="Best: "+cookie.data.highScoreHard+"/50";
				}
				//reset the score
				score=0;
				
				
				//Event listeners:
				playButton.addEventListener(MouseEvent.CLICK, Replay);
				backButton.addEventListener(MouseEvent.CLICK, returnToMain);
				
			}
			if(this.currentFrame==4)
			{
				backButton2.gotoAndStop(2);
				//reset the score
				score=0;
				if(mode==0)
				{
					winUnlock.text="Hard Mode Unlocked!"
				}
				if(mode==1)
				{
					winUnlock.text="    You Won Beta 2!"
				}
				backButton2.addEventListener(MouseEvent.CLICK, returnToMain);
			}
			if(this.currentFrame==5)
			{
				//setup Highscore.
				if(cookie.data.highScore==undefined)
				{
					cookie.data.highScore=0;
				}
				
				if(cookie.data.highScoreHard==undefined)
				{
					cookie.data.highScoreHard=0;
				}
				
				HS1.text=cookie.data.highScore+"/50";
				
				if(cookie.data.highScore==50) // if hard mode is unlocked...
				{
					hardButton.gotoAndStop(2);
					HS2.text=cookie.data.highScoreHard+"/50";
				}
				
				
				//graphic the back button
				backButton.gotoAndStop(1);
				
				
				
				//action Listeners:
				backButton.addEventListener(MouseEvent.CLICK, returnToMain);
				playNormal.addEventListener(MouseEvent.CLICK, gameInit);
				hardButton..addEventListener(MouseEvent.CLICK, gameInitHard);
			}
		}
		
		
		
		
		
		
		function gameMenu(e:MouseEvent) // this brings you to the game select menu.
		{
			//goto game
			frameControl(5);
		
		}
		
		function gameInit(e:MouseEvent) // this brings you to the actual game.
		{
			//goto game
			mode=0;
			frameControl(2);
		
		}
		
		function gameInitHard(e:MouseEvent) // this brings you to the actual game.
		{
			//goto game
			if(cookie.data.highScore==50)
			{
				mode=1;
				frameControl(2);
			}
		
		}
		
		function returnToMain(e:MouseEvent)
		{
			cookie.flush();
			frameControl(1);
		}
		
		function Replay(e:MouseEvent) 
		{
			
			cookie.flush();
			frameControl(2);
			
		}
		
		function detectCollision() // find anything that hits the players head
		{
			//move the hitboxes with the anvils
			HB1.x=anvilone.x+13;
			HB1.y=anvilone.y;
			HB2.x=anviltwo.x+13;
			HB2.y=anviltwo.y;
			HB3.x=anvilthree.x+13;
			HB3.y=anvilthree.y;
			HB4.x=anvilGold1.x+13;
			HB4.y=anvilGold1.y;
	
			// This is what happens when you hit an anvil.
			if(PlayerHead.hitTestObject(HB1)||PlayerHead.hitTestObject(HB2)||PlayerHead.hitTestObject(HB3)) 
			{
				if(!debug)
				{
					health--;
				}
				
				anvilone.reroll();
				anviltwo.reroll();
				anvilthree.reroll();
				
			}
			
			// for golden anvil.
			if(PlayerHead.hitTestObject(HB4))
			{
				health++;
				anvilGold1.reroll(); // reset the anvil.
			}
			
			
			scoreManager();			
			healthManager(); //deal with the health system now
			projectileManager(); // Make sure everything is okay with the anvils.
			
		}
		
		
		function winEnd(event:TimerEvent)
		{
			
			timer.stop();
			winTimer.stop();
			anvilone.timer.stop();
			anviltwo.timer.stop();
			anvilthree.timer.stop();
			
			// Get rid of everything else.
			removeChild(Player);
			cookie.flush();
			
			//Systematicly remove health icons from the stage.
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
			
			//goto win screen:
			frameControl(4);
		}
		
		
		function projectileManager() // Deals with projectiles in spicific edge cases
		{
			anvilone.y=anviltwo.y; //make sure anvils don't "shift"
			anvilone.y=anvilthree.y;
			
			goldx= anvilGold1.x;
			
			while(true) //rules restricting anvil generation.
			{
				if(mode==0)// rules for normal mode
				{
					while(true)//three anvils cannot line up on x axis.
					{
						if(anvilone.x==anviltwo.x+50 && anviltwo.x==anvilthree.x+50)
						{
							anvilone.reroll();
							anviltwo.reroll();
							anvilthree.reroll();
						}
						else
						{
							if(anvilone.x==anvilthree.x+50 && anvilthree.x==anviltwo.x+50)
							{
								anvilone.reroll();
								anviltwo.reroll();
								anvilthree.reroll();
							}
							else
							{
								if(anviltwo.x==anvilone.x+50 && anvilone.x==anvilthree.x+50)
								{
									anvilone.reroll();
									anviltwo.reroll();
									anvilthree.reroll();
								}
								else
								{
									if(anviltwo.x==anvilthree.x+50 && anvilthree.x==anvilone.x+50)
									{
										anvilone.reroll();
										anviltwo.reroll();
										anvilthree.reroll();
									}
									else
									{
										if(anvilthree.x==anvilone.x+50 && anvilone.x==anviltwo.x+50)
										{
											anvilone.reroll();
											anviltwo.reroll();
											anvilthree.reroll();
										}
										else
										{
											if(anvilthree.x==anviltwo.x+50 && anviltwo.x==anvilone.x+50)
											{
												anvilone.reroll();
												anviltwo.reroll();
												anvilthree.reroll();
											}
											else
											{
												break;
											}
										}
									}
								}
							}
						}
					}
				}
				if(mode==1) // hard mode rules.
				{	
					
					
					
				}
				break;
			} 
		}
		
		
		function scoreManager() // deals with score*.
		{
		
			
			if(!debug)
			{	
				scoreText.text="Score: "+score+"/50";
				if(mode==0)
				{
					if(cookie.data.highScore<score) // increases high score count. (this shouold only happen when you die)
					{
						cookie.data.highScore=score;
						cookie.flush();
						highScoreText.text="Best: "+cookie.data.highScore+"/50";
					}
				}
				else
				{
					if(cookie.data.highScoreHard<score) // increases high score count. (this shouold only happen when you die)
					{
						cookie.data.highScoreHard=score;
						cookie.flush();
						highScoreText.text="Best: "+cookie.data.highScoreHard+"/50";
					}
				}
			}
			else
			{
				scoreText.text="Debug Mode"
			}
			
			if(score>=50)
			{
			
				anvilone.Active=false;
				anviltwo.Active=false;
				anvilthree.Active=false;
				anvilGold1.Active=false;
				
				anvilone.reroll();
				anviltwo.reroll();
				anvilthree.reroll();
				anvilGold1.reroll();
				
				anvilGold2.Active=true;
				anvilGold3.Active=true;
				anvilGold4.Active=true;
				anvilGold5.Active=true;
				anvilGold6.Active=true;
				anvilGold7.Active=true;
				
				if(!winTimer.running)
				{
					
					winTimer.start();
					
				}
			}
			
		}
		
		
		function healthManager() // this controls everything* to do with health.
		{
			if(health<=0) //you die when your health is zero.
			{
				
				//shutdown all of the timers.
				timer.stop();
				anvilone.timer.stop();
				anviltwo.timer.stop();
				anvilthree.timer.stop();
				
				// Get rid of everything else.
				removeChild(Player);
				cookie.flush();
				
				//Systematicly remove health icons from the stage.
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
				
				//goto death screen,
				frameControl(3);
			}
			
			
			// when your health is at four, it is 'MAX'.
			if(health==4)
			{
				healthText.text="Health: MAX";
			}
			else
			{
				healthText.text="Health: "+health;
			}
			
		
			if(health>4) //limit max health.
			{
				health=4;
			}
			
			
			//Deal with health icons.
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
				PlayerHead.x=PlayerHead.x-6;
				
				if(Player.currentFrame<17)
				{
					Player.gotoAndPlay(18);
				}
				
			}
			
			if(moveRight)
			{
				PlayerHead.x=PlayerHead.x+6;
				
				if(Player.currentFrame==1||Player.currentFrame>=17)
				{
					Player.gotoAndPlay(3);
				}
				
			}
			
			if(!moveLeft && !moveRight)
			{
				Player.gotoAndStop(1);
			}
			
			// manage boundries (kinda crude, but whatever.)
			if(PlayerHead.x<150)
			{
				PlayerHead.x=150;
			}
			if(PlayerHead.x>450-PlayerHead.width)
			{
				PlayerHead.x=450-PlayerHead.width;
			}
			
			//Move the the body with player's head.
			Player.x=PlayerHead.x;
			PlayerHead.y=300-(PlayerHead.height+Player.height)
			Player.y=PlayerHead.y+PlayerHead.height-2.5;
			
			
			// find various objects that hit the players head.
			detectCollision();
		}
		

		function reportKeyDown( event:KeyboardEvent )
		{
			 _keysPressed[event.keyCode] = true;
			if ( event.keyCode == Keyboard.LEFT ) // Move the player Left.
			{
			
				moveLeft=true;
				
			}
			if ( event.keyCode == Keyboard.RIGHT ) // Move the player right
			{
				
				moveRight=true;
				
			}
			if ( event.keyCode == Keyboard.A ) // Move the player Left.
			{
			
				moveLeft=true;
				
			}
			if ( event.keyCode == Keyboard.D ) // Move the player right
			{
				
				moveRight=true;
				
			}
			if (event.keyCode == Keyboard.C ) // SUPER SECRET CRAB MODE!!!!
			{
				
				if(!crabMode)
				{
					anvilone.gotoAndStop(2);
					anviltwo.gotoAndStop(2);
					anvilthree.gotoAndStop(2);
					crabMode=true;
				}
				else
				{
					anvilone.gotoAndStop(1);
					anviltwo.gotoAndStop(1);
					anvilthree.gotoAndStop(1);
					crabMode=false;
				}
			}
			
			if ( event.keyCode == Keyboard.P ) // Debug some more score.
			{
				if(score<25)
				{
						//score=25;
				}
				else
				{
					if(score<50)
					{
						//score=50;
					}
				}
			}
			
			if ( event.keyCode == Keyboard.O ) // activate Debug mode!(disabled for release)
			{
				
				if(!debug) //if debug mode is off, turn it on.
				{
					//debug=true;
					//anvilone.scoring=false;
				}
				else
				{
					//debug=false;
					//anvilone.scoring=true;
				}
				
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
			
			if ( event.keyCode == Keyboard.A ) // 
			{
			
				moveLeft=false;
				
			}
			if ( event.keyCode == Keyboard.D ) // Move the player right
			{
				
				moveRight=false;
				
			}
			
		}
		
		
		
		

	}
}
