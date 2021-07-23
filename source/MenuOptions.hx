package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.FlxAssets.FlxShader;

using StringTools;

class MenuOptions extends MenuBaseState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;

	override function create()
	{
		super.create();

		// var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = coolStringFile((FlxG.save.data.fullScreen ? 'Fullscreen' : 'Windowed') + "\n"
			+ (FlxG.save.data.antiSpam ? "FNF Mode" : "DDR Mode") + "\n" + (FlxG.save.data.downScroll ? 'Downscroll' : 'Upscroll') + "\n"
			+ (FlxG.save.data.keyInputs ? 'Raw Input' : 'Warm Input') + "\nControls" + "\nNote colors" + "\nWebm player");

		trace(controlsStrings);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		// add(versionShit);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		// if (controls.RIGHT_R)
		// {
		// 	FlxG.save.data.offset++;
		// 	versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
		// }

		// if (controls.LEFT_R)
		// {
		// 	FlxG.save.data.offset--;
		// 	versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
		// }

		if (controls.ACCEPT)
		{
			if (curSelected < 4)
				grpControls.remove(grpControls.members[curSelected]);
			switch (curSelected)
			{
				case 0:
					FlxG.save.data.fullScreen = !FlxG.save.data.fullScreen;
					var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.fullScreen ? 'Fullscreen' : 'Windowed'), true, false);
					ctrl.isMenuItem = true;
					ctrl.targetY = curSelected;
					grpControls.add(ctrl);
					FlxG.fullscreen = FlxG.save.data.fullScreen;

				case 1:
					FlxG.save.data.antiSpam = !FlxG.save.data.antiSpam;
					var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.antiSpam ? "FNF Mode" : "DDR Mode"), true, false);
					ctrl.isMenuItem = true;
					ctrl.targetY = curSelected - 1;
					grpControls.add(ctrl);
				case 2:
					FlxG.save.data.downScroll = !FlxG.save.data.downScroll;
					var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downScroll ? 'Downscroll' : 'Upscroll'), true, false);
					ctrl.isMenuItem = true;
					ctrl.targetY = curSelected - 2;
					grpControls.add(ctrl);
				case 3:
					FlxG.save.data.keyInputs = !FlxG.save.data.keyInputs;
					var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.keyInputs ? 'Raw Input' : 'Warm Input'), true, false);
					ctrl.isMenuItem = true;
					ctrl.targetY = curSelected - 3;
					grpControls.add(ctrl);
				case 4:
					trace('switch');
					FlxG.switchState(new ControlMenu());
				case 5:
					trace('switch');
					FlxG.switchState(new NotesSubstate());
				case 6:
					trace('switch');
					FlxG.switchState(new VideoState('paint', new MenuOptions(), -1, true));
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

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

	public static function coolStringFile(path:String):Array<String>
	{
		var daList:Array<String> = path.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
}

class NotesSubstate extends MenuBaseState
{
	private static var curSelected:Int = 0;
	private static var typeSelected:Int = 0;

	private var grpNumbers:FlxTypedGroup<Alphabet>;
	private var grpNotes:FlxTypedGroup<FlxSprite>;
	private var shaderArray:Array<ColorSwap> = [];
	var curValue:Float = 0;
	var holdTime:Float = 0;
	var hsvText:Alphabet;
	var nextAccept:Int = 5;

	var posX = 250;

	override function create()
	{
		super.create();

		grpNotes = new FlxTypedGroup<FlxSprite>();
		add(grpNotes);
		grpNumbers = new FlxTypedGroup<Alphabet>();
		add(grpNumbers);

		for (i in 0...Saves.arrowHSV.length)
		{
			var yPos:Float = (165 * i) + 35;
			for (j in 0...3)
			{
				var optionText:Alphabet = new Alphabet(0, yPos, Std.string(Saves.arrowHSV[i][j]));
				optionText.x = posX + (225 * j) + 100 - ((optionText.lettersArray.length * 90) / 2);
				grpNumbers.add(optionText);
			}

			var note:FlxSprite = new FlxSprite(posX - 70, yPos);
			note.frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
			switch (i)
			{
				case 0:
					note.animation.addByPrefix('idle', 'purple0');
				case 1:
					note.animation.addByPrefix('idle', 'blue0');
				case 2:
					note.animation.addByPrefix('idle', 'green0');
				case 3:
					note.animation.addByPrefix('idle', 'red0');
			}
			note.animation.play('idle');
			note.antialiasing = true;
			grpNotes.add(note);

			var newShader:ColorSwap = new ColorSwap();
			note.shader = newShader.shader;
			for (type in 0...3)
			{
				newShader.update(Saves.arrowHSV[i][type], type);
			}
			shaderArray.push(newShader);
		}
		hsvText = new Alphabet(0, 0, "Hue    Saturation  Brightness", false, false, 0, 0.65);
		add(hsvText);
		changeSelection();
	}

