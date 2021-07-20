package;

import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import sys.FileSystem;
import sys.io.File;
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
import hscript.*;

class MenuBaseState extends MusicBeatState
{
	var themeName:String = TitleState.curTheme;
	var themeParser:Parser = new Parser();
	var themeCode:Interp = new Interp();

	override function create()
	{
		super.create();

		var theme:String = "";
		if (FileSystem.exists('mods/themes/$themeName/base.hs'))
		{
			try
			{
				theme = File.getContent('mods/themes/$themeName/base.hs');
				themeParser.allowTypes = true;
				var code = themeParser.parseString(theme);
				setVars();
				themeCode.execute(code);
				themeCode.variables.get('onMenuCreate')();
			}
			catch (exception)
			{
				FlxG.log.error('Something has gone wrong while loading a theme!\nDetails: ' + exception);
				var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
				// controlsStrings = CoolUtil.coolTextFile(Paths.txt('controls'));
				menuBG.color = 0x3486B8;
				menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
				menuBG.updateHitbox();
				menuBG.screenCenter();
				menuBG.antialiasing = true;
				add(menuBG);
			}
		}
		else
		{
			var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
			// controlsStrings = CoolUtil.coolTextFile(Paths.txt('controls'));
			menuBG.color = 0x3486B8;
			menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
			menuBG.updateHitbox();
			menuBG.screenCenter();
			menuBG.antialiasing = true;
			add(menuBG);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FileSystem.exists('mods/themes/$themeName/base.hs'))
		{
			try
			{
				themeCode.variables.get('onMenuUpdate')();
			}
			catch (exception)
			{
				trace('nope');
			}
		}
	}

	function setVars()
	{
		themeCode.variables.set("FlxG", FlxG);
		themeCode.variables.set("Sys", Sys);
		themeCode.variables.set("Std", Std);
		themeCode.variables.set("StringTools", StringTools);
		themeCode.variables.set("Math", Math);
		themeCode.variables.set("FlxMath", FlxMath);
		themeCode.variables.set("FlxSprite", FlxSprite);
		themeCode.variables.set("FlxObject", FlxObject);
		themeCode.variables.set("File", File);
		themeCode.variables.set("fs", FileSystem);
		themeCode.variables.set("SpriteData", BitmapData);
		themeCode.variables.set("FlxTimer", FlxTimer);
		themeCode.variables.set("FlxTween", FlxTween);
		themeCode.variables.set("FlxEase", FlxEase);
		themeCode.variables.set("FlxText", FlxText);
		themeCode.variables.set("Alphabet", Alphabet);
		themeCode.variables.set("FlxEmitter", FlxEmitter);
		themeCode.variables.set("FlxParticle", FlxParticle);
		themeCode.variables.set("MusicBeatState", MusicBeatState);
		themeCode.variables.set("menu", this);
		themeCode.variables.set("FlxCamera", FlxCamera);
		themeCode.variables.set("FlxTypedGroup", FlxTypedGroup);
	}
}
