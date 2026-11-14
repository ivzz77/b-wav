@warning_ignore_start("unused_parameter")
class_name PhysicsEngineView
extends PhysicsEngine
## A proxy for [PhysicsEngine] allowing read-only access.

var _physicsEngine: PhysicsEngine


## Initialize a proxy where [param physicsEngine] is the target object.
func _init(physicsEngine: PhysicsEngine):
	_physicsEngine = physicsEngine

	# Pass all signals through (since signals are always read-only)
	_physicsEngine.character_collided_bullet.connect(
		func(character_token: int, bullet_token: int):
			character_collided_bullet.emit(character_token, bullet_token)
	)
	_physicsEngine.character_collided_character.connect(
		func(character_token: int, other_character_token: int):
			character_collided_character.emit(character_token, other_character_token)
	)
	_physicsEngine.entity_despawned.connect(
		func(token: int):
			entity_despawned.emit(token)
	)
	_physicsEngine.entity_respawned.connect(
		func(token: int):
			entity_respawned.emit(token)
	)
	_physicsEngine.entity_destroyed.connect(
		func(token: int):
			entity_destroyed.emit(token)
	)
	_physicsEngine.pre_character_tick.connect(
		func():
			pre_character_tick.emit()
	)
	_physicsEngine.post_tick.connect(
		func():
			post_tick.emit()
	)


func get_tick() -> int:
	return _physicsEngine.get_tick()


func spawn_character(type: CharacterType, position: Transform2D) -> int:
	push_error("PhysicsEngineView cannot call spawn_character()")
	return 0


func spawn_bullet(type: BulletType, position: Transform2D) -> int:
	push_error("PhysicsEngineView cannot call spawn_bullet()")
	return 0


func despawn_entity(token: int) -> bool:
	push_error("PhysicsEngineView cannot call despawn_entity()")
	return false


func simulate() -> void:
	push_error("PhysicsEngineView cannot call simulate()")


func rollback(past_tick: int) -> bool:
	push_error("PhysicsEngineView cannot call rollback()")
	return false


func get_entity_position(token: int) -> Transform2D:
	return _physicsEngine.get_entity_position(token)


func get_entity_future_position(token: int) -> Transform2D:
	return _physicsEngine.get_entity_future_position(token)


func set_character_velocity(character_token: int, velocity: Vector2) -> void:
	push_error("PhysicsEngineView cannot call set_character_velocity()")
