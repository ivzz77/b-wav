# alas gdscript doesn't support generic pools
class_name BulletPool

# ONLY ONE NODE SHOULD MODIFY THIS CONCURRENTLY !!!!!
# probably only the physics node


# wonder if this even helps w/ performance at all .....
# maybe dont't want to organize thsi way after all...
# or like.... maybe this isn't doing it right etc

# tbh im not sure how godot works w/ pass by ref/val this might not do anyhitng at all



# equivalent of the list of entities
var bullets : Array[Bullet]
# array of components for easy iterating
var components : Array[Component]


# internal map for tracking which index is active ('set')
var _set_map : PackedInt32Array
# likely the most efficient
# modern cpus work w/ 32b usually yeah


# maybe return error if pool full or some
func spawn(b : Bullet) -> void:
	var i = _get_next_free()
	bullets[i] = b
	
	_set_map_bit(i)


func despawn(i : int) -> void:
	_unset_map_bit(i)



func _add32() -> void:
	_set_map.append(0)

# -1 if none found
# assumes _set_map uses (u)int32
func _get_next_free() -> int:
	for i in _set_map.size():
		var x = _set_map.get(i)
		if x ^ UINT32_MAX:
			var j = _get_bit_set(x)
			return 32*i +j
			
	return -1


# get lsb set in NONZERO!!! int32
# gdscript only has int as uint64; should provide int32 
func _get_bit_set(x : int) -> int:
	var val = x
	# use loop for now can maybe replace w/ lookup table
	for i in 32:
		# mod2 *should* be super cheap but i genuinely don't know
		# what gdscript will do
		if val % 2:
			return i
		val >>= 1
	
	assert(false)
	return -1

func _set_map_bit(index : int) -> void:
	@warning_ignore("integer_division")
	var i = index / 32
	var j = index % 32
	_set_map[i] |= 1 << j


func _unset_map_bit(index : int) -> void:
	@warning_ignore("integer_division")
	var i = index / 32
	var j = index % 32
	_set_map[i] &= (1 << j)^UINT32_MAX
	
	# this might not work tbh...
