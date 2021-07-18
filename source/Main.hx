package;

import OutdatedSubState.PiracyState;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import haxe.Timer;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public var fps:FPSMem;
	public var webmHandle:WebmHandler;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		// if (FlxG.random.bool(50))
		// 	initialState = PiracyState;

		#if html5
		initialState = PiracyState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		var ourSource:String = "assets/videos/dontDelete.webm";

		var str1:String = "WEBM SHIT";
		webmHandle = new WebmHandler();
		webmHandle.source(ourSource);
		webmHandle.makePlayer();
		webmHandle.webm.name = str1;
		addChild(webmHandle.webm);
		GlobalVideo.setWebm(webmHandle);

		#if !mobile
		fps = new FPSMem(10, 3, 0xFFFFFF);
		addChild(fps);
		#end

		fps.visible = false;

		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end

		PlayerSettings.init();

		// DEBUG BULLSHIT

		NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		Saves.init();

		Highscore.load();

		#if desktop
		Discord.DiscordClient.initialize();

		lime.app.Application.current.onExit.add(function(exitCode)
		{
			Discord.DiscordClient.shutdown();
		});
		#end
	}

	public function fpsShow(yeh:Bool)
	{
		fps.visible = yeh;
	}
}

/**

	* FPS class extension to display memory usage.

	* @author Kirill Poletaev

 */
class FPSMem extends TextField
{
	private var times:Array<Float>;

	private var memPeak:Float = 0;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000)
	{
		super();

		x = inX;

		y = inY;

		selectable = false;

		defaultTextFormat = new TextFormat("_sans", 12, inCol);

		text = "FPS: ";

		times = [];

		addEventListener(Event.ENTER_FRAME, onEnter);

		width = 150;

		height = 70;
	}

	private function onEnter(_)
	{
		var now = Timer.stamp();

		times.push(now);

		while (times[0] < now - 1)
			times.shift();

		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;

		if (mem > memPeak)
			memPeak = mem;

		if (visible)
		{
			text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";
		}
	}
}
