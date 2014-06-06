package lilsquest.game.items;

import com.haxepunk.Entity;
import lilsquest.factories.EntityFactory;
import lilsquest.utils.AssetUtil;
import lilsquest.utils.Globals;

class Fireball extends Entity {
	
	private var _dx:Float;
	private var _dy:Float;

	public function new(x:Float, y:Float, dx:Float, dy:Float) {
		super(x, y);
		_dy = dy;
		_dx = dx;
		var xml = AssetUtil.getCachedXml("configs/fireball.xml");
		EntityFactory.setup(xml, this);
	}
	
	public override function update():Void {
		var newX = x + _dx;
		var newY = y + _dy;
		if (newX < 0 || newX > Globals.ROOM_WIDTH - width) {
			_dx = -_dx;
		}else {
			x = newX;
		}
		if (newY < 0 || newY > Globals.ROOM_HEIGHT - height) {
			_dy = -_dy;
		}else {
			y = newY;
		}
	}
	
}
