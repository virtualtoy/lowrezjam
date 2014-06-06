package lilsquest.game.roomscripts;

import com.haxepunk.Entity;
import lilsquest.game.roomscripts.RoomScript_3_3;
import lilsquest.game.sequences.Sequence;
import lilsquest.utils.SoundUtil;

class RoomScript_3_3 extends RoomScript {
	
	private var _witch:Entity;
	private var _cat:Entity;
	private var _potion:Entity;
	
	public static function fromXml(xml:Xml):RoomScript_3_3 {
		return new RoomScript_3_3();
	}
	
	public override function enteredRoom():Void {
		super.enteredRoom();
		_witch = _gameScene.getInstance("witch");
		_cat = _gameScene.getInstance("cat");
		_potion = _gameScene.getInstance("potion");
		if (!_gameScene.givenCatToWitch) {
			hideEntity(_cat);
		}
		if (!_gameScene.givenCatToWitch || _gameScene.pickedUpPotion) {
			hideEntity(_potion);
		}
	}
	
	public override function playerAction():Void {
		if (_gameScene.playerCollidesWith(_potion)) {
			_gameScene.pickedUpPotion = true;
			hideEntity(_potion);
			SoundUtil.pickedUp.play();
			_gameScene.startSequence(new Sequence().showSpeech("YOU'VE\nGOT A\nPOTION!"));
		}else if (_gameScene.playerCollidesWith(_witch)) {
			if (_gameScene.givenCatToWitch) {
				_gameScene.startSequence(new Sequence().showSpeech("HOW\nIS IT\nGOING?", "witch"));
			}else if (_gameScene.pickedUpCat && !_gameScene.givenCatToWitch) {
				_gameScene.givenCatToWitch = true;
				_gameScene.talkedToWitch = true;
				showEntity(_cat);
				showEntity(_potion);
				_gameScene.startSequence(new Sequence().showSpeech("YOU\nFOUND\nMY CAT!", "witch").showSpeech("THANK\nYOU!", "witch").showSpeech("TAKE\nTHIS\nPOTION!", "witch"));
			}else if (!_gameScene.talkedToWitch) {
				_gameScene.talkedToWitch = true;
				_gameScene.startSequence(new Sequence().showSpeech("HI! I'M A\nWITCH!", "witch").showSpeech("DID YOU\nSEE MY\nCAT?", "witch"));
			}else if (!_gameScene.pickedUpCat) {
				_gameScene.startSequence(new Sequence().showSpeech("PLEASE\nFIND MY\nCAT!", "witch"));
			}
		}else {
			super.playerAction();
		}
	}
	
}
