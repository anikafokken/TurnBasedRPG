package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class GameOverState extends FlxState
{
	var titleText:FlxText;
	var messageText:FlxText;
	var scoreIcon:FlxSprite;
	var scoreText:FlxText;
	var highscoreText:FlxText;
	var mainMenuButton:FlxButton;

	/**
		Called from PlayState, this will set our win and score variables
		@param win
		@param score
	**/
	public function new(win:Bool, score:Int)
	{
		super();

		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end

		// create and add each of our items
		titleText = new FlxText(0, 20, 0, if (win) "You Win!" else "Game Over!", 22);
		titleText.alignment = CENTER;
		titleText.screenCenter(FlxAxes.X);
		add(titleText);

		messageText = new FlxText(0, (FlxG.height / 2) - 18, 0, "Final Score:", 8);
		messageText.alignment = CENTER;
		messageText.screenCenter(FlxAxes.X);
		add(messageText);

		scoreText = new FlxText((FlxG.width / 2) - 8, 0, Std.string(score), 8);
		scoreText.screenCenter(FlxAxes.Y);
		add(scoreText);

		var highscore = checkHighscore(score);

		highscoreText = new FlxText(0, (FlxG.height / 2) + 10, 0, "High Score: " + highscore, 8);
		highscoreText.alignment = CENTER;
		highscoreText.screenCenter(FlxAxes.Y);
		add(highscoreText);

		mainMenuButton = new FlxButton(0, FlxG.height - 32, "Main Menu", switchToMainMenu);
		mainMenuButton.screenCenter(FlxAxes.X);
		mainMenuButton.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(mainMenuButton);

		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end

		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		super.create();
	}

	/**
	 * This function will compare the new score with the saved highscore.
	 * If the new score is higher, it will save it as the new highscore, otherwise, it will return the saved highscore.
	 * @param	score	The new score
	 * @return	the highscore
	 */
	function checkHighscore(score:Int):Int
	{
		var highscore:Int = score;
		if (FlxG.save.data.highscore != null && FlxG.save.data.highscore > highscore)
		{
			highscore = FlxG.save.data.highscore;
		}
		else
		{
			// data is less or there is no data; save current score
			FlxG.save.data.highscore = highscore;
		}
		return highscore;
	}

	/**
		When the user hits the main menu button, it should fade out and then take them back to the MenuState
	**/
	function switchToMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(MenuState.new);
		});
	}
}