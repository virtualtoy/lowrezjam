package lilsquest.utils;

import com.haxepunk.Sfx;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import openfl.Assets;

class SoundUtil {
	
	private static var _inited:Bool = false;
	private static var _soundEnabled:Bool = true;
	
	public static var dead(default, null):Sfx;
	public static var impDead(default, null):Sfx;
	public static var jump(default, null):Sfx;
	public static var music(default, null):Sfx;
	public static var pickedUp(default, null):Sfx;
	public static var witchSpell(default, null):Sfx;
	
	public static function init():Void {
		if (!_inited) {
			_inited = true;
			
			dead = new Sfx(Assets.getSound("audio/dead.mp3"));
			impDead = new Sfx(Assets.getSound("audio/imp_dead.mp3"));
			jump = new Sfx(Assets.getSound("audio/jump.mp3"));
			music = new Sfx(Assets.getSound("audio/music.mp3"));
			pickedUp = new Sfx(Assets.getSound("audio/picked_up.mp3"));
			witchSpell = new Sfx(Assets.getSound("audio/witch_spell.mp3"));
			
			music.loop();
		}
	}
	
	public static var soundEnabled(get, set):Bool;
	
	private static function get_soundEnabled():Bool {
		return _soundEnabled;
	}
	
	private static function set_soundEnabled(value:Bool):Bool {
		SoundMixer.soundTransform = new SoundTransform(value ? 1 : 0);
		return _soundEnabled = value;
	}
	
}
