package lilsquest.utils;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class InputUtil {

	public static var left(get, never):Bool;
	
	private static inline function get_left():Bool {
		return Input.check(Key.LEFT);
	}
	
	public static var right(get, never):Bool;
	
	private static inline function get_right():Bool {
		return Input.check(Key.RIGHT);
	}
	
	public static var jump(get, never):Bool;
	
	private static inline function get_jump():Bool {
		return Input.pressed(Key.UP) || Input.pressed(Key.SPACE);
	}
	
	public static var action(get, never):Bool;
	
	private static inline function get_action():Bool {
		return Input.pressed(Key.ENTER) || Input.pressed(Key.DOWN);
	}
	
	public static var cancel(get, never):Bool;
	
	private static inline function get_cancel():Bool {
		return Input.pressed(Key.ESCAPE);
	}
	
}
