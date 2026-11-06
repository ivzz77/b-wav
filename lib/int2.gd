# why godot only let u define 1 global class per file anyway
class_name int2

var x : int
var y : int

# i swear if this makes gdscript think this is not literally just 2 integers
func _init(x:int, y:int) -> void:
	self.x = x
	self.y = y
	
