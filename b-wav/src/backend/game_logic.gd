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
## override all the event methods and perform actions when they are received.
## The implementing script is expected to change as the game is iterated on.


## A physics engine injected before [method initialize] for the game logic
## script to use.
var physics: PhysicsEngine:
	get:
		return _physics

# Where the physics engine should be injected
var _physics: PhysicsEngine


## Fired once before all other events.
func initialize() -> void:
	pass


## Fired every processing tick.
func process(tick: int) -> void:
	pass


## Fired every tick in which some input has changed. Parameter [param movement]
## contains movement input and [param actions] contains a bitset of input actions
## for this character.
func character_input_changed(tick: int, character_token: int, movement: Vector2, actions: int) -> void:
	pass


## Fired on a character's collision with a bullet.
func character_collided_bullet(tick: int, character_token: int, bullet_token: int) -> void:
	pass


## Fired when a character collides with another character. This event fires
## twice, once for each character as [param this_character_token], so the character
## identified by [param other_character_token] should not be modified.
func character_collided_character(tick: int, this_character_token: int, other_character_token: int) -> void:
	pass


## Fired when a character's health should change. Since health changes may happen
## externally, this event should be used instead of relying on character collisions.
func character_health_changed(tick: int, character_token: int, health: int) -> void:
	pass
