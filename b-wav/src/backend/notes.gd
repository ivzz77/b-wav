class_name Note
extends Resource

#Meant to hold information about a note

enum NoteType {WEAK, NORMAL, STRONG}

@export var note_strength:NoteType
@export var time:float #Time is meant to be in miliseconds

func _init(strength:NoteType = NoteType.NORMAL, milisecond:float = 0.0):
	note_strength = strength
	time = milisecond
