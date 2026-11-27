class_name IntervalArray

## Deque that stores game state to rollback on.
## Used to implement the GGPO physics engine in [World]
## implementation by magical

const COMPACT_MIN = 32

var _interval: Array[Vector2i] = []
var _data: Array = []
var _hashed = 0
var _head = 0

static func bsearch_predicate(a: Vector2i, b: Vector2i): return a.x < b.x

## Inserts an event [param what] at [[param start], [param end])
func insert(what: Variant, start: int, end: int) -> int:
	var interval = Vector2i(end, start)
	var i = maxi(_interval.bsearch_custom(interval, bsearch_predicate, false), _head)
	_interval.insert(i, interval)
	_data.insert(i, what)
	
	_hashed += 1
	return _hashed

## Queries at time [param t]
func query(t: int) -> Array:
	var out = []
	var i = maxi(_interval.bsearch_custom(Vector2i(t, 0), bsearch_predicate, false), _head)
	for j in range(i, _interval.size()):
		if _interval[j].y <= t and _data[j] != null:
			out.append(_data[j])

	return out

## Every live entry whose end is after t
func ending_after(t: int) -> Array:
	var out = []
	var i = maxi(_interval.bsearch_custom(Vector2i(t, 0), bsearch_predicate, false), _head)
	for j in range(i, _interval.size()):
		if _data[j] != null:
			out.append(_data[j])
	return out

## Tombstone deletes [param what], this is used to completely cancel actions
func remove(what: Variant) -> void:
	var i = _data.find(what, _head)
	if i >= 0: _data[i] = null

## Drops everything that ended at or before [param t]
func prune_before(t: int) -> void:
	while _head < _interval.size() and _interval[_head].x <= t:
		_data[_head] = null
		_head += 1

	if _head >= COMPACT_MIN and _head * 2 >= _interval.size():
		# Slice after COMPACT_MIN insertions
		_interval = _interval.slice(_head)
		_data = _data.slice(_head)
		_head = 0
