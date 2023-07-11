extends Resource
class_name MusicCue

@export var action: String
@export var when: float
@export var early_tolerance: float
@export var late_tolerance: float
@export var early_fail: float
@export var pressed: bool
@export var score_amt: int

signal missed(by: float, cue: MusicCue)
signal passed(by: float, cue: MusicCue)

func _init():
	pass
