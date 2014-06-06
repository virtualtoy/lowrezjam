package lilsquest.preloader;

#if doc

#elseif js

// html5 doesn't support drawTiles
class Preloader extends NMEPreloader { }

#else

import flash.display.Bitmap;
import flash.display.BitmapData;

@:bitmap("assets/graphics/preloader.png")
class Background extends BitmapData { }

class Preloader extends NMEPreloader {

	public function new() {
		
		super();
		
		outline.visible = false;
		
		var progressWidth = getWidth() * 0.8;
		
		progress.x = getWidth() / 2;
		progress.y = Math.fround(getHeight() * 0.66);
		
		progress.graphics.clear();
		progress.graphics.beginFill(0xCB6325);
		progress.graphics.drawRect( -width / 2, 0, width, Math.fround(getHeight() / 32));
		progress.graphics.endFill();
		
		var background = new Bitmap(new Background(0, 0));
		background.width = getWidth();
		background.height = getHeight();
		addChildAt(background, 0);
	}

}

#end
