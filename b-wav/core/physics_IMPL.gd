class_name PhysicsIMPL
extends PhysicsEngine
# fixed point physics engine for the game board (where the player characters exist & gameplay happens)
# should act as a Singleton at least for its parent node (the Game board); other nodes should
# be able to access its contents

# ig this will just be the physics *provider*
# the COMMS LAYER will represent the inner game board & all the data


# has everything to do with POSITION
# which the game logic thing does not ig



# called every physics tick... by the comms layer!!
# WILL MODIFY entity list STATE!!!
func process() -> void:
	
	for bullet in C.bp.bullets:
		update(bullet)
	for character in C.characters:
		update(character)
			
	# character collision check
	for character in C.characters:
		for bullet in C.bp.bullets:
			if character.intersects(bullet):
				pass
#				TODO see what beam wants	

	# maybe could do more fancy interval path collision check
	#	but like whatever tbh


func update(e : Entity) -> void:
	e.pos += e.velocity
	


# commuicate w/ beam i dont need a lot of this

func get_tick() -> int:
	return -1
func spawn_character(type: CharacterDefinition, position: Vector2i) -> int:
	return -1
func despawn_character(character_token: int) -> void:
	pass

func spawn_bullet(type: BulletType, pose: Vector3i) -> int:
	return -1

func despawn_bullet(bullet_token: int) -> void:
	pass

func simulate() -> void:
	pass

func rollback(past_tick: int) -> bool:
	return false

func get_character_position(character_token: int) -> Vector2i:
	return Vector2i.ZERO

func set_character_velocity(character_token: int, velocity: Vector2) -> void:
	pass

func get_bullet_pose(bullet_token: int) -> Vector3i:
	return Vector3i.ZERO

func get_bullet_future_pose(bullet_token: int) -> Vector3i:
	return Vector3i.ZERO



# helper functions
