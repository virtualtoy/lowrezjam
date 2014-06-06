package lilsquest.game.characters;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tweens.motion.Motion;
import lilsquest.factories.EntityFactory;
import lilsquest.utils.AssetUtil;

class Ghost extends Entity {
	
	private var _motion:Motion;
	private var _prevX:Float = Math.NaN;
	
	public function new() {
		super();
		var xml = AssetUtil.getCachedXml("configs/ghost.xml");
		EntityFactory.setup(xml, this);
	}
	
	public static function fromXml(xml:Xml):Ghost {
		return new Ghost();
	}
	
	public override function added():Void {
		_motion = cast(_tween, Motion);
	}
	
	public override function update():Void {
		x = Math.fround(_motion.x);
		y = Math.fround(_motion.y);
		if (_prevX < x) {
			cast(graphic, Spritemap).play("right");
		}else if (_prevX > x) {
			cast(graphic, Spritemap).play("left");
		}
		_prevX = x;
	}
	
}
