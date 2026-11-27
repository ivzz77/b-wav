class_name PowerBulletType
extends Resource

# FOR USE IN GAME LOGIC SCRIPTS


# is in fact a different kind of thing than BulletType
# a LIST of BulletTypes parameterized by power, pretty much

# so yeah... don't have like. get functions for these things
# it's really just fetching from a table 
# -ivzz77

# exactly indexed by power, 0 = 0 power so fill that w/ unusued template
var btypes : Array[BulletType]

# limit the way we access this ig
func populate(b1:BulletType, b2:BulletType, b3:BulletType, b4:BulletType, b5:BulletType):
	btypes.append(Const.EMPTY_B_TYPE)
	btypes.append(b1)
	btypes.append(b2)
	btypes.append(b3)
	btypes.append(b4)
	btypes.append(b5)
	
