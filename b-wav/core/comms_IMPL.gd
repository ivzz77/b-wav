class_name C
#extends CommunicationLayer
extends Node

 


# the specific implementation of comms layer by beam
# which uses my own specific entity implementation

# considering how the comms layer manages & deals w/ entities,
# this node will contain the data structures holding the entities
# -ivzz77


# note on nodetree organization
# i can only imagine the comms layer parenting everything
# considering everything needs access to the entities 


# only bullets are really created dynamically & potentially cause lag...
static var bp : BulletPool

# obj are passed by reference thankfully
static var characters : Array[Character]

static var phy : PhysicsEngine
static var logic : GameLogic

static var renderer : Renderer


# @beam -> idk how u want these layers to interrelate ultimately
# need this to happen before game systems act on entities
func _ready() -> void:
	#	 init components
	phy = Singleton.PHYSICS
	logic = Singleton.GAME_LOGIC
	
	renderer = Singleton.RENDERER
	
	
	# do initialization of bullet pool (NOT made of nodes)
	bp = BulletPool.new()
	for i in 32:
		# surely 1024 is enough
		bp._add32()
		
		# why the hell is it called by .new() like that
		for j in 32:
			var b = Bullet.new() 
			bp.bullets.push_back(b)
			var c = Component.new
			bp.components.push_back(c)
	
	#	spawn the 2 kat characters & push to list
	const SPAWN_OFFSET : int = 100
	characters.append( Character.new(%Kat.def, Vector2i(-SPAWN_OFFSET, 0) ))
	characters.append( Character.new(%Kat.def, Vector2i(SPAWN_OFFSET, 0) ))


@warning_ignore("unused_parameter")
func _physics_process(delta : float) -> void:
	logic.process()
	phy.process()
	
	#	might need to have multiple phases to this tbh
	
	
	pass



# per frame rendering
func _process(delta: float) -> void:
	renderer.process(delta)
