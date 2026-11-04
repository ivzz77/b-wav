@abstract class_name Entity
#extends Object
# tbh is that even necessary

# the most basic element to be acted upon by our physics engine
# well lets just say all entities may as well have velocity

# should not do its own processing


var x : int
var y : int
var velocity : int2


# everything may as well have it
# including players ig etc
var radius : int = 0


# assume hitbox circular by default since its so easy....
# hm....

# TODO test this actually works lmao
func intersects(other : Entity) -> bool:
	var dx = other.x - x
	var dy = other.y - y
	var dist = intsqrt(dx*dx + dy*dy)
	# might be potentially problematic from overflow
	# but probably not for the scale we're working with
	
	return dist < radius + other.radius


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
