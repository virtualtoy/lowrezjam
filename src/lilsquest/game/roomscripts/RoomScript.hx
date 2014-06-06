package lilsquest.game.roomscripts;

import com.haxepunk.Entity;
import lilsquest.game.GameScene;
import lilsquest.game.items.Flag;
import lilsquest.utils.SoundUtil;

class RoomScript extends Entity {
	
	private var _gameScene:GameScene;
	private var _flag:Flag;
	private var _flagUp:Bool;
	
	public static function fromXml(xml:Xml):RoomScript {
		return new RoomScript();
	}
	
	public override function added():Void {
		_gameScene = cast(scene, GameScene);
	}
	
	public function enteredRoom():Void {
		_flag = _gameScene.classFirst(Flag);
		if (_flag != null) {
			_flagUp = _gameScene.mapX == _gameScene.checkPointMapX && _gameScene.mapY == _gameScene.checkPointMapY;
			if (_flagUp) {
				_flag.playUp();
			}
		}
	}
	
	public function playerAction():Void {
		if (_flag != null && !_flagUp && _gameScene.playerCollidesWith(_flag)) {
			_flagUp = true;
			_flag.playRaise();
			SoundUtil.pickedUp.play();
			_gameScene.setCheckPoint();
		}
	}
	
	private function hideEntity(entity:Entity):Void {
		entity.active =
		entity.collidable =
		entity.visible = false;
	}
	
	private function showEntity(entity:Entity):Void {
		entity.active =
		entity.collidable =
		entity.visible = true;
	}
	
}
