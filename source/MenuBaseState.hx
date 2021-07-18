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

		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image('titlescreen/gradient'));
		bg.screenCenter();
		bg.alpha = 0.7;
		add(bg);

		var bg2:FlxSprite = new FlxSprite();
		bg2.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg2.screenCenter();
		bg2.alpha = 0.4;
		add(bg2);
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
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
