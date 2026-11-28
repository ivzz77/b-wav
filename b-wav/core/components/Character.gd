class_name Character

const CAPACITY = 128
const MASK = CAPACITY - 1
const PRUNE_MIN_AMOUNT = 5

const PLAYER_RADIUS = 6.0

## Character, basic linear velocity character solver.
## As such, it makes it stupidly easy to just create
## a piecewise function determining the path of the player.
## implementation by magical :3

var despawned_at = 0x7fffffff
var spawned_at = 0
var kind = 0
var id = -1

# ring buffer of velocity changes, oldest at _head
var _ticks = PackedInt64Array()
var _velocities: Array[Vector2i] = []
var _head = 0
var _count = 0

var _was_hit = false
var _last_position: Vector2i
var _last_timestep: int
var _last_velocity = Vector2i.ZERO

func _slot(i: int) -> int: return (_head + i) & MASK

func _init(what: int, pos: Vector2i, t: int):
	_ticks.resize(CAPACITY)
	_velocities.resize(CAPACITY)
	_last_position = pos
	_last_timestep = t
	kind = what

static var _pos = PackedInt32Array()
static var _rot = PackedFloat32Array()
static var _type = PackedInt32Array()
static var _age = PackedInt32Array()

## Ran on simulation, per tick lol
func tick(_t: int, _world: PhysicsEngine) -> void:
	_world.query_bullets(_pos, _rot, _type, _age)
	
	var pos = Vector2(_world.get_character_position(id))
	var who = -1
	for i in range(_type.size()):
		var R: float = PLAYER_RADIUS + BulletData.BULLET_RADIUS.get(_type[i], 8.0)
		if pos.distance_squared_to(Vector2(_pos[i * 2], _pos[i * 2 + 1])) <= R * R:
			who = i
			break
	
	if who != -1 and not _was_hit:
		_world.character_collided_bullet.emit(id, _type[who])
		print("lol")
	_was_hit = who != -1

## Sets the velocity of the player on tick [param t], with
## velocity [param v].
func set_velocity(t: int, v: Vector2i) -> void:
	var current = _velocities[_slot(_count - 1)] if _count > 0 else _last_velocity
	if current == v: return

	# remove the oldest change in to make room
	if _count == CAPACITY: _remove_oldest()

	var s = _slot(_count)
	_ticks[s] = t - 1
	_velocities[s] = v
	_count += 1

# Gets rid of the oldest element in the ring buffer and that'll be our
# initial position + velocity to step from 
func _remove_oldest() -> void:
	var s = _head
	_last_position += _last_velocity * (_ticks[s] - _last_timestep)
	_last_timestep = _ticks[s]
	_last_velocity = _velocities[s]
	_head = (_head + 1) & MASK
	_count -= 1

## Called on reconciliation, only set the active
## buffer during tick [param t].
func rollback(t: int) -> void:
	while _count > 0 and _ticks[_slot(_count - 1)] >= t:
		_count -= 1

## Remove frames before tick [param t]
func prune_before(t: int) -> void:
	var n = 0
	while n < _count and _ticks[_slot(n)] < t:
		n += 1
	if n < PRUNE_MIN_AMOUNT: return
	for i in n:
		_remove_oldest()

## Gets the position of the player at tick [param t]
func get_position(t: int) -> Vector2i:
	var pos = _last_position
	var last = _last_timestep
	var vel = _last_velocity

	for i in _count:
		var s = _slot(i)
		if _ticks[s] > t: break
		
		# integrate
		pos += vel * (_ticks[s] - last)
		last = _ticks[s]
		vel = _velocities[s]

	return pos + vel * (t - last)
