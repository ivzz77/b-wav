@abstract class_name Entity
extends Object
# tbh is that even necessary
# yeah ig....

# the most basic element to be acted upon by our physics engine
# well lets just say all entities may as well have velocity

# should not do its own processing


# reading beam's backend stuff,
# seems like the exact implementation of entity is not specified
# only that it needs a unique token

var token : int

# one must imagine there's some way to find the entity by token
#



#var x : int
#var y : int

var pos : Vector2i
var velocity : Vector2i

#var sprite = null
# we do NOT want each entity to have a sprite2D, which is a NODE
# just point to a shared resource
# actually, rendering for  bullet should be instanced w/ multimesh,
# character just use a sprite
# so, define differently in subclass




# everything may as well have it
# including players ig etc
var radius : int = 0

# assume hitbox circular by default since its so easy....
# hm....

# TODO test this actually works lmao
func intersects(other : Entity) -> bool:
	var dist = intlength(other.pos - pos)	
	return dist < radius + other.radius



# like copy constructor but doesn't actually create new instance
# BE VERY CAREFUL ACTUALLY COPY EVERY FIELD
func _copy(e : Entity) -> void:
	#	TODO
	pass


# might be potentially problematic from overflow
# but probably not for the scale we're working with
func intlength(v : Vector2i) -> int:
	return intsqrt(v.x*v.x + v.y*v.y)



# returns in same units
# value determinism over accuracy
# from https://en.wikipedia.org/wiki/Integer_square_root#Using_bitwise_operations
func intsqrt(x : int) -> int:
	assert(x >= 0)

	var op = x
	var res = 0

	# "one" starts at the highest power of four <= x
	var one = 1
	while one <= op: one <<= 2
	one >>= 2

	while one != 0:
		var dltasqr = res + one
		if op >= dltasqr:
			op -= dltasqr
			res += one << 1
		res >>= 1
		one >>= 2

	return res
