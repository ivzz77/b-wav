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

var _isready : bool = false


# only bullets are really created dynamically & potentially cause lag...
static var bp : BulletPool

# obj are passed by reference thankfully
static var characters : Array[Character]



static var phy : PhysicsEngine
static var logic : GameLogic

static var renderer : Renderer
static var tx_reg : BulletTextureRegistry


# the specific character logics
# ideally shouldnt need these in the 1st place
# but access these if needed
static var Kat : CharacterLogic




# @beam -> idk how u want these layers to interrelate ultimately
# need this to happen before game systems act on entities
func _ready() -> void:
	#	 init components
	phy = Singleton.PHYSICS
	logic = Singleton.GAME_LOGIC
	
	renderer = Singleton.RENDERER
	tx_reg = Singleton.BULLET_REGISTRY
	
	# do initialization of bullet pool (NOT made of nodes)
	bp = BulletPool.new()
	for i in 32:
		# surely 1024 is enough
		bp._add32()
		for j in 32:
			# why the hell is it called by .new() like that
			var b = Bullet.new() 
			bp.bullets.push_back(b)
			
	
	
	# do character scene loading & bullet registry stuff
	Kat = preload("uid://bq8dekq5xqg0i").instantiate()
	add_child(Kat)
	# all characters should be loaded before now
	tx_reg.init()
	Kat.init()
	Kat.ready()
	# separate these calls fornow ig
	
	
	

	#	spawn the 2 kat characters & push to list
	const SPAWN_OFFSET : int = 100
	characters.append( Character.new(Kat.def, Vector2i(-SPAWN_OFFSET, 0) ))
	characters.append( Character.new(Kat.def, Vector2i(SPAWN_OFFSET, 0) ))
	
	print(characters[0].base)
	print(characters[1])
	
	
	# add the representative character sprites as nodes to renderer
	#	 the origin node2D in scenetree should not be modified !!
	renderer.comms_init(%Origin)
	
	
	
	
	_isready = true






@warning_ignore("unused_parameter")
func _physics_process(delta : float) -> void:
	if not _isready:
		return
	
	logic.process()
	phy.process()
	
	#	might need to have multiple phases to this tbh
	
	
	
	debug_tick()
	pass



# per frame rendering
func _process(delta: float) -> void:
	if not _isready:
		# this actually mattesrs... which is fucked up to think about
		# why would godot be doing stuff when things havent even readied
		# why
		return
	
	
	renderer.process(delta)




func debug_tick():
	if Input.is_action_just_pressed("debug1"):
		print(%Kat.claw_spr)
		#		this just straight up never set for some reason
		#		but still exists just [] why why why
