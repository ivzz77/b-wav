class_name CharacterAttackEmitter
extends Node2D

class ClawRenderPool extends RenderObjectPool:
	func draw_bullet(bullet: BulletCommandPool.BulletResult, timer: float) -> void:
		if _cursor + 1 == _capacity:
			try_allocate(_capacity)
		super.draw_bullet(bullet, timer)
		if timer > bullet.end - FADE_TIME:
			_pool[_cursor - 1].modulate.a = 1.0

@onready var _renderer := BulletRenderer.new($Projectiles)
@onready var _templates: Array[Sprite2D] = [$Claw1, $Claw2, $Claw3]

var _pattern := KatPrimary.build_pattern()
var _tick := 0


func _ready() -> void:
	for row in _templates.size():
		_renderer.object_pools[KatPrimary.CLAW_KINDS[row]] = ClawRenderPool.new(_templates[row], $Projectiles)


func cast(angle: float) -> void:
	var time_sec := float(_tick) / Engine.physics_ticks_per_second
	_renderer.add_command_pool(_pattern, time_sec, global_position, angle)


func advance() -> void:
	_tick += 1
	_renderer.draw(float(_tick) / Engine.physics_ticks_per_second)
