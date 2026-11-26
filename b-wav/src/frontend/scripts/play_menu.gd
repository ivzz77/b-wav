extends Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_menu = $"../Main"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_local_play_pressed() -> void:
	pass # Replace with function body.


func _on_online_multiplayer_pressed() -> void:
	pass # Replace with function body.


func _on_tutorial_pressed() -> void:
	pass # Replace with function body.


func _on_server_pressed() -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	Signals.menu_transition.emit(previous_menu)
