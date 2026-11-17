extends Node
# fixed point physics engine for the game board (where the player characters exist & gameplay happens)
# should act as a Singleton at least for its parent node (the Game board); other nodes should
# be able to access its contents

# ig this will just be the physics *provider*
# the COMMS LAYER will represent the inner game board & all the data


func _ready() -> void:
	pass

# called every physics tick
# WILL MODIFY entity list STATE!!!
func _physics_process(delta: float) -> void:
	
	for entity in C.bp:
		update(entity)
	pass
	
	# character collision check
	for player in C.characters:
		pass


func update(e : Entity) -> void:
	e.x += e.velocity.x
	e.y += e.velocity.y
	
	pass





# helper functions
