@warning_ignore_start("unused_signal")
@abstract class_name CommunicationLayer
extends Node
## Interface for communications between the interal game state and external game
## systems.
##
## The communication layer provides all data about the game's current state, and
## accepts external input to change that state. All actual modes of play such
## as local play or online play must be inherit from this class, giving a
## consistent interface to interact with the game.
## [br][br]
##
## The communication layer uses identifiers called tokens to refer to all
## entities which exist in the game. Each token is unique and only used once.
## This way, game objects may be represented as nodes in the scene tree (see
## [Node]), simple objects (see [RefCounted], [Object]), or as pure data.
## [br][br]
##
## On object creation, some signals may return a class specifying an entity's
## type. This object contains only shared data about that object, meaning it
## lacks any properties unique to the entity such as position. External game
## systems must listen to the signals provided by this class to get individual
## entity data. These objects follow the
## [url=https://gameprogrammingpatterns.com/flyweight.html]flyweight design
## pattern.[/url]
## [br][br]
##
## Externally, positional data is provided as floats or other objects which
## contain floats (such as [Transform2D]). However, internally positions may be
## stored in a different format (such as integers) and thus internal components
## should not expect to receive this same data format.

## Emitted when a new character is created.
signal character_created(token: int, type: CharacterType)

## Emitted when a character changes its health.
signal character_health_changed(token: int, health: int)

# TODO: use an enum for movement state.
## Emitted when a character changes its movement state (such as regular, focused,
## stunned)
signal character_movement_mode_changed(token: int, state: int)

## Emitted when a new bullet is created.
signal bullet_created(token: int, type: BulletType)

## Emitted when an entity is removed from the world. The entity should no longer
## be visible and create a destruction effect if it has one. The entity will no
## longer be simulated, so calls to [method get_entity_transform] with
## [param token] will return the last known position. The next signal with this
## token will either be [signal entity_respawn] or [signal entity_destroyed].
signal entity_despawn(token: int)

## Emitted when an entity is respawned into the world from the despawn state.
## The entity should become visible again and any ongoing destruction effect 
## should be removed (if there is an effect done for entity creation, such
## as following [signal bullet_created], it should not be created here).
signal entity_respawn(token: int)

## Emitted when an entity is destroyed irreversibly. The token of this entity will
## never be used again. This signal will only be emitted after
## [signal entity_respawn], and should trigger removal of any data corresponding
## to the entity.
signal entity_destroyed(token: int)

## Get an entity's current transform. Value should change independently of the
## physics rate so this method should be called every frame on each visible
## entity. [color=gold]Warning: calling this method with the token of a
## destroyed entity will return a nonsense value and produce a warning[/color].
@abstract func get_entity_transform(token: int) -> Transform2D

## Configures a [Callable] to be invoked whenever the game requires local input.
## Callable [param input_func] should return a [Vector2] indicating a movement
## vector this physics tick.
@abstract func set_input_device(input_func: Callable) -> void
