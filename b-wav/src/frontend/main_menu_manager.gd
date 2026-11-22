extends Control

@onready var MainMenu:Control = $Main
@onready var SettingsMenu:Control = $Settings
@onready var CreditsMenu:Control = $ControlMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainMenu.visible = true
	SettingsMenu.visible = false
	CreditsMenu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
