package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.macros.FlxMacroUtil;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.util.FlxSort;
import flixel.FlxObject;

using StringTools;

class ControlMenu extends MenuBaseState
{
	var selector:FlxText;

	public static var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];
	var shitass:Array<String> = [
		"UP", "DOWN", "LEFT", "RIGHT", "UP (ALTERNATE)", "DOWN (ALTERNATE)", "LEFT (ALTERNATE)", "RIGHT (ALTERNATE)", "ACCEPT", "RESET", "BACK", "CHEAT",
		"ACCEPT (ALTERNATE)", "RESET (ALTERNATE)", "BACK (ALTERNATE)", "CHEAT (ALTERNATE)"
	];

	private var grpControls:FlxTypedSpriteGroup<Alphabet>;
	private var grpKeys:FlxTypedGroup<Alphabet>;
	var changingInput:Bool = false;

	var camFollow:FlxObject;

	override function create()
	{
		super.create();

		camFollow = new FlxObject(0, 0, 1, 1);

		grpControls = new FlxTypedSpriteGroup<Alphabet>();
		add(grpControls);

		grpKeys = new FlxTypedGroup<Alphabet>();
		add(grpKeys);
		var i = 0;

		var elements:Array<String> = controlsStrings[i].split(',');

		// FlxG.camera.follow(camFollow, null, 0.06);

		for (i in 0...shitass.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, '   ' + shitass[i].replace('(ALTERNATE)', 'ALT') + ': ', false, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;

			var controlLabel2:Alphabet = new Alphabet(0, controlLabel.y, Controls.keyboardMap.get(shitass[i]), true, false);
			controlLabel2.y -= i * 70;
			controlLabel2.y += 12;
			controlLabel2.screenCenter(X);
			// controlLabel2.x += FlxG.height / 2;
			controlLabel2.x += 200;
			controlLabel.add(controlLabel2);
			grpControls.add(controlLabel);
		}

		// /* dont delete this; this handles the sorting for the menu
		// 	** deleting this will give the menu a random selection every time
		// 	** so dont
		//  */
		// // ok ok ok -Verwex
		// grpControls.sort(FlxSort.byY, FlxSort.DESCENDING);
		changeSelection();

		grpControls.x += 20;
		// FlxG.camera.zoom = 0.9;
		// grpControls.scale.set(0.7, 0.7);
		// grpControls.updateHitbox();

		// for (i in 0...controlsStrings.length)
		// {
		//
		//	var elements:Array<String> = controlsStrings[i].split(',');
		//	var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30,'set ' + elements[0] + ': ' + elements[1], true, false);
		//	controlLabel.isMenuItem = true;
		//	controlLabel.targetY = i;
		//	grpControls.add(controlLabel);
		//
		//	// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		// }

		// super.create();

		// openSubState(new OptionsSubState());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!changingInput)
		{
			if (controls.BACK)
			{
				FlxG.switchState(new MenuOptions());
				Controls.saveControls();
				controls.setKeyboardScheme(Solo, true);
			}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.ACCEPT)
				ChangeInput();
		}
		else
		{
			ChangingInput();
		}
	}

	function changeSelection(change:Int = 0)
	{
		// #if !switch
		// NGio.logEvent('Fresh');
		// #end

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function ChangeInput()
	{
		changingInput = true;
		FlxFlicker.flicker(grpControls.members[curSelected], 0);
	}

	function ChangingInput()
	{
		if (FlxG.keys.pressed.ANY)
		{
			// Checks all known keys
			var keyMaps:Map<String, FlxKey> = FlxMacroUtil.buildMap("flixel.input.keyboard.FlxKey");
			for (key in keyMaps.keys())
			{
				if (FlxG.keys.checkStatus(key, 2) && key != "ANY")
				{
					FlxFlicker.stopFlickering(grpControls.members[curSelected]);

					var elements:Array<String> = grpControls.members[curSelected].text.split(':');
					var name:String = StringTools.replace(elements[0], '   ', '');
					var controlLabel:Alphabet = new Alphabet(0, 0, '   ' + name.replace('(ALTERNATE)', 'ALT') + ': ', false, false);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = 0;

					var controlLabel2:Alphabet = new Alphabet(0, controlLabel.y, key, true, false);
					// controlLabel2.y -= 30;
					// controlLabel2.x += FlxG.height / 2;
					controlLabel2.y += 12;
					controlLabel2.screenCenter(X);
					// controlLabel2.x += FlxG.height / 2;
					controlLabel2.x += 200;
					controlLabel.add(controlLabel2);
					grpControls.replace(grpControls.members[curSelected], controlLabel);
					changingInput = false;

					Controls.keyboardMap.set(name, keyMaps[key]);
					FlxG.log.add(name + " is bound to " + keyMaps[key]);

					break;
				}
			}
		}
	}
}
