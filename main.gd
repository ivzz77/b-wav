extends Node


# init
func _ready() -> void:
	Engine.physics_jitter_fix = 0
	# ensure physics ticks sync with real time
