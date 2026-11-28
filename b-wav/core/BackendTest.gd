extends Node2D

# Ticks run in _physics_process
# magical

const TPS = 60.0
const PLAYER_ID = 0
const PLAYER_SPEED = 800.0 / TPS
const FOCUS_MULTIPLIER = 0.333
const PLAYER_RADIUS = 6.0
const ROLLBACK_DEPTH = 3

@export var circle_sprite: Sprite2D
@export var heart_sprite: Sprite2D
@export var small_sprite: Sprite2D
@export var wide_sprite: Sprite2D
@export var player_sprite: Node2D

var world: World
var renderer: BulletRenderer

var stress = false
var rollbacks = 0
var mismatches = 0
var hits = 0

var _inputs: Dictionary[int, Vector2i] = {}
var _schedule: Dictionary[int, Array] = {}
var _was_hit = false
var _label: Label

var _pos = PackedInt32Array()
var _rot = PackedFloat32Array()
var _type = PackedInt32Array()
var _age = PackedInt32Array()

# Paths are now pure functions, and we have to wait for ticks now!!

static func ticks(seconds: float) -> int:
	return maxi(int(round(seconds * TPS)), 1)

func prepare_zigzag(n: int, count: int, speed: float, spacing: float) -> AttackData.AttackInstance:
	var pool = AttackData.AttackInstance.new()
	for j in range(count):
		for i in range(n):
			var direction = Vector2.from_angle((i * TAU) / float(n))
			var right = Vector2(-direction.y, direction.x)
			var velocity = direction * speed / TPS
			var heading = rad_to_deg(direction.angle())
			pool.summon(BulletData.Kind.WIDE, ticks(3.0), func(t: int) -> Vector3:
				var phase = t * 5.0 / TPS
				var p = velocity * t + right * acos(cos(phase)) * spacing
				return Vector3(p.x, p.y, heading))
		pool.wait(ticks(0.02))
	return pool.commit()

func prepare_circle_circle(n: int, count: int, radius: float, speed: float, w: float, delay: float) -> AttackData.AttackInstance:
	var pool = AttackData.AttackInstance.new()
	for i in range(n):
		var direction = Vector2.from_angle((i * TAU) / float(n))
		var heading = rad_to_deg(direction.angle())
		for j in range(count):
			var theta = (j * TAU) / 4.5
			var velocity = direction * speed / TPS
			pool.summon(BulletData.Kind.SMALL, ticks(3.0), func(t: int) -> Vector3:
				var seconds = t / TPS
				var offset = Vector2.from_angle(seconds * w + theta)
				var phase_radius = sin(seconds * w) * 100 + radius
				var p = velocity * t + offset * phase_radius
				return Vector3(p.x, p.y, heading))
		pool.wait(ticks(delay))
	return pool.commit()

func prepare_pyramid(n: int, offset: Vector2, space: int, count: int, speed: float) -> AttackData.AttackInstance:
	var pool = AttackData.AttackInstance.new()
	var half = count >> 1
	for j in range(n):
		var direction = Vector2.from_angle((j * TAU) / float(n))
		var right = Vector2(-direction.y, direction.x)
		var heading = rad_to_deg(direction.angle())
		for i in range(count):
			var distance: int = absi(i - half)
			var velocity = direction * (speed - distance * 30) / TPS
			var origin = right * (i - half) * space + offset
			pool.summon(BulletData.Kind.WIDE, ticks(3.0), func(t: int) -> Vector3:
				var p = origin + velocity * t
				return Vector3(p.x, p.y, heading))
	return pool.commit()

func prepare_spiral(count: int) -> AttackData.AttackInstance:
	var pool = AttackData.AttackInstance.new()
	for i in range(count):
		# Make a spiral pattern I guess :D
		var direction = Vector2.from_angle((i * TAU) / 32.0)
		var velocity = direction * 300 / TPS
		var heading = rad_to_deg(direction.angle())
		pool.summon(BulletData.Kind.CIRCLE, ticks(6.0), func(t: int) -> Vector3:
			var p = velocity * t
			return Vector3(p.x, p.y, heading))
		pool.wait(ticks(maxf(0.1 - i / 32.0, 0.025)))
	return pool.commit()

func prepare_hearts(n: int, m: int, delay: float) -> AttackData.AttackInstance:
	var pool = AttackData.AttackInstance.new()
	for i in range(n):
		var phase = i / 4.2
		for j in range(m):
			var direction = Vector2.from_angle((j * TAU) / m + phase)
			var velocity = direction * 800 / TPS
			var heading = rad_to_deg(direction.angle())
			pool.summon(BulletData.Kind.HEART, ticks(2.0), func(t: int) -> Vector3:
				var p = velocity * t
				return Vector3(p.x, p.y, heading))
		pool.wait(ticks(delay))
	return pool.commit()

