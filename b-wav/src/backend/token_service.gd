extends Node
## Generates unique tokens for game entities.
##
## A token is made up of a concatination of two 32-bit values, a nonce and an
## index. The nonce, or number only used once, makes up the lower 32 bits of a
## token. This number is never repeated during runtime (unless it gets too large
## and overflows). The index is the higher 32 bits of a token, and is inteded as
## an identifier for the object represented by the token. It is most useful for
## storing an array offset within the token itself.
## Indexes are not unique, so it is recommended to store an object's
## token as a part of its data, and validating that token when finding an object
## from its index.
## [br][br]
## If a nonce is needed without a token, use [method get_nonce]. Attempting to
## call [method extract_index] on a nonce will always fail.


# Arbitrary starting values to avoid common numbers
const _NONCE_OFFSET = 10000
const _INDEX_OFFSET = 1000

const _UINT32_MAX = 0xFFFF_FFFF


var _nonce: int = _NONCE_OFFSET


## Get index from token.
static func extract_index(token: int) -> int:
	var high := token >> 32
	assert(high >= _INDEX_OFFSET, "Token is invalid")
	# index must remain identical to value used in token generation, so subtract
	# offset before returning
	return high - _INDEX_OFFSET


## Get nonce from token.
static func extract_nonce(token: int) -> int:
	var low = token & _UINT32_MAX
	assert(low >= _NONCE_OFFSET, "Token is invalid")
	# valid nonce is always above NONCE_OFFSET, so don't subtract
	return low


## Retrieve a unique number only used once.
func get_nonce() -> int:
	# check if passed 32bit size
	if _nonce > _UINT32_MAX:
		_nonce = _NONCE_OFFSET
		push_warning("Nonce exceeded 32 bits and wrapped around to initial value, may cause issues")

	var val := _nonce
	_nonce += 1
	return val


## Retrieve a unique token.
func make_token(index: int) -> int:
	var high := index + _INDEX_OFFSET
	assert(high & _UINT32_MAX == high, "Token generation failed, index too large")

	return (high << 32) | get_nonce()
