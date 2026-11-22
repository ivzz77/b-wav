extends Control

@onready var MainMenu:Control = $Main
@onready var SettingsMenu:Control = $Settings
@onready var CreditsMenu:Control = $CreditsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainMenu.visible = false
	SettingsMenu.visible = true
	CreditsMenu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
