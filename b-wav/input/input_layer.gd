@abstract class_name InputLayer

# takes defined input events in inputmap & makes a hotswappable 
# readable thing out of it
# that uses ints

# keyed by stringname of built in InputMap's events
# value is either int 0/1 or intprop (for uldr)
var inputs : Dictionary[StringName, Variant] 


# should be called before inputs are needed
@abstract func refresh()
