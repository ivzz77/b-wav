class_name Renderer
extends Node


# should be specifically for game board related rendering...?
# bullets, player, relevant hud stuff that needs to interface with game board state
# & have entity fixed point  to godot rendering logic...

# ui doesn't need this....?

# for kazelink to figure out probably



@export var camera : Camera2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# manually called by comms layer every frame
func process(delta: float) -> void:
	
	for bullet in C.bp:
		render(bullet, delta)
	for character in C.characters:
		render(character, delta)
#		probably need specific logic tbh
	


# probably want a view into the physics tick thing
# or whatever
# actually needs to use delta
# since it's not shared state just display it's fine to use delta
func render(e : Entity, delta: float) -> void:
	# draw the sprite associated w/ entity
	
	#	should probably use renderingserver api actaully
	#	 & the character/bullet etc shared resource should contain a 
	#	 actual canvasitem (sprite2d)? which we will fetch the
	#	resource id (rid) from & call renderingserver stuff
	
	
	#	TODO temporary thing for now
	#	kazelink should figure all this out tbh
	
	
	pass
	
# maybe each entity should get its own render function come to think of it




# helper functions

# ig like. this actually doesn't matter for anything other than rendering
# internal physics units is agnostic 
const UNITS_PER_PIXEL : int = 128
const MAGIC_NUMBER : int = 7 
# um yeah

# note this is prescaled pixel position,
# relative to screen resolution
func to_screenpos(e : Entity) -> Vector2:
	var v : Vector2
	v.x = e.x >> MAGIC_NUMBER as float
	v.y = e.y >> MAGIC_NUMBER as float
	
	return v
