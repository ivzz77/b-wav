@abstract class_name SimpleAbility
extends Ability

# Persistent data
const DEFAULT_COOLDOWN_S := 5
## The cooldown when this ability is used. Warning! this is persistent data,
## set only during _init
var max_cooldown: int

# Simulated data
var _cooldown_v: int

var cooldown: int:
	get = get_cooldown, set = set_cooldown


func _init(gameLogic: GameLogic, type: AbilityDefinition, parent: Character) -> void:
	super(gameLogic, type, parent)

	max_cooldown = DEFAULT_COOLDOWN_S * _game.PHYSICS_RATE_HZ

	_cooldown_v = _data.declare()


## Override with what this ability should actually do
@abstract func act(delta_us) -> void


func pressed(delta_us: int) -> void:
	if cooldown == 0:
		reset_cooldown()
		act(delta_us)


@warning_ignore("unused_parameter")
func released(delta_us: int) -> void:
	pass


func post_tick() -> void:
	if cooldown > 0:
		cooldown -= 1


func get_cooldown() -> int:
	return _data.get_value(_cooldown_v)


func set_cooldown(new_cooldown: int) -> void:
	assert(new_cooldown >= 0)
	assert(new_cooldown <= max_cooldown)
	_data.set_value(_cooldown_v, new_cooldown)

	@warning_ignore("integer_division")
	set_ability_ratio(cooldown * _game.RATIO_MAX / max_cooldown)


func reset_cooldown() -> void:
	_data.set_value(_cooldown_v, max_cooldown)
