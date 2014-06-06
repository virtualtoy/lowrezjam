package lilsquest.game.roomscripts;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import lilsquest.game.sequences.Sequence;

class RoomScript_4_1 extends RoomScript {
	
	private var _knight:Entity;
	
	public static function fromXml(xml:Xml):RoomScript_4_1 {
		return new RoomScript_4_1();
	}
	
	public override function enteredRoom():Void {
		super.enteredRoom();
		_knight = _gameScene.getInstance("knight");
		if (_gameScene.givenShrubberyToKnight) {
			cast(_knight.graphic, Spritemap).play("handDown");
		}
	}
	
	public override function update():Void {
		if (_gameScene.playerCollidesWith(_knight) && !_gameScene.givenShrubberyToKnight) {
			if (_gameScene.pickedUpShrubbery && !_gameScene.givenShrubberyToKnight) {
				_gameScene.givenShrubberyToKnight = true;
				cast(_knight.graphic, Spritemap).play("handDown");
				_gameScene.startSequence(new Sequence().showSpeech("GOOD!\nIT'S A\nNICE", "knight")
														.showSpeech("SHRUB-\nBERY.\n", "knight")
														.showSpeech("YOU MAY\nPASS\nNOW.", "knight"));
			}else {
				_gameScene.player.x = _knight.x - 4;
				if (!_gameScene.talkedToKnight) {
					_gameScene.talkedToKnight = true;
					_gameScene.startSequence(new Sequence().showSpeech("HEY! WE\nARE THE\nKNIGHTS", "knight")
															.showSpeech("WHO SAY\nNI!", "knight")
															.showSpeech("BRING US\nA...\n", "knight")
															.showSpeech("SHRUB-\nBERY!", "knight"));
				}else {
					_gameScene.startSequence(new Sequence().showSpeech("BRING US\nSHRUB-\nBERY!", "knight"));
				}
			}
		}
	}
	
	public override function playerAction():Void {
		if (_gameScene.playerCollidesWith(_knight) && _gameScene.givenShrubberyToKnight) {
			_gameScene.startSequence(new Sequence().showSpeech("DO YOU\nHAVE...\n", "knight")
													.showSpeech("ANOTHER\nSHRUB-\nBERY?", "knight"));
		}else {
			super.playerAction();
		}
	}
	
}
