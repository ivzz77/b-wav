@abstract class_name Character
extends Entity
# should really be just an abstract representation of a character's data


var base : CharacterDefinition


var direction : intdir

var speed_mult : intprop

# timer in ticks until wears off
var speed_mult_timer : int
var dir_lock : int
var move_lock : int		# equivalent of stun timer
var atk_lock : int
var inv_timer : int


# things from mns not sure if we will have exactly the same
#var action_lock : int
#var spell_lock : int
#var cooldown_hold : int
#var combo : int


var hearts_left : int
# how many hits until lose stock -> walls reset

# not sure if this is state should be tracked by gamelogic script instead



func reset():
	hearts_left = 4
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
	
	
