extends Node

# rather than the char definition, is the code responsible for kat's logic
# should probably be loaded only once as a node & then called upon...

# contains DEFintions for various atk & bullet types


var claw : PowerBulletType


@export var claw_spr : Array[Sprite2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
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
	
