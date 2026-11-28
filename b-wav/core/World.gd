class_name World
extends PhysicsEngine

const FLAG_DYNAMIC_BULLET = 1 << 62
const MAX_ROLLBACK = 64
const NEVER = 0x7fffffff
const LOCAL_BITS = 20

## Implementation of the physics engine, processing motion and collisions.
## The physics engine is responsible for all entity motion and collision
## interactions. It also owns all data representing location and motion within
## the world. To create entities, a [GameLogic] script should call the methods
## available on this interface (with some exceptions). That script does not need
## to store any position data, be tasked with moving each entity every tick, or
## implement any collision code.
## implementation by magical

# Used to identify our main objects easily
var _bullet_array: IntervalArray = IntervalArray.new()
var _attack_array: IntervalArray = IntervalArray.new()
var _characters: Dictionary[int, Character] = {}

var _tick: int = 0
var _in_step: bool = false

# Spawn counters for the current stamp only (k in the token layouts)
var _count_stamp: int = -1
var _counts: Dictionary[int, int] = {}
var _counts_dirty: bool = false

# Returns the "effective tick" that we'll write into
func _stamp() -> int:
	return _tick + 1 if _in_step else _tick

# Returns how many things [param key] already spawned
func _next_k(stamp: int, key: int) -> int:
	# It's the current tick, so just bump the current tick lol
	if stamp == _count_stamp: return _bump(key)
	
	_count_stamp = stamp
	_counts.clear()
	
	# Since we don't need to retrack anything, this is fine
	if not _counts_dirty: return _bump(key)
	
	# Since the counts (from some previous reconcilation) changed
	# we have to reevaluate
	_counts_dirty = false
	for attack in _attack_array.ending_after(stamp - 1):
		if attack.start == stamp: _bump((attack.owner + 1) & 0xFF)

	for bullet in _bullet_array.ending_after(stamp - 1):
		if bullet.start == stamp: _bump(0x100 | ((bullet.owner + 1) & 0xFF))

	return _bump(key)

# Increment the current counts of tick [param key] by one
func _bump(key: int) -> int:
	var k: int = _counts.get(key, 0)
	_counts[key] = k + 1
	
	return k

# Find annotation [param field] in the corresponding tick
func _find(array: IntervalArray, field: String, value: int, t: int) -> Variant:
	for obj in array.query(t):
		if obj.get(field) == value: return obj
	return null

## Returns the current tick (the tick most recently simulated).
func get_tick() -> int:
	return _tick

## Spawns a new character. Returns a Token representing that character.
## Characters have no rotation
func spawn_character(type: int, id: int, position: Vector2i) -> int:
	# Stamp when this character respawned
	var stamp = _stamp()
	var character = Character.new(type, position, stamp)
	
	character.id = id
	character.spawned_at = stamp
	character.despawned_at = NEVER
	
	_characters[id] = character
	character_respawned.emit(id)
	
	return id

## Despawn a character. This entity will no longer simulate and may be destroyed
## in the near future.
func despawn_character(id: int) -> void:
	assert(_characters.has(id), "despawn_character(): character does not exist!")
	if _characters[id].despawned_at != NEVER: return

	# Stamp when this character despawned
	_characters[id].despawned_at = _stamp()
	character_despawned.emit(id)

## Spawns a new attack. Returns a Token representing that attack. The starting
## position and rotation of the new attack is [param pose], where [Vector3i.x]
## and [Vector3i.y] are x- and y-position, and [Vector3i.z] is rotation in
## degrees.
func spawn_attack(kind: int, owner: int, pose: Vector3i) -> int:
	var stamp = _stamp()
	var owner_bits = (owner + 1) & 0xFF
	var instance = AttackData.create_attack(kind, owner, pose)

	# We use a unique attack id w/ (stamp, owner, k) so it doesnt collide with previous rollback
	# and is deterministic
	instance.id = (stamp << 16) | (owner_bits << 8) | _next_k(stamp, owner_bits)
	instance.start = stamp
	_attack_array.insert(instance, stamp, stamp + instance.length)
	
	return instance.id

## Spawns a new bullet. Returns a Token representing that bullet. The path that
## this bullet follows is [param path], which MUST depend on the physics state.
## Moreover, dynamic bullets must control their own destruction.
func spawn_bullet(owner: int, instance: BulletInstance) -> int:
	var stamp = _stamp()
	var owner_bits = (owner + 1) & 0xFF
	var k = _next_k(stamp, 0x100 | owner_bits)

	instance.token = FLAG_DYNAMIC_BULLET | (stamp << 24) | (owner_bits << 16) | k
	instance.owner = owner
	instance.start = stamp
	instance.end = NEVER
	
	_bullet_array.insert(instance, stamp, NEVER)
	return instance.token

