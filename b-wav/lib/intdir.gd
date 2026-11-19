class_name intdir

# integer represented direction

# how many directions possible to represent
# 2^15
const DIR_SUBDIVISION : int = 32768

# starts from +x axis, ccw
var arg : int

@warning_ignore("shadowed_variable")
func _init(arg : int) -> void:
	self.arg = arg
