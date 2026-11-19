@abstract class_name Interpolator
extends RefCounted
## Component to smooth positional motion between physics tick intervals.
##
## This component interpolates physics positions to create smoother looking
## motion of entities. It's purpose is to decouple the physical tick rate from
## the visual frame rate. Since the tick rate is fixed, and the frame rate may
## be variable, this component keeps motion smooth and consistent at all times.
## An interpolator sits directly between the [CommunicationLayer] and the
## [PhysicsEngine]. Calls to [CommunicationLayer.get_entity_transform] pass
## through this object on their way to [PhysicsEngine]. This object may then
## use the entity's real positions and the time since the last tick (see 
## [signal PhysicsEngine.post_tick]) to create the illusion of smooth movement.


## A private reference to the physics engine with read-only access.
@warning_ignore("unused_private_class_variable")
var _physicsView: PhysicsEngine:
	get:
		return _internal_physics

# Private hidden variable for actually storing a PhysicsEngine reference (so it
# cannot be easily overwritten
var _internal_physics: PhysicsEngine

## Initializer. It is recommended to pass in a proxy object with read-only
## access (see [PhysicsEngineView]).
func _init(physicsEngine: PhysicsEngine):
	_internal_physics = physicsEngine


## Get an entity's current transform
## (see [method CommunicationLayer.get_entity_transform]).
@abstract func get_entity_transform(token: int) -> Transform2D
