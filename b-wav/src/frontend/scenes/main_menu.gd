extends Menu

@onready var play: Button = $PanelContainer/MarginContainer/VBoxContainer/Play
@onready var options: Button = $PanelContainer/MarginContainer/VBoxContainer/Options
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit

#Menus it can travel to
var play_menu:Menu
@onready var settings_menu:Menu = $"../Settings"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	pass
	#Signals.menu_transition.emit(play_menu)
	#Signal to menu manager to transition to play menu


func _on_options_pressed() -> void:
	Signals.menu_transition.emit(settings_menu)
	#Signal to menu manager to transition to settings menu


func _on_quit_pressed() -> void:
	get_tree().quit()
	#Quit game directly 
