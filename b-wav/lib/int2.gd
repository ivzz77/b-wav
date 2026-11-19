# why godot only let u define 1 global class per file anyway
class_name int2
extends RefCounted
# at least let these be garbage collected ig


var x : int
var y : int

# i swear if this makes gdscript think this is not literally just 2 integers
# i get the feeling we will never be able to just have c structs in gdscript

@warning_ignore("shadowed_variable")
func _init(x:int, y:int) -> void:
	self.x = x
	self.y = y
	
@warning_ignore("shadowed_variable")
func set2(x:int, y:int) -> void:
	self.x = x
	self.y = y
