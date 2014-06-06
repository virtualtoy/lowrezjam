package lilsquest.game.sequences;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.BitmapText;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.HXP;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.motion.LinearMotion;
import lilsquest.factories.EntityFactory;
import lilsquest.utils.AssetUtil;
import lilsquest.utils.InputUtil;

class Sequence extends Entity {
	
	public var completed(default, null):Bool = false;
	
	private var _gameScene:GameScene;
	private var _items:Array<SequenceItem> = [];
	private var _currentIndex:Int = 0;
	private var _currentItem:SequenceItem = null;
	private var _speechBubble:Stamp;
	private var _speechBubbleTail:Stamp;
	private var _speechBubbleText:BitmapText;
	private var _completedCallback:Void->Void;
	
	public function new(?completedCallback:Void->Void) {
		super();
		_completedCallback = completedCallback;
		
		var nameToGraphic:Map<String, Graphic> = new Map<String, Graphic>();
		EntityFactory.setup(AssetUtil.getCachedXml("configs/sequence.xml"), this, nameToGraphic);
		
		_speechBubble = cast(nameToGraphic["speechBubble"], Stamp);
		_speechBubbleTail = cast(nameToGraphic["speechBubbleTail"], Stamp);
		_speechBubbleText = cast(nameToGraphic["speechBubbleText"], BitmapText);
	}
	
	public override function added():Void {
		_gameScene = cast(scene, GameScene);
		if (_items.length == 0) {
			if (_completedCallback != null) {
				_completedCallback();
			}
			completed = true;
		}
	}
	
	public override function update():Void {
		if (_currentItem != null) {
			_currentItem.update();
			if (!_currentItem.completed) {
				return;
			}else if (++_currentIndex == _items.length) {
				if (_completedCallback != null) {
					_completedCallback();
				}
				completed = true;
				return;
			}
		}
		_currentItem = _items[_currentIndex];
		_currentItem.start();
	}
	
	public function showSpeechBubble(text:String, entityName:String):Void {
		if (text == null) {
			_speechBubble.visible = 
			_speechBubbleTail.visible = 
			_speechBubbleText.visible = false;
		}else {
			_speechBubble.visible = true;
			if (entityName != null) {
				_speechBubbleTail.visible = true;
				var entity = _gameScene.getInstance(entityName);
				_speechBubbleTail.x = Math.max(1, Math.min(26, Math.fround(entity.centerX - _speechBubbleTail.width / 2)));
			}else {
				_speechBubbleTail.visible = false;
			}
			_speechBubbleText.visible = true;
			_speechBubbleText.text = text;
		}
	}
	
	/**
	 * 
	 * @param	text		if null speech bubble will be hidden and sequence continues
	 * @param	entityName	if null no speech bubble tail will be shown
	 * @return	this Sequence object
	 */
	public function showSpeech(?text:String, ?entityName:String):Sequence {
		_items.push(new SpeechItem(this, text, entityName));
		return this;
	}
	
	public function move(entityName:String, fromX:Float, fromY:Float, toX:Float, toY:Float, duration:Float):Sequence {
		_items.push(new MotionItem(entityName, fromX, fromY, toX, toY, duration));
		return this;
	}
	
	public function setProperty(entityName:String, property:String, value:Dynamic):Sequence {
		_items.push(new SetPropertyItem(entityName, property, value));
		return this;
	}
	
	public function playAnimation(entityName:String, animationName:String):Sequence {
		_items.push(new PlayAnimationItem(entityName, animationName));
		return this;
	}
	
	public function callMethod(method:Void->Void):Sequence {
		_items.push(new CallMethodItem(method));
		return this;
	}
	
	public function pause(duration:Float):Sequence {
		_items.push(new PauseItem(duration));
		return this;
	}
	
}

private class SequenceItem {
	
	public var completed(default, null):Bool = false;
	
	public function start():Void {
		
	}
	
	public function update():Void {
		
	}
	
}

private class SpeechItem extends SequenceItem {
	
	private var _sequence:Sequence;
	private var _text:String;
	private var _entityName:String;
	
	public function new(sequence:Sequence, text:String, entityName:String) {
		_sequence = sequence;
		_text = text;
		_entityName = entityName;
	}
	
	public override function start():Void {
		_sequence.showSpeechBubble(_text, _entityName);
		if (_text == null) {
			completed = true;
		}
	}
	
	public override function update():Void {
		if (InputUtil.cancel || InputUtil.action) {
			completed = true;
		}
	}
	
}

private class MotionItem extends SequenceItem {
	
	private var _entityName:String;
	private var _fromX:Float;
	private var _fromY:Float;
	private var _toX:Float;
	private var _toY:Float;
	private var _duration:Float;
	private var _entity:Entity;
	private var _motion:LinearMotion;
	
	public function new(entityName:String, fromX:Float, fromY:Float, toX:Float, toY:Float, duration:Float) {
		_entityName = entityName;
		_fromX = fromX;
		_fromY = fromY;
		_toX = toX;
		_toY = toY;
		_duration = duration;
	}
	
	public override function start():Void {
		_motion = new LinearMotion(onMotionCompleted, TweenType.OneShot);
		_motion.setMotion(_fromX, _fromY, _toX, _toY, _duration);
		_entity = HXP.scene.getInstance(_entityName);
		_entity.addTween(_motion, true);
	}
	
	private function onMotionCompleted(event:Dynamic):Void {
		completed = true;
	}
	
	public override function update():Void {
		_motion.update();
		_entity.x = Math.fround(_motion.x);
		_entity.y = Math.fround(_motion.y);
	}
	
}

private class SetPropertyItem extends SequenceItem {
	
	private var _entityName:String;
	private var _property:String;
	private var _value:Dynamic;
	
	public function new(entityName:String, property:String, value:Dynamic) {
		_value = value;
		_property = property;
		_entityName = entityName;
	}
	
	public override function update():Void {
		var entity = HXP.scene.getInstance(_entityName);
		Reflect.setProperty(entity, _property, _value);
		completed = true;
	}
	
}

private class PlayAnimationItem extends SequenceItem {
	
	private var _entityName:String;
	private var _animationName:String;
	
	public function new(entityName:String, animationName:String) {
		_entityName = entityName;
		_animationName = animationName;
	}
	
	public override function start():Void {
		var entity = HXP.scene.getInstance(_entityName);
		cast(entity.graphic, Spritemap).play(_animationName);
		completed = true;
	}
	
}

private class CallMethodItem extends SequenceItem {
	
	private var _method:Void->Void;
	
	public function new(method:Void->Void) {
		_method = method;
	}
	
	public override function start():Void {
		_method();
		completed = true;
	}
	
}

private class PauseItem extends SequenceItem {
	
	private var _duration:Float;
	
	public function new(duration:Float) {
		_duration = duration;
	}
	
	public override function start():Void {
		var alarm = new Alarm(_duration, onAlarmCompleted, TweenType.OneShot);
		HXP.scene.addTween(alarm, true);
	}
	
	private function onAlarmCompleted(event:Dynamic):Void {
		completed = true;
	}
	
}
