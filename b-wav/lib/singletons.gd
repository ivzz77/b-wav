class_name Singleton
extends Node

static var P1 : P1InputLayer
static var PHYSICS : PhysicsEngine
static var GAME_LOGIC : GameLogic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	P1 = P1InputLayer.new()
	PHYSICS = PhysicsIMPL.new()
	GAME_LOGIC = LocalPVPLogic.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# ideally want some stuff to update every tick
