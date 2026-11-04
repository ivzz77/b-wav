extends Node
# fixed point physics engine for the game board (where the player characters exist & gameplay happens)
# should act as a Singleton at least for its parent node (the Game board); other nodes should
# be able to access its contents



class BulletPool :
	# equivalent of the list of entities
	var bullets : Array[Bullet]
	# array of components for easy iterating
	var hitboxes : Array[Hitbox]
	#var components : Array[Component]

# wonder if this even helps w/ performance at all .....
	
	
	
var bp : BulletPool


func _ready() -> void:
	# do initialization of bullet pool (NOT made of nodes)
	pass # Replace with function body.


# called every physics tick
# 
func _physics_process(delta: float) -> void:
	pass





# helper functions
