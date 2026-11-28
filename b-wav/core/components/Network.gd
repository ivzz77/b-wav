class_name Network

## Two-peer rollback netcode ontop of [World]
##
## Every tick, peer sends its inputs (velocity + buttons) per tick
## that the other side hasn't acknowledged yet, so lost packet don't matter.
## Remote player is predicted by repeating last confirmed input, and if it differs, the world is rolled back
## just before the violated tick and we resimulate
##
## We also batch inputs and such :d
## Usage per physics tick:
## [codeblock]
## net.set_local_input(Vector3i(vx, vy, buttons))
## net.update()
## [/codeblock]
## and inside [signal PhysicsEngine.before_character_tick], we read
## [code]net.input(id, world.get_tick() + 1)[/code] for every player.
## magical

const MAX_PREDICTION = 12
const MAX_INPUTS_PER_PACKET = 64
const MSG_INPUTS = 0x0

const NEVER = 0x7FFFFFFF
const NONE = Vector3i.ZERO

var world: World
var transport: PacketPeer
var local_id: int
var remote_id: int

## Reported tick information currently...
var remote_confirmed: int = 0
var remote_tick: int = 0
var started = false
var debug_loss = 0.0

var _local: Dictionary[int, Vector3i] = {}
var _remote: Dictionary[int, Vector3i] = {}
var _predicted: Dictionary[int, Vector3i] = {}
var _hashes: Dictionary[int, int] = {}
var _remote_hashes: Dictionary[int, int] = {}

var _acked: int = 0
var _latest_local: int = 0
var _pending: int = NEVER
var _remote_advantage: int = 0
var _frame: int = 0
var _outgoing: Array = []
var _rng = RandomNumberGenerator.new()

var _pos = PackedInt32Array()
var _rot = PackedFloat32Array()
var _type = PackedInt32Array()
var _age = PackedInt32Array()

func _init(_world: World, _transport: PacketPeer, _local_id: int, _remote_id: int) -> void:
	world = _world
	transport = _transport
	local_id = _local_id
	remote_id = _remote_id
	world.post_tick.connect(_on_post_tick)

## Records this frame's local input
func set_local_input(v: Vector3i) -> void:
	if not started: return
	var t = world.get_tick() + 1

	# Once a tick's input exists it could be on wire, so final
	if _local.has(t): return
	_local[t] = v
	_latest_local = maxi(_latest_local, t)

## Input of [param player] for the step into tick [param t] lol
func input(id: int, t: int) -> Vector3i:
	if id == local_id:
		return _local.get(t, NONE)
	elif _remote.has(t):
		return _remote[t]
	var guess: Vector3i = _remote.get(remote_confirmed, NONE)
	_predicted[t] = guess
	return guess

## Keep timers in step and simulate hte tick and send. Checks what the peer's
## state hash was and compared it to ours, we do not need to rollback
## if they are the same.
func update() -> void:
	_frame += 1
	_recieve()

	if started:
		# There's some pending state, let's see what happened
		if _pending != NEVER: _resimulate()
		_check_hashes()

		# See if we need to resimulate the world
		var ahead = world.get_tick() - remote_confirmed >= MAX_PREDICTION
		var advantage = world.get_tick() - remote_tick
		var drifting = (advantage - _remote_advantage) / 2 >= 1 and _frame % 3 == 0
		if not ahead and not drifting: world.simulate()

	_send()
	_prune()

## Try rollbacking if we can
func _resimulate() -> void:
	var target = world.get_tick()
	var from = _pending - 1
	_pending = NEVER
	if from >= target: return
	if not world.rollback(from):
		push_error("desync")
		return

	var delta = target - world.get_tick()
	while world.get_tick() < target:
		world.simulate()
	push_warning("rollbacked %d ticks" % [delta])

func _on_post_tick():
	_hashes[world.get_tick()] = state_hash()

## Hash of current world that everyone must agree on
func state_hash() -> int:
	world.query_bullets(_pos, _rot, _type, _age)
	var a = mini(local_id, remote_id)
	var b = maxi(local_id, remote_id)
	return hash([ _pos, _rot, _type, _age, world.get_character_position(a), world.get_character_position(b) ])

func _final_tick() -> int:
	return mini(world.get_tick(), remote_confirmed)

func _send() -> void:
	var buf = StreamPeerBuffer.new()
	buf.put_8(MSG_INPUTS)
	buf.put_32(remote_confirmed)
	buf.put_32(world.get_tick())
	buf.put_32(world.get_tick() - remote_tick)

	# Current hash of the world that we check against
	var final = _final_tick()
	buf.put_32(final if started and _pending == NEVER and _hashes.has(final) else -1)
	buf.put_u32(_hashes.get(final, 0))

	var first = _acked + 1
	var count = clampi(_latest_local - first + 1, 0, MAX_INPUTS_PER_PACKET)
	buf.put_32(first)
	buf.put_8(count)

	for i in range(count):
		var v: Vector3i = _local.get(first + i, NONE)
		buf.put_16(v.x)
		buf.put_16(v.y)
		buf.put_16(v.z)

	# emulate net loss
	if debug_loss > 0.0 and _rng.randf() < debug_loss:
		pass
	else:
		_outgoing.append([ _frame, buf.data_array ])

	var keep = []
	for p in _outgoing:
		if p[0] <= _frame: transport.put_packet(p[1])
		else: keep.append(p)
	_outgoing = keep

## Tries recieving network data from our peer
func _recieve() -> void:
	while transport.get_available_packet_count() > 0:
		var buf = StreamPeerBuffer.new()
		buf.data_array = transport.get_packet()

		# Alright, so they sent jack
		if buf.get_size() < 1 or buf.get_u8() != MSG_INPUTS: continue

		started = true
		_acked = maxi(_acked, buf.get_32())
		remote_tick = maxi(remote_tick, buf.get_32())
		_remote_advantage = buf.get_32()

		# Check the current tick and hash for comparison
		var hash_tick = buf.get_32()
		var hash_value = buf.get_u32()
		if hash_tick >= 0: _remote_hashes[hash_tick] = hash_value

		var first = buf.get_32()
		var count = buf.get_u8()
		for i in range(count):
			var t = first + i
			var v = Vector3i(buf.get_16(), buf.get_16(), buf.get_u8())

			# Take recent one pls
			if t != remote_confirmed + 1: continue
			remote_confirmed = t
			_remote[t] = v

			if _predicted.has(t):
				if _predicted[t] != v:
					_pending = mini(_pending, t)
				_predicted.erase(t)

## Cleanup the hashes dictionary once we're done with it
func _check_hashes() -> void:
	var final = _final_tick()
	for t in _remote_hashes.keys():
		if t > final: continue
		if _hashes.has(t) and _hashes[t] != _remote_hashes[t]:
			push_warning("net: desync at tick %d" % [t])
			_remote_hashes.erase(t)

## Try cleaning up the rollback buffers per second
func _prune() -> void:
	if _frame % 60 != 0: return
	var limit = world.get_tick() - World.MAX_ROLLBACK - 8

	# Cleanup crap in the prediction arrays before the tick limit
	for d in [ _local, _remote, _predicted, _hashes, _remote_hashes ]:
		for t in d.keys():
			if t < limit: d.erase(t)