## Despawn a bullet. This entity will no longer simulate and may be destroyed
## in the near future.
func despawn_bullet(bullet_token: int) -> void:
	var stamp = _stamp()
	if (bullet_token & FLAG_DYNAMIC_BULLET) != 0:
		# Dynamic bullet path, mark what we're deleting and proceed!
		var bullet = _find(_bullet_array, "token", bullet_token, stamp)
		if bullet == null: return
		_set_stray_end(bullet, stamp)
	else:
		# Mark deletion within the data structure
		var attack = _find(_attack_array, "id", bullet_token >> LOCAL_BITS, stamp)
		if attack == null: return
		attack.set_bullet_despawn(bullet_token & ((1 << LOCAL_BITS) - 1), stamp)
	bullet_despawned.emit(bullet_token)

func _set_stray_end(bullet: BulletInstance, end: int) -> void:
	# Removes the dynamic bullet from the array (for now)
	_bullet_array.remove(bullet)
	_bullet_array.insert(bullet, bullet.start, end)
	
	bullet.end = end

## Simulate the next tick. Positions of all entities are updated first, then
## signals are emitted. Signal [signal post_tick] is always emitted following
## this method and any other signals.
func simulate() -> void:
	_in_step = true
	before_character_tick.emit()
	for id in _characters:
		var character = _characters[id]
		if character.despawned_at != NEVER: continue
		
		# Since this character didn't despawn yet, we'll tick you.
		character.tick(_tick, self)
		character.prune_before(_tick - MAX_ROLLBACK)
	
	for stray in _bullet_array.query(tick):
		stray.advance(_tick, self)
	
	_tick += 1
	_in_step = false
	_attack_array.prune_before(_tick - MAX_ROLLBACK)
	_bullet_array.prune_before(_tick - MAX_ROLLBACK)
	post_tick.emit()

## Attempt to rollback to a previous tick. The next call to [method simulate]
## will simulate step [code]past_tick+1[/code]. Returns false if that tick cannot
## be recovered.
func rollback(past_tick: int) -> bool:
	if past_tick > _tick or past_tick < _tick - MAX_ROLLBACK: return false

	# We pretend that anything that started after past_tick never happened.
	# Also make sure that we respawn stuff from the previous tick so we can
	# work with them
	
	# See if we can respawn or despawn the attacks
	for attack in _attack_array.ending_after(past_tick):
		if attack.start > past_tick:
			_attack_array.remove(attack)
			continue
		for local in attack.undo_despawns_after(past_tick):
			bullet_respawned.emit((attack.id << LOCAL_BITS) | local)

	# See if we can respawn or despawn the bullets
	for bullet in _bullet_array.ending_after(past_tick):
		if bullet.start > past_tick:
			_bullet_array.remove(bullet)
		elif bullet.end != NEVER:
			_set_stray_end(bullet, NEVER)
			bullet.rewind(past_tick)
			bullet_respawned.emit(bullet.token)

	# try doing the same for characters too
	for id in _characters.keys():
		var character = _characters[id]
		if character.spawned_at > past_tick:
			_characters.erase(id)
			continue
		elif character.despawned_at != NEVER and character.despawned_at > past_tick:
			# Alright, respawn the player then.
			character.despawned_at = NEVER
			character_respawned.emit(id)
		character.rollback(past_tick)

	_count_stamp = -1
	_counts_dirty = true
	_tick = past_tick
	return true

## Get a character's current location this tick. Will return the most recent
## position of a despawned entity and nonsense data for a destroyed entity.
## Characters have no rotation.
func get_character_position(id: int) -> Vector2i:
	var character: Character = _characters.get(id)
	if character == null: return Vector2i.ZERO
	return character.get_position(mini(_tick, character.despawned_at))

## Change a character's current velocity. Must be set to create character motion
## as characters do not move on their own. Set velocity following signal
## [signal before_character_tick] to minimize input latency.
func set_character_velocity(id: int, velocity: Vector2i) -> void:
	_characters[id].set_velocity(_stamp(), velocity)

## Outputs all bullet positions in [param out_pos], rotations in [param out_rot],
## types in [param out_type], and ages in [param out_age] for this current tick.
## Note: [param out_pos] stores XY per bullet
## Returns true if this operation was successful, returns false otherwise.
func query_bullets(out_pos: PackedInt32Array, out_rot: PackedFloat32Array, out_type: PackedInt32Array, out_age: PackedInt32Array) -> bool:
	out_pos.clear()
	out_rot.clear()
	out_type.clear()
	out_age.clear()

	for obj in _attack_array.query(_tick):
		var attack = obj as AttackData.AttackInstance
		attack.rollback(_tick, out_pos, out_rot, out_type, out_age)

	for obj in _bullet_array.query(_tick):
		var attack = obj as BulletInstance
		attack.rollback(_tick, out_pos, out_rot, out_type, out_age)
	return true
