@warning_ignore_start("unused_parameter")
class_name DataStoreUser
extends DataStore
## Proxy for a DataStore used in a [GameLogic] script


var _target: DataStore


func _init(dataStoreInstance: DataStore):
	_target = dataStoreInstance


func declare(default_value: int = 0) -> int:
	return _target.declare(default_value)


func declare_array(size: int, default_values: int = 0) -> int:
	return _target.declare_array(size, default_values)


func get_value(token: int, index: int = 0) -> int:
	return _target.get_value(token, index)


func set_value(token: int, value: int, index: int = 0) -> void:
	return _target.set_value(token, value, index)


func declare_start() -> void:
	push_error("DataStoreUser cannot call declare_start()")


func declare_end() -> void:
	push_error("DataStoreUser cannot call declare_end()")


func step() -> void:
	push_error("DataStoreUser cannot call step()")


func rollback(ticks: int) -> void:
	push_error("DataStoreUser cannot call rollback()")


func can_rollback(ticks: int) -> bool:
	push_error("DataStoreUser cannot call can_rollback()")
	return false
