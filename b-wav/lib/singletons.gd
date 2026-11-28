class_name Singleton
extends Node

static var P1 : P1InputLayer
static var PHYSICS : PhysicsEngine
static var GAME_LOGIC : GameLogic
static var RENDERER : Renderer


static var BULLET_REGISTRY : BulletTextureRegistry


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	P1 = P1InputLayer.new()
	PHYSICS = PhysicsIMPL.new()
	GAME_LOGIC = LocalPVPLogic.new()
	GAME_LOGIC.init()
	
	RENDERER = Renderer.new()
	
	
	#	 might want to load only what's needed
	#	not that we have that many different characters anyhow
	BULLET_REGISTRY = BulletTextureRegistry.new()
	# init should be handled in comms layer for this

	

# might want some stuff to update ...
#func _process(delta: float) -> void:
	#pass
