package lilsquest.game.characters;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import lilsquest.factories.EntityFactory;
import lilsquest.utils.AssetUtil;
import lilsquest.utils.Globals;
import lilsquest.utils.InputUtil;
import lilsquest.utils.SoundUtil;

class Player extends Entity {
	
	public var onGround(default, null):Bool = false;
	public var dead(default, null):Bool = false;
	
	private var _collisions:Array<Entity> = [];
	
	private var _gameScene:GameScene;
	private var _spritemap:Spritemap;
	private var _vx:Float = 0;
	private var _vy:Float = 0;
	private var _inputEnabled:Bool = true;
	
	public function new() {
		super();
		var xml = AssetUtil.getCachedXml("configs/player.xml");
		EntityFactory.setup(xml, this);
		_spritemap = cast(graphic, Spritemap);
	}
	
	public override function added():Void {
		_gameScene = cast(scene, GameScene);
	}
	
	public override function update():Void {
		if (dead) {
			return;
		}
		if (_inputEnabled) {
			if (InputUtil.left) {
				_spritemap.play("walk_left");
				_vx = -1;
			}else if (InputUtil.right) {
				_spritemap.play("walk_right");
				_vx = 1;
			}else {
				if (_vx < 0) {
					_spritemap.play("idle_left");
				}else if (_vx > 0) {
					_spritemap.play("idle_right");
				}
				_vx = 0;
			}
			if (InputUtil.jump && onGround) {
				SoundUtil.jump.play();
				_vy = -Globals.PLAYER_JUMP_STRENGTH;
				onGround = false;
			}
			if (InputUtil.action && !dead && onGround) {
				_gameScene.playerAction();
			}
		}
		
		if ((_vx > 0 && checkStep(right, right + _vx, top, bottom)) ||
			(_vx < 0 && checkStep(left + _vx, left, top, bottom))) {
			
			x += _vx;
		}
		_vy += Globals.GRAVITY;
		if (_vy > 0) {
			if (_vy > 2.5) {
				_vy = 2.5;
			}
			var fallPosition = checkFall(left, right, bottom, bottom + Math.fceil(_vy));
			if (Math.isNaN(fallPosition)) {
				y += Math.fceil(_vy);
				onGround = false;
			}else {
				y = fallPosition - height;
				onGround = true;
				_vy = 0;
			}
		}else if (_vy < 0) {
			var jumpPosition = checkJump(left, right, top + Math.ffloor(_vy), top);
			if (Math.isNaN(jumpPosition)) {
				y += Math.ffloor(_vy);
			}else {
				y = jumpPosition;
				_vy = 0;
			}
		}
		
		_collisions = [];
		collideInto("enemy", x, y, _collisions);
		if (_collisions.length != 0) {
			kill();
		}
	}
	
	public function kill():Void {
		SoundUtil.dead.play();
		_gameScene.playerDied();
		if (_vx < 0) {
			_spritemap.play("die_left");
		}else {
			_spritemap.play("die_right");
		}
		dead = true;
	}
	
	public function disableInput():Void {
		_inputEnabled = false;
		if (_vx < 0) {
			_spritemap.play("idle_left");
		}else if (_vx > 0) {
			_spritemap.play("idle_right");
		}
		_vx = 0;
		_vy = 0;
	}
	
	public function enableInput():Void {
		_inputEnabled = true;
	}
	
	public function revive():Void {
		_vx = 0;
		_vy = 0;
		dead = false;
		_spritemap.play("idle_right");
	}
	
	private function checkStep(left:Float, right:Float, top:Float, bottom:Float):Bool {
		for (iy in Math.floor(top)...Math.floor(bottom)) {
			for (ix in Math.floor(left)...Math.floor(right)) {
				if (_gameScene.checkCollision(ix, iy)) {
					return false;
				}
			}
		}
		return true;
	}
	
	private function checkFall(left:Float, right:Float, top:Float, bottom:Float):Float {
		for (iy in Math.floor(top)...Math.floor(bottom)) {
			for (ix in Math.floor(left)...Math.floor(right)) {
				if (_gameScene.checkCollision(ix, iy)) {
					return iy;
				}
			}
		}
		return Math.NaN;
	}
	
	private function checkJump(left:Float, right:Float, top:Float, bottom:Float):Float {
		var iy = Math.ceil(bottom);
		while (iy >= Math.ceil(top)) {
			for (ix in Math.floor(left)...Math.floor(right)) {
				if (_gameScene.checkCollision(ix, iy)) {
					return iy + 1;
				}
			}
			iy--;
		}
		return Math.NaN;
	}
	
}
