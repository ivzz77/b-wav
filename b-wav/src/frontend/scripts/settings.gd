extends Menu

@onready var master_vol_slider: HSlider = $"VBoxContainer/PanelContainer/MarginContainer/TabContainer/Game Settings/VBoxContainer/MasterVolume/HSlider"
@onready var music_vol_slider: HSlider = $"VBoxContainer/PanelContainer/MarginContainer/TabContainer/Game Settings/VBoxContainer/MusicVolume/HSlider"
@onready var sfx_vol_slider: HSlider = $"VBoxContainer/PanelContainer/MarginContainer/TabContainer/Game Settings/VBoxContainer/SFXVolume/HSlider"
@onready var back_button: Button = $VBoxContainer/PanelContainer2/MarginContainer/BackButton

func _ready() -> void:
	previous_menu = $"../Main"
	master_vol_slider.value = 100.0

# Game Settings Controllers
func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value/100))
	
func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value/100))

func _on_effects_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value/100))

func _on_resolution_select(index) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))

func _on_window_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# Add func vsync later

# Keybindings Controller


func _on_back_button_pressed() -> void:
	Signals.menu_transition.emit(previous_menu)
