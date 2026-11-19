class_name S
extends Node

static var p1 : P1InputLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1 = P1InputLayer.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# ideally want some stuff to update every tick
