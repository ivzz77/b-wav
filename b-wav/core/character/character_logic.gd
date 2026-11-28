@abstract class_name CharacterLogic
extends Node

# the logic for a character
# should contain character definition too ig

# functions as just read only library to call into

# well ok ig like. in practice currently used to set some inner consts
# according to other global state
# e.g. BulletTextureRegistry ints for use in spawning bullets
@abstract func init()

# another setup function. make sure to call after init()
@abstract func ready()
