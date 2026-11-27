class_name BulletRenderer

## Draws whatever bullets the World says are alive. It doesn't own any
## simulation state, so rolling back the world just changes what gets drawn.
## Pretty nice design hopefully :3
## magical

var object_pools: Dictionary[int, RenderObjectPool] = {}
var world: World
var parent: Node2D

# Reused every frame so we don't allocate
var _pos = PackedInt32Array()
var _rot = PackedFloat32Array()
var _type = PackedInt32Array()
var _age = PackedInt32Array()

func _init(_parent: Node2D, _world: World) -> void:
	parent = _parent
	world = _world

## Attach a sprite to some specific kind of bullet
func add_object_pool(kind: int, rect: Sprite2D, reserve: int = 256) -> void:
	object_pools[kind] = RenderObjectPool.new(rect, parent)
	object_pools[kind].reserve(reserve)

## Query current state of the world
func draw() -> void:
	world.query_bullets(_pos, _rot, _type, _age)
	for i in range(_type.size()):
		var pool: RenderObjectPool = object_pools.get(_type[i], null)
		if pool == null: continue
		pool.draw_bullet(_pos[i * 2], _pos[i * 2 + 1], _rot[i], _age[i])

	# Finalize the object pools!!
	for pool in object_pools.values():
		pool.commit()
