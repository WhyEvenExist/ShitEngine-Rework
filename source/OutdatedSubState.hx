package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

/**
 * THE PIRATE BAY MUAHAHA
 */
class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var banana = "*insert gaybanana link here*";
		var mirror = "*insert mirror link here*";
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! You're running a pirated version of the mod!"
			+ "\nTo get the full experience,\nPlease download the mod from gamebanana.\n "
			+ banana
			+ "\nOr if you're feeling short on connection,\nthe mirror link: "
			+ mirror
			+ "\nYou can play the mod,\nhowever the features will be limited by the site provider.\n \nI hope you enjoy the mod!",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			FlxG.switchState(new MainMenuState());

		super.update(elapsed);
	}
}

class PiracyState extends MusicBeatState
{
	public static var pirated:Bool = false;

	override function create()
	{
		super.create();
		pirated = false;
		FlxG.mouse.visible = false;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var bg2:FlxSprite = new FlxSprite();
		bg2.loadGraphic(Paths.image('titlescreen/blu'));
		bg2.screenCenter();

		var bg3:FlxSprite = new FlxSprite();
		bg3.loadGraphic(Paths.image('titlescreen/beep'));
		bg3.screenCenter();

		var bg4:FlxSprite = new FlxSprite();
		bg4.loadGraphic(Paths.image('titlescreen/piracy'));
		bg4.screenCenter();

		new FlxTimer().start(0.5, function(_)
		{
			(cast(openfl.Lib.current.getChildAt(0), Main)).fpsShow(false);
			// FlxG.fullscreen = true;
			new FlxTimer().start(0.5, function(_)
			{
				add(bg2);
				new FlxTimer().start(1, function(_)
				{
					remove(bg2);
					// FlxG.fullscreen = false;
					new FlxTimer().start(0.2, function(_)
					{
						add(bg3);
						FlxG.sound.play(Paths.sound('beepD'));
						new FlxTimer().start(0.7, function(_)
						{
							remove(bg3);
							add(bg4);
							FlxG.sound.playMusic(Paths.sound('dosert'));
							pirated = true;
						});
					});
				});
			});
		});
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			// (cast(openfl.Lib.current.getChildAt(0), Main)).showFPS(true);
			FlxG.sound.music.stop();
			FlxG.mouse.visible = true;
			FlxG.switchState(new TitleState());
		}

		super.update(elapsed);
	}
}
