package;

import flixel.FlxG;
import flixel.util.FlxSave;
import openfl.display.Sprite;
import flixel.FlxGame;

class Main extends Sprite
{
	public function new()
	{
		var startFullscreen:Bool = false;
		var save:FlxSave = new FlxSave();
		save.bind("TurnBasedRPG");
		#if desktop
		if (save.data.fullscreen != null)
		{
			startFullscreen = save.data.fullscreen;
		}
		#end

		super();
		addChild(new FlxGame(320, 240, MenuState));

		if (save.data.volume != null)
		{
			FlxG.sound.volume = save.data.volume;
		}
		save.close();
	}
}
