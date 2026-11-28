extends Menu

@onready var play: Button = $PanelContainer/MarginContainer/VBoxContainer/Play
@onready var options: Button = $PanelContainer/MarginContainer/VBoxContainer/Options
@onready var credits: Button = $PanelContainer/MarginContainer/VBoxContainer/Credits
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit

#Menus it can travel to
@onready var play_menu: Menu = $"../PlayMenu"
@onready var settings_menu:Menu = $"../Settings"
@onready var credits_menu: Menu = $"../CreditsMenu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	Signals.menu_transition.emit(play_menu)
	#Signal to menu manager to transition to play menu


func _on_options_pressed() -> void:
	Signals.menu_transition.emit(settings_menu)
	#Signal to menu manager to transition to settings menu


func _on_credits_pressed() -> void:
	Signals.menu_transition.emit(credits_menu)


func _on_quit_pressed() -> void:
	get_tree().quit()
	#Quit game directly 
