class_name PhysicsActions
extends RefCounted
## A proxy for [PhysicsEngine] used inside a [GameLogic] script.
##
## The interface of this object makes several methods of [PhysicsEngine]
## available for a game logic script to use. PhysicsEngine methods not found
## here are not permitted for a game logic script to use.


## The current game tick.
var tick: int:
	get = get_tick

var _physics: PhysicsEngine


func _init(physics: PhysicsEngine):
	_physics = physics


func get_tick() -> int:
	return _physics.get_tick()


## Spawn a new character. Returns a Token representing that character. Parameter
## [param position] is the starting location of the new character.
func spawn_character(type: CharacterType, position: Transform2D) -> int:
	return _physics.spawn_character(type, position)


## Spawns a new bullet. Returns a Token representing that bullet. Parameter
## [param position] is the starting location of the new bullet.
func spawn_bullet(type: BulletType, position: Transform2D) -> int:
	return _physics.spawn_bullet(type, position)


## Despawn a character. This character will no longer simulate and may be
## destroyed in the near future. Returns false if the character was not
## despawned (such as if it doesn't exist).
func despawn_character(character_token: int) -> bool:
	return _physics.despawn_character(character_token)


## Despawn a bullet. This bullet will no longer simulate and may be destroyed
## in the near future. Returns false if the bullet was not despawned (such as
## if it doesn't exist).
func despawn_bullet(bullet_token: int) -> bool:
	return _physics.despawn_bullet(bullet_token)
