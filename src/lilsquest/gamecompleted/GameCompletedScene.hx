package lilsquest.gamecompleted;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.BitmapText;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import lilsquest.factories.SceneFactory;
import lilsquest.mainmenu.MainMenuScene;
import lilsquest.ui.Button;
import lilsquest.utils.AssetUtil;

class GameCompletedScene extends Scene {
	
	private var _gameTime:Float;
	
	public function new(gameTime:Float) {
		super();
		_gameTime = gameTime;
	}

	public override function begin():Void {
		var nameToGraphic = new Map<String, Graphic>();
		SceneFactory.setup(AssetUtil.getCachedXml("configs/game_completed.xml"), this, nameToGraphic);
		updateLists();
		cast(nameToGraphic["playTimeText"], BitmapText).text = "IN " + (Math.ffloor(_gameTime / 10) * 10) / 1000;
		var button = cast(getInstance("againButton"), Button);
		button.onPressedCallback = onAgainPressedCallback;
		button.hotKey = Key.ENTER;
	}
	
	private function onAgainPressedCallback():Void {
		HXP.scene = new MainMenuScene();
	}
	
}
