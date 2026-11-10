@abstract class_name PhysicsEngine
extends RefCounted
## Interface for the component which processes motion and collisions.
##
## The physics engine is responsible for all entity motion and collision
## interactions. It also owns all data representing location and motion within
## the world. To create entities, a [GameLogic] script should call the methods
## available on this interface (with some exceptions). That script does not need
## to store any position data, be tasked with moving each entity every tick, or
## implement any collision code. Instead, the game logic script should expect to
## receive relevant events to act upon, such as
## [method GameLogic.character_collided_bullet].


## Emitted when a character collides with a bullet.
signal character_collided_bullet(character_token: int, bullet_token: int)

## Emitted when a character collides with another character. Unlike [method
## GameLogic.character_collided_character], this is only emitted once.
signal character_collided_character(character_token: int, other_character_token: int)

## Emitted when an entity is removed from the world, and will no longer
## participate in simulation steps. The next signal with this token will either
## be [signal entity_respawned] or [signal entity_destroyed].
signal entity_despawned(token: int)

## Emitted when an entity is respawned into the world from the despawn state.
## This signal will be emitted before any collision signals.
signal entity_respawned(token: int)

## Emitted when an entity is destroyed. Destruction is irreversable, and this
## token will never be used again.
signal entity_destroyed(token: int)


## Returns the current tick (the tick most recently simulated).
var tick: int:
	get():
		return _tick

var _tick: int


## Spawn a new character. Returns a Token representing that character. Parameter
## [param position] is the starting location of the new character.
@abstract func spawn_character(type: CharacterType, position: Transform2D) -> int

## Spawns a new bullet. Returns a Token representing that bullet. Parameter
## [param position] is the starting location of the new bullet.
@abstract func spawn_bullet(type: BulletType, position: Transform2D) -> int

## Despawn a character. This character will no longer simulate and may be
## destroyed in the near future. Returns false if the character was not
## despawned (such as if it doesn't exist).
@abstract func despawn_character(character_token: int) -> bool

## Despawn a bullet. This bullet will no longer simulate and may be destroyed
## in the near future. Returns false if the bullet was not despawned (such as
## if it doesn't exist).
@abstract func despawn_bullet(bullet_token: int) -> bool

## Simulate the next tick. Positions of all entities are updated first before
## signals are emitted.
@abstract func simulate() -> void

## Attempt to rollback to a previous tick. The next call to [method simulate]
## will simulate step [code]tick+1[/code]. Returns false if that tick cannot
## be recovered.
@abstract func rollback(tick: int) -> bool
