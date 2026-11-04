class_name Hitbox
#extends Component
# not sure how it should even work tbh
# component is just an enum that points to the right functionality implemented
# in more or less static classes


# should be a GENERALIZED hitbox that's NOT circular
# -> define in terms of some fixedpointShape2D ?.....


func intersects(other : Entity) -> bool:
	return false
