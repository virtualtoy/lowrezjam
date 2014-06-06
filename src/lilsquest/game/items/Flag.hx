package lilsquest.game.items;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import lilsquest.factories.EntityFactory;
import lilsquest.utils.AssetUtil;

class Flag extends Entity {

	public function new() {
		super();
		var xml = AssetUtil.getCachedXml("configs/flag.xml");
		EntityFactory.setup(xml, this);
	}
	
	public static function fromXml(xml:Xml):Flag {
		return new Flag();
	}
	
	public function playUp():Void {
		cast(graphic, Spritemap).play("up");
	}
	
	public function playRaise():Void {
		cast(graphic, Spritemap).play("raise");
	}
	
}
