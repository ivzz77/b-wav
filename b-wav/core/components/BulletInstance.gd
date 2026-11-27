@abstract class_name BulletInstance

var token = 0
var owner = -1
var start = 0
var end = 0x7fffffff
var kind = 0
var id = 0

## Component that handles more complicated bullets that are stepped arbritrarily
## We encode the bullet position and rotation through a Vector3i, using X,Y,R
## where X,Y are in pixels, and R is in degrees.
## implementation by magical :3

var _poses: Array[Vector3i] = []
var _base = 0 # t[0]

## Advances one tick from [param prev] (pose at t - 1) to tick [param t].
## You must read other entities through [param world] at tick [param t].
@abstract func step(t: int, prev: Vector3i, world: World) -> Vector3i

## Pose at spawn
@abstract func initial() -> Vector3i

## Called by World.simulate() for every live stepped bullet
func advance(t: int, world: World) -> void:
	if _poses.is_empty():
		# Initialize cuz we don't have any frames yet :p
		_base = start
		_poses.append(initial())

	# Keep poses...
	while _base + _poses.size() <= t:
		var at = _base + _poses.size()
		_poses.append(step(at, _poses.back(), world))

	# Try rolling back if we can now!
	if _poses.size() > World.MAX_ROLLBACK + 1:
		var drop = _poses.size() - (World.MAX_ROLLBACK + 1)
		_poses = _poses.slice(drop)
		_base += drop

## Forget everything after t
func rewind(t: int) -> void:
	_poses.resize(clampi(t - _base + 1, 0, _poses.size()))

## Rollback this individual bullet
func rollback(t: int, out_pos: PackedInt32Array, out_rot: PackedFloat32Array, out_type: PackedInt32Array, out_age: PackedInt32Array) -> void:
	var i = t - _base
	if i < 0 or i >= _poses.size(): return
	
	var res = _poses[i]
	out_pos.append(res.x)
	out_pos.append(res.y)
	out_rot.append(res.z)
	out_type.append(kind)
	out_age.append(t - start)
