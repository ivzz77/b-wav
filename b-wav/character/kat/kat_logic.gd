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

@export var claw_spr : Array[Sprite2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#	subject to change!!!
	def.new("kat", 48, 24)
	
	claw.populate(
		# attack parameters go here
		# keep in mind player hitbox is around 48px
		BulletType.new(48, 24, claw_spr[1]),
		BulletType.new(64, 32, claw_spr[2]),
		BulletType.new(96, 48, claw_spr[3]),
		BulletType.new(128, 64, claw_spr[4]),
		BulletType.new(144, 64, claw_spr[5])
	)
	
	
	pass
	
