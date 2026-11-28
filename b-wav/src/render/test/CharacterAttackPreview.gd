extends Node2D

@onready var emitter: CharacterAttackEmitter = $Emitter
@onready var target: Node2D = $Target


func _physics_process(_delta: float) -> void:
	emitter.advance()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("first_atk"):
		return

	_fire()
	get_viewport().set_input_as_handled()


func _fire() -> void:
	var origin := emitter.global_position
	var angle := origin.angle_to_point(target.global_position)
	emitter.cast(angle)
