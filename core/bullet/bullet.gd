@abstract class_name Bullet
extends Entity

# should represent the visual component of the bullet ig
# with its own associated xy & velocity


# maybe should be animated?...
# ig if so better to have custom type that's just. static loop
var sprite : Sprite2D

# ALL BULLETS HAVE CIRCULAR HITBOX BY DEFAULT
# set radius to 0 for disable
#var radius : int = 0

# relevant for music gameplay
var power_level : int
