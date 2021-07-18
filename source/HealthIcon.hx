package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'madeline', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('madeline', [0, 1], 0, false, isPlayer);
		animation.add('badeline', [2, 3], 0, false, isPlayer);
		animation.add('sus', [4, 5], 0, false, isPlayer);
		if (animation.getByName(char) != null)
			animation.play(char);
		else
			animation.play('sus');
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
