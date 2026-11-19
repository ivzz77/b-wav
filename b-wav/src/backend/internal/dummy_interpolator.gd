class_name DummyInterpolator
extends Interpolator
## A dummy class for testing.
##
## Does not do any actual interpolating, just passes through position values.


# An actual interpretor would want to use the following pseudocode:
# func _init:
# 	_physicsView.post_tick.connect():
# 		record the current value of Time.get_ticks_usec()
# func get_entity_transform:
# 	store the following (consider caching):
# 		_physicsView.get_entity_position()
# 		_physicsView.get_entity_future_position()
# 	get current Time.get_ticks_usec()
# 	use time delta to find where the entity should be right now
#
# An important consideration, character motion is much less predictable than
# bullet motion. Characters must be fluid but also responsive, with as little
# input lag as possible. 


func get_entity_transform(token: int) -> Transform2D:
	return _physicsView.get_entity_position(token)
	
