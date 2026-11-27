class_name BulletType
extends Resource
## Flyweight representing shared bullet data.

# some of this data might be redundant, but serves as a default by which
# to initialize with,
# with the actual entity obj holding relevant variable data

# scalar for default speed of  bullet
var speed : int
var radius : int

# same int to index into BulletTextureRegistry mesh,
# same int field that bullet entity has
var sprite : int


func _init(s : int, r : int, spr : int):
	speed = s
	radius = r
	sprite = spr
