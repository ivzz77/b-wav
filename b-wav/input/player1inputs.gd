class_name P1InputLayer
extends InputLayer

# should really be a singleton tbh

func refresh():
	var prop = intprop.new(0)
	
	#	there might be some esoteric reason we need these separated instead
	#	of just horizontal & vertical 
	inputs["left"] = prop.float_set( Input.get_action_strength("left") )
	inputs["right"] = prop.float_set( Input.get_action_strength("right") )
	inputs["up"] = prop.float_set( Input.get_action_strength("up") )
	inputs["down"] = prop.float_set( Input.get_action_strength("down") )
	
	inputs["x"] = prop.float_set( Input.get_axis("left", "right") )
	inputs["y"] = prop.float_set( Input.get_axis("up", "down") )
	#	wtf up is positive
	
	inputs["focus"] = Input.get_action_strength("focus") as int
	
	inputs["first_atk"] = Input.get_action_strength("first_atk") as int
	inputs["second_atk"] = Input.get_action_strength("second_atk") as int
	inputs["mobility_atk"] = Input.get_action_strength("mobility_atk") as int
	
	inputs["kinetic_atk"] = mouse_moved()
	#	feels kind of awkward like this ig
	#	not to mention it breaks the hypothetical of remapping
	#	TODO make more generalized
	
	
	pass

# threshhold in pixels moved in 1 frame = consider fast enough
const THRESHHOLD : int = 10
# corresponds to 2000px/s which. according to 1 website tool i used
# is just around the comfort deadzone
# not too slow

# 1 if moved enough in 1 frame....
# 0 otherwise
func mouse_moved() -> int:
	var vec = Const.MOUSE_MOTION.screen_relative
	var x = vec.x
	var y = vec.y
	if abs(x) >= THRESHHOLD or abs(y) >= THRESHHOLD:
		return 1
	return 0
