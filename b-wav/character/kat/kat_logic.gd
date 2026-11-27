extends CharacterLogic

# not a obj representing kat in the actual game world, but the construct
# that defines all that kat is !!!!

# should probably be loaded only once as a node & then called upon...
# ie SINGLETON
# but rather than loaded in singleton class it's actual node so can just exist
# in scenetree ig

# contains defintions for various atk & bullet types...
# & kat character entity itself ig

var def : CharacterDefinition
var claw : PowerBulletType

# is still 0 indexed, but by power
# so 1 is the 1st populated entry
@export var claw_spr : Array[Sprite2D]


# no way around it than to just . have all this
# no real enum in godot ahahahah
# should be treated as const
var CLAW1 : int
var CLAW2 : int
var CLAW3 : int
var CLAW4 : int
var CLAW5 : int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	i do not understand
# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# the export should happen before _ready()
	print("readying kat, claw_spr is ", claw_spr )
	
	#	subject to change!!!
	def = CharacterDefinition.new("kat", 48, 24)
	
	
	claw = PowerBulletType.new()
	claw.populate(
		# attack parameters go here
		# keep in mind player hitbox is around 48px
		BulletType.new(48, 24,  CLAW1),
		BulletType.new(64, 32,  CLAW2),
		BulletType.new(96, 48,  CLAW3),
		BulletType.new(128, 64, CLAW4),
		BulletType.new(144, 64, CLAW5)
	)
	
	
	pass

# should call after bullet textures are ready(registered)
func _ready2():
	#	how utterly nightmarish
	# all i wanted was to use the @export feature to conveniently set sprites
	# godot giving me all the reasons to not ever touch the Node system
	CLAW1 = %BulletTextureRegistry.indices["CLAW1"]
	CLAW2 = %BulletTextureRegistry.indices["CLAW2"]
	CLAW3 = %BulletTextureRegistry.indices["CLAW3"]
	CLAW4 = %BulletTextureRegistry.indices["CLAW4"]
	CLAW5 = %BulletTextureRegistry.indices["CLAW5"]
	
	
	#	 
	
	
	pass
	
