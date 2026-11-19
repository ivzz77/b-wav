class_name BulletType
extends Resource
## Flyweight representing shared bullet data.

# some of this data might be redundant, but serves as a default by which
# to initialize with,
# with the actual entity obj holding relevant variable data

# scalar for default speed of  bullet
var speed : int
var radius : int

var sprite : Sprite2D
# apparently can do instanced rendering w/ this
# maybe a AnimatedSprite2D ...
