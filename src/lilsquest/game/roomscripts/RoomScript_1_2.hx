package lilsquest.game.roomscripts;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import lilsquest.game.items.Fireball;
import lilsquest.game.sequences.Sequence;
import lilsquest.utils.SoundUtil;

class RoomScript_1_2 extends RoomScript {
	
	private var _impHitArea:Entity;
	private var _imp:Entity;
	private var _key:Entity;
	
	public static function fromXml(xml:Xml):RoomScript_1_2 {
		return new RoomScript_1_2();
	}
	
	public override function enteredRoom():Void {
		super.enteredRoom();
		_impHitArea = _gameScene.getInstance("impHitArea");
		_imp = _gameScene.getInstance("imp");
		if (_gameScene.impKilled) {
			hideEntity(_imp);
		}
		_key = _gameScene.getInstance("key");
		if (!_gameScene.impKilled || _gameScene.pickedUpKey) {
			hideEntity(_key);
		}
		if (!_gameScene.impKilled && _gameScene.talkedToImp) {
			addFireballs();
		}
	}
	
	public override function update():Void {
		if (_gameScene.playerCollidesWith(_impHitArea)) {
			if (!_gameScene.talkedToImp) {
				_gameScene.talkedToImp = true;
				_gameScene.startSequence(new Sequence(addFireballs).showSpeech("HEY YOU!\nPREPARE\nTO DIE!", "imp"));
			}
		}
		if (_gameScene.playerCollidesWith(_imp)) {
			if (_gameScene.pickedUpPotion) {
				_gameScene.impKilled = true;
				_imp.collidable = false;
				cast(_imp.graphic, Spritemap).play("die");
				SoundUtil.impDead.play();
				_gameScene.removeFireballs();
				showEntity(_key);
				_gameScene.startSequence(new Sequence().showSpeech("YOU'VE\nTHROWN\nPOTION").showSpeech("AT IMP\nAND HE\nDIED!"));
			}else {
				_gameScene.player.kill();
				_imp.collidable = false;
			}
		}
	}
	
	private function addFireballs():Void {
		_gameScene.addFireball(_imp.x + 4, _imp.y + 4, 1, 1);
		_gameScene.addFireball(_imp.x + 4, _imp.y, -1, -1);
	}
	
	public override function playerAction():Void {
		if (_gameScene.playerCollidesWith(_key)) {
			_gameScene.pickedUpKey = true;
			hideEntity(_key);
			SoundUtil.pickedUp.play();
			_gameScene.startSequence(new Sequence().showSpeech("YOU'VE\nGOT A\nKEY!"));
		}else {
			super.playerAction();
		}
	}
	
}
