extends Menu

@onready var play_menu: Control = $"../PlayMenu"
@onready var select_button: Button = $VBoxContainer/NavigationButtonsArea/NavigationButtonsArea/MarginContainer2/SelectButton
#Going to want to change select button text once both plays select a character, to START

var num_players:int = 2
var characters_selected:int = 0
var player_selected_character:bool = false
var kat_selected:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select_button.text = "SELECT"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Select Button Disabled
	if player_selected_character == true:
		select_button.disabled = false
	else:
		select_button.disabled = true
	
	#Select Button Text
	if characters_selected == 2:
		select_button.text = "START"
	else:
		select_button.text = "SELECT"


func _on_kat_pressed() -> void:
	#Also check which player pressed Kat button
	if kat_selected:
		kat_selected = false
		player_selected_character = false
		#Make button change image or increase saturation, add border color based on player
	else:
		kat_selected = true
		player_selected_character = true
		#Make button change image or decrease saturation, remove border color based on player


func _on_back_button_pressed() -> void:
	if characters_selected == 0:
		Signals.menu_transition.emit(play_menu)
	else:
		characters_selected -= 1
		#Deselect character for that player


func _on_select_button_pressed() -> void:
	#Should only work when abled, so don't have to double check if player made a selection
	if characters_selected < num_players:
		#Set corresponding character to player
		characters_selected += 1
	elif characters_selected == num_players:
		Signals.match_start.emit()
	
