class_name LocalPVPLogic
extends GameLogic


# dictionary bc there should really only be 2 plaryers
# ui needs to handle differently
var active_char_controllers : Dictionary[StringName, CharacterController]



func _ready() -> void:
	active_char_controllers["p1"] = PlayerController.new(Singleton.P1)
	active_char_controllers["p2"] = PlayerController.new(Singleton.P1)
	#	TODO add keybinds for p2 lol

# called in comms layer every tick
func process():
	for key in active_char_controllers:
		active_char_controllers[key].process()
