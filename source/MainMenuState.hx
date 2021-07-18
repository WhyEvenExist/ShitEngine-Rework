package;

import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import lime.system.System;
import FreeplayState.SongMetadata;
import flixel.util.FlxTimer;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var textMenuItems:Array<String> = ['CLIMB', 'Freeplay', 'FART', 'Options'];
	var spriteItems:Array<String> = ['mount', 'freepl', 'fart', 'sett'];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedSpriteGroup<FlxText>;
	var grpOptionsSprites:FlxTypedSpriteGroup<FlxSprite>;

	var selected:Bool = false;

	var camGame:FlxCamera;
	var camUI:FlxCamera;

	override function create()
	{
		clearCache();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		camGame = new FlxCamera();
		// camGame.bgColor.alpha = 0;

		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camUI);

		FlxCamera.defaultCameras = [camGame];

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		// controlsStrings = CoolUtil.coolTextFile(Paths.txt('controls'));
		menuBG.color = 0x3486B8;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image('titlescreen/gradient'));
		bg.screenCenter();
		bg.alpha = 0.6;
		add(bg);
		// bg.cameras = [camBG];

		var snowParticles:FlxEmitter = new FlxEmitter(-500, -50, 1000);
		for (i in 0...1000)
		{
			var randoString:String = "Small";
			if (FlxG.random.bool(50))
			{
				randoString = "Medium";
			}
			var p = new FlxParticle();
			if (FlxG.random.bool(50))
				p.loadGraphic(Paths.image('titlescreen/snow' + randoString), false, 50, 50);
			else
				p.loadGraphic(Paths.image('titlescreen/snow'), false, 50, 50);
			p.alpha = FlxG.random.float(0.3, 0.7);
			p.lifespan = 1000000;
			p.exists = false;
			var scale = FlxG.random.float(0.5, 1);
			p.scale.set(scale, scale);
			snowParticles.add(p);
		}
		add(snowParticles);
		snowParticles.start(false, 0.05);
		// snowParticles.scale.set(0.5, 1, 0.5, 1, 0.5, 1, 0.5, 1);
		snowParticles.alpha.set(0.3, 0.7);
		snowParticles.acceleration.set(0, 0, 0, 0, FlxG.width, FlxG.width, FlxG.height, FlxG.height);
		// snowParticles.cameras = [camBG];

		FlxTween.tween(snowParticles, {x: FlxG.width + 500}, 1, {ease: FlxEase.quadInOut, type: PINGPONG});

		grpOptionsTexts = new FlxTypedSpriteGroup<FlxText>();
		add(grpOptionsTexts);

		grpOptionsSprites = new FlxTypedSpriteGroup<FlxSprite>();
		add(grpOptionsSprites);

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		// add(selector);

		for (i in 0...textMenuItems.length)
		{
			var optionText:FlxText = new FlxText(100, 0, 0, textMenuItems[i], 50);
			optionText.setFormat('assets/fonts/renogare.otf', 50, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			if (textMenuItems[i].toLowerCase() != 'climb')
				optionText.size = 32;
			optionText.y = 280 + (i * optionText.size + 25);
			if (textMenuItems[i].toLowerCase() != 'climb')
			{
				optionText.y += 55;
				optionText.x += 50;
			}
			if (i > 1)
				optionText.y += 15;
			if (i > 2)
				optionText.y += 15;
			optionText.setBorderStyle(OUTLINE, FlxColor.BLACK, 0.5, 0.5);
			optionText.ID = i;
			optionText.cameras = [camUI];
			var acomSprite:FlxSprite = new FlxSprite(optionText.x - 50, optionText.y - 50).loadGraphic(Paths.image('titlescreen/' + spriteItems[i]));
			if (textMenuItems[i].toLowerCase() != 'climb')
			{
				acomSprite.setGraphicSize(Std.int(acomSprite.width * 0.24));
				acomSprite.offset.x += 20;
				acomSprite.y -= 5;
			}
			else
			{
				acomSprite.setGraphicSize(Std.int(acomSprite.width * 0.62));
				acomSprite.y -= 145;
				acomSprite.offset.x -= 30;
			}

			acomSprite.ID = i;
			acomSprite.antialiasing = true;
			// acomSprite.shader = new HQ2x();
			acomSprite.cameras = [camUI];
			grpOptionsSprites.add(acomSprite);
			grpOptionsTexts.add(optionText);
		}

		changeSelection();

		grpOptionsSprites.cameras = [camUI];
		grpOptionsTexts.cameras = [camUI];

		camUI.x += 50;

		selected = false;

		super.create();

		camUI.alpha = 0;
		FlxTween.tween(camUI, {alpha: 1}, 1.5, {ease: FlxEase.quadInOut});
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		super.update(elapsed);

		if (!selected)
		{
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.UP_P)
				changeSelection(-1);

			if (controls.BACK)
				System.exit(0);

			if (controls.ACCEPT)
			{
				if (textMenuItems[curSelected].toLowerCase() == 'fart')
				{
					FlxG.sound.play(Paths.sound('fart'));
					FlxG.camera.shake(0.01, 0.1);
				}
				else
				{
					if (textMenuItems[curSelected].toLowerCase() != 'options')
					{
						FlxG.sound.music.stop();
					}
					selected = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					grpOptionsTexts.forEach(function(txt:FlxText)
					{
						if (txt.ID == curSelected)
						{
							txt.y -= 20;
							FlxTween.tween(txt, {y: txt.y + 20}, 0.5, {ease: FlxEase.quadInOut});
						}
					});
					grpOptionsSprites.forEach(function(txt:FlxSprite)
					{
						if (txt.ID == curSelected)
						{
							txt.y -= 20;
							FlxTween.tween(txt, {y: txt.y + 20}, 0.5, {ease: FlxEase.quadInOut});
						}
					});
					new FlxTimer().start(1, function(_)
					{
						FlxTween.tween(camUI, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
						switch (textMenuItems[curSelected].toLowerCase())
						{
							case "climb":
								FlxG.switchState(new VideoState('paint', new MainMenuState(), -1, true));
								FlxTransitionableState.skipNextTransIn = true;
							case "freeplay":
								FlxG.switchState(new FreeplayState());
							case "options":
								FlxG.switchState(new MenuOptions());
						}
					});
				}
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
			{
				txt.color = 0x65FE65;
				FlxTween.tween(txt, {x: 60}, 0.2, {ease: FlxEase.quadInOut});
			}
			else
			{
				FlxTween.tween(txt, {x: 50}, 0.2, {ease: FlxEase.quadInOut});
			}
		});

		grpOptionsSprites.forEach(function(txt:FlxSprite)
		{
			// txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
			{
				// txt.color = 0x65FE65;
				FlxTween.tween(txt, {x: -15}, 0.2, {ease: FlxEase.quadInOut});
			}
			else
			{
				FlxTween.tween(txt, {x: -25}, 0.2, {ease: FlxEase.quadInOut});
			}
		});
	}
}
