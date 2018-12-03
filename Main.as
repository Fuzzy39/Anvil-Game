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
		
		//Universal Game Variables
		public static var mode:int = 0; // game difficulty, slightly affects game rules. 0=normal, 1=hard, 2=brutal(unused)
		public static var score:int = 0; //scoring is done by the anvil class.
		public var health:int = 1;//max 4, if it hits 0, you lose.
		public var debug:Boolean=false; //if true, player is invincible, but cannot increase score.
		var crabMode:Boolean=false; // Controls crab mode.
		
		//Other Public variables
		public static var goldx:int;// for use in hard mode rules changes.
		
		
		
		//init the health icons
		var HP1OFF=new healthLow();
		var HP2OFF=new healthLow();
		var HP3OFF=new healthLow();
		
		//These are not visible on game start.
		var HP1ON=new healthHigh();
		var HP2ON=new healthHigh();
		var HP3ON=new healthHigh();
		
		//init player
		var Player=new playerBody();
		var moveLeft:Boolean=false; // check if the player is trying to move left or right.
		var moveRight:Boolean=false;	
		
		
		//Start the Shared object for persitance
		var cookie:SharedObject = SharedObject.getLocal("masonGameCookie2");
		
		
		// init timers
		var timer:Timer = new Timer(25);
		var winTimer:Timer = new Timer(5000);
				
		
		public function Main() // Start the game.
		{
			
			
			stop(); // Seizures aren't fun!
			frameControl(1); // initiate everything and get it under control.
			
		}
		
		

		
		function detectCollision() // find anything that hits the players head.
		{
			//move the hitboxes with the anvils.
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
				if(!debug) // make the DEBUG user invincible.
				{
					health--; //reduce the player's health.
				}
				
				//reset all of the anvils.
				anvilone.reroll();
				anviltwo.reroll();
				anvilthree.reroll();
				
			}
			
			// When you hit a golden anvil.
			if(PlayerHead.hitTestObject(HB4))
			{
				//increase user's health
				health++;
				
				anvilGold1.reroll(); // reset the anvil.
			}
			
			
			
			
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
					
				//Maybe rules will be added in the future.	
					
				}
				break;
			} 
		}
		
		
		function scoreManager() // deals with score*.
		{
		
			
			if(!debug)// normal rules.
			{	
				scoreText.text="Score: "+score+"/50"; //Show the player the score
				
				if(mode==0) // Normal mode rules.
				{
					
					if(cookie.data.highScore<score) // increases high score count.
					{
						
						cookie.data.highScore=score;
						cookie.flush(); //Save this info.
						highScoreText.text="Best: "+cookie.data.highScore+"/50"; // Show the player.
						
					}
				}
				else //rules for Hard mode.
				{
					
					if(cookie.data.highScoreHard<score) // increases high score count. 
					{
						//same stuff from before.
						cookie.data.highScoreHard=score;
						cookie.flush();
						highScoreText.text="Best: "+cookie.data.highScoreHard+"/50";
						
					}
				}
			}
			else //debug rules
			{
				scoreText.text="Debug Mode"
			}
			
			if(score>=50) // when you beat the game:
			{
				//Shutdown all of the 'game' anvils
				anvilone.Active=false;
				anviltwo.Active=false;
				anvilthree.Active=false;
				anvilGold1.Active=false;
				
				//get them off the screen.
				anvilone.reroll();
				anviltwo.reroll();
				anvilthree.reroll();
				anvilGold1.reroll();
				
				//activate golden anvil shower!
				anvilGold2.Active=true;
				anvilGold3.Active=true;
				anvilGold4.Active=true;
				anvilGold5.Active=true;
				anvilGold6.Active=true;
				anvilGold7.Active=true;
				
				// begin the win timer (which ends the game)
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
		
		
		function winEnd(event:TimerEvent) // WHat happens when the win timer goes off.
		{
			//sut everything off.
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
		
		function playerMovement()
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
			Player.y=PlayerHead.y+PlayerHead.height;
			
			
			
		}
		
		
		function gameCore(event:TimerEvent)
		{
			//Do all game functions.
			playerMovement();
			detectCollision();
			scoreManager();	//Deal with	!suprise SCORE	
			healthManager(); //Deal with the health system now
			projectileManager(); // Make sure everything is okay with the anvils.
		}

		
		
		function reportKeyDown( event:KeyboardEvent ) // this function handles when a key is pressed down.
		{
			
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
				
				if(!crabMode) //CRAB CRAB CRAB CRAAAB!
				{
					anvilone.gotoAndStop(2);
					anviltwo.gotoAndStop(2);
					anvilthree.gotoAndStop(2);
					crabMode=true;
				}
				else //NO CRAB NO CRAMP OH NO STAN!!!
				{
					// This is stan:
					
					//  /---\
					//			/---\
					//	|       |
					//  |       |
					//
					//  _____________
					//	\           /
					//	 \---------/
					
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
						score=25;
				}
				else
				{
					if(score<50)
					{
						score=50;
					}
				}
			}
			
			if ( event.keyCode == Keyboard.O ) // activate Debug mode!(disabled for release)
			{
				
				if(!debug) //if debug mode is off, turn it on.
				{
					debug=true;
					anvilone.scoring=false; // no Score in Debug mode.
				}
				else
				{
					debug=false;
					anvilone.scoring=true;
				}
				
			}
			
			
		}

		

		
		function reportKeyUp( event:KeyboardEvent )
		{
			
			if ( event.keyCode == Keyboard.LEFT ) // Stop moving the player left.
			{
			
				moveLeft=false;
				
			}
			if ( event.keyCode == Keyboard.RIGHT ) // Stop moving the player right.
			{
				
				moveRight=false;
				
			}
			
			if ( event.keyCode == Keyboard.A ) // Move the Player Left.
			{
			
				moveLeft=false;
				
			}
			if ( event.keyCode == Keyboard.D ) // Move the player right
			{
				
				moveRight=false;
				
			}
			
		}
		
		
		
		//Does the magic of switching frames, based on Mouse Events.
		function frameControlButton(frame:int):Function 
		{
			return function(e:MouseEvent):void // Got this from stack exchange  a long time ago, it works.
			{
				//set everything and go!
				cookie.flush();
				frameControl(frame);
			}
		}
		

		
		function gameInit(e:MouseEvent) // this brings you to the actual game.
		{
			
			mode=0;//Set mode to normal
			frameControl(2); //Goto game.
		
		}
		
		
		function gameInitHard(e:MouseEvent) // this brings you to the actual game.
		{
			
			if(cookie.data.highScore==50)// if hardmode is unlocked:
			{
				mode=1; //Set mode to hard.
				frameControl(2); //then get to the game.
			}
		
		}
		
		
		
		
		
		public function frameControl(frame) //Move to different parts of the game.
		{				
			
			//Do the actual moving.
			gotoAndStop(frame);
			
			//Setup frame related stuff.
			if(this.currentFrame==1) // init intro frame.
			{
				
				// add event listeners
				playButton.addEventListener(MouseEvent.CLICK, frameControlButton(5));
				
				
			}
			
			if(this.currentFrame==2) // init game.
			{
				
				// Move the Health Icons to their proper locations.
				this.HP1OFF.y=210;
				this.HP2OFF.y=130;
				this.HP3OFF.y=50;
				
				this.HP1ON.y=210;
				this.HP2ON.y=130;
				this.HP3ON.y=50;
				
				//Setup special rules for the anvils.
				anvilone.scoring=true;
				anvilGold2.Active=false;
				anvilGold3.Active=false;
				anvilGold4.Active=false;
				anvilGold5.Active=false;
				anvilGold6.Active=false;
				anvilGold7.Active=false;
				
				// Setup health
				health=1;
				
				//Put the 'low Health' icons into play.
				addChild(HP1OFF);
				addChild(HP2OFF);
				addChild(HP3OFF);
				
				
				// Setup player: (Note that 'player' here is refering only to the player's body, not its head.)
				
				this.Player.x=150;
				this.Player.y=240;
				stage.focus= Player;
				
				if(! stage.contains(Player)) //If the player is not already in play, put it in play.
				{
					addChild(Player);
				}
				
				
				//Setup Highscore:
				
				if(mode==0) //as there are two High scores in the game, the game hardness must be checked before using one.
				{
					//For normal mode:
					highScoreText.text="Best: "+cookie.data.highScore+"/50";
				}
				else
				{
					// for hard mode:
					highScoreText.text="Best: "+cookie.data.highScoreHard+"/50";
				}
				
				
				//Event listeners:
				timer.addEventListener("timer", gameCore); //get the player moving.
				winTimer.addEventListener("timer", winEnd); // started when the game is won.
				
				// For all keyboard related input:
				stage.addEventListener ( KeyboardEvent.KEY_DOWN, reportKeyDown ); 
				stage.addEventListener ( KeyboardEvent.KEY_UP, reportKeyUp ); 
				
				
				
				// get the game running.
				timer.start();
			}
			
			if(this.currentFrame==3) // Death screen.
			{
				//graphic the back button
				backButton.gotoAndStop(2);
				
				
				// Write the score.
				var scoreS:String=score.toString();
				scoreOut.text="Your final score was: "+scoreS+"/50";
		
				//Write out the high score.
				
				if(mode==0) //as always, check the game mode to see the apropriate high score.
				{
					//Normal Mode
					highScoreOut.text="Best: "+cookie.data.highScore+"/50";
				}
				else
				{
					//Hard Mode
					highScoreOut.text="Best: "+cookie.data.highScoreHard+"/50";
				}
				
				//reset the score, so you can play again.
				score=0;
				
				
				//Event listeners:
				playButton.addEventListener(MouseEvent.CLICK, frameControlButton(2));
				backButton.addEventListener(MouseEvent.CLICK, frameControlButton(1));
				
			}
			if(this.currentFrame==4) //Victory Screen.
			{
				//Change the Back button the the apropriate Palete.
				backButton2.gotoAndStop(2);
				
				//reset the score, so you can play again.
				score=0;
				
				if(mode==0) //Set the Normal mode text
				{
					winUnlock.text="Hard Mode Unlocked!"
				}
				
				if(mode==1) //Set the text in hard mode.
				{
					winUnlock.text="    You Won Beta 2!"
				}
				
				//event listener:
				backButton2.addEventListener(MouseEvent.CLICK, frameControlButton(1));
			}
			if(this.currentFrame==5) //Game Mode menu.
			{
				
				//If there is no high score (first time playing) set it to zero.
				if(cookie.data.highScore==undefined) 
				{
					cookie.data.highScore=0;
				}
				
				//Do this for hard mode too.
				
				if(cookie.data.highScoreHard==undefined)
				{
					cookie.data.highScoreHard=0;
				}
				
				//set the highscore text for normal mode.
				HS1.text=cookie.data.highScore+"/50";
				
				
				if(cookie.data.highScore==50) // if hard mode is unlocked, do the same.
				{
					hardButton.gotoAndStop(2); //unlock the button.
					HS2.text=cookie.data.highScoreHard+"/50";
				}
				
				
				//graphic the back button
				backButton.gotoAndStop(1);
				
				
				
				//action Listeners:
				backButton.addEventListener(MouseEvent.CLICK, frameControlButton(1));
				playNormal.addEventListener(MouseEvent.CLICK, gameInit);
				hardButton..addEventListener(MouseEvent.CLICK, gameInitHard);
			}
		}
		
		

	}
}