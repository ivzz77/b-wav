extends Node

# treat this as the entry point
# modify it as needed to test stuff
# don't change the starting scene in the project.godot without notice
# -ivzz77



# global variables that inner stuff needs to act on



# init
func _ready() -> void:
	Engine.physics_jitter_fix = 0
	
	#	no idea if this is how its supposed to be used
	#	 TODO test
	InputMap.action_add_event("kinetic_atk", InputEventMouseMotion.new())
	# ensure physics ticks sync with real time
	
