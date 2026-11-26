class_name Menu
extends Control

var previous_menu:Menu
var is_transition:bool = false

func _switched_to() -> void:
	visible = true
	
	#Switch menu's track on
	if not(is_transition):
		pass
	
func _switched_from() -> void:
	visible = false
