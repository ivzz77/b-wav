class_name Bullet
extends Entity
# should NOT be instantiated directly
# use the BulletPool spawn functions
# only acts as a class to collect relevant data together 

# only represents a physical bullet in game space when acted on by some physics provider
# ^ which would operate on the bullet pool




# tbh like. may as well just access these fields directly
var active : bool = false

# hm... not sure if should be entire character reference
# who the bullet belongs to
var owner : int




# ALL BULLETS HAVE CIRCULAR HITBOX BY DEFAULT
# set radius to 0 for disable
#var radius : int = 0

# relevant for music gameplay
var power_level : int = -1


# fucking shit!!!
# gdscript doesn't even allow global enums
# use an int to represent specific texture
# renderer should refer to Singleton BulletTextureRegistry to find associated
# multimesh
# doesn't matter to anything except renderer
var sprite : int



# sets all of own value according to b
	# i swear
	# its not like i'm trying to overload ts
@warning_ignore("shadowed_variable")
func copy_set(b : Bullet, owner : int) -> void:
	#active should be manually set by some other thing ig
	# an active bullet should imply physics is acting upon it
	# shouldn't be passing around Bullets as values if they're active...
	sprite = b.sprite
	power_level = b.power_level
	self.owner = owner
	
