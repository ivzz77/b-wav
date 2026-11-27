class_name AttackData

class AttackInstance:
	## Interface for the component which processes attack data.
	##
	## AttackInstance is responsible for all bullets inside of the attack. Bullets MUST have
	## a unique identifier, in order for tombstone marking to work properly.
	## AttackInstance will be used to implement analytic bullet paths and discrete paths
	## implementation by magical :3

	const COMMAND_POOL_BLOCKS = 8
	const NEVER = 0x7fffffff

	class BulletProxy:
		# Structure to hold the interval data. I did it this way
		# so we don't have to create a dictionary every single time
		# we request a BulletProxy LOL
		var path: Callable
		var kind: int
		var start: int
		var end: int
		var first_block: int = 0

		func _init(_kind: int, _start: int, _end: int, _path: Callable) -> void:
			path = _path
			kind = _kind
			start = _start
			end = _end

	## Length of this attack in terms of ticks
	var length: int = 0
	var id: int = 0

	# Template data
	var max_particles: Dictionary[int, int] = {}
	var interval_list: Array[BulletProxy] = []
	var blocks: Array[Array] = []

	# Instance data
	var start: int = 0
	var owner: int = -1
	var pose: Vector3i = Vector3i.ZERO

	var _cos: float = 1.0
	var _sin: float = 0.0
	var _despawned: Dictionary[int, int] = {}
	var _wait_delay: int = 0
	var _committed: bool = false

	# Delays the creation of the next bullet
	func wait(ticks: int) -> AttackInstance:
		_wait_delay += ticks
		return self

	## Adds a bullet into the command list. [param path] is a pure function
	## func(t: int) -> Vector3 giving local (x, y, rotation in degrees), where
	## t is ticks since this bullet was summoned
	func summon(kind: int, lifetime: int, path: Callable) -> AttackInstance:
		assert(not _committed, "AttackInstance.summon(): already committed")
		interval_list.append(BulletProxy.new(kind, _wait_delay, _wait_delay + lifetime, path))
		return self

	func _block_of(t: int) -> int:
		if length <= 0: return 0
		return clampi(t * COMMAND_POOL_BLOCKS / length, 0, COMMAND_POOL_BLOCKS - 1)

	func commit() -> AttackInstance:
		assert(not _committed, "AttackInstance.commit(): already committed")
		length = 0
		for proxy in interval_list:
			length = maxi(length, proxy.end)

		blocks.clear()
		for i in range(COMMAND_POOL_BLOCKS):
			blocks.append([])

		# Now, create the decomposed interval tree :3
		var occupancy: Dictionary[int, PackedInt32Array] = {}
		for idx in range(interval_list.size()):
			var proxy = interval_list[idx]
			var i = _block_of(proxy.start)
			var j = _block_of(proxy.end)
			proxy.first_block = i

			if not occupancy.has(proxy.kind):
				var fresh = PackedInt32Array()
				fresh.resize(COMMAND_POOL_BLOCKS)
				occupancy[proxy.kind] = fresh

			var counts = occupancy[proxy.kind]
			for b in range(i, j + 1):
				counts[b] += 1
				blocks[b].append(idx)
			occupancy[proxy.kind] = counts

		# Upper bound on how many bullets of each kind can be alive at once
		for kind in occupancy:
			var count = 0
			for c in occupancy[kind]:
				count = maxi(count, c)
			max_particles[kind] = count

		_committed = true
		return self

	## Appends every bullet alive at absolute tick [param t]: XY per bullet in
	## [param out_pos], rotation in [param out_rot], kind in [param out_type] and
	## ticks since the bullet was summoned in [param out_age].
	func rollback(t: int, out_pos: PackedInt32Array, out_rot: PackedFloat32Array, out_type: PackedInt32Array, out_age: PackedInt32Array) -> void:
		var local_t = t - start
		if local_t < 0 or local_t >= length:
			return

		for idx in blocks[_block_of(local_t)]:
			var proxy = interval_list[idx]
			if local_t < proxy.start or local_t >= proxy.end: continue
			if t >= _despawned.get(idx, NEVER): continue

			# p' = R * p_local + position
			var age = local_t - proxy.start
			var local = proxy.path.call(age)
			out_pos.append(roundi(float(local.x) * _cos - float(local.y) * _sin + pose.x))
			out_pos.append(roundi(float(local.y) * _cos + float(local.x) * _sin + pose.y))
			out_rot.append(float(local.z) + pose.z)
			out_type.append(proxy.kind)
			out_age.append(age)

	## Despawns bullet [param id] from absolute tick [param tick] onwards.
	## Passing [constant NEVER] brings it back (used when rolling back a despawn).
	func set_bullet_despawn(id: int, tick: int) -> void:
		if tick >= NEVER: _despawned.erase(id)
		else: _despawned[id] = tick

	## Creates the attack by [param owner] with transform [param pose]. [param pose] represents XYR (R in degrees, XY in pixels)
	func instantiate(_owner: int, _pose: Vector3i) -> AttackInstance:
		assert(_committed, "AttackInstance.instantiate(): commit() first")

		var clone = AttackInstance.new()
		clone.blocks = blocks
		clone.interval_list = interval_list
		clone.max_particles = max_particles
		clone.length = length
		clone._committed = true

		clone.owner = _owner
		clone.pose = _pose
		clone._cos = cos(deg_to_rad(_pose.z))
		clone._sin = sin(deg_to_rad(_pose.z))
		return clone

	## Brings back every bullet despawned after [param t]. Returns their ids.
	func undo_despawns_after(t: int) -> Array[int]:
		var restored: Array[int] = []
		for idx in _despawned.keys():
			if _despawned[idx] > t:
				_despawned.erase(idx)
				restored.append(idx)
		return restored

static var _attack_registry: Dictionary[int, AttackInstance] = {}

## Registers a new attack. [kind] is the ID referred to on the network, and [attack]
## can either be either AttackAnalytic, or AttackDiscrete (these determine how attacks will propagate)
static func register_attack(kind: int, attack: AttackInstance) -> void:
	_attack_registry[kind] = attack

## Creates the attack by [owner] with transform [pose]. [pose] represents XYR (in degrees)
static func create_attack(kind: int, owner: int, pose: Vector3i) -> AttackInstance:
	return _attack_registry[kind].instantiate(owner, pose)
