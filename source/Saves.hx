package;

import flixel.FlxG;
import lime.app.Application;

class Saves
{
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];

	public static function init()
	{
		if (FlxG.save.data.downScroll == null)
			FlxG.save.data.downScroll = false;
		if (FlxG.save.data.antiSpam == null)
			FlxG.save.data.antiSpam = true;
		if (FlxG.save.data.fullScreen == null)
			FlxG.save.data.fullScreen = false;
		if (FlxG.save.data.keyInputs == null)
			FlxG.save.data.keyInputs = false;
		if (FlxG.save.data.arrowHSV == null)
			FlxG.save.data.arrowHSV = [
				[Std.int(0), Std.int(0), Std.int(0)],
				[Std.int(0), Std.int(0), Std.int(0)],
				[Std.int(0), Std.int(0), Std.int(0)],
				[Std.int(0), Std.int(0), Std.int(0)]
			];

		arrowHSV = FlxG.save.data.arrowHSV;
	}
}
