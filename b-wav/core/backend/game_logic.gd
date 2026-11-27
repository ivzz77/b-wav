@abstract class_name GameLogic
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
## Implementation is done by overriding various event hooks, represented as
## empty methods in this class. An implementation of a game logic class should
## override any or all of the event methods and perform actions when they are
## received. The game logic script is expected to change frequently as the game
## is iterated on.
## [br][br]
## Sending messages from this script are done by calling methods
## directly on injected objects (see [member physics]). This script
## should [color=orange_red]never[/color] call its own event methods directly,
## as this may bypass important in-between code.
## [br][br]
## This script is permitted to create its own helper methods and classes.


## A physics engine proxy injected before [method initialize] for the game logic
## script to use.
var physics: PhysicsActions:
	get:
		return _physics

# Where the physics engine should be injected
var _physics: PhysicsActions


## An interface for performing several game actions. Injected before
## [method initialize].
var game: GameActions:
	get:
		return _game

var _game: GameActions


## Fired once before all other events.
func initialize() -> void:
	pass


## Fired every processing tick.
func process() -> void:
	pass


## Fired whenever the current movement input changes for each character. Fires
## at most once per tick.
@warning_ignore("unused_parameter")
func character_input_changed(character_token: int, movement: Vector2) -> void:
	pass


# TODO: make action an Enum
## Fires on the next tick immediately after an action input. Parameter
## [param delta] is the amount of time between the action and this tick, which
## can be at most the time between two consecutive ticks.
@warning_ignore("unused_parameter")
func character_action_changed(action: int, delta: float) -> void:
	pass


## Fired on a character's collision with a bullet.
@warning_ignore("unused_parameter")
func character_collided_bullet(character_token: int, bullet_token: int) -> void:
	pass


## Fired when a character collides with another character. This event fires
## twice, once for each character as [param this_character_token], so the character
## identified by [param other_character_token] should not be modified.
@warning_ignore("unused_parameter")
func character_collided_character(this_character_token: int, other_character_token: int) -> void:
	pass


## Fired when a character's health should change. Since health changes may happen
## externally, this event should be used instead of relying on character collisions.
@warning_ignore("unused_parameter")
func character_health_changed(character_token: int, health: int) -> void:
	pass
