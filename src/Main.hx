import com.haxepunk.debug.Console.TraceCapture;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import lilsquest.mainmenu.MainMenuScene;
import lilsquest.utils.Globals;
import lilsquest.utils.SoundUtil;

class Main extends Engine {
	
	public function new() {
		super(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, 30);
	}

	override public function init():Void {
#if debug
		HXP.console.enable(TraceCapture.No);
#end
		var screenScaleX:Float = Math.ffloor(Lib.current.stage.stageWidth / Globals.ROOM_WIDTH);
		var screenScaleY:Float = Math.ffloor(Lib.current.stage.stageHeight / Globals.ROOM_HEIGHT);
		var screenScale:Float = Math.max(Math.min(screenScaleX, screenScaleY), 1);
		HXP.screen.scale = Math.ffloor(screenScale);
		HXP.screen.smoothing = false;
		HXP.stage.scaleMode = StageScaleMode.SHOW_ALL;
		HXP.stage.align = StageAlign.TOP;
		
		SoundUtil.init();
		
		HXP.scene = new MainMenuScene();
	}
	
	override function update():Void {
		super.update();
		if (Input.pressed(Key.S) || Input.pressed(Key.M)) {
			SoundUtil.soundEnabled = !SoundUtil.soundEnabled;
		}
	}

	public static function main():Void { new Main(); }

}
