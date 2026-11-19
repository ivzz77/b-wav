@abstract class_name CharacterController
extends Node

# to be extended by player controller
# & cpu if we ever get to it
# not that we probably will tbh i don't want 2 keep using godot

# this will fall under the game logic part of beam's diagram

# character that's controlled
# the CharacterController will MODIFY STATE of contained Character
# like the hand which moves the pieces
var c : Character


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# call this in the gamelogic layer every tick
@abstract func process()
	#	set char velocity according to etc
	# do other stuff to translate input to character state 
