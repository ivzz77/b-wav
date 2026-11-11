@abstract class_name GameActions
extends RefCounted
## An interface for actions which a [GameLogic] script can use.
##
## The methods found here give a game logic script the ability to interact with
## the game. Included are all non-physical actions (see [PhysicsActions] for all
## remaining methods).

## Request a character change its health. Event [method character_health_changed]
## will typically fire immediately after this signal, but more may be going on
## under the hood, so avoid calling that method directly.
@abstract func change_character_health(character_token: int, health: int) -> bool
