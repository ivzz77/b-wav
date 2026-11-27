class_name Character

## Character, basic linear velocity character solver.
## As such, it makes it stupidly easy to just create
## a piecewise function determining the path of the player.
## implementation by magical :3

var despawned_at = 0x7fffffff
var spawned_at = 0
var kind = 0

var _ticks = PackedInt64Array()
var _velocities: Array[Vector2i] = []
var _last_position: Vector2i
var _last_timestep: int

func _init(what: int, pos: Vector2i, t: int):
	_last_position = pos
	_last_timestep = t
	kind = what

func tick(_t: int, _world: PhysicsEngine) -> void:
	pass

## Sets the velocity of the player on tick [param t], with
## velocity [param v].
func set_velocity(t: int, v: Vector2i) -> void:
	_ticks.append(t)
	_velocities.append(v)

## Called on reconciliation, only set the active
## buffer during tick [param t].
func rollback(t: int) -> void:
	var n = _ticks.bsearch(t, false)
	_ticks.resize(n)
	_velocities.resize(n)

## Remove frames before tick [param t]
func prune_before(t: int) -> void:
	var n = _ticks.bsearch(t, false)
	_ticks = _ticks.slice(n)
	_velocities = _velocities.slice(n)

## Gets the position of the player at tick [param t]
func get_position(t: int) -> Vector2i:
	var p = _last_position
	var last = _last_timestep
	var v = Vector2i.ZERO
	
	for i in _ticks.size():
		if _ticks[i] > t: break
		p += v * (_ticks[i] - last)
		last = _ticks[i]
		v = _velocities[i]

	return p + v * (t - last)
