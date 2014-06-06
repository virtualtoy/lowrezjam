package lilsquest.game.roomscripts;

import com.haxepunk.Entity;
import lilsquest.game.sequences.Sequence;
import lilsquest.utils.SoundUtil;

class RoomScript_4_4 extends RoomScript {
	
	private var _shrubbery:Entity;
	
	public static function fromXml(xml:Xml):RoomScript_4_4 {
		return new RoomScript_4_4();
	}
	
	public override function enteredRoom():Void {
		super.enteredRoom();
		_shrubbery = _gameScene.getInstance("shrubbery");
		if (_gameScene.pickedUpShrubbery) {
			hideEntity(_shrubbery);
		}
	}
	
	public override function playerAction():Void {
		if (_gameScene.playerCollidesWith(_shrubbery)) {
			hideEntity(_shrubbery);
			_gameScene.pickedUpShrubbery = true;
			SoundUtil.pickedUp.play();
			_gameScene.startSequence(new Sequence().showSpeech("YOU'VE\nGOT A\nSHRUB!"));
		}else {
			super.playerAction();
		}
	}
	
}
