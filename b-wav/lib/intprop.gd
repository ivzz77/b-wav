class_name intprop

var p : int

const PROP_SUBDIVISION : int = 128

func _init(prop : int):
	p = prop


# just "for now" ig
func float_set(prop : float):
	self.p = (prop * PROP_SUBDIVISION) as int

static func propmult(prop : intprop, x : int) -> int:
	@warning_ignore("integer_division")
	return (prop.p * x) / PROP_SUBDIVISION
