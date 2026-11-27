class_name RenderObjectPool

## RenderObjectPool is responsible for rendering a specific bullet on the screen
## So, everything in here has to be homogeneous!
## The system works through basically taking the bullets World gives us
## and writing them into one MultiMesh, so a whole kind is a single draw call.
## magical

const FADE_TICKS = 12
const INITIAL_CAPACITY = 256

# 8 floats for 2d transform, 4 for color
const STRIDE = 12

var _original_scale: Vector2
var _modulate: Color
var _capacity: int = 0
var _cursor: int = 0

var _buffer = PackedFloat32Array()
var _multimesh: MultiMesh
var _instance: MultiMeshInstance2D

func _init(rect: Sprite2D, parent: Node2D) -> void:
	_original_scale = rect.scale
	_modulate = rect.modulate
	rect.visible = false

	_multimesh = MultiMesh.new()
	_multimesh.transform_format = MultiMesh.TRANSFORM_2D
	_multimesh.use_colors = true
	_multimesh.mesh = _make_quad(rect.get_rect())

	_instance = MultiMeshInstance2D.new()
	_instance.multimesh = _multimesh
	_instance.texture = rect.texture
	_instance.material = rect.material
	_instance.z_index = rect.z_index
	_instance.top_level = true
	parent.add_child(_instance)

	try_allocate(INITIAL_CAPACITY)

# Helper function to build a quad that also respects texture UV
static func _make_quad(rect: Rect2) -> ArrayMesh:
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = PackedVector2Array([
		rect.position, Vector2(rect.end.x, rect.position.y),
		rect.end, Vector2(rect.position.x, rect.end.y)])
	arrays[Mesh.ARRAY_TEX_UV] = PackedVector2Array([
		Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)])
	arrays[Mesh.ARRAY_INDEX] = PackedInt32Array([0, 1, 2, 0, 2, 3])

	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh

## Draws a bullet at (x, y) with rotation in degrees, [param age] ticks old
func draw_bullet(x: int, y: int, rotation: float, age: int) -> void:
	if _cursor >= _capacity:
		# Out of room, double the pool
		try_allocate(maxi(_capacity, INITIAL_CAPACITY))

	var scale = _original_scale
	var alpha = 1.0
	if age < FADE_TICKS:
		# If we're spawning in, play the spawn transition and also
		# scale the bullet visually by it. Basically, your standard
		# Touhou bullet spawn effect
		var t = float(age) / FADE_TICKS
		scale *= 1.0 + (1.0 - t)
		alpha = smoothstep(0.0, 1.0, t)

	var r = deg_to_rad(rotation)
	var c = cos(r)
	var s = sin(r)

	# Row-major 2D transform: [x.x, y.x, 0, origin.x, x.y, y.y, 0, origin.y]
	var i = _cursor * STRIDE
	_buffer[i] = c * scale.x
	_buffer[i + 1] = -s * scale.y
	_buffer[i + 2] = 0.0
	_buffer[i + 3] = x
	_buffer[i + 4] = s * scale.x
	_buffer[i + 5] = c * scale.y
	_buffer[i + 6] = 0.0
	_buffer[i + 7] = y
	_buffer[i + 8] = _modulate.r
	_buffer[i + 9] = _modulate.g
	_buffer[i + 10] = _modulate.b
	_buffer[i + 11] = _modulate.a * alpha
	_cursor += 1

## Uploads this frame's bullets, call this at the end
## of drawing bullets
func commit() -> void:
	_multimesh.buffer = _buffer
	_multimesh.visible_instance_count = _cursor
	_cursor = 0

## Makes sure at least [param amount] bullets fit
func reserve(amount: int) -> void:
	if amount <= _capacity: return
	try_allocate(amount - _capacity)

## Adds [param amount] sprites to the object pool
func try_allocate(amount: int) -> void:
	_capacity += amount
	_buffer.resize(_capacity * STRIDE)
	_multimesh.instance_count = _capacity
	_multimesh.visible_instance_count = 0
