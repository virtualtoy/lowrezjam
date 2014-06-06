package lilsquest.factories;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Scene;
import lilsquest.factories.EntityFactory;
import lilsquest.factories.SceneFactory;

class SceneFactory {

	public static function setup(xml:Xml, scene:Scene, ?nameToGraphic:Map<String, Graphic>, ?entities:Array<Entity>):Void {
		
		if (xml.nodeType == Xml.Document) {
			xml = xml.firstElement();
		}
		
		for (graphicList in xml.elementsNamed("Graphic")) {
			for (graphicXml in graphicList.elements()) {
				var entity:Entity = scene.addGraphic(GraphicFactory.create(graphicXml, nameToGraphic));
				if (entities != null) {
					entities.push(entity);
				}
			}
		}
		
		for (entitiesList in xml.elementsNamed("Entities")) {
			for (entityXml in entitiesList.elements()) {
				var entity:Entity = scene.add(EntityFactory.create(entityXml));
				if (entities != null) {
					entities.push(entity);
				}
			}
		}
		
	}
	
}
