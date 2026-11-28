class_name BulletTextureRegistry
#extends Node
# this needs to be a node to access global nodes apparently
# siiigh...
# ok well because the node system is so fucked & necessarily requires
# circular dependencies for what we need
# just call things in the right order anyway dont even bother


# a singleton, to be INSTANTIATED but NOT initialized
# initialize in comms layer



# assigns a unique int for each bullet sprite, anything that spawns bullets
# the same int is used to index into the mesh array
# need only make the lookup once & use a local "ENUM" to refer to that 

# list of meshes for each 
static var textures : Array[BulletTexture]
static var indices : Dictionary[StringName, int]
static var _index : int = 0


func _ready() -> void:
	#init()
	pass



# need all character resources from scene to be loaded already
func init():
	textures.append(null)
	indices["EMPTY_B"] = _next_index()
	#	the null bullet at 0th
	
	# register the unique bullet texture meshes here
	
	
	# should be agnostic to exact names of nodes tbh
	# fine, use static vars
	var Kat = C.Kat
	
	
	
	
	#print(Kat.claw_spr, "  size: ", Kat.claw_spr.size())
	#return
	
	register_bullet("CLAW1", Kat.claw_spr[1])
	register_bullet("CLAW2", Kat.claw_spr[2])
	register_bullet("CLAW3", Kat.claw_spr[3])
	register_bullet("CLAW4", Kat.claw_spr[4])
	register_bullet("CLAW5", Kat.claw_spr[5])
	
	#	other bullets go here
	
	
	
	pass


func _next_index() -> int:
	_index += 1
	return _index-1

# also creates a new multimesh initialized properly
# takes sprite2D defined in character's scene, adds the relevant transforms too
func register_bullet(name_ : StringName, sprite : Sprite2D):
	
	print("currently registering ", name_, sprite)
	assert(sprite != null)
	
	#	 might need to drop this as child node of renderer or some other thing
	var mmi = MultiMeshInstance2D.new()
	mmi.set_texture(sprite.texture)
	mmi.multimesh = MultiMesh.new()
	#print(mmi.multimesh)
	mmi.multimesh.set_visible_instance_count(0)
	mmi.multimesh.set_instance_count(512)
	#	allocate but draw none
	
	#	this is the relevant part where this might incur a good bit of time cost
	#	maybe inefficient.. allocating that much for every single sprite 
	#	could do some shader + spritesheet on bullet power level
	#	but that's not very straightforward...
	#	something for kazelink to figure out if they'll ever get around to
	
	#	magic number maybe tie it to bullet pool size
	
	
	var btex = BulletTexture.new(mmi, sprite.offset)
	#print("btex mesh ", btex.mesh)
	
	textures.append(btex)
	indices[name_] = _next_index()
	
	
	
