package lilsquest.factories;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Tween;

class EntityFactory {

	public static function create(xml:Xml):Entity {
		
		if (xml.nodeType == Xml.Document) {
			xml = xml.firstElement();
		}
		
		var className = xml.get("class");
		
		var entity:Entity = className == null ? new Entity() : ObjectFactory.create(className, xml);
		
		EntityFactory.setup(xml, entity);
		
		return entity;
	}
	
	public static function setup(xml:Xml, entity:Entity, ?nameToGraphic:Map<String, Graphic>, ?nameToTween:Map<String, Tween>):Void {
		
		if (xml.nodeType == Xml.Document) {
			xml = xml.firstElement();
		}
		
		if (xml.exists("x")) {
			entity.x = Std.parseFloat(xml.get("x"));
		}
		if (xml.exists("y")) {
			entity.y = Std.parseFloat(xml.get("y"));
		}
		if (xml.exists("width")) {
			entity.width = Std.parseInt(xml.get("width"));
		}
		if (xml.exists("height")) {
			entity.height = Std.parseInt(xml.get("height"));
		}
		if (xml.exists("visible")) {
			entity.visible = xml.get("visible") == "true";
		}
		if (xml.exists("layer")) {
			entity.layer = Std.parseInt(xml.get("layer"));
		}
		if (xml.exists("type")) {
			entity.type = xml.get("type");
		}
		if (xml.exists("name")) {
			entity.name = xml.get("name");
		}
		
		for (graphicList in xml.elementsNamed("Graphic")) {
			for (graphicXml in graphicList.elements()) {
				entity.addGraphic(GraphicFactory.create(graphicXml, nameToGraphic));
			}
		}
		
		for (tweenList in xml.elementsNamed("Tweens")) {
			for (tweenXml in tweenList.elements()) {
				entity.addTween(TweenFactory.create(tweenXml, nameToTween));
			}
		}
		
	}
	
}
