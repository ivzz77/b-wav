@warning_ignore_start("unused_signal")
class_name GameLogic
extends RefCounted
## Interface for the game logic script which controls game state.
##
## The game logic unit is the main controller of internal game state. It uses
## an [url=https://en.wikipedia.org/wiki/Inversion_of_control]Inversion of
## control[/url] style design, where control flow is given to this script
## through intercepting game events. The specific implementation of game events
## are abstracted away such that a game logic script may run on both local
## multiplayer and on clients in an online match, all without conditional logic
## changing behavior depending on which one is being done.
## [br][br]
## Implementation is done by connecting to various event hooks, represented as
## signals in this class. An implementation of a game logic class should
## connect to any or all of the event signals, perform actions when they are
## received, and emit them to send signals out. The game logic script is
## expected to change frequently as the game is iterated on.
## [br][br]
## As the networked game uses rollback netcode, memory has to be managed
## carefully. There are two types of memory, persistent and simulated.
## [br][br]
## Persistent memory stays constant for the entire course of a game. This
## includes most data about characters and actions, since they are expected to
## spawn at the start and last through the entire match. All persistent data
## must be declared inside the call to [method initialize]
## [br][br]
## Simulated memory may change during the course of the game, as much as during
## every tick. This memory must be able to be rolled back, and thus requires
## a special way to handle it. Since we are working inside GDScript, which
## limits memory management, a separate injected object is used for all
## simulated data (see [param dataStore])


enum InputType {
	PRIMARY,	# left mouse button
	SECONDARY	# right mouse button
	# TODO: add more
}

enum InputState {
	PRESSED,
	RELEASED
}

## Ticks per second.
const TICK_RATE_HZ := 60
## For ratios, the value which means 100%
const RATIO_MAX := 100_000


## A physics engine proxy injected before [method initialize] for the game logic
## script to use.
var physics: PhysicsActions:
	get:
		return _physics

# Where the physics engine should be injected
var _physics: PhysicsActions


## An object for creating simulated data which can rollback. Calls to
## [method data.declare] and [method data.declare_array] should occur during
## [method initialize], while calls to [method data.get_value] and [method
## data.set_value] should occur during gameplay ticks.
var data: DataStore:
	get:
		return _dataStore

var _dataStore: DataStore


# TODO: move this maybe? this is an input while all other signals on this
# class are an output
## Fires on the next tick immediately after an action input. Parameter [param
## input] is what input happened, and [param state] is what happened to that
## input. Parameter [param delta] is the amount of time in microseconds between
## the action and this tick, which can be at most the time between two
## consecutive ticks.
signal character_input_changed(
	character_token: int, input: InputType, state: InputState, delta_us: int
)

## Emit when a character's health should change.
signal character_health_changed(character_token: int, health: int)

## Emit when an ability is created. Abilities are only created on start and
## are never removed.
signal ability_created(ability_token: int, type: AbilityDefinition)

## Emit when an ability should change active state.
signal ability_activity_changed(ability_token: int, active: bool)

## Emit when an ability ratio changes. Parameter [param ratio] is a value from
## 0 to RATIO_MAX representing 0% to 100%.
signal ability_ratio_changed(ability_token: int, ratio: int)


var player_1: Character
var player_2: Character


## Fired once before all other events. Use this method to store any persistant
## data
func initialize(init_data: MatchInitData) -> void:
	assert(init_data.player_1.character_class)
	assert(init_data.player_2.character_class)

	# TODO: better initial positions
	player_1 = init_data.player_1.character_class.new(
		self, init_data.player_1, Vector2i(-100_000, 0)
	)
	player_2 = init_data.player_2.character_class.new(
		self, init_data.player_2, Vector2i(100_000, 0)
	)

	# TODO: setup any simulated data (see DataStore) needed in game logic
	# itself.
