class_name Charting
extends Resource

#Meant to hold information about the charting of a song

@export var bpm:float #Beats per minute, how fast a song is
@export var song_length:float #In miliseconds
@export var song_name:String #Double check if needed, to hold what song the charting is for
@export var notes:Array[Note] = []

func _init(beatPerMinute:float, length:float, name:String, noteArray:Array[Note]):
	bpm = beatPerMinute
	song_length = length
	song_name = name
	notes = noteArray
	
func _add_note(strength:Note.NoteType = Note.NoteType.NORMAL, milisecond:float = 0.0):
	var new_note := Note.new(strength, milisecond)
	notes.append(new_note)

func change_charting(noteArray:Array[Note]):
	notes = noteArray
#^Last two functions are [ossible helper functions, depends on whether want to add notes within Charting class defintion or prepare them before setting them to a charting

#Assumption that notes given will be in correct order
#Also not sure if array is best way to go about having notes in terms of checking an input that doesn't exactly match the milisecond
