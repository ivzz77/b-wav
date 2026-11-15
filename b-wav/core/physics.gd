extends Node
# fixed point physics engine for the game board (where the player characters exist & gameplay happens)
# should act as a Singleton at least for its parent node (the Game board); other nodes should
# be able to access its contents

# ig this will just be the physics *provider*
# the game node itself will represent the inner game board & all the data


# figure out scope semantics in gdscript & move to game node

func _ready() -> void:
	pass

# called every physics tick
# as much as like. one might want this to just be a physics provider
# this like...
#
# asdlfjkasdlfj;l
# unless i want to use _physics_process() in main instead??
# waiting for another opinion ig

# ideally the Game node really should just be a container of state
# w/ the child nodes doing logic
# rather than having game node needing to have logic to call inner stuff


func _physics_process(delta: float) -> void:
	pass





# helper functions
