@abstract class_name Ability
extends RefCounted
## A generic ability controller defined in [Character] objects.

var _game: GameLogic
var _physics: PhysicsEngine
var _data: DataStore

var _parent: Character

var parent: Character:
	get():
		return _parent

var _token: int

var token: int:
	get():
		return _token


func _init(gameLogic: GameLogic, type: AbilityDefinition, parent: Character) -> void:
	_game = gameLogic
	_physics = gameLogic.physics
	_data = gameLogic.data

	_parent = parent
	# index isn't used by abilities, just store the input type in the token for
	# convenience
	_token = Token.make_token(type.input)

	# create entity
	gameLogic.ability_created.emit(_token, type)

	# bind to event signals
	_game.character_input_changed.connect(
		func(character_token: int, input: GameLogic.InputType,
				state: GameLogic.InputState, delta_us: int):
			if character_token == parent.token and input == type.input:
				_input_changed(state, delta_us)
	)
	_physics.post_tick.connect(post_tick)


func _input_changed(state: GameLogic.InputState, delta_us: int) -> void:
	if state == GameLogic.InputState.PRESSED:
		pressed(delta_us)
	elif state == GameLogic.InputState.RELEASED:
		released(delta_us)
	else:
		push_warning("Unhandled input state %s" % str(state))


@abstract func pressed(delta_us: int) -> void


@abstract func released(delta_us: int) -> void


func post_tick() -> void:
	pass


func set_ability_activity(active: bool) -> void:
	_game.ability_activity_changed.emit(token, active)


func set_ability_ratio(ratio: int) -> void:
	_game.ability_ratio_changed.emit(token, ratio)
