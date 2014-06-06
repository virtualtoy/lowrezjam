package lilsquest.game.roomscripts;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.VarTween;
import flash.display.BitmapData;
import lilsquest.game.sequences.Sequence;
import lilsquest.gamecompleted.GameCompletedScene;
import lilsquest.utils.SoundUtil;

class RoomScript_0_4 extends RoomScript {
	
	private var _boyHitArea:Entity;
	private var _jailDoorHitArea:Entity;
	private var _jailDoor:Entity;
	private var _gameCompletedTime:Float;
	private var _overlayTween:VarTween;
	
	public static function fromXml(xml:Xml):RoomScript_0_4 {
		return new RoomScript_0_4();
	}
	
	public override function enteredRoom():Void {
		super.enteredRoom();
		_boyHitArea = _gameScene.getInstance("boyHitArea");
		_jailDoorHitArea = _gameScene.getInstance("jailDoorHitArea");
		_jailDoor = _gameScene.getInstance("jailDoor");
	}
	
	public override function update():Void {
		if (_overlayTween != null) {
			_overlayTween.update();
		}
		
		if (!_gameScene.talkedToBoyInJail && _gameScene.playerCollidesWith(_boyHitArea)) {
			_gameScene.talkedToBoyInJail = true;
			_gameScene.startSequence(new Sequence().showSpeech("HEY, LIL!\nIT'S ME,\nTIM!", "boy")
													.showSpeech("WHAT'S\nHAP-\nPENED?", "player")
													.showSpeech("EVIL IMP\nPUT ME\nHERE!", "boy")
													.showSpeech("PLEASE\nHELP\nME!", "boy"));
		}
	}
	
	public override function playerAction():Void {
		if (_gameScene.playerCollidesWith(_jailDoorHitArea)) {
			if (_gameScene.pickedUpKey) {
				hideEntity(_jailDoor);
				_gameCompletedTime = Date.now().getTime();
				_gameScene.startSequence(new Sequence(onSequenceCompleted)
												.showSpeech("THANK\nYOU, LIL!", "boy")
												.showSpeech("YOU\nSAVED\nME!", "boy")
												.showSpeech("HA-HA!\nI'M NOT\nLIL!", "player")
												.showSpeech("I'M HER\nEVIL\nTWIN!", "player")
												.showSpeech("NOW YOU\nCOME\nWITH ME", "player")
												.showSpeech()
												.setProperty("witch", "visible", true)
												.playAnimation("witch", "walk")
												.move("witch", 32, 21, 22, 21, 4)
												.playAnimation("witch", "idle")
												.playAnimation("player", "idle_right")
												.showSpeech("NOT SO\nFAST!", "witch")
												.showSpeech("ABRA\nKADABRA\nKABOOM!", "witch")
												.showSpeech()
												.setProperty("player", "visible", false)
												.setProperty("cake", "visible", true)
												.callMethod(playWitchSpellSfx)
												.showSpeech("YOU'VE\nTURNED\nHER...", "boy")
												.showSpeech("INTO\nA CAKE?!!", "boy")
												.showSpeech("WHY\nNOT?", "witch")
												.showSpeech()
												.setProperty("twin", "visible", true)
												.move("twin", 32, 22, 15, 22, 4)
												.playAnimation("twin", "idle")
												.showSpeech("THERE\nYOU ARE!", "twin")
												.showSpeech("LITTLE\nBRAT!", "twin")
												.showSpeech("NO\nDESSERT\nTILL", "twin")
												.showSpeech("FRIDAY!!!", "twin")
												.showSpeech("NOW YOU\nCOME\nWITH ME", "twin")
												.showSpeech("AND WHO\nIS EVIL\nTWIN", "boy")
												.showSpeech("AFTER\nALL?..", "boy")
												.showSpeech("WHAT???", "twin")
												.callMethod(showOverlay)
												.pause(3)
												);
			}else {
				_gameScene.startSequence(new Sequence().showSpeech("HELP!", "boy"));
			}
		}else {
			super.playerAction();
		}
	}
	
	private function showOverlay():Void {
		var image = new Image(new BitmapData(32, 32, true, 0xFF000000));
		image.alpha = 0;
		_gameScene.addGraphic(image).layer = -1000;
		
		_overlayTween = new VarTween(null, TweenType.OneShot);
		_overlayTween.tween(image, "alpha", 1, 2.5);
		_overlayTween.start();
	}
	
	private function playWitchSpellSfx():Void {
		SoundUtil.witchSpell.play();
	}
	
	private function onSequenceCompleted():Void {
		HXP.scene = new GameCompletedScene(_gameCompletedTime - _gameScene.gameStartedTime);
	}
	
}
