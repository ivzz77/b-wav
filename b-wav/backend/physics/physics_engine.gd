@warning_ignore_start("unused_signal")
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
## [br][br]
## Update order on every simulation step must be:[br]
## Simulate next entity positions -> increment [param tick] -> emit signals

## Emitted when a character collides with a bullet.
signal character_collided_bullet(character_token: int, bullet_token: int)

## Emitted when a character collides with another character. Unlike [method
## GameLogic.character_collided_character], this is only emitted once.
signal character_collided_character(character_token: int, other_character_token: int)

## Emitted when a character is removed from the world, and will no longer
## participate in simulation steps. The next signal with this token will either
## be [signal character_respawned] or [signal character_destroyed].
signal character_despawned(character_token: int)

## Emitted when a character is respawned into the world from the despawn state.
## This signal will be emitted before any collision signals this tick.
signal character_respawned(character_token: int)

## Emitted when a character is destroyed. Destruction is irreversable, and this
## token will never be used again.
signal character_destroyed(character_token: int)

## Emitted when a bullet is removed from the world, and will no longer
## participate in simulation steps. The next signal with this token will either
## be [signal bullet_respawned] or [signal bullet_destroyed].
signal bullet_despawned(bullet_token: int)

## Emitted when a bullet is respawned into the world from the despawn state.
## This signal will be emitted before any collision signals this tick.
signal bullet_respawned(bullet_token: int)

## Emitted when a bullet is destroyed. Destruction is irreversable, and this
## token will never be used again.
signal bullet_destroyed(bullet_token: int)

## Emitted during [method simulate] immediately before characters are simulated.
## Useful for changing character velocity at the last possible moment to
## minimize input lag.
signal before_character_tick()

## Emitted after a simulation step, following all other signals emitted during
## this tick. This signal is always emitted after [member tick] changes.
signal post_tick()


## The current tick of the engine (the tick most recently simulated).
var tick: int:
	get = get_tick


## Returns the current tick (the tick most recently simulated).
@abstract func get_tick() -> int

## Spawns a new character. Returns a Token representing that character.
## Characters have no rotation
@abstract func spawn_character(type: CharacterDefinition, position: Vector2i) -> int

## Despawn a character. This entity will no longer simulate and may be destroyed
## in the near future.
@abstract func despawn_character(character_token: int) -> void

## Spawns a new bullet. Returns a Token representing that bullet. The starting
## position and rotation of the new entity is [param pose], where [Vector3i.x]
## and [Vector3i.y] are x- and y-position, and [Vector3i.z] is rotation in
## degrees.
@abstract func spawn_bullet(type: BulletType, pose: Vector3i) -> int

## Despawn a bullet. This entity will no longer simulate and may be destroyed
## in the near future.
@abstract func despawn_bullet(bullet_token: int) -> void

## Simulate the next tick. Positions of all entities are updated first, then
## signals are emitted. Signal [signal post_tick] is always emitted following
## this method and any other signals.
@abstract func simulate() -> void

## Attempt to rollback to a previous tick. The next call to [method simulate]
## will simulate step [code]past_tick+1[/code]. Returns false if that tick cannot
## be recovered.
@abstract func rollback(past_tick: int) -> bool

## Get a character's current location this tick. Will return the most recent
## position of a despawned entity and nonsense data for a destroyed entity.
## Characters have no rotation.
@abstract func get_character_position(character_token: int) -> Vector2i

## Change a character's current velocity. Must be set to create character motion
## as characters do not move on their own. Set velocity following signal
## [signal before_character_tick] to minimize imput latency.
@abstract func set_character_velocity(character_token: int, velocity: Vector2) -> void

## Get a bullet's current pose (rotation and orientation) this tick. Will return
## the most recent pose of a despawned bullet and nonsense data for a destroyed
## bullet. Components [Vector3i.x] and [Vector3i.y] are x- and y-position, and
## [Vector3i.z] is rotation in degrees.
@abstract func get_bullet_pose(bullet_token: int) -> Vector3i

## Get a bullet's predicted pose in the next tick. [color=gold]Warning:
## this method is speculative. An entity may be despawned before the next tick,
## or may move differently than predicted. Use only for visual smoothing
## (lerping).[/color]
@abstract func get_bullet_future_pose(bullet_token: int) -> Vector3i
