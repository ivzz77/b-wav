class_name PhysicsEngineView
extends PhysicsEngine
## A proxy for [PhysicsEngine] allowing read-only access.

var _physicsEngine: PhysicsEngine

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
	_physicsEngine.post_tick.connect(
		func():
			post_tick.emit()
	)

func get_tick() -> int:
	return _physicsEngine.get_tick()

@warning_ignore("unused_parameter")
func spawn_character(type: CharacterType, position: Transform2D) -> int:
	push_error("PhysicsEngineView cannot call spawn_character()")
	return 0

@warning_ignore("unused_parameter")
func spawn_bullet(type: BulletType, position: Transform2D) -> int:
	push_error("PhysicsEngineView cannot call spawn_bullet()")
	return 0

@warning_ignore("unused_parameter")
func despawn_character(character_token: int) -> bool:
	push_error("PhysicsEngineView cannot call despawn_character()")
	return false

@warning_ignore("unused_parameter")
func despawn_bullet(bullet_token: int) -> bool:
	push_error("PhysicsEngineView cannot call despawn_bullet()")
	return false

func simulate() -> void:
	push_error("PhysicsEngineView cannot call simulate()")

@warning_ignore("unused_parameter", "shadowed_variable_base_class")
func rollback(tick: int) -> bool:
	push_error("PhysicsEngineView cannot call rollback()")
	return false

func get_bullet_position(bullet_token: int) -> Transform2D:
	return _physicsEngine.get_bullet_position(bullet_token)

func get_bullet_future_position(bullet_token: int) -> Transform2D:
	return _physicsEngine.get_bullet_future_position(bullet_token)
