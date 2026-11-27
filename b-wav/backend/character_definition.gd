class_name CharacterDefinition
extends Resource
## Contains all data about one character. Contains shared data across systems

# doesn't use StringName because this is not an identifier
@export var name: String

@export_group("Backend")
@export var character_class: GDScript
@export var abilities: Array[AbilityDefinition]
#@export_group("")

# TODO: vfx should define variables needed here
@export var texture: Texture2D

var speed : int
var focused_speed : int

# hitbox
var radius : int = 48

@warning_ignore("shadowed_variable")
func _init(name : String, speed : int, focused_speed : int, radius : int = 48):
	self.name = name
	self.speed = speed
	self.focused_speed = focused_speed
	self.radius = radius
	
	
	
