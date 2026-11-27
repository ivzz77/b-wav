class_name Renderer


# should be specifically for game board related rendering
# pretty much entities only; things that need to be translated from
# int game space to float screen pos


# ui doesn't need this

	#	TODO interpolating
	#	kazelink should figure all this out tbh



# a node2D for non instanced rendering
# this node should be passed in by init, & have child canvasItem nodes
# added & removed as needed
var _origin : Node2D
# because a canvasItem in the scenetree will just auto be rendered ig
# do also want a additional camera in the scenetree, for relative position
# rendering of such canvasItems


# renderer's representation of character's sprite
var _char1 : Sprite2D
var _char2 : Sprite2D
# probably want a renderedCharacter class too
# for relevant animations



# knowing that this gets inited in comms layer, the topmost node
# this will be inited correctly

# int array indexed by BulletTextureRegistry's texture ints
# holds number of instances of each texture to draw this frame
var _instance_count : Array[int]



func comms_init(o : Node2D):
	for _tx in BulletTextureRegistry.textures:
		_instance_count.append(0)
		# all start at 0
	
	
	_origin = o
	_char1 = Sprite2D.new()
	_char1.texture = C.characters[0].base.texture
	_char2 = Sprite2D.new()
	_char2.texture = C.characters[1].base.texture
	
	#	relative to origin node so like whatever pos = global pos
	_char1.position = Vector2.ZERO
	_char2.position = Vector2.ZERO
	#	will probably get overriden by renderer's process()
	
	_origin.add_child(_char1)
	_origin.add_child(_char2)
	
	




# manually called by comms layer every frame
func process(delta: float) -> void:
	
	#	instanced rendering of all bullets by texture
	reset__instance_count()
	
	for bullet in C.bp.bullets:
		if bullet.active:
			var tx = bullet.sprite
			# maybe shouldn't be interchanging texture & sprite lol
			
			var pos = to_screenpos(bullet) + tx_offset(tx)
#			TODO the integer space should have a camera as well
# take that into consideration +to_screenpos(camera) type thing
			
			tx_mmesh(tx).set_instance_transform(_instance_count[tx], pos)
	
	# now make only this many visible
	for tx in range(BulletTextureRegistry.textures.size()):
		tx_mmesh(tx).visible_instance_count = _instance_count[tx]



	#	characters list is kind of constant anyway
	render_characters(delta)
	



func reset__instance_count():
	for i in range(_instance_count.size()):
		_instance_count[i] = 0
		

# just shorthand for this long thing
func tx_mmesh(tx : int) -> MultiMesh:
	return BulletTextureRegistry.textures[tx].mesh.multimesh

func tx_offset(tx : int) -> Vector2:
	return BulletTextureRegistry.textures[tx].offset




@warning_ignore("unused_parameter")
func render_characters(delta: float) -> void:
	_char1.position = to_screenpos(C.characters[0])
	_char2.position = to_screenpos(C.characters[1])
	
	# updating the position is just enough apparently,
	# judging by what nerb wrote

	pass



# helper functions

# ig like. this actually doesn't matter for anything other than rendering
# internal physics units is agnostic 
const UNITS_PER_PIXEL : int = 128
const MAGIC_NUMBER : int = 7 
# um yeah

# note this is prescaled pixel position,
# relative to screen resolution, & not accounting for camera
func to_screenpos(e : Entity) -> Vector2:
	var v : Vector2
	v.x = e.pos.x >> MAGIC_NUMBER as float
	v.y = e.pos.y >> MAGIC_NUMBER as float
	
	return v
