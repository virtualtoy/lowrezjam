package lilsquest.utils;

import openfl.Assets;

class AssetUtil {
	
	private static var idToXml:Map<String, Xml> = new Map<String, Xml>();

	public static function getCachedXml(id:String):Xml {
		if (!idToXml.exists(id)) {
			idToXml[id] = Xml.parse(Assets.getText(id));
		}
		return idToXml[id];
	}
	
}