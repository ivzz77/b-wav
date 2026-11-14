extends Control


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	
func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_effects_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_resolution_select(index) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
