class_name PlayerController
extends CharacterController

# should NOT pull directly from Input singleton
# use InputLayer
var il : InputLayer




func process():
	il.refresh()
	
	#c.velocity.set2()
	
