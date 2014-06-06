package lilsquest.factories;

import com.haxepunk.Tween;
import com.haxepunk.tweens.motion.LinearPath;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Ease.EaseFunction;

class TweenFactory {

	public static function create(xml:Xml, ?nameToTween:Map<String, Tween>):Tween {
		
		var tween:Tween;
		var className = xml.nodeName;
		
		switch (className) {
			case "LinearPath":
				tween = createLinearPath(xml);
			default:
				tween = ObjectFactory.create(className, xml);
		}
		
		if (nameToTween != null && xml.exists("name")) {
			nameToTween[xml.get("name")] = tween;
		}
		
		return tween;
		
	}
	
	private static function createLinearPath(xml:Xml):LinearPath {
		var type:TweenType = xml.exists("type") ? Type.createEnum(TweenType, xml.get("type")) : null;
		var linearPath = new LinearPath(null, type);
		for (pointXml in xml.elementsNamed("Point")) {
			var x = pointXml.exists("x") ? Std.parseFloat(pointXml.get("x")) : 0;
			var y = pointXml.exists("y") ? Std.parseFloat(pointXml.get("y")) : 0;
			linearPath.addPoint(x, y);
		}
		var ease:EaseFunction = xml.exists("ease") ? Reflect.field(Ease, xml.get("ease")) : null;
		if (xml.exists("duration")) {
			var duration = Std.parseFloat(xml.get("duration"));
			linearPath.setMotion(duration, ease);
		}
		if (xml.exists("speed")) {
			var speed = Std.parseFloat(xml.get("speed"));
			linearPath.setMotionSpeed(speed, ease);
		}
		return linearPath;
	}
	
}
