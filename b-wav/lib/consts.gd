class_name Const
extends Node

# let it be known, i tried, but gdscript has other plans
# consts in gdscript are so utterly.... nothing
# there's no initializer syntax, seemingly consts can only apply to very few specific
# built in types 

# there's a . *abandoned* issue on the godot github
# about how consts can't even be used with certain builtin types

# not to mention, when i tried to use const, i ended up finding a consistent reproducible
# crash from the language server shitting itself or something
# not that i care to report it to the godot github anymore




# thus, this is my solution for a problem that shouldn't exist


static var DIR_RIGHT : intdir = intdir.new(0)
static var PROP_ONE : intprop = intprop.new(intprop.PROP_SUBDIVISION)

static var EMPTY_B : Bullet = Bullet.new()
static var EMPTY_B_TYPE : BulletType = BulletType.new(0,0,null)
static var MOUSE_MOTION : InputEventMouseMotion = InputEventMouseMotion.new()

# as far as i know, autoloading happens before anything else
# so these values *should* be set correctly when used
# but maybe TODO test anyway

# rather than remembering to autoload every new thing,
# ADD ALL CONSTS IN HERE


func _ready() -> void:
	# oh static vars can be initialized w/ expressions
	pass
