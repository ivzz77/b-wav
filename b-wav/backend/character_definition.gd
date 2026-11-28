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

@export var speed : int
@export var focused_speed : int

# hitbox
@export var radius : int = 48


# pretty sure read that @export happens before _init
# but then again, ig if its a already created instance then doesn't matter?


#	https://www.reddit.com/r/godot/comments/19dw7hc/export_variables_null/
#	hmmmm....
# actually can't even just leave this around???
# IMPORTANT truly insidious bug.... simply for how . outrageous it is
#@warning_ignore("shadowed_variable")
#func _init(name : String, speed : int, focused_speed : int, radius : int = 48):
	#self.name = name
	#self.speed = speed
	#self.focused_speed = focused_speed
	#self.radius = radius

# nor does godot have function overloading, what a fucking 