	var changingNote:Bool = false;
	var hsvTextOffsets:Array<Float> = [240, 90];

	override function update(elapsed:Float)
	{
		if (changingNote)
		{
			if (holdTime < 0.5)
			{
				if (controls.LEFT_P)
				{
					updateValue(-1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				else if (controls.RIGHT_P)
				{
					updateValue(1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				else if (controls.RESET)
				{
					resetValue(curSelected, typeSelected);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				if (controls.LEFT_R || controls.RIGHT_R)
				{
					holdTime = 0;
				}
				else if (controls.LEFT || controls.RIGHT)
				{
					holdTime += elapsed;
				}
			}
			else
			{
				var add:Float = 90;
				switch (typeSelected)
				{
					case 1 | 2:
						add = 50;
				}
				if (controls.LEFT)
				{
					updateValue(elapsed * -add);
				}
				else if (controls.RIGHT)
				{
					updateValue(elapsed * add);
				}
				if (controls.LEFT_R || controls.RIGHT_R)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					holdTime = 0;
				}
			}
		}
		else
		{
			if (controls.UP_P)
			{
				changeSelection(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.DOWN_P)
			{
				changeSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.LEFT_P)
			{
				changeType(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.RIGHT_P)
			{
				changeType(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.RESET)
			{
				for (i in 0...3)
				{
					resetValue(curSelected, i);
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.ACCEPT && nextAccept <= 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changingNote = true;
				holdTime = 0;
				for (i in 0...grpNumbers.length)
				{
					var item = grpNumbers.members[i];
					item.alpha = 0;
					if ((curSelected * 3) + typeSelected == i)
					{
						item.alpha = 1;
					}
				}
				for (i in 0...grpNotes.length)
				{
					var item = grpNotes.members[i];
					item.alpha = 0;
					if (curSelected == i)
					{
						item.alpha = 1;
					}
				}
				super.update(elapsed);
				return;
			}
		}

		var lerpVal:Float = boundTo(elapsed * 9.6, 0, 1);
		for (i in 0...grpNotes.length)
		{
			var item = grpNotes.members[i];
			var intendedPos:Float = posX - 70;
			if (curSelected == i)
			{
				item.x = FlxMath.lerp(item.x, intendedPos + 100, lerpVal);
			}
			else
			{
				item.x = FlxMath.lerp(item.x, intendedPos, lerpVal);
			}
			for (j in 0...3)
			{
				var item2 = grpNumbers.members[(i * 3) + j];
				item2.x = item.x + 265 + (225 * (j % 3)) - (30 * item2.lettersArray.length) / 2;
				if (Saves.arrowHSV[i][j] < 0)
				{
					item2.x -= 20;
				}
			}

			if (curSelected == i)
			{
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}

		if (controls.BACK || (changingNote && controls.ACCEPT))
		{
			changeSelection();
			if (!changingNote)
			{
				grpNumbers.forEachAlive(function(spr:Alphabet)
				{
					spr.alpha = 0;
				});
				grpNotes.forEachAlive(function(spr:FlxSprite)
				{
					spr.alpha = 0;
				});
				FlxG.switchState(new MenuOptions());
			}
			changingNote = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if (nextAccept > 0)
		{
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = Saves.arrowHSV.length - 1;
		if (curSelected >= Saves.arrowHSV.length)
			curSelected = 0;

		curValue = Saves.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length)
		{
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i)
			{
				item.alpha = 1;
			}
		}
		for (i in 0...grpNotes.length)
		{
			var item = grpNotes.members[i];
			item.alpha = 0.6;
			item.scale.set(1, 1);
			if (curSelected == i)
			{
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeType(change:Int = 0)
	{
		typeSelected += change;
		if (typeSelected < 0)
			typeSelected = 2;
		if (typeSelected > 2)
			typeSelected = 0;

		curValue = Saves.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length)
		{
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i)
			{
				item.alpha = 1;
			}
		}
	}

	function resetValue(selected:Int, type:Int)
	{
		curValue = 0;
		FlxG.save.data.arrowHSV[selected][type] = 0;
		Saves.arrowHSV[selected][type] = 0;
		shaderArray[selected].update(0, type);
		grpNumbers.members[(selected * 3) + type].changeText('0');
		FlxG.save.flush();
	}

	function updateValue(change:Float = 0)
	{
		curValue += change;
		var roundedValue:Int = Math.round(curValue);
		var max:Float = 180;
		switch (typeSelected)
		{
			case 1 | 2:
				max = 100;
		}

		if (roundedValue < -max)
		{
			curValue = -max;
		}
		else if (roundedValue > max)
		{
			curValue = max;
		}
		roundedValue = Math.round(curValue);

		FlxG.save.data.arrowHSV[curSelected][typeSelected] = roundedValue;
		Saves.arrowHSV[curSelected][typeSelected] = roundedValue;
		shaderArray[curSelected].update(roundedValue, typeSelected);
		grpNumbers.members[(curSelected * 3) + typeSelected].changeText(Std.string(roundedValue));
		FlxG.save.flush();
	}

	public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		var newValue:Float = value;
		if (newValue < min)
			newValue = min;
		else if (newValue > max)
			newValue = max;
		return newValue;
	}
}

class ColorSwap
{
	public var shader(default, null):ColorSwapShader = new ColorSwapShader();

	public function new()
	{
		shader.uTime.value = [0, 0, 0];
		shader.money.value = [0];
		shader.awesomeOutline.value = [false];
	}

	public function update(value:Float, ?type:Int = 0)
	{
		var divide:Float = 360;
		switch (type)
		{
			case 1 | 2:
				divide = 100;
		}
		shader.uTime.value[type] = value / divide;
	}

	public function updateAdd(value:Float, ?type:Int = 0)
	{
		var divide:Float = 360;
		switch (type)
		{
			case 1 | 2:
				divide = 100;
		}
		shader.uTime.value[type] += value / divide;
	}
}

class ColorSwapShader extends FlxShader
{
	@:glFragmentSource('
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		uniform sampler2D bitmap;

		uniform bool hasTransform;
		uniform bool hasColorTransform;

		vec4 flixel_texture2D(sampler2D bitmap, vec2 coord)
		{
			vec4 color = texture2D(bitmap, coord);
			if (!hasTransform)
			{
				return color;
			}

			if (color.a == 0.0)
			{
				return vec4(0.0, 0.0, 0.0, 0.0);
			}

			if (!hasColorTransform)
			{
				return color * openfl_Alphav;
			}

			color = vec4(color.rgb / color.a, color.a);

			mat4 colorMultiplier = mat4(0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = openfl_ColorMultiplierv.w;

			color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);

			if (color.a > 0.0)
			{
				return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
			}
			return vec4(0.0, 0.0, 0.0, 0.0);
		}

		uniform vec3 uTime;
		uniform float money;
		uniform bool awesomeOutline;

		const float offset = 1.0 / 128.0;
		vec3 normalizeColor(vec3 color)
		{
			return vec3(
				color[0] / 255.0,
				color[1] / 255.0,
				color[2] / 255.0
			);
		}

		vec3 rgb2hsv(vec3 c)
		{
			vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
			vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

			float d = q.x - min(q.w, q.y);
			float e = 1.0e-10;
			return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		vec3 hsv2rgb(vec3 c)
		{
			vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
			return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
		}

		void main()
		{
			vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

			vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);

			// [0] is the hue???
			swagColor[0] += uTime[0];
			swagColor[1] += uTime[1];
			if(swagColor[1] < 0.0)
			{
				swagColor[1] = 0.0;
			}
			else if(swagColor[1] > 1.0)
			{
				swagColor[1] = 1.0;
			}
			swagColor[2] *= 1.0 + uTime[2];

			color = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);

			if (awesomeOutline)
			{
				 // Outline bullshit?
				vec2 size = vec2(3, 3);

				if (color.a <= 0.5) {
					float w = size.x / openfl_TextureSize.x;
					float h = size.y / openfl_TextureSize.y;
					
					if (flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y)).a != 0.
					|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y)).a != 0.
					|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + h)).a != 0.
					|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y - h)).a != 0.)
						color = vec4(1.0, 1.0, 1.0, 1.0);
				}
			}
			gl_FragColor = color;

			/* 
			if (color.a > 0.5)
				gl_FragColor = color;
			else
			{
				float a = flixel_texture2D(bitmap, vec2(openfl_TextureCoordv + offset, openfl_TextureCoordv.y)).a +
						  flixel_texture2D(bitmap, vec2(openfl_TextureCoordv, openfl_TextureCoordv.y - offset)).a +
						  flixel_texture2D(bitmap, vec2(openfl_TextureCoordv - offset, openfl_TextureCoordv.y)).a +
						  flixel_texture2D(bitmap, vec2(openfl_TextureCoordv, openfl_TextureCoordv.y + offset)).a;
				if (color.a < 1.0 && a > 0.0)
					gl_FragColor = vec4(0.0, 0.0, 0.0, 0.8);
				else
					gl_FragColor = color;
			} */
		}')
	@:glVertexSource('
		attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;

		attribute float alpha;
		attribute vec4 colorMultiplier;
		attribute vec4 colorOffset;
		uniform bool hasColorTransform;
		
		void main(void)
		{
			openfl_Alphav = openfl_Alpha;
			openfl_TextureCoordv = openfl_TextureCoord;

			if (openfl_HasColorTransform) {
				openfl_ColorMultiplierv = openfl_ColorMultiplier;
				openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
			}

			gl_Position = openfl_Matrix * openfl_Position;

			openfl_Alphav = openfl_Alpha * alpha;
			if (hasColorTransform)
			{
				openfl_ColorOffsetv = colorOffset / 255.0;
				openfl_ColorMultiplierv = colorMultiplier;
			}
		}')
	public function new()
	{
		super();
	}
}
