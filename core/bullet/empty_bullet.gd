class_name EmptyBullet
extends Bullet


# or null bullet idk
# jsut place holder for initing

func _init() -> void:
	x = 0
	y = 0
	velocity.x = 0
	velocity.y = 0
	# surely some better way to do in 1 line
	
	sprite = null
	power_level = -1
	# like. don't process these 
