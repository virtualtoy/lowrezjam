package lilsquest.game;

import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import lilsquest.factories.SceneFactory;
import lilsquest.game.characters.Player;
import lilsquest.game.items.Fireball;
import lilsquest.game.roomscripts.RoomScript;
import lilsquest.game.sequences.Sequence;
import lilsquest.utils.AssetUtil;
import lilsquest.utils.Globals;

class GameScene extends Scene {
	
	public var pickedUpShrubbery:Bool = false;
	public var pickedUpPotion:Bool = false;
	public var pickedUpCat:Bool = false;
	public var pickedUpKey:Bool = false;
	public var givenCatToWitch:Bool = false;
	public var givenShrubberyToKnight:Bool = false;
	public var talkedToBoyInJail:Bool = false;
	public var talkedToKnight:Bool = false;
	public var talkedToWitch:Bool = false;
	public var talkedToImp:Bool = false;
	public var impKilled:Bool = false;
	public var gameStartedTime:Float;
	
	public var checkPointMapX:Int;
	public var checkPointMapY:Int;
	public var checkPointRoomX:Int;
	public var checkPointRoomY:Int;
	
	public var mapX(default, null):Int = -1;
	public var mapY(default, null):Int = -1;
	public var player(default, null):Player = new Player();
	
	private var _map:GameMap = new GameMap();
	private var _roomEntities:Array<Entity> = [];
	private var _roomScript:RoomScript = null;
	private var _sequence:Sequence = null;
	
	public override function begin():Void {
		
		gameStartedTime = Date.now().getTime();
		
		player.x = Globals.PLAYER_START_ROOM_X;
		player.y = Globals.PLAYER_START_ROOM_Y;
		add(player);
		updateLists();
		
		checkPointMapX = Globals.PLAYER_START_MAP_X;
		checkPointMapY = Globals.PLAYER_START_MAP_Y;
		checkPointRoomX = Globals.PLAYER_START_ROOM_X;
		checkPointRoomY = Globals.PLAYER_START_ROOM_Y;
		
		enterRoom(Globals.PLAYER_START_MAP_X, Globals.PLAYER_START_MAP_Y);
	}
	
	private function enterRoom(x:Int, y:Int):Void {
		if (_roomEntities.length > 0) {
			removeList(_roomEntities);
			_roomEntities = [];
		}
		
		mapX = x;
		mapY = y;
		
		var xml = _map.getRoomData(mapX, mapY);
		SceneFactory.setup(xml, this, _roomEntities);
		updateLists();
		
		_roomScript = classFirst(RoomScript);
		if (_roomScript != null) {
			_roomScript.enteredRoom();
		}
	}
	
	private function moveRoom(dx:Int, dy:Int):Void {
		enterRoom(mapX + dx, mapY + dy);
	}
	
	public inline function checkCollision(roomX:Int, roomY:Int):Bool {
		return _map.getCollisionData(mapX, mapY, roomX, roomY) != 0xFFFFFF;
	}
	
	public inline function playerCollidesWith(entity:Entity):Bool {
		return player.collideWith(entity, player.x, player.y) != null;
	}
	
	public function startSequence(sequence:Sequence):Void {
		if (_sequence == null) {
			player.disableInput();
			_sequence = add(sequence);
		}
	}
	
	public function addFireball(x:Float, y:Float, dx:Float, dy:Float):Void {
		var fireball = add(new Fireball(x, y, dx, dy));
		_roomEntities.push(fireball);
	}
	
	public function removeFireballs():Void {
		var fireballs:Array<Fireball> = [];
		getClass(Fireball, fireballs);
		removeList(fireballs);
		for (i in fireballs) {
			_roomEntities.remove(i);
		}
	}
	
	public function setCheckPoint():Void {
		checkPointMapX = mapX;
		checkPointMapY = mapY;
		checkPointRoomX = Math.round(player.x);
		checkPointRoomY = Math.round(player.y);
	}
	
	public function playerAction():Void {
		if (_sequence == null && _roomScript != null) {
			_roomScript.playerAction();
		}
	}
	
	public function playerDied():Void {
		var tween = new Alarm(1.5, onPlayerDiedTweenCompleted, TweenType.OneShot);
		addTween(tween, true);
	}
	
	private function onPlayerDiedTweenCompleted(event:Dynamic):Void {
		player.x = checkPointRoomX;
		player.y = checkPointRoomY;
		enterRoom(checkPointMapX, checkPointMapY);
		player.revive();
	}
	
	public override function update() {
		if (player.bottom < 0) {
			player.y = Globals.ROOM_HEIGHT - player.height - 1;
			moveRoom(0, -1);
		}else if (player.top > Globals.ROOM_HEIGHT) {
			player.y = 0;
			moveRoom(0, 1);
		}else if (player.left < 0) {
			player.x = Globals.ROOM_WIDTH - player.width;
			moveRoom(-1, 0);
		}else if (player.right > Globals.ROOM_WIDTH) {
			player.x = 0;
			moveRoom(1, 0);
		}else {
			super.update();
			if (_sequence != null && _sequence.completed) {
				remove(_sequence);
				_sequence = null;
				player.enableInput();
			}
		}
	}
	
}
