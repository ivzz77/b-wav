extends Node
# fixed point physics engine for the game board (where the player characters exist & gameplay happens)
# should act as a Singleton at least for its parent node (the Game board); other nodes should
# be able to access its contents



var bp : BulletPool

func _ready() -> void:
	# do initialization of bullet pool (NOT made of nodes)
	for i in 32:
		# surely 1024 is enough
		bp._add32()
		
		bp.bullets.push_back(EmptyBullet.new())
		bp.components.push_back(null)
		
		# why the hell is it called by .new() like that

# called every physics tick
# 
func _physics_process(delta: float) -> void:
	pass





# helper functions
