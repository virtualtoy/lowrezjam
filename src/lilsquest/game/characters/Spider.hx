package lilsquest.game.characters;

import com.haxepunk.Entity;
import com.haxepunk.tweens.motion.Motion;
import lilsquest.factories.EntityFactory;
import lilsquest.utils.AssetUtil;

class Spider extends Entity {
	
	private var _motion:Motion;
	
	public function new() {
		super();
		var xml = AssetUtil.getCachedXml("configs/spider.xml");
		EntityFactory.setup(xml, this);
	}
	
	public static function fromXml(xml:Xml):Spider {
		return new Spider();
	}
	
	public override function added():Void {
		_motion = cast(_tween, Motion);
	}
	
	public override function update():Void {
		x = Math.fround(_motion.x);
		y = Math.fround(_motion.y);
	}
	
}
