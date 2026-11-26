extends Control

@onready var main_menu:Control = $Main
@onready var settings_menu:Control = $Settings
@onready var credits_menu:Control = $CreditsMenu
@onready var play_menu: Menu = $PlayMenu

var currentMenu:Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.visible = true
	currentMenu = main_menu
	settings_menu.visible = false
	credits_menu.visible = false
	play_menu.visible = false
	
	#Attach signals
	Signals.menu_transition.connect(_next_menu_pressed)


#func _back_button_pressed() -> void:
	#var previousMenu:Menu = currentMenu.previousMenu
	#currentMenu._switched_from()
	#previousMenu._switched_to()
	#currentMenu = previousMenu
	#If want to do transitions, can just make the transition animation it's own menu
	#which plays animation on switch_to(), and then have it switch to the next Menu after that animation


func _next_menu_pressed(next_menu:Menu) -> void:
	currentMenu._switched_from()
	next_menu._switched_to()
	currentMenu = next_menu
	#In a sense back button is also just another form of "next menu", so can have back button do the same here too

#When button of menu pressed, don't want it to directly trigger transition there, instead send signals to menu_manager to handle
#Since MenuManager already knows which menu is the current one, just needs to know which menu to transition to
#Button gives signal, which has to include which Menu to transition to (could make it a String, or have it hold a reference to the nextMenu itself to pass instead)
