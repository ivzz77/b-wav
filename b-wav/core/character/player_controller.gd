class_name PlayerController
extends CharacterController

# should NOT pull directly from Input singleton
# use InputLayer
var il : InputLayer



func _init(i : InputLayer):
	il = i



func process():
	il.refresh()
	
	#c.velocity.set2()
	
