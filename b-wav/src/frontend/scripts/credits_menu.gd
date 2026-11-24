extends Menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_menu = $"../Main"
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





#DO NOT USE _input() to handle inputs, will still accept them when invisible
#Using stuff like mouse_hover will be fine
