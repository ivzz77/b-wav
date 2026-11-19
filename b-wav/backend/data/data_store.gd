class_name DataStore
extends RefCounted
## Object to store simulated data to allow rollback

var MAX_ROLLBACK = 60

var _allow_declarations := true
# map from token index to offset and size
# Given i = index of token, nonce = _vars[i], size = _vars[i+1] and
# offset = _vars[i+2] in buffer
# nonce is stored for saftey, should prevent tokens which point to memory
# that has been deleted
var _var_map := PackedInt32Array()

# a circular buffer for storing current data and past data
var _buffer := PackedInt32Array()

# pointer to active segment
var _segment := 0
# size of each segment
var _size := 0
# amount of previous ticks currently saved
var _history := 0


# insert into var map, return new token
func _make_entity(offset: int, size: int) -> int:
	var index := _var_map.size()
	var token := Token.make_token(index)

	_var_map.resize(index + 3)
	_var_map[index] = Token.extract_nonce(token)
	_var_map[index + 1] = size
	_var_map[index + 2] = offset

	return Token.make_token(index)


## Declare a new variable to use during simulated time. Returns a token to
## access the new variable.
func declare(default_value: int = 0) -> int:
	assert(_allow_declarations, "Cannot declare new variable")

	# add variable to buffer
	var offset := _buffer.size()
	_buffer.push_back(default_value)

	return _make_entity(offset, 1)


## Declare a new array to use during simulated time. Returns a token to access
## the new array.
func declare_array(size: int, default_values: int = 0) -> int:
	assert(size > 0)
	assert(_allow_declarations, "Cannot declare new array")

	# add array to buffer
	var offset := _buffer.size()
	_buffer.resize(offset + size)
	for i in range(size):
		_buffer[offset + i] = default_values

	# make token and return
	return _make_entity(offset, size)


# get the index of this token, checking if it exists in _var_map
func _get_index(token: int) -> int:
	var index := Token.extract_index(token)
	assert(index+2 < _var_map.size() and Token.has_nonce(token, _var_map[index]),
			"Data token is stale")
	return index


## Get data from a variable or array
func get_value(token: int, index: int = 0) -> int:
	assert(index >= 0)

	var key := _get_index(token)
	assert(_var_map[key+1] < index, "Out of bounds error")

	var offset := _var_map[index+2]
	return _buffer[offset + _segment]


## Set data to a variable or array
func set_value(token: int, value: int, index: int = 0) -> void:
	assert(index >= 0)

	var key := _get_index(token)
	assert(_var_map[key+1] < index, "Out of bounds error")

	var offset := _var_map[index+2]
	_buffer[offset + _segment] = value


## Allow new data to be declared. Clears all previous data.
func declare_start() -> void:
	assert(not _allow_declarations, "Method declare_start() called twice before declare_end()")
	_var_map.clear()
	_buffer.clear()

	_allow_declarations = true


## Duplicate data to allow rollback
func declare_end() -> void:
	assert(_allow_declarations, "Method declare_start() not called before declare_end()")

	_size = _buffer.size()

	## (MAX_ROLLBACK + 1) because the current data is '0' rollbacks away
	var err := _buffer.resize(_size * (MAX_ROLLBACK + 1))
	if err != OK:
		push_error(error_string(err))
		OS.crash(error_string(err))

	_segment = 0
	_history = 0

	_allow_declarations = false


## Steps to the next tick
func step() -> void:
	assert(not _allow_declarations, "Cannot step during declarations")

	# move 1 step forward, wrapped to buffer size
	var new_segment = (_segment + _size) % _buffer.size()

	# Copy old segment into new one. This isn't going to be very fast on
	# GDScript, but there are no builtin methods for this operation, so hopefully
	# fast enough?
	# pointer to new segment
	var j = new_segment
	# pointer to old segment
	for i in range(_segment, _segment+_size):
		_buffer[j] = _buffer[i]
		# i is automatically incremented, but not j
		j += 1

	_segment = new_segment
	# the old data left behind increases history, up to maximum
	_history += min(1, MAX_ROLLBACK)


## Rolls back to a previous tick.
func rollback(ticks: int) -> void:
	assert(not _allow_declarations, "Cannot rollback during declarations")
	assert(ticks > 0, "called rollback with invalid value: " + str(ticks))
	assert(can_rollback(ticks), "tried to rollback too far, data unrecoverable")

	# move 'ticks' steps back, wrapped to buffer size
	_segment = (_segment - ticks * _size) % _buffer.size()
	# reduce history since there's less data in the past now
	_history -= ticks


## Check if a rollback is possible
func can_rollback(ticks: int) -> bool:
	return ticks <= _history
