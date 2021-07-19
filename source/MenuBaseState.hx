package;

import flixel.util.FlxColor;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.*;
import flixel.effects.particles.*;
import flixel.tweens.*;
import openfl.Assets;

class MenuBaseState extends MusicBeatState
{
	override function create()
	{
		super.create();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		// controlsStrings = CoolUtil.coolTextFile(Paths.txt('controls'));
		menuBG.color = 0x3486B8;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