func _ready() -> void:
	AttackData.register_attack(BulletData.Pattern.SPIRAL, prepare_spiral(128))
	AttackData.register_attack(BulletData.Pattern.HEARTS, prepare_hearts(5, 8, 0.4))
	AttackData.register_attack(BulletData.Pattern.PYRAMID, prepare_pyramid(10, Vector2.ZERO, 64, 5, 500))
	AttackData.register_attack(BulletData.Pattern.CIRCLE_CIRCLE, prepare_circle_circle(16, 10, 62, 400, 1, 0.1))
	AttackData.register_attack(BulletData.Pattern.ZIGZAG, prepare_zigzag(8, 10, 400, 50))

	world = World.new()
	world.before_character_tick.connect(_on_before_character_tick)
	world.post_tick.connect(_on_post_tick)

	renderer = BulletRenderer.new(self, world)
	renderer.add_object_pool(BulletData.Kind.CIRCLE, circle_sprite)
	renderer.add_object_pool(BulletData.Kind.HEART, heart_sprite)
	renderer.add_object_pool(BulletData.Kind.SMALL, small_sprite)
	renderer.add_object_pool(BulletData.Kind.WIDE, wide_sprite)

	var start = Vector2i(player_sprite.global_position) if player_sprite != null else Vector2i(global_position) + Vector2i(0, 300)
	world.spawn_character(0, PLAYER_ID, start)

	_label = Label.new()
	_label.top_level = true
	_label.position = Vector2(-1920/2,1080/2)
	add_child(_label)

	schedule_patterns()

func schedule_patterns() -> void:
	_schedule.clear()
	var now = world.get_tick()
	var pose = Vector3i(int(global_position.x), int(global_position.y), 0)
	for entry in [[BulletData.Pattern.SPIRAL, 1.0], [BulletData.Pattern.HEARTS, 5.0], [BulletData.Pattern.PYRAMID, 6.0],
			[BulletData.Pattern.CIRCLE_CIRCLE, 7.0], [BulletData.Pattern.ZIGZAG, 8.0]]:
		_schedule[now + ticks(entry[1])] = [entry[0], pose]

func _exit_tree() -> void:
	AttackData._attack_registry.clear()

func _on_before_character_tick() -> void:
	var t = world.get_tick() + 1
	if not _inputs.has(t):
		_inputs[t] = _poll_velocity()
	world.set_character_velocity(PLAYER_ID, _inputs[t])

func _on_post_tick() -> void:
	var t = world.get_tick()
	if _schedule.has(t):
		world.spawn_attack(_schedule[t][0], -1, _schedule[t][1])

func _poll_velocity() -> Vector2i:
	var wish = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_D): wish.x += 1
	if Input.is_physical_key_pressed(KEY_A): wish.x -= 1
	if Input.is_physical_key_pressed(KEY_S): wish.y += 1
	if Input.is_physical_key_pressed(KEY_W): wish.y -= 1
	var speed = PLAYER_SPEED * (FOCUS_MULTIPLIER if Input.is_physical_key_pressed(KEY_SHIFT) else 1.0)
	return Vector2i((wish.limit_length(1.0) * speed).round())

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo(): return
	match (event as InputEventKey).physical_keycode:
		KEY_R: stress = not stress
		KEY_T: schedule_patterns()

func _physics_process(_delta: float) -> void:
	world.simulate()
	if stress:
		_stress_rollback()
	_forget_old_inputs()

func _snapshot() -> Array:
	world.query_bullets(_pos, _rot, _type, _age)
	return [ _pos.duplicate(), _type.duplicate(), _age.duplicate(), world.get_character_position(PLAYER_ID) ]

func _stress_rollback() -> void:
	var now = world.get_tick()
	if now <= ROLLBACK_DEPTH: return
	var before = _snapshot()
	if not world.rollback(now - ROLLBACK_DEPTH):
		push_warning("rollback(): tick %d refused" % (now - ROLLBACK_DEPTH))
		return

	for i in range(1):
		world.simulate()

	#rollbacks += 1
	#if _snapshot() != before:
		#mismatches += 1
		#push_warning("rollback(): tick %d mismatched" % now)

# check for hits here cuz i didnt implement it in character yet lol
func _forget_old_inputs() -> void:
	var limit = world.get_tick() - World.MAX_ROLLBACK - 1
	if _inputs.has(limit):
		_inputs.erase(limit)

# drawing
func _process(_delta: float) -> void:
	renderer.draw()
	if player_sprite != null:
		player_sprite.global_position = Vector2(world.get_character_position(PLAYER_ID))
		player_sprite.modulate = Color.RED if _was_hit else Color.WHITE
	_label.text = "tick %d   bullets %d   hits %d\nrollback stress [R]: %s   rollbacks %d   mismatches %d" % [
		world.get_tick(), _type.size(), hits, "ON" if stress else "off", rollbacks, mismatches]
