package lilsquest.factories;

import flash.errors.ReferenceError;
import flash.errors.TypeError;

class ObjectFactory {

	public static function create(className:String, xml:Xml):Dynamic {
		var type = Type.resolveClass(className);
		if (type == null) {
			throw new TypeError("Type not found: " + className);
		}
		var factoryMethod = Reflect.field(type, "fromXml");
		if (factoryMethod == null) {
			throw new ReferenceError("No static method fromXml() found in type: " + className);
		}
		return Reflect.callMethod(type, factoryMethod, [xml]);
	}
	
}
