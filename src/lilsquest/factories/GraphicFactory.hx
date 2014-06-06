package lilsquest.factories;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.BitmapText;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.graphics.Text;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextFormatAlign;
import openfl.Assets;

class GraphicFactory {

	public static function create(xml:Xml, ?nameToGraphic:Map<String, Graphic>):Graphic {
		
		var graphic:Graphic;
		var className = xml.nodeName;
		
		switch (className) {
			case "Spritemap":
				graphic = createSpritemap(xml);
			case "Stamp":
				graphic = createStamp(xml);
			case "Image":
				graphic = createImage(xml);
			case "Backdrop":
				graphic = createBackdrop(xml);
			case "Text":
				graphic = createText(xml);
			case "BitmapText":
				graphic = createBitmapText(xml);
			default:
				graphic = ObjectFactory.create(className, xml);
		}
		
		setAttributes(xml, graphic);
		
		if (nameToGraphic != null && xml.exists("name")) {
			nameToGraphic[xml.get("name")] = graphic;
		}
		
		return graphic;
		
	}
	
	private static function createBitmapText(xml:Xml):BitmapText {
		var text:String = xml.exists("text") ? xml.get("text") : "";
		var width:Int = xml.exists("width") ? Std.parseInt(xml.get("width")) : 0;
		var height:Int = xml.exists("height") ? Std.parseInt(xml.get("height")) : 0;
		return new BitmapText(text, 0, 0, width, height, parseTextOptions(xml));
	}
	
	private static function createText(xml:Xml):Text {
		var text:String = xml.exists("text") ? xml.get("text") : "";
		var width:Int = xml.exists("width") ? Std.parseInt(xml.get("width")) : 0;
		var height:Int = xml.exists("height") ? Std.parseInt(xml.get("height")) : 0;
		return new Text(text, 0, 0, width, height, parseTextOptions(xml));
	}
	
	private static function createBackdrop(xml:Xml):Backdrop {
		var repeatX:Bool = xml.exists("repeatX") ? xml.get("repeatX") == "true" : true;
		var repeatY:Bool = xml.exists("repeatY") ? xml.get("repeatY") == "true" : true;
		return new Backdrop(parseAsset(xml.get("source")), repeatX, repeatY);
	}
	
	private static function createImage(xml:Xml):Image {
		var clipRect:Rectangle = xml.exists("clipRect") ? parseRectangle(xml.get("clipRect")) : null;
		return new Image(parseAsset(xml.get("source")), clipRect);
	}
	
	private static function createStamp(xml:Xml):Stamp {
		return new Stamp(parseAsset(xml.get("source")));
	}
	
	private static function createSpritemap(xml:Xml):Spritemap {
		
		var frameWidth = Std.parseInt(xml.get("frameWidth"));
		var frameHeight = Std.parseInt(xml.get("frameHeight"));
		var spritemap = new Spritemap(parseAsset(xml.get("source")), frameWidth, frameHeight);
		
		for (animXml in xml.elementsNamed("Animation")) {
			var framesString:Array<String> = animXml.get("frames").split(",");
			var framesInt:Array<Int> = framesString.map(Std.parseInt);
			var frameRate:Float = animXml.exists("frameRate") ? Std.parseFloat(animXml.get("frameRate")) : 0;
			var loop:Bool = animXml.exists("loop") ? animXml.get("loop") == "true" : true;
			spritemap.add(animXml.get("name"), framesInt, frameRate, loop);
		}
		
		if (xml.exists("play")) {
			spritemap.play(xml.get("play"));
		}
		return spritemap;
		
	}
	
	private static inline function parseTextOptions(xml:Xml):TextOptions {
		var options:TextOptions = { };
		
		if (xml.exists("font")) 		{ options.font = xml.get("font"); }
		if (xml.exists("size")) 		{ options.size = Std.parseInt(xml.get("size")); }
		if (xml.exists("wordWrap")) 	{ options.wordWrap = xml.get("repeatX") == "true"; }
		if (xml.exists("resizable")) 	{ options.resizable = xml.get("resizable") == "true"; }
		if (xml.exists("color")) 		{ options.color = Std.parseInt(xml.get("color")); }
		
#if (flash || js)
		if (xml.exists("align"))		{
			switch (xml.get("align")) {
				case "center":
					options.align = TextFormatAlign.CENTER;
				case "justify":
					options.align = TextFormatAlign.JUSTIFY;
				case "left":
					options.align = TextFormatAlign.LEFT;
				case "right":
					options.align = TextFormatAlign.RIGHT;
			}
		}
#else
		if (xml.exists("align"))		{ options.align = xml.get("align"); }
#end
		return options;
	}
	
	private static inline function parseAsset(id:String):Dynamic {
		return Assets.getBitmapData(id);
	}
	
	private static inline function parseRectangle(source:String):Rectangle {
		var values:Array<String> = source.split(",");
		return new Rectangle(Std.parseFloat(values[0]), Std.parseFloat(values[1]), Std.parseFloat(values[2]), Std.parseFloat(values[3]));
	}
	
	private static function setAttributes(xml:Xml, graphic:Graphic):Void {
		if (xml.exists("x")) {
			graphic.x = Std.parseFloat(xml.get("x"));
		}
		if (xml.exists("y")) {
			graphic.y = Std.parseFloat(xml.get("y"));
		}
		if (xml.exists("visible")) {
			graphic.visible = xml.get("visible") == "true";
		}
	}
	
}
