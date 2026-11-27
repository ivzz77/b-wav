class_name BulletTexture

# FOR RENDERER TO DO INSTANCED DRAW BY MULTIMESH
# wrapper for multimesh but contains some other stuff


# this is fine to be float tbh
# reflect the convenient WYSIWIG sprite editor in godot engine
var offset : Vector2
var mesh : MultiMeshInstance2D


func _init(m : MultiMeshInstance2D, o : Vector2):
	mesh = m
	offset = o
