class_name CircleHitbox
extends Hitbox

# ig this shall be the true representation of a bullet's hazard
# which may or may not actually have same position as bullet....
# wonder if i really should keep it like this



var radius : int

# TODO test this actually works lmao
func intersects(other : CircleHitbox) -> bool:
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
