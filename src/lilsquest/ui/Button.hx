package lilsquest.ui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.Assets;

class Button extends Entity {
	
	private var _normalState:Stamp;
	private var _activeState:Stamp;
	private var _activated:Bool = false;
	
	public var onPressedCallback:Void -> Void;
	public var hotKey:Int = -1;

	public function new(normalState:String, activeState:String, x:Float = 0, y:Float = 0) {
		super(x, y);
		_normalState = new Stamp(Assets.getBitmapData(normalState));
		_activeState = new Stamp(Assets.getBitmapData(activeState));
		addGraphic(_normalState);
		addGraphic(_activeState);
		redraw();
	}
	
	public static function fromXml(xml:Xml):Button {
		var normalState = xml.get("normalState");
		var activeState = xml.get("activeState");
		return new Button(normalState, activeState);
	}
	
	public override function update():Void {
		if (visible) {
			var collides:Bool = collidePoint(x, y, Input.mouseX, Input.mouseY);
			setActivated(collides);
			if (onPressedCallback != null) {
				if ((collides && Input.mouseReleased) || (hotKey != -1 && Input.pressed(hotKey))) {
					onPressedCallback();
				}
			}
		}
	}
	
	private function redraw():Void {
		_normalState.visible = !_activated;
		_activeState.visible = _activated;
		width = _activated ? _activeState.width : _normalState.width;
		height = _activated ? _activeState.height : _normalState.height;
	}
	
	function setActivated(value:Bool):Void {
		if (_activated != value) {
			_activated = value;
			redraw();
		}
	}
	
}
