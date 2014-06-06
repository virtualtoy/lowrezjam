package lilsquest.game.roomscripts;

import com.haxepunk.Entity;
import lilsquest.game.sequences.Sequence;
import lilsquest.utils.SoundUtil;

class RoomScript_3_1 extends RoomScript {
	
	private var _cat:Entity;
	
	public static function fromXml(xml:Xml):RoomScript_3_1 {
		return new RoomScript_3_1();
	}
	
	public override function enteredRoom():Void {
		super.enteredRoom();
		_cat = _gameScene.getInstance("cat");
		if (_gameScene.pickedUpCat) {
			hideEntity(_cat);
		}
	}
	
	public override function playerAction():Void {
		if (_gameScene.playerCollidesWith(_cat)) {
			hideEntity(_cat);
			_gameScene.pickedUpCat = true;
			SoundUtil.pickedUp.play();
			_gameScene.startSequence(new Sequence().showSpeech("YOU'VE\nGOT A\nCAT!"));
		}else {
			super.playerAction();
		}
	}
	
}
