class_name PhysicsActions
extends PhysicsEngine
## A proxy for [PhysicsEngine] used inside a [GameLogic] script.


var _physicsEngine: PhysicsEngine


## Initialize a proxy where [param physicsEngine] is the target object.
func _init(physicsEngine: PhysicsEngine):
	_physicsEngine = physicsEngine

	# Pass all signals through
	_physicsEngine.character_collided_bullet.connect(
		func(character_token: int, bullet_token: int):
			character_collided_bullet.emit(character_token, bullet_token)
	)
	_physicsEngine.character_collided_character.connect(
		func(character_token: int, other_character_token: int):
			character_collided_character.emit(character_token, other_character_token)
	)
	_physicsEngine.character_despawned.connect(
		func(character_token: int):
			character_despawned.emit(character_token)
	)
	_physicsEngine.character_respawned.connect(
		func(character_token: int):
			character_respawned.emit(character_token)
	)
	_physicsEngine.character_destroyed.connect(
		func(character_token: int):
			character_destroyed.emit(character_token)
	)
	_physicsEngine.bullet_despawned.connect(
		func(bullet_token: int):
			bullet_despawned.emit(bullet_token)
	)
	_physicsEngine.bullet_respawned.connect(
		func(bullet_token: int):
			bullet_respawned.emit(bullet_token)
	)
	_physicsEngine.bullet_destroyed.connect(
		func(bullet_token: int):
			bullet_destroyed.emit(bullet_token)
	)
	_physicsEngine.before_character_tick.connect(
		func():
			before_character_tick.emit()
	)
	_physicsEngine.post_tick.connect(
		func():
			post_tick.emit()
	)


func get_tick() -> int:
	return _physicsEngine.get_tick()


func spawn_character(type: CharacterDefinition, position: Vector2i) -> int:
	return _physicsEngine.spawn_character(type, position)


func despawn_character(character_token: int) -> void:
	return _physicsEngine.despawn_character(character_token)


func spawn_bullet(type: BulletType, pose: Vector3i) -> int:
	return _physicsEngine.spawn_bullet(type, pose)


func despawn_bullet(bullet_token: int) -> void:
	return _physicsEngine.despawn_bullet(bullet_token)


func simulate() -> void:
	push_error("PhysicsActions cannot call simulate()")


func rollback(past_tick: int) -> bool:
	push_error("PhysicsActions cannot call rollback()")
	return false


func get_character_position(character_token: int) -> Vector2i:
	return _physicsEngine.get_character_position(character_token)


func set_character_velocity(character_token: int, velocity: Vector2) -> void:
	return _physicsEngine.set_character_velocity(character_token, velocity)


func get_bullet_pose(bullet_token: int) -> Vector3i:
	return _physicsEngine.get_bullet_pose(bullet_token)


func get_bullet_future_pose(bullet_token: int) -> Vector3i:
	return _physicsEngine.get_bullet_future_pose(bullet_token)
