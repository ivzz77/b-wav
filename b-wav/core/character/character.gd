class_name Character
extends Entity
# should really be just an abstract representation of a character's data
# and yet not @abstract bc it should actually exist in world & be instantiable

var base : CharacterDefinition


var direction : intdir

var speed_mult : intprop

# timer in ticks until wears off
var speed_mult_timer : int
var dir_lock : int
var move_lock : int		# equivalent of stun timer
var atk_lock : int
var inv_timer : int

# maybe expose to game settings @ some point TODOn't
const STUN_THRESHHOLD : int = 2
var stun_counter : int

# not a comprehensive state list; just things that are binary
# might make bit flags somehow
enum state {NORMAL, FOCUSED}


# things from mns not sure if we will have exactly the same
#var action_lock : int
#var spell_lock : int
#var cooldown_hold : int
#var combo : int


var hearts_left : int
# how many hits until lose stock -> walls reset

# not sure if this is state should be tracked by gamelogic script instead


@warning_ignore("shadowed_variable_base_class")
func _init(chr : CharacterDefinition, pos : Vector2i):
	base = chr
	self.pos = pos
	reset()
	
	direction = intdir.new(0)
	
	pass


func reset():
	hearts_left = 4
	stun_counter = 0
	speed_mult = Const.PROP_ONE
	reset_timers()
	# technically round reset should  add some action lock until round
	# officially starts, leave that to be decided though


func reset_timers():
	speed_mult_timer = 0
	dir_lock = 0
	move_lock = 0
	atk_lock = 0
	inv_timer = 0
	
	
