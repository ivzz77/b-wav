extends Node


# global variables that inner stuff needs to act on
static var bp : BulletPool



# init
func _ready() -> void:
	Engine.physics_jitter_fix = 0
	# ensure physics ticks sync with real time
	
	# do initialization of bullet pool (NOT made of nodes)
	for i in 32:
		# surely 1024 is enough
		bp._add32()
		
		
		# why the hell is it called by .new() like that
		for j in 32:
			var b = Bullet.new() 
			bp.bullets.push_back(b)
			var c = Component.new
			bp.components.push_back(c)
		
