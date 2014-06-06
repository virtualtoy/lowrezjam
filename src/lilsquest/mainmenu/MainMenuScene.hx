package lilsquest.mainmenu;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.Lib;
import flash.net.URLRequest;
import lilsquest.factories.SceneFactory;
import lilsquest.game.GameScene;
import lilsquest.ui.Button;
import lilsquest.utils.AssetUtil;
import lilsquest.utils.InputUtil;
import lilsquest.utils.SoundUtil;

class MainMenuScene extends Scene {
	
	private var _background:Backdrop;
	private var _helpPage:Int = -1;
	
	public override function begin():Void {
		var nameToGraphic = new Map<String, Graphic>();
		SceneFactory.setup(AssetUtil.getCachedXml("configs/main_menu.xml"), this, nameToGraphic);
		updateLists();
		_background = cast(nameToGraphic["background"], Backdrop);
		setupButton("sfxButton", onSfxButtonPressed);
		setupButton("twitterButton", onTwitterButtonPressed, Key.T);
		setupButton("playButton", onPlayButtonPressed, Key.SPACE);
		setupButton("helpButton", onHelpButtonPressed, Key.ENTER);
		getInstance("help_page_0").visible = false;
		getInstance("help_page_1").visible = false;
	}
	
	private function setupButton(name:String, onPressedCallback:Void -> Void, hotKey:Int = -1):Void {
		var button = cast(getInstance(name), Button);
		button.onPressedCallback = onPressedCallback;
		button.hotKey = hotKey;
	}
	
	private function onSfxButtonPressed():Void {
		SoundUtil.soundEnabled = !SoundUtil.soundEnabled;
	}
	
	private function onTwitterButtonPressed():Void {
		Lib.getURL(new URLRequest("https://twitter.com/virtualtoy"), "_blank");
	}
	
	private function onPlayButtonPressed():Void {
		if (_helpPage == -1) {
			HXP.scene = new GameScene();
		}
	}
	
	private function onHelpButtonPressed():Void {
		showHelp();
	}
	
	public override function update() {
		_background.x -= HXP.elapsed * 6;
		if (_helpPage != -1 && Input.pressed(Key.ESCAPE)) {
			showHelp();
		}
		super.update();
	}
	
	private function showHelp():Void {
		if (_helpPage == -1) {
			_helpPage = 0;
			getInstance("help_page_0").visible = true;
			getInstance("help_page_1").visible = false;
		}else if (_helpPage == 0) {
			_helpPage = 1;
			getInstance("help_page_0").visible = false;
			getInstance("help_page_1").visible = true;
		}else if (_helpPage == 1) {
			_helpPage = -1;
			getInstance("help_page_0").visible = false;
			getInstance("help_page_1").visible = false;
		}
	}
	
}
