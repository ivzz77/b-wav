#class_name Character
extends RefCounted
## A generic character controller defined in a [GameLogic] script.
##
## This object provides boilerplate code for any character. To make more
## specific behavior, inherit this class and assign it to a
## [member CharacterDefinition.character_class].
## [br][br]
## This class does not always have to be subclassesed for each character
## (although a [CharacterDefinition] must exist for each character). Consider
## subclassing [Ability] before choosing to inherit from this class.

var DEFAULT_HP = 5

# Persistent data
var _game: GameLogic
var _physics: PhysicsEngine
var _data: DataStore

var _token: int

var token: int:
	get():
		return _token

var _abilities: Array[Ability]


# Simulated data
# convention: all simulated data ends in _v
var _health_v: int

## Current character health
var health: int:
	get = get_health, set = set_health


func _init(gameLogic: GameLogic, type: CharacterDefinition, position: Vector2i) -> void:
	_game = gameLogic
	_physics = _game.physics
	_data = _game.data

	_token = _physics.spawn_character(type, position)

	# bind to event signals
	# callables are filters which only call the method of the character if
	# the token matches
	_physics.character_collided_bullet.connect(
		func(character_token: int, bullet_token: int):
			if character_token == _token:
				collided_bullet(bullet_token)
	)
	_physics.character_collided_character.connect(
		func(character_token: int, other_character_token: int):
			if character_token == _token:
				collided_character(other_character_token)
	)
	_physics.post_tick.connect(post_tick)

	# create abilities
	_abilities = []
	for ability_def in type.abilities:
		var ability: Ability
		assert(ability_def.ability_class, "Ability %s has no ability class!" % str(ability_def))
		ability = ability_def.ability_class.new(gameLogic, ability_def)
		_abilities.push_back(ability)

	# declare simulated data
	_health_v = _data.declare(DEFAULT_HP)


func collided_bullet(bullet_token: int) -> void:
	health -= 1
	_physics.despawn_bullet(bullet_token)


@warning_ignore("unused_parameter")
func collided_character(other_character_token: int) -> void:
	pass


func post_tick() -> void:
	pass


# make sure to declare _health_v in _init!
func get_health() -> int:
	return _data.get_value(_health_v)


func set_health(hp: int) -> void:
	_data.set_value(_health_v, hp)
	_game.character_health_changed.emit(token, hp)
