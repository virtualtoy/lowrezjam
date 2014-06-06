package lilsquest.game;

import flash.errors.ArgumentError;
import haxe.ds.Vector;
import lilsquest.utils.AssetUtil;
import lilsquest.utils.Globals;
import openfl.Assets;

class GameMap {
	
	private var _roomData:Array<Array<Xml>> = new Array<Array<Xml>>();
	private var _collisionData:Vector<Vector<UInt>>;

	public function new() {
		init();
	}
	
	private function init():Void {
		var xml = AssetUtil.getCachedXml("configs/game_map.xml");
		var root = xml.firstElement();
		var mapWidth = Std.parseInt(root.get("width"));
		var mapHeight = Std.parseInt(root.get("height"));
		for (y in 0...mapHeight) {
			_roomData.push([for (x in 0...mapWidth) null]);
		}
		for (roomXml in root.elementsNamed("Room")) {
			var roomX = Std.parseInt(roomXml.get("x"));
			var roomY = Std.parseInt(roomXml.get("y"));
			_roomData[roomY][roomX] = roomXml;
		}
		var collisionBitmap = Assets.getBitmapData("graphics/game/collision_map.png");
		_collisionData = new Vector<Vector<UInt>>(collisionBitmap.height);
		for (y in 0...collisionBitmap.height) {
			var collisionDataRow = new Vector<UInt>(collisionBitmap.width);
			for (x in 0...collisionBitmap.width) {
				collisionDataRow[x] = collisionBitmap.getPixel(x, y);
			}
			_collisionData[y] = collisionDataRow;
		}
	}
	
	public inline function getRoomData(mapX:Int, mapY:Int):Xml {
		var roomData = _roomData[mapY][mapX];
		if (roomData == null) {
			throw new ArgumentError("No room data at x=" + mapX + ", y=" + mapY);
		}
		return roomData;
	}
	
	public inline function getCollisionData(mapX:Int, mapY:Int, roomX:Int, roomY:Int):UInt {
		return _collisionData[mapY * Globals.ROOM_HEIGHT + roomY][mapX * Globals.ROOM_WIDTH + roomX];
	}
	
}
